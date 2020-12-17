require('chai').use(require('chai-as-promised')).should();
const { expect } = require('chai');
const EVMRevert = require('./helpers/VMExceptionRevert');

const isValidDate = date => date instanceof Date && !isNaN(date.valueOf());

const Proxy = artifacts.require('../contracts/ERC1822/Proxy.sol');
const Etherland = artifacts.require('../contracts/Etherland.sol');
const LandidMock = artifacts.require('./contracts/LandidMock.sol');

contract('Proxy', (accounts) => {
    // implem
    let code;
    // proxy
    let etherland;
    let proxy;
    // mocking
    let landid;

    const owner = accounts[0];
    const user1 = accounts[1];
    const user2 = accounts[2];
    const user3 = accounts[3];
    const reserveWallet = accounts[4];
    const teamWallet = accounts[5];
    const landRegistration = accounts[6];

    const NAME = 'TestEland';
    const SYMBOL = 'TSTELND';
    const DECIMALS = 18;

    const eland = val => val + '000000000000000000';
    const totalSupply = eland(1000000000);


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

    it('checks that supply is well ditributed as expected upon migration', async() => {
      (await etherland.totalSupply()).toString().should.equal(totalSupply);
      (await etherland.circulatingSupply()).toString().should.equal('0');
      (await etherland.balanceOf(owner)).toString().should.equal('700000000000000000000000000');
      (await etherland.balanceOf(teamWallet)).toString().should.equal('100000000000000000000000000');
      (await etherland.balanceOf(reserveWallet)).toString().should.equal('200000000000000000000000000');
    });

    it('checks that minting is finished upon migration', async() => {
      (await etherland.mintingFinished()).toString().should.equal('true');
    });

    it('test ownership of the contract and standalone state', async () => {
      const wrongToken = '0x51bb523c9f629b017f8fda6078e83480e968f648b6f6f2e3f94ef9daa13fb75f';
      (await etherland.standalone()).toString().should.equal('false');
      (await etherland.owner()).toLowerCase().should.equal(owner.toString().toLowerCase());
      await etherland.transferOwnership(user1, { from: owner }).should.be.fulfilled;
      (await etherland.owner()).toLowerCase().should.equal(user1.toString().toLowerCase());
      await etherland.renounceOwnership(wrongToken, { from: owner }).should.be.rejectedWith(EVMRevert);
      await etherland.renounceOwnership(wrongToken, { from: user1 }).should.be.rejectedWith(EVMRevert);
      await etherland.preRenounceOwnership({ from: owner }).should.be.rejectedWith(EVMRevert);
      await etherland.preRenounceOwnership({ from: user1 }).should.be.fulfilled;
      const rToken = await etherland.getRelinquishmentToken({ from: user1 });
      await etherland.renounceOwnership(rToken, { from: owner }).should.be.rejectedWith(EVMRevert);
      await etherland.renounceOwnership(rToken, { from: user1 }).should.be.fulfilled;
      (await etherland.owner()).toString().should.equal('0x0000000000000000000000000000000000000000');
      (await etherland.standalone()).toString().should.equal('true');

    });

    it('test burn function and supply state update', async () => {
      (await etherland.circulatingSupply()).toString().should.equal('0');
      await etherland.transfer(user1, eland(1500), { from: owner }).should.be.fulfilled;
      (await etherland.totalSupply()).toString().should.equal(totalSupply);
      (await etherland.circulatingSupply()).toString().should.equal(eland(1500));
      (await etherland.balanceOf(user1)).toString().should.equal(eland(1500));
      await etherland.burn(eland(500), { from: user1 }).should.be.fulfilled;
      (await etherland.balanceOf(user1)).toString().should.equal(eland(1000));
      (await etherland.circulatingSupply()).toString().should.equal(eland(1000));
      (await etherland.totalSupply()).toString().should.equal(eland(1e9 - 500));
    });

    it('testing approve and allowances updates functions', async () => {
      await etherland.transfer(user1, eland(1500), { from: owner }).should.be.fulfilled;
      (await etherland.balanceOf(user1)).toString().should.equal(eland(1500));
      await etherland.approve(user2, eland(500), { from: user3 }).should.be.fulfilled;
      await etherland.approve(user2, eland(500), { from: user1 }).should.be.fulfilled;
      await etherland.approve(user2, eland(500), { from: user1 }).should.be.fulfilled;
      (await etherland.allowance(user1, user2)).toString().should.equal(eland(500));
      await etherland.decreaseApproval(user2, eland(151), { from: user1 }).should.be.fulfilled;
      (await etherland.allowance(user1, user2)).toString().should.equal(eland(349));
      await etherland.increaseApproval(user2, eland(251), { from: user1 }).should.be.fulfilled;
      (await etherland.allowance(user1, user2)).toString().should.equal(eland(600));
      await etherland.decreaseApproval(user2, eland(599), { from: user1 }).should.be.fulfilled;
      (await etherland.allowance(user1, user2)).toString().should.equal(eland(1));

    });

    it('testing transferFrom function', async () => {
      await etherland.transfer(user1, eland(1500), { from: owner }).should.be.fulfilled;
      (await etherland.balanceOf(user1)).toString().should.equal(eland(1500));
      await etherland.approve(user2, eland(1499), { from: user1 }).should.be.fulfilled;
      await etherland.transferFrom(user1, user3, eland(9999), { from: user3 }).should.be.rejectedWith(EVMRevert);
      await etherland.transferFrom(user1, user2, eland(1500), { from: user2 }).should.be.rejectedWith(EVMRevert);
      await etherland.transferFrom(user1, user2, eland(1099), { from: user2 }).should.be.fulfilled;
      (await etherland.balanceOf(user2)).toString().should.equal(eland(1099));
      (await etherland.balanceOf(user1)).toString().should.equal(eland(401));
      (await etherland.allowance(user1, user2)).toString().should.equal(eland(400));
      await etherland.transferFrom(user1, user2, eland(401), { from: user2 }).should.be.rejectedWith(EVMRevert);    
      (await etherland.allowance(user1, user2)).toString().should.equal(eland(400));
      await etherland.transferFrom(user1, user2, eland(400), { from: user2 }).should.be.fulfilled; 
      (await etherland.allowance(user1, user2)).toString().should.equal('0');
      (await etherland.balanceOf(user1)).toString().should.equal(eland(1));

    });

    it('testing batch transfer', async () => {
      (await etherland.balanceOf(user1)).toString().should.equal('0');
      (await etherland.balanceOf(user2)).toString().should.equal('0');
      (await etherland.balanceOf(user3)).toString().should.equal('0');
      await etherland.batchTransfer([user1, user2], eland(125000), { from: owner }).should.be.fulfilled;
      (await etherland.balanceOf(user1)).toString().should.equal(eland(125000));
      (await etherland.balanceOf(user2)).toString().should.equal(eland(125000));
      (await etherland.balanceOf(user3)).toString().should.equal('0');
      (await etherland.balanceOf(owner)).toString().should.equal(eland('699750000'));
      (await etherland.circulatingSupply()).toString().should.equal(eland(125000 * 2));
    });
    
    it('testing land registry', async () => {
      landid = await LandidMock.new({ from: owner });
      const landidNftAddress = landid.address;
      await etherland.setLandRegistrationAddress(landRegistration, { from: user2 }).should.be.rejectedWith(EVMRevert);
      await etherland.setLandRegistrationAddress(landRegistration, { from: owner }).should.be.fulfilled;
      await etherland.setLandidNftAddress(landidNftAddress, { from: user1 }).should.be.rejectedWith(EVMRevert);
      await etherland.setLandidNftAddress(landidNftAddress, { from: owner }).should.be.fulfilled;
      (await etherland.landidNftAddress()).toString().should.equal(landidNftAddress);
      await etherland.openLandRegistry({ from: user1 }).should.be.rejectedWith(EVMRevert);
      (await etherland.landRegistryOpened()).toString().should.equal('false');      
      await etherland.openLandRegistry({ from: owner }).should.be.fulfilled;
      (await etherland.landRegistryOpened()).toString().should.equal('true');
      // set record right prices
      await etherland.setRecordRightsOffers([eland(800), eland(2500), eland(5000), eland(10000)], {from: owner }).should.be.fulfilled;
      // buy record right
      await etherland.registerLand(1, { from: user1 }).should.be.rejectedWith(EVMRevert);
      await etherland.transfer(user1, eland(10000), { from: owner }).should.be.fulfilled;
      /* /!\ @todo : HANDLE INDEX 0 */
      await etherland.registerLand(1, { from: user1 }).should.be.fulfilled;
      let rrr = await etherland.registryRecordRights(user1, 0);
      let time = rrr.time.toString();
      let tokenId = rrr.tokenId.toString();
      let right = rrr.right.toString();
      expect(time).to.be.a('string');
      let timestamp = parseInt(time);
      expect(timestamp).to.be.above(0);
      let date = new Date(timestamp * 1000);
      expect(isValidDate(date).toString()).to.equal('true');
      expect(parseInt(right)).to.equal(1);
      expect(tokenId).to.equal('0');  // indicating a valid, unused record right
      /* Consume Record (admin action) */
      // only admins can consume rights => minting LANDID #7
      await etherland.consumeRecordRight(user1, 1, 7, { from: user2 }).should.be.rejectedWith(EVMRevert);
      await etherland.consumeRecordRight(user1, 2, 7, { from: owner }).should.be.rejectedWith(EVMRevert);
      await etherland.consumeRecordRight(user1, 1, 7, { from: owner }).should.be.fulfilled;
      let crrr = await etherland.registryRecordRights(user1, 0);
      let ctime = crrr.time.toString();
      let ctokenId = crrr.tokenId.toString();
      let cright = crrr.right.toString();
      expect(ctime).to.be.a('string');
      let ctimestamp = parseInt(ctime);
      expect(ctimestamp).to.be.above(0);
      let cdate = new Date(ctimestamp * 1000);
      expect(isValidDate(cdate).toString()).to.equal('true');
      expect(parseInt(cright)).to.equal(1);
      expect(ctokenId).to.equal('7');  
      await etherland.consumeRecordRight(user1, 1, 7, { from: owner }).should.be.rejectedWith(EVMRevert);

    });

});
