/* SPDX-License-Identifier: UNLICENSED */
pragma solidity ^0.7.0;

import './Ownable.sol';
import './Pausable.sol';
import './ERC20/StandardToken.sol';
import './ERC20/BurnableToken.sol';
import './utils/Utils.sol';

/**
* @title Etherland
* @dev Etherland fungible utility token
*/
contract Etherland is Ownable, Pausable, StandardToken, BurnableToken, Utils {

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
    * @dev Erc20 standard Etherland token constructor
    * @param _owner address of the contract owner to set when migrating this contract
    */
    constructor(address _owner, address reserve, address team) {
        /* give ownership of the contract to _owner */
        _transferOwnership(_owner);

        /* define supply partitioning */
        // 20 percent of the maximum supply goes to the reserve wallet 
        uint reserveAmount = percentOf(maximumSupply, 20);
        transfer(reserve, reserveAmount);

        // 10 percent of the maximum supply goes to the team wallet
        uint teamAmount = percentOf(maximumSupply, 10);
        transfer(team, teamAmount);

        // remaining 70 percent of the maximum supply are made available
        totalSupply_ = percentOf(maximumSupply, 70);
    }

    // function batchTransfer(address _from, address _to, uint _amount) public {

    // }

}