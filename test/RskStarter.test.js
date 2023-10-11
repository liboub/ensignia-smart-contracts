const { expect } = require('chai');
const { deployContract } = require('../util');

describe('LottoTickets', () => {
  let owner;
  let user;
  let lottoTickets;

  const mintCost = ethers.utils.parseEther('0.0001'); // 1 ether
  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
  });

  before(async () => {
    lottoTickets = await deployContract(
      'LottoTickets',
      'ipfs//QmesotUeUcMRhTEvpHhM3F7KN24Pzf9hzGzqaCmuCvFfBD/',
    );
  });

  describe('Upon deployment', () => {
    it('deployed smart contracts should have valid addresses', async () => {
      expect(lottoTickets.address).to.be.properAddress;
    });

    it('Should deploy with the correct initial values', async function () {
      expect(await lottoTickets.owner()).to.equal(owner.address);
      expect(await lottoTickets.name()).to.equal('lottoTickets');
      expect(await lottoTickets.symbol()).to.equal('LT');
      expect(await lottoTickets.mintCost()).to.equal(mintCost);
      expect(await lottoTickets.baseURI()).to.equal('ipfs//QmesotUeUcMRhTEvpHhM3F7KN24Pzf9hzGzqaCmuCvFfBD/');
      expect(await lottoTickets.getTotalMinted()).to.equal(0);
    });
  });

  describe('mint an nft ', () => {
    it('Should allow minting tickets', async function () {
      const quantity = 3;
      await lottoTickets
        .connect(user)
        .mint(user.address, quantity, { value: mintCost.mul(quantity) });

      expect(await lottoTickets.balanceOf(user.address)).to.equal(quantity);
      expect(await lottoTickets.getTotalMinted()).to.equal(quantity);
    });

    it('Should prevent minting with insufficient funds', async function () {
      const quantity = 3;
      const insufficientFunds = mintCost
        .mul(quantity)
        .sub(ethers.utils.parseEther('0.00001')); // Less than required

      await expect(
        lottoTickets
          .connect(user)
          .mint(user.address, quantity, { value: insufficientFunds }),
      ).to.be.revertedWith('Not enough funds');
    });
  });

  describe('burn an nft ', () => {
    it('Should prevent burning tokens by non-owners', async function () {
      const quantity = 3;
      await lottoTickets
        .connect(user)
        .mint(user.address, quantity, { value: mintCost.mul(quantity) });

      await expect(
        lottoTickets.connect(user).burnOneToken(1),
      ).to.be.revertedWith('Not the owner');
    });
  });
  /*   it('deployed smart contracts should have valid addresses', async () => {
             expect(rskStarterLogs.address).to.be.properAddress;
             expect(rskStarter.address).to.be.properAddress;
           });

           it('logger counter should be set to zero', async () => {
             expect(await rskStarterLogs.count()).to.equal(0);
           });
         }); */
  /*
          describe('Logging the RskStarter function calls', () => {
            it('should log the speak() function call', async () => {
              const source = rskStarter.address;
              const isLoud = false;
              const text = 'Our purpose is to build a more decentralized world';

              await expect(rskStarter.speak(text))
                .to.emit(rskStarterLogs, 'RskStarterLog')
                .withArgs(source, isLoud, text);
            });

            it('should increment the logger counter after the logging', async () => {
              expect(await rskStarterLogs.count()).to.equal(1);
            });

            it('should log the shout() function call', async () => {
              const source = rskStarter.address;
              const isLoud = true;
              const text = 'Our vision is a safe and equitable global financial system';

              await expect(rskStarter.shout(text))
                .to.emit(rskStarterLogs, 'RskStarterLog')
                .withArgs(source, isLoud, text);
            });

            it('should increment the logger counter after the logging', async () => {
              expect(await rskStarterLogs.count()).to.equal(2);
            });
          });
         */
});
