// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import './Ownable.sol';
import './Pausable.sol';
import './ERC20/MintableToken.sol';
import './ERC20/BurnableToken.sol';
import './utils/Utils.sol';
import './libraries/SafeMath.sol';

/**
* @title Etherland
* @dev Etherland fungible utility token
*/
contract Etherland is MintableToken, Pausable, BurnableToken, Utils {
    using SafeMath for uint256;

    /**
    * @dev Etherland Token Identification
    */
    string public name = 'Etherland';
    string public symbol = 'ELAND';
    uint256 public decimals = 18;

    /**
    * @dev Etherland Wallets
    */
    address public team;
    address public reserve;

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
    constructor(address _owner, address _reserve, address _team) {
        /* give ownership of the contract to _owner */
        _transferOwnership(_owner);
        // set wallets
        team = _team;
        reserve = _reserve;
        /* supply partitioning */
        // 20 percent of the supply goes to the reserve wallet 
        mint(_reserve, percentOf(maximumSupply, 20));
        // 10 percent of the supply goes to the team wallet
        mint(_team, percentOf(maximumSupply, 10));
        // 70 percent of the supply are kept by the owner
        mint(_owner, percentOf(maximumSupply, 70));
        // definitively terminate ELAND minting : total and circulating supply will never ever be higher than maximum supply
        finishMinting();
    }
    
    /**
    * @dev Total circulating supply
    * @return the number of circulating ELAND (totalSupply - team - reserve - owner)
    */
    function circulatingSupply() public view returns(uint) {
        return (totalSupply() - balances[team] - balances[reserve] - balances[owner]);
    }

   /**
    * @dev Transfer ELAND value to multiple addresses
    * @param _to array of addresses to send value to
    * @param _value the ELAND value to transfer for each address
    */
    function batchTransfer(address[] memory _to, uint _value) public returns(bool) {
        uint ttlRecipients = _to.length;
        require(ttlRecipients > 0, 'at least on recipient must be defined');
        require(balanceOf(msg.sender) >= (_value.mul(ttlRecipients)), 'batch transfer denied : unsufficient balance');
        for (uint i = 0; i < ttlRecipients; i++) {
            address recipient = _to[i];
            transfer(recipient, _value);
        }
        return true;
    }

}