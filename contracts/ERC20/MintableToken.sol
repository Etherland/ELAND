pragma solidity ^0.7.0;

import "./StandardToken.sol";
import "../Ownable.sol";
import "../libraries/SafeMath.sol";
/**
* @title Mintable token
* @dev Simple ERC20 Token Mintable implementation
* @notice will be used only once on contrat construction, then minting MUST be automatically terminated 
*/
contract MintableToken is StandardToken {
    using SafeMath for uint256;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    bool public mintingFinished = false;
   
    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    /**
    * @dev Function to mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(
        address _to,
        uint256 _amount
    )
        internal
        canMint
        returns (bool)
    {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    /**
    * @dev Function to definitively stop minting new tokens.
    * @return True if the operation was successful.
    * @notice Finishing Minting is irreversible 
    */
    function finishMinting() internal canMint returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }
}
