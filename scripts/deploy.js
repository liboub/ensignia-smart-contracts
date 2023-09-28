const { deployContract } = require('../util');

async function main() {
  try {
    const LottoTickets = await deployContract('LottoTickets','ipfs//QmRDKjZLj2Yfd4eEEBo8gU2X2FCbMsRUqj79iqFkzUuYKS/');
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
}

main();
