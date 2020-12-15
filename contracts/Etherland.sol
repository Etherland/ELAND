/* SPDX-License-Identifier: UNLICENSED */
pragma solidity 0.7.0;

import './Pausable.sol';

/**
* @title Etherland
* @dev Etherland fungible utility token
*/
contract Etherland is Ownable, Pausable {

    /**
    * @dev Etherland Token Identification
    */
    string public name = 'Etherland';
    string public symbol = 'ELAND';
    uint256 public decimals = 18;

    /**
    * @dev Maximum Supply
    *   Represents the maximum amount of tokens the contract will ever mint 
    * @notice 1 000 000 000 (1 Billion) ELAND tokens are pre-minted upon contract construction
    */
    uint256 public maximumSupply = 1e9 * 10 ** decimals;  

    /**
    * @dev Total Supply
    *   Represents the total available supply of ELAND
    *   Will never be higher than the Maximum Supply defined precedently
    */
    uint256 public totalSupply = maximumSupply;


    /**
    * @dev Erc20 standard Etherland token constructor
    * @param _owner address of the contract owner to set when migrating this contract
    */
    constructor(address _owner) {
        _transferOwnership(_owner);
    }

}