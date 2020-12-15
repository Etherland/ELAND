/* SPDX-License-Identifier: UNLICENSED */
pragma solidity 0.7.0;

import './Pausable.sol';

contract Etherland is Ownable, Pausable {

    string public name = 'Etherland';
    string public symbol = 'ELAND';
    uint256 public decimals = 18;
    /**
    * @notice Maximum Supply
    *   Represents the maximum amount of tokens the contract will ever mint 
    *   ELAND tokens are pre-minted by the constructor of this contract
    */
    uint256 public maximumSupply = 1e9 * 10 ** decimals;   

    constructor(address _owner) Ownable(_owner) {
        
    }

}