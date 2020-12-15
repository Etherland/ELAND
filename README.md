# Smart Contracts for Etherland - ELAND ERC20 Token


## Contracts

`Etherland.sol` is ERC20-compatible and has the following characteristics:
	1. MAXIMUM SUPPLY 
		A maximum amount of tokens the contract will ever mint 
		1 000 000 000 (1 Billion) ELAND tokens are created upon contract construction 
	2.	TOTAL SUPPLY
		A fixed total available supply of ELAND
		Will never be higher than the Maximum Supply defined in pt.1
	3.	BURN
		Any token holder has the ability to burn its own tokens, 
		Contract `owner` has the ability to burn available tokens hold by the contract itself
		Both burn action removes the tokens from the total supply
	4.  


`Etherland.sol` flow:

The total supply is pre-minted on contract initialization and maximum supply is made available
Address of the contract owner is initialized by the contract constructor.
	•	Owner can transfer tokens in the name of the contract
	•	Token Supply is 1000000000 units (1 billion tokens)


We cloned OpenZeppelin code for `SafeMath`, `Ownable`, `Burnable`, `Pausable` and `StandardToken` logic.

	* `SafeMath` provides arithmetic functions that throw exceptions when integer overflows occur.
	* `Ownable` keeps track of a contract owner and permits the transfer of ownership by the current owner.
	* `Burnable`provides a burning function that decrement the balance of the burner and the total supply
	* `StandardToken` provides an implementation of the ERC20 standard.
	* `Pausable` allows owner to pause the Token Offering contract.
