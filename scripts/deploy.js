const { deployContract } = require('../util');

async function main() {
  try {
    //const LottoTickets = await deployContract('LottoTickets','ipfs//QmesotUeUcMRhTEvpHhM3F7KN24Pzf9hzGzqaCmuCvFfBD/','0xCB46c0ddc60D18eFEB0E586C17Af6ea36452Dae0');
    // const MintDocContract = await deployContract(
    //    'LottoTickets',
    //    '0xcb46c0ddc60d18efeb0e586c17af6ea36452dae0',
    //  );
    //  const MintDocContract2 = await deployContract(
    //     'LottoTicketsErc1155',
    //  'ipfs://QmR5JoJjhLWKdYPAnphHeZ5m2QT5tmAHPLLbxe6SmW96NT',
    //  '0xcb46c0ddc60d18efeb0e586c17af6ea36452dae0',
    //  );
    const MintDocContract3 = await deployContract(
      'LottoTicketsERC20',
      '0xcb46c0ddc60d18efeb0e586c17af6ea36452dae0',
    );
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
}

main();
