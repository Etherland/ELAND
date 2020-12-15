pragma solidity ^0.7.0;


import "./ERC20Basic.sol";
import "../libraries/SafeMath.sol";


/**
* @title Basic token
* @dev Basic version of StandardToken, with no allowances.
*/
contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) internal balances;

    uint256 internal totalSupply_;

    /**
    * @dev Total Supply
    *   Represents the total available/in existence supply of ELAND
    *   Will never be higher than the Maximum Supply
    */
    function totalSupply() override public view returns (uint256) {
        return totalSupply_;
    }

    /**
    * @dev Transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) override public returns (bool) {
        require(_value <= balances[msg.sender], "transferred value must be lower or equal to the sender's balance");
        require(_to != address(0), "recipient can't be the zero address");

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) override public view returns (uint256) {
        return balances[_owner];
    }

}
