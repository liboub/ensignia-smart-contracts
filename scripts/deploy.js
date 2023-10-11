const { deployContract } = require('../util');

async function main() {
  try {
    const LottoTickets = await deployContract('LottoTickets','ipfs//QmesotUeUcMRhTEvpHhM3F7KN24Pzf9hzGzqaCmuCvFfBD/');
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
}

main();
