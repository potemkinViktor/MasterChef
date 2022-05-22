//SPDX-License-Identifier: Unlicenseess

pragma solidity ^0.8.13;

import "./Ownable.sol";
import "./MasterChef.sol";



contract MasterChefSetter is Ownable{

    // Dev address.
    address public devAddress;
    // Deposit Fee address
    address public feeAddress;
    // Deposit Charity address
    address public charityAddress;    
    // Lottery contract address : default address is the burn address and will be updated when lottery release
    address public lotteryAddress;
    // Narfex tokens created per block.
    uint256 public NRFXPerBlock;    
    // Lottery mint rate : maximum 5% (in basis point) :  default rate is 0 and will be updated when lottery release
    uint16 public lotteryMintRate;
    // Charity fee is a part of deposit fee (in basis point)
    uint16 public charityFeeBP;
    // Locker interface
    ILocker NarfexLocker;
    // Locker rate (in basis point) if = 0 locker desactivated
    uint16 public lockerRate;
    // Vault for transfer NRFX token
    address private tokenAmountContract;
    // Narfex referral contract address.
    IReferral public NarfexReferral;
    // Referral commission rate in basis points.
    uint16 public referralCommissionRate = 100;

    event EmissionRateUpdated(address indexed caller, uint256 previousAmount, uint256 newAmount);
    event FeeAddressUpdated(address indexed user, address indexed newAddress);
    event CharityAddressUpdated(address indexed user, address indexed newAddress);
    event CharityFeeRateUpdated(address indexed user, uint256 previousAmount, uint16 newAmount);
    event DevAddressUpdated(address indexed user, address indexed newAddress);
    event NarfexReferralUpdated(address indexed user, IReferral newAddress);
    event NarfexLockerUpdated(address indexed user, ILocker newAddress);
    event LockerRateUpdated(address indexed user, uint256 previousAmount, uint256 newAmount);
    event ReferralRateUpdated(address indexed user, uint256 previousAmount, uint256 newAmount);
    event LotteryAddressUpdated(address indexed user, address indexed newAddress);
    event LotteryMintRateUpdated(address indexed user, uint256 previousAmount, uint16 newAmount);
    event SetTokenAmountContract(address _tokenAmountContract);
    
    constructor () {}

    // Update tokenAmountContract by only owner
    function setTokenAmountContract(address _tokenAmountContract) external onlyOwner {
        require(_tokenAmountContract != address(0), "tokenAmountContract can not be zero!");
        tokenAmountContract = _tokenAmountContract;
        emit SetTokenAmountContract(tokenAmountContract);
    }

    // Update dev address by the previous dev address
    function setDevAddress(address _devAddress) public {
        require(msg.sender == devAddress, "setDevAddress: FORBIDDEN");
        require(_devAddress != address(0), "setDevAddress: ZERO");
        devAddress = _devAddress;
        emit DevAddressUpdated(msg.sender, _devAddress);
    }

    //Update fee address by the previous fee address
    function setFeeAddress(address _feeAddress) public {
        require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
        require(_feeAddress != address(0), "setFeeAddress: ZERO");
        feeAddress = _feeAddress;
        emit FeeAddressUpdated(msg.sender, _feeAddress);
    }
    
    //Update charity address by the previous charity address
    function setCharityAddress(address _charityAddress) public {
        require(msg.sender == charityAddress, "setCharityAddress: FORBIDDEN");
        require(_charityAddress != address(0), "setCharityAddress: ZERO");
        charityAddress = _charityAddress;
        emit CharityAddressUpdated(msg.sender, _charityAddress);
    }    

    //Update lottery address by the owner
    function setLotteryAddress(address _lotteryAddress) public onlyOwner {
        require(_lotteryAddress != address(0), "setLotteryAddress: ZERO");
        lotteryAddress = _lotteryAddress;
        emit LotteryAddressUpdated(msg.sender, _lotteryAddress);
    }    

    // Update emission rate by the owner
    function updateEmissionRate(uint256 _NRFXPerBlock) public onlyOwner {
        //massUpdatePools();
        emit EmissionRateUpdated(msg.sender, NRFXPerBlock, _NRFXPerBlock);
        NRFXPerBlock = _NRFXPerBlock;
    }
    
    // Update the Narfex referral contract address by the owner
    function setNarfexReferral(IReferral _NarfexReferral) public onlyOwner {
        NarfexReferral = _NarfexReferral;
        emit NarfexReferralUpdated(msg.sender, _NarfexReferral);
    }

    // Update referral commission rate by the owner
    function setReferralCommissionRate(uint16 _referralCommissionRate) public onlyOwner {
        // Max referral commission rate: 10%.
        require(_referralCommissionRate <= 1000, "setReferralCommissionRate: invalid referral commission rate basis points");
        emit ReferralRateUpdated(msg.sender, referralCommissionRate, _referralCommissionRate);
        referralCommissionRate = _referralCommissionRate;

    }

    // Update lottery mint rate by the owner
    function setLotteryMintRate(uint16 _lotteryMintRate) public onlyOwner {
        // Max lottery mint rate: 5%.
        require(_lotteryMintRate <= 500, "setLotteryMintRate: invalid lottery mint rate basis points");
        emit LotteryMintRateUpdated(msg.sender, lotteryMintRate, _lotteryMintRate);
        lotteryMintRate = _lotteryMintRate;
    }  

    // Update charity fee rate by the owner
    function setCharityFeeRate(uint16 _charityFeeBP) public onlyOwner {
        // Max charity fee rate: 50%
        // charity fee is a part of deposit fee and not added fee
        require(_charityFeeBP <= 5000, "setCharityFeeRate: invalid charity fee rate basis points");
        emit CharityFeeRateUpdated(msg.sender, charityFeeBP, _charityFeeBP);
        charityFeeBP = _charityFeeBP;
    }     

    // Update the Narfex locker contract address by the owner
    function setNarfexLocker(ILocker _NarfexLocker) public onlyOwner {
        NarfexLocker = _NarfexLocker;
        emit NarfexLockerUpdated(msg.sender, _NarfexLocker);
    }   

    // Update locker rate by the owner
    function setLockerRate(uint16 _lockerRate) public onlyOwner {
        // Max locker rate: 50%.
        require(_lockerRate <= 5000, "setLockerRate: invalid locker rate basis points");
        emit LockerRateUpdated(msg.sender, lockerRate, _lockerRate);
        lockerRate = _lockerRate;
    }
}