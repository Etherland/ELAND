const Etherland = artifacts.require("./contracts/Etherland.sol");

module.exports = async (deployer, network) => {

    const deployConfig = await Promise.resolve({
        live: {
            owner : '0x969c1b456D178fFC7E8d7919d71D37E33293A772',
        },
        test : {
            owner : '0x5B9a4e44F70206c13f27395cf929c3701d2621FA',
        }
    });

    // set network `rinkeby-fork` as rinkeby
    const config = await Promise.resolve(
        network.indexOf('rinkeby') >= 0
        ? deployConfig.test
        : deployConfig[network]
    )

    const { owner } = config;

    await deployer.deploy(
        Etherland,
        owner
    )

};