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

Upon Contract Construction:
- Maximum supply is pre-minted 
- Address of the contract owner is initialized
- Supply is partionnalized and distributed to 3 different wallets :
	- Team wallet : 10% of the maximum supply is allocated to the team
	- Reserve : 20% of the maximum supply is allocated to the reserve
	- Owner : 70% of the maximum supply is transfered to the contract owner


We cloned OpenZeppelin code for `SafeMath`, `Ownable`, `Burnable`, and `StandardToken` logic.

	* `SafeMath` provides arithmetic functions that throw exceptions when integer overflows occur.
	* `Ownable` keeps track of a contract owner and permits the transfer of ownership by the current owner.
				This part of the logic  originally propose a straight method named `renounceOwnership`
				We've enhanced this logic by adding new methods to allow the current owner 
				to definitively and safely relinquish control of the contract.
    			this safe check mechanism has been implemented to absolutely avoid situations where a method is unwantely called 
				which could potentially lock the all ecosystem permanently.
				To make sure this will never happens, we've defined the standalone release process in 2 steps : 
					1. First, the owner calls `preRenounceOwnership` method to generate, store and retrieve an hexadecimal random key 
					   named `relinquishmentToken`.
					2. In a second time, the owner calls `renounceOwnership` method with `relinquishmentToken` to renounce to his ownership and set the standalone state to true.
	* `Burnable`provides a burning function that decrement the balance of the burner and the total supply
	* `StandardToken` provides an implementation of the ERC20 standard.
