//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.13;


import "./Address.sol";
import "./SafeBEP20.sol";
import "./SafeMath.sol";
import "./ILocker.sol";

contract NarfexLocker is ILocker {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    address public Narfex;

    uint256 public startReleaseBlock;
    uint256 public endReleaseBlock;

    uint256 private _totalLock;
    mapping(address => uint256) private _locks;
    mapping(address => uint256) private _released;

    event Lock(address indexed to, uint256 value);

    constructor(
        address _Narfex,
        uint256 _startReleaseBlock,
        uint256 _endReleaseBlock
    ) {
        require(_endReleaseBlock > _startReleaseBlock, "endReleaseBlock < startReleaseBlock");
        Narfex = _Narfex;
        startReleaseBlock = _startReleaseBlock;
        endReleaseBlock = _endReleaseBlock;
    }

    function totalLock() external view override returns (uint256) {
        return _totalLock;
    }
    
    function getStartReleaseBlock() external view override returns (uint256) {
        return startReleaseBlock;
    }    

    function lockOf(address _account) external view override returns (uint256) {
        return _locks[_account];
    }

    function released(address _account) external view override returns (uint256) {
        return _released[_account];
    }

    function lock(address _account, uint256 _amount) external override {
        require(block.number < startReleaseBlock, "no more lock");
        require(_account != address(0), "no lock to address(0)");
        require(_amount > 0, "zero lock");

        IBEP20(Narfex).safeTransferFrom(msg.sender, address(this), _amount);

        _locks[_account] = _locks[_account].add(_amount);
        _totalLock = _totalLock.add(_amount);

        emit Lock(_account, _amount);
    }

    function canUnlockAmount(address _account) public view override returns (uint256) {
        if (block.number < startReleaseBlock) {
            return 0;
        } else if (block.number >= endReleaseBlock) {
            return _locks[_account].sub(_released[_account]);
        } else {
            uint256 _releasedBlock = block.number.sub(startReleaseBlock);
            uint256 _totalVestingBlock = endReleaseBlock.sub(startReleaseBlock);
            return _locks[_account].mul(_releasedBlock).div(_totalVestingBlock).sub(_released[_account]);
        }
    }

    function unlock() external override {
        require(block.number > startReleaseBlock, "still locked");
        require(_locks[msg.sender] > _released[msg.sender], "no locked");

        uint256 _amount = canUnlockAmount(msg.sender);

        IBEP20(Narfex).safeTransfer(msg.sender, _amount);
        _released[msg.sender] = _released[msg.sender].add(_amount);
        _totalLock = _totalLock.sub(_amount);
    }

}