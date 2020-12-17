require('chai').use(require('chai-as-promised')).should();
const EVMRevert = require('./helpers/VMExceptionRevert');

const Proxy = artifacts.require('../contracts/ERC1822/Proxy.sol');
const Etherland = artifacts.require('../contracts/Etherland.sol');

contract('Proxy', (accounts) => {
  try {
    // implem
    let code;
    // proxy
    let etherland;
    let proxy;

    const owner = accounts[0];
    const user1 = accounts[1];
    const user2 = accounts[2];
    const user3 = accounts[3];
    const reserveWallet = accounts[4];
    const teamWallet = accounts[5];

    const NAME = 'TestEland';
    const SYMBOL = 'TSTELND';
    const DECIMALS = 18;

    const dec = val => val + '000000000000000000';
    const totalSupply = dec(1000000000);

    beforeEach(async () => {
      code = await Etherland.new({ from: user1 });
      const constructData = code.contract.methods.init(NAME, SYMBOL, DECIMALS, owner, reserveWallet, teamWallet).encodeABI();
      proxy = await Proxy.new(constructData, code.address, { from: owner });
      etherland = await Etherland.at(proxy.address);
    });


    it('checks token details (name, symbol)', async () => {
      (await etherland.name()).toString().should.equal('TestEland');
      (await etherland.symbol()).toString().should.equal('TSTELND');
    });

    it('checks that partioning is ok upon migration', async() => {
      (await etherland.totalSupply()).toString().should.equal(totalSupply);
      (await etherland.circulatingSupply()).toString().should.equal('0');
      (await etherland.balanceOf(owner)).toString().should.equal('700000000000000000000000000');
      (await etherland.balanceOf(teamWallet)).toString().should.equal('100000000000000000000000000');
      (await etherland.balanceOf(reserveWallet)).toString().should.equal('200000000000000000000000000');
    });

    it('test ownership of the contract', async () => {
      const wrongToken = '0x51bb523c9f629b017f8fda6078e83480e968f648b6f6f2e3f94ef9daa13fb75f';
      (await etherland.owner()).toLowerCase().should.equal(owner.toString().toLowerCase());
      await etherland.transferOwnership(user1, { from: owner }).should.be.fulfilled;
      (await etherland.owner()).toLowerCase().should.equal(user1.toString().toLowerCase());
      await etherland.renounceOwnership(wrongToken, { from: owner }).should.be.rejectedWith(EVMRevert);
      await etherland.renounceOwnership(wrongToken, { from: user1 }).should.be.rejectedWith(EVMRevert);
      await etherland.preRenounceOwnership({ from: owner }).should.be.rejectedWith(EVMRevert);
      await etherland.preRenounceOwnership({ from: user1 }).should.be.fulfilled;
      const rightToken = await etherland.getRelinquishmentToken({ from: user1 });
      const rToken = await rightToken;
      await etherland.renounceOwnership(rToken, { from: owner }).should.be.rejectedWith(EVMRevert);
      await etherland.renounceOwnership(rToken, { from: user1 }).should.be.fulfilled;
      (await etherland.owner()).toString().should.equal('0x0000000000000000000000000000000000000000');
    });

    it('test burn function and supply state change', async () => {
      (await etherland.circulatingSupply()).toString().should.equal('0');
      await etherland.transfer(user1, dec(1500), { from: owner }).should.be.fulfilled;
      (await etherland.totalSupply()).toString().should.equal(totalSupply);
      (await etherland.circulatingSupply()).toString().should.equal(dec(1500));
      (await etherland.balanceOf(user1)).toString().should.equal(dec(1500));
      await etherland.burn(dec(500), { from: user1 }).should.be.fulfilled;
      (await etherland.balanceOf(user1)).toString().should.equal(dec(1000));
      (await etherland.circulatingSupply()).toString().should.equal(dec(1000));
      (await etherland.totalSupply()).toString().should.equal(dec(1e9 - 500));
    });

    it('testing approve function', async () => {
      await etherland.transfer(user1, dec(1500), { from: owner }).should.be.fulfilled;
      (await etherland.balanceOf(user1)).toString().should.equal(dec(1500));
      await etherland.approve(user2, dec(500), { from: user3 }).should.be.fulfilled;
      await etherland.approve(user2, dec(500), { from: user1 }).should.be.fulfilled;
      await etherland.approve(user2, dec(500), { from: user1 }).should.be.fulfilled;
      (await etherland.allowance(user1, user2)).toString().should.equal(dec(500));
    });

    it('testing transferFrom function', async () => {
      await etherland.transfer(user1, dec(1500), { from: owner }).should.be.fulfilled;
      (await etherland.balanceOf(user1)).toString().should.equal(dec(1500));
      await etherland.approve(user2, dec(1499), { from: user1 }).should.be.fulfilled;
      await etherland.transferFrom(user1, user3, dec(9999), { from: user3 }).should.be.rejectedWith(EVMRevert);
      await etherland.transferFrom(user1, user2, dec(1500), { from: user2 }).should.be.rejectedWith(EVMRevert);
      await etherland.transferFrom(user1, user2, dec(1099), { from: user2 }).should.be.fulfilled;
      (await etherland.balanceOf(user2)).toString().should.equal(dec(1099));
      (await etherland.balanceOf(user1)).toString().should.equal(dec(401));
      (await etherland.allowance(user1, user2)).toString().should.equal(dec(400));
      await etherland.transferFrom(user1, user2, dec(401), { from: user2 }).should.be.rejectedWith(EVMRevert);    
      (await etherland.allowance(user1, user2)).toString().should.equal(dec(400));
      await etherland.transferFrom(user1, user2, dec(400), { from: user2 }).should.be.fulfilled; 
      (await etherland.allowance(user1, user2)).toString().should.equal('0');
    });

    // it('testing land registry', async () => {
    
    // });
  }
  catch(testError) {
    console.log('testError', testError);
  }
});
