# Smart Contracts for Etherland - ELAND ERC20 Token


## Contracts Structure

### `CLONED SOURCE`
- We cloned OpenZeppelin Contracts v3 code for `SafeMath`, `ERC20` and `ERC20Burnable` logic.

	* `SafeMath` provides arithmetic functions that throw exceptions when integer overflows occur.
	* `ERC20` provides a basic implementation of the ERC20 standard
	* `ERC20Burnable`provides a burning function that decrement the balance of the burner and the total supply
	* `MintableToken` provides the token a mintable ability in order to generate the supply

### `UPGRADED CLONED SOURCE`
- We cloned OpenZeppelin Contracts v3 code for `Ownable` and added some logic.

	* `Ownable` *keeps track of a contract owner and permits the transfer of ownership by the current owner*
		- This part of the logic originally propose a straight method named `renounceOwnership`.
		- We've enhanced this part of the contract's logic by adding a new layer of security materialized by a new method allowing the current owner to definitively relinquish control of the contract in a safe way. 
		- This safe check mechanism has been implemented to absolutely avoid situations where a method is unwantely called which could potentially lock the all ecosystem permanently.
		- To make sure this will never happens, we've defined the standalone release process in 2 steps : 
			1. First, the owner calls `preRenounceOwnership` method to generate, store and retrieve an hexadecimal random key 
				named `relinquishmentToken`.
			2. In a second time, the owner calls `renounceOwnership` method with `relinquishmentToken` to renounce to his ownership and set the standalone state to true.
	* `ERC20Capped` *provides a way to add a cap to the supply of tokens ensuring overflow will never happen* 
		- Constructor has been replaced by a method called `setImmutableCap` that is called during contract migration (*see Flow section of Etherland.sol definition down below*)
		- Internal calls to `_beforeTokenTransfer` are made to `ERC20.sol`

### `INTERNAL SOURCE`
* `LandRegistry.sol` *Etherland Decentralized Land Registration Protocol*
	- Uses `iLANDID.sol` interface to get the ability to call the `hasAdminRights` function of Etherland LANDID Non-Fungible-Token smart-contract at address retrievable with the  `landidNftAddress` getter function.
	- On the Etherland Metaverse, any token holder has the ability to register a new land, to do so, they must exchange *ELAND* Ethereum or any other Token displayed on the offer of Opensea marketplace.
	- Land Record Rights offers and prices are in ELAND or ETH or other Tokens.
	- Those rights are detailed on our website at https://etherland.io/dashboard/?ua=newitem
	- `REGISTER A NEW LAND` *request the mint of an Etherland LANDID Non-Fungible-Token *use-case**
		- Making a new record in the Land Registry is doable in a few simple steps :
		1. Select a `Record Right` among the offers at https://etherland.world/register-a-place/
		2. Fill the form and validate all record steps
		3. Validate purchase: A transaction calling the function `registerLand` is prompted and must be accepted/successfull
		4. Corresponding `Record Right` is attributed to the caller and safely stored on-chain
		5. Etherland administrator validates the record and mints the corresponding LANDID NFT which caller becomes the owner
		6. Etherland administrator consumes the corresponding `Record Right` by calling the function `consumeRecordRight` giving a tokenId
		7. Operation is successfull : a new unique LANDID NFT has been minted which caller is the owner

* `Etherland.sol` *contract assembling the code for Etherland logic*

	#### GENERAL CHARASTERISTICS:
	1. IDENTIFICATION
		- Name : Etherland
		- Symbol : ELAND
		- Decimals : 18

	2. CAP *The maximum amount of ELAND tokens the contract will ever mint* 
		- 1 000 000 000 (1 Billion) units

	3. TOTAL SUPPLY *A total available supply of ELAND (will never be higher than the Maximum Supply)*
		- starting at capped value of 1 000 000 000 (1 Billion) units
		- may be lower than the Cap along with the burn operations

	4. CIRCULATING SUPPLY
		The number of circulating ELAND :
		= totalSupply - team and advisors - reserve - Etherland wallet - Credit carbon reward

	5. MINTING FINISHED
		In concern for transaprency, we've made available a getter returning a boolean that *must* be positive with value "true", indicating that its programmatically impossible to mint more tokens than the cap

	6. BURN
		- Any token holder has the ability to burn its own tokens, 
		- *Burn operations remove the tokens from the total supply*

	7. APPROVE
		- Any token holder has the ability to allow a tiers to spend/burn its own tokens

	8. LAND REGISTRY **see LandRegistry definition above**


	#### FLOW UPON CONTRACT CONSTRUCTION:
	- Maximum supply is pre-minted 
	- Address of the contract owner is initialized
	- Supply is partionnalized and distributed to 3 different wallets :
		- Team wallet : 10% of the maximum supply is allocated to the team
		- Reserve : 20% of the maximum supply is allocated to the reserve
		- Owner : 70% of the maximum supply is transfered to the contract owner
	- Minting is definitvely closed assuring that no more tokens than the maximum supply will be minted

### LOCAL TEST FLOW
after having installed dependencies :
1. install yarn running commant `yarn install`
2. run command `yarn test` 

### DEPLOYMENT FLOW
1. If its not done yet, install truffle globally on your system, run `npm install -g truffle` in a terminal
2. Create or update the `.env` file at the root of the project with the following environnement variables :
	- `OWNER_LIVE` : the public address of the contract owner to use on mainnet
	- `OWNER_TEST` : the public address of the contract owner to use on testnet *(rinkeby only)*
	- `RESERVE_WALLET` : the address to use as the reserve wallet for partionning
	- `TEAM_WALLET` : the address to use as the team wallet for partionning
    - `DEPLOY_ETHERLAND_ERC20` : a boolean to allow the deployment flow, set to `true` if you allow deployment or `false` otherwise
    - `MNEMONIC` : seed words separated with a space  
    - `INFURA_KEY` : goto https://infura.io to get an access key
3. Open a terminal at root and run : 
    - for Rinkeby : truffle deploy --network rinkeby
    - for Mainnet : truffle deploy --network live
    ##### *if you have the `up to date` message when deploying, maybe you've already deployed the contract before. In that case, if your contract doesnt deploy, simply add the `--reset` tag as follow : `truffle deploy --network rinkeby --reset`*


### /!\ IMPORTANT /!\
##### DO NOT FORGET NOT TO SHARE YOUR .env MNEMONIC and INFURA_KEY PUBLICLY 
#
### PACKAGES VERSION  
##### If any error occurs due to node or npm version, try to update version to : 
- npm : 6.14.8
run ```npm install -g npm@6.14.8```
- node : 14.15.0
run ```nvm use 14.15.0```
# 
*contact: info@etherland.world* 

