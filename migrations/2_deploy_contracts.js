const Etherland = artifacts.require("./contracts/Etherland.sol");
const Proxy = artifacts.require('./contracts/ERC1822/Proxy.sol');
const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider);

const { DEPLOY_ETHERLAND_ERC20, RESERVE_WALLET, TEAM_WALLET } = process.env;

module.exports = async (deployer, network) => {

    const ownerAdds = await Promise.resolve({
        live: process.env.OWNER_LIVE,
        test : process.env.OWNER_TEST
    });
    // defined contract owner address depending on deployment network
    const OWNER = await Promise.resolve(
        network.indexOf('rinkeby') >= 0
        ? ownerAdds.test
        : ownerAdds[network]
    );

    if (DEPLOY_ETHERLAND_ERC20 && OWNER) {
        const NAME = 'Etherland';
        const SYMBOL = 'ELAND';
        const DECIMALS = 18;

        await deployer.deploy(Etherland, { gas: 3000000 });
        const { abi, address } = Etherland;
        const logic = await Promise.resolve(new web3.eth.Contract(abi, address, { address }));
        const constructData = logic.methods.init(NAME, SYMBOL, DECIMALS, OWNER, RESERVE_WALLET, TEAM_WALLET).encodeABI();
        await deployer.deploy(Proxy, constructData, address);
    } 
    else console.error('Etherland ERC20 ELAND contract is not ready for deployment, please check your settings at 2_deploy_contracts.js');

};