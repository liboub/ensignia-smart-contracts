pragma solidity ^0.5.8;

import "money-on-chain/contracts/MoC.sol";
import "money-on-chain/contracts/token/DocToken.sol";
import 'money-on-chain/contracts/MoCInrate.sol';
import 'money-on-chain/contracts/MoCExchange.sol';
// Here you will import your own dependencies
​
contract YourMintingDocContract {
// Address of the MoC contract
MoC public moc;
// Address of the MoCInrate contract
MoCInrate public mocInrate;
// Address of the MoCExchange contract
MoCExchange public moCExchange;
// Address of the doc token
DocToken public doc;
// Address that will receive all the commissions
address public receiverAddress;
// Address that will receive the markup
address public vendorAccount;
// rest of your variables

constructor (MoC _mocContract, MoCInrate _mocInrateContract, MoCExchange _mocExchangeContract, DocToken _doc, address _receiverAddress, address _vendorAccount) public {
moc = _mocContract;
mocInrate = _mocInrateContract;
moCExchange = _mocExchangeContract;
doc = _doc;
receiverAddress = _receiverAddress;
vendorAccount = _vendorAccount;
// You could have more variables to initialize here
}
​
function doTask(uint256 btcAmount) public payable {
// Calculate operation fees
CommissionParamsStruct memory params;
params.account = address(this); // address of minter
params.amount = btcAmount; // BTC amount you want to mint
params.txTypeFeesMOC = mocInrate.MINT_DOC_FEES_MOC();
params.txTypeFeesRBTC = mocInrate.MINT_DOC_FEES_RBTC();
params.vendorAccount = vendorAccount;

CommissionReturnStruct memory commission = mocExchange.calculateCommissionsWithPrices(params);
// If commission is paid in RBTC, subtract it from value
uint256 fees = commission.btcCommission - commission.btcMarkup;
// Mint some new DoC
moc.mintDocVendors.value(msg.value)(msg.value - fees, vendorAccount);
​      // Transfer it to your receiver account
doc.transfer(receiverAddress, doc.balanceOf(address(this)));
// Rest of the function to actually perform the task
}
// rest of your contract
}
