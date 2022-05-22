//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./IBEP20.sol";
import "./Ownable.sol";

contract NarfexLockerAddress is Ownable{

    IBEP20 public token;

    function withdraw(IBEP20 _token, address to, uint256 amount) public onlyOwner {
        uint256 erc20balance = _token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");
        _token.transfer(to, amount);
    }

    /*function deposit(IBEP20 _token, uint256 _amount) public {
        require()
        require(_amount > 0, "You should deposit more then ZERO");
    }*/
}