pragma solidity ^0.7.0;

import "./BasicToken.sol";
import '../libraries/SafeMath.sol';
/**
* @title Burnable Token
* @dev Token that can be irreversibly burned (destroyed).
*/
contract BurnableToken is BasicToken {
    using SafeMath for uint256;

    event Burn(address indexed burner, uint256 value);

    /**
    * @dev Burns a specific amount of tokens.
    * @param _value The amount of token to be burned.
    */
    function burn(uint256 _value) public {
        _burn(msg.sender, _value);
    }

    function _burn(address _who, uint256 _value) internal {
        require(_value <= balances[_who], "amount to burn can't be higher than balance of sender");

        balances[_who] = balances[_who].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }
}