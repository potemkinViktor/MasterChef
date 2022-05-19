//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.13;

interface ILocker {
    function totalLock() external view returns (uint256);

    function lockOf(address _account) external view returns (uint256);

    function released(address _account) external view returns (uint256);

    function canUnlockAmount(address _account) external view returns (uint256);

    function lock(address _account, uint256 _amount) external;

    function unlock() external;
    
    function getStartReleaseBlock() external view returns (uint256);
}