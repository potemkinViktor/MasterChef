//SPDX-License-Identifier: Unlicenseess

pragma solidity ^0.8.13;

import "./IReferral.sol";
import "./ILocker.sol";

interface IMasterChefSetter {

    function setTokenAmountContract(address _tokenAmountContract) external;

    function setDevAddress(address _devAddress) external;

    function setFeeAddress(address _feeAddress) external;

    function setCharityAddress(address _charityAddress) external;

    function setLotteryAddress(address _lotteryAddress) external;

    function updateEmissionRate(uint256 _NRFXPerBlock) external;

    function setNarfexReferral(IReferral _NarfexReferral) external;

    function setReferralCommissionRate(uint16 _referralCommissionRate) external;

    function setLotteryMintRate(uint16 _lotteryMintRate) external;

    function setCharityFeeRate(uint16 _charityFeeBP) external;

    function setNarfexLocker(ILocker _NarfexLocker) external;

    function setLockerRate(uint16 _lockerRate) external;

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
}