import "./ERC20.sol";

/**
 * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
 */
contract ERC20Capped is ERC20 {
    using SafeMath for uint256;

    // uint256 private _cap;

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    function setImmutableCap(uint256 cap_) internal {
        require(cap() == 0, 'cap value is immutable and is already set to 1 Billion ELAND');
        require(cap_ > 0, "cap must be higher than 0");
        _cap = cap_;
    }

    /**
    * @dev Cap that is set on the total token supply
    *   Represents the maximum amount of tokens the contract will ever mint 
    * @notice cap value is 1 000 000 000 (1 Billion) ELAND tokens and are all pre-minted upon contract construction
    */
    function cap() public view returns (uint256) {
        return _cap;
    }

}
