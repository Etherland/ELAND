import './libraries/SafeMath.sol';
import "./ERC1822/Proxiable.sol";
import './LANDID/LandRegistry.sol';
/**
* @title Etherland
* @dev Etherland fungible utility token
*/
contract Etherland is LandRegistry, Proxiable {
    using SafeMath for uint256;
    
    /**
    * @dev Contact initialization state
    * initialized state is set upon construction
    * MUST be initialized to be valid
    */
    bool public initialized = false;

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
    uint256 public maximumSupply;  

    /**
    * @return amount representing _percent % of _amount
    */
    function percentOf(uint _total, uint _percent) internal pure returns(uint amount) {
        amount = ((_total * _percent) / 100);
    }

    /**
    * @dev Erc20 Etherland ELAND token constructor
    * @param _owner address of the contract owner to set when migrating this contract
    * @notice called only once in contract lifetime upon migration to chain
    */
    function init(
        string memory name_, 
        string memory symbol_, 
        uint8 decimals_, 
        address _owner, 
        address _reserve, 
        address _team
    ) public {
      
        if (initialized != true) {
            /* 
                initialize contract 
            */
            initialized = true;
            
            /* give ownership of the contract to _owner */
            _transferOwnership(_owner);
            
            /* 
                set identifiers 
            */
            _name = name_;
            _symbol = symbol_;
            _decimals = decimals_;

            /* set maximum supply to 1 Billion tokens */
            maximumSupply = 1e9 * 10 ** _decimals;
            
            /*
                set wallets 
            */
            team = _team;
            reserve = _reserve;
            
            /* 
                supply partitioning 
                    - 20 percent of the supply goes to the reserve wallet
                    - 10 percent of the supply goes to the team wallet
                    - 70 percent of the supply are kept by the owner
            */
            mint(_reserve, percentOf(maximumSupply, 20));
            mint(_team, percentOf(maximumSupply, 10));
            mint(_owner, percentOf(maximumSupply, 70));
            
            /* 
                definitively end minting of ELAND token
                total and circulating supply will never ever be higher than the maximum supply 
            */
            finishMinting();
        }
    }

    /**
    * @dev EIP-1822 feature
    * @dev Realize an update of the Etherland logic code 
    * @dev calls the proxy contract to update stored logic code contract address at keccak256("PROXIABLE")
    * @notice once owner renounce contract ownership and owner address is set to the zero address, 
    *         no one will be able to update the logic code (see renounceOwnership method)
    */
    function updateCode(address newCode) public onlyOwner {
        updateCodeAddress(newCode);
    }
    
    /**
    * @dev Total circulating supply
    * @return the number of circulating ELAND (totalSupply - team - reserve - owner)
    */
    function circulatingSupply() public view returns(uint) {
        return (totalSupply().sub(balanceOf(team)).sub(balanceOf(reserve)).sub(balanceOf(owner)));
    }

   /**
    * @dev Transfer ELAND value to multiple addresses
    * @param _to array of addresses to send value to
    * @param _value the ELAND value to transfer for each address
    * @return boolean indicating operation success
    */
    function batchTransfer(address[] memory _to, uint _value) public returns(bool) {
        uint ttlRecipients = _to.length;
        require(ttlRecipients > 0, 'at least on recipient must be defined');
        require(balanceOf(_msgSender()) >= (_value.mul(ttlRecipients)), 'batch transfer denied : unsufficient balance');
        for (uint i = 0; i < ttlRecipients; i++) {
            address recipient = _to[i];
            transfer(recipient, _value);
        }
        return true;
    }

    /**
    * @dev Set Etherland LANDID NFT contract address
    * @param _landidNftAddress the address of LANDID NFT Token
    * @return boolean indicating operation success
    */
    function setLandidNftAddress(address _landidNftAddress) public onlyOwner returns (bool) {
        landidNftAddress = _landidNftAddress;
        return true;
    }

    /**
    * @dev Set Land Registration Address
    * @param _landRegistration the address of the wallet dedicated to land registrations
    * @return boolean indicating operation success
    */
    function setLandRegistrationAddress(address _landRegistration) public onlyOwner returns(bool) {
        landRegistration = _landRegistration;
        return true;
    }
    

}