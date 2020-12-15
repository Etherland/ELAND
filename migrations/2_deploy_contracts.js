const Etherland = artifacts.require("./contracts/Etherland.sol");

module.exports = async (deployer, network) => {

    const ownerAdds = await Promise.resolve({
        live: {
            owner : process.env.OWNER_LIVE
        },
        test : {
            owner : process.env.OWNER_TEST
        }
    });

    // set network `rinkeby-fork` as rinkeby
    const owner = await Promise.resolve(
        network.indexOf('rinkeby') >= 0
        ? ownerAdds.test
        : ownerAdds[network]
    )

    await deployer.deploy(
        Etherland,
        owner
    )

};