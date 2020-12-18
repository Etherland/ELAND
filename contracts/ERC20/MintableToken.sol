import "./ERC20Burnable.sol";
import "../libraries/SafeMath.sol";

/**
* @title Mintable token
* @dev Simple ERC20 Token Mintable implementation
* @notice will be used only once on contrat construction, then minting MUST be automatically terminated 
*/
contract MintableToken is ERC20Burnable {
    using SafeMath for uint256;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    //bool public mintingFinished = false;
   
    modifier canMint() {
        require(!mintingFinished, "denied : minting has been terminated");
        _;
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
        canMint
        returns (bool)
    {
        _mint(_to, _amount);
        return true;
    }

    /**
    * @dev
    */
    function mintingIsFinished() public view returns(bool) {
        return mintingFinished;
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
