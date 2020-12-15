const Etherland = artifacts.require("./contracts/Etherland.sol");
const Proxy = artifacts.require('./ERC1822/Proxy.sol');

const { DEPLOY_ETHERLAND_ERC20, RESERVE, TEAM } = process.env;

module.exports = async (deployer, network) => {

    const ownerAdds = await Promise.resolve({
        live: {
            owner : process.env.OWNER_LIVE
        },
        test : {
            owner : process.env.OWNER_TEST
        }
    });

    // defined contract owner address depending on deployment network
    const OWNER = await Promise.resolve(
        network.indexOf('rinkeby') >= 0
        ? ownerAdds.test
        : ownerAdds[network]
    );

    if (DEPLOY_ETHERLAND_ERC20) {
        await deployer.deploy(Etherland, { gas: 3000000 });
        const { abi, address } = Etherland;
        const logic = new web3.eth.Contract(abi, address, { address });
        const constructData = logic.methods.init(OWNER, RESERVE, TEAM).encodeABI();
        await deployer.deploy(Proxy, constructData, address);
    } else console.error('Etherland contract is not ready for deployment, please check your settings at 2_deploy_contracts.js');

};