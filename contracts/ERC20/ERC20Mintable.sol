import "./ERC20Burnable.sol";
import "../libraries/SafeMath.sol";

/**
* @title Mintable token
* @dev Simple ERC20 Token Mintable implementation
* @notice will be used only once on contrat construction, then minting MUST be automatically terminated 
*/
contract ERC20Mintable is ERC20Burnable {
    using SafeMath for uint256;

    /**
    * @dev Minting event for Etherland *MUST* fire only once by supply partition (see Etherland.sol `init` function called when migrating
    */
    event Mint(address indexed to, uint256 amount);

    function mintingFinished() public view returns(bool){
        return _mintingFinished;
    }

    /**
    * @dev Function to internally mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    * @notice this method is called only once in Etherland contract lifetime as minting is terminated upon initial contract migration on chain
    */
    function mint(
        address _to,
        uint256 _amount
    )
        internal
        returns (bool)
    {
        require(mintingFinished() == false, 'ERC20Mintable : Minting is finished');
        _mint(_to, _amount);
        Mint(_to, _amount);
        return true;
    }

}
