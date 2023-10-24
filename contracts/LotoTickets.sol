pragma solidity ^0.8.0;

//@author Antoine Libouban
//@title lottoTickets

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

interface IOracle {
    function peek() external view returns(uint256, bool);
    function getLastPublicationBlock() external view returns (uint256);
}

interface IMoCState {
    function getBitcoinPrice() external view returns(uint256);
    function getBtcPriceProvider() external view returns(address);
}

contract LottoTickets is Ownable, ERC721A {
    using Strings for uint256;

    uint256 public mintCost = 0.0001 ether;
    uint256 public rBtcPrice ;
    uint256 public supplyTotal;
    string public baseURI;
    string public baseExtension = '.json';
    address IMoCState_addr = 0x0adb40132cB0ffcEf6ED81c26A1881e214100555;


    constructor(string memory _initBaseURI) ERC721A('lottoTickets', 'LT') {
        setBaseURI(_initBaseURI);
    }

    // to be sure is not called by another contract
    modifier callerIsUser() {
        require(tx.origin == msg.sender, 'The caller is another contract');
        _;
    }

    // Return the current price
    function getPrice() external view returns(uint256){
        return IMoCState(IMoCState_addr).getBitcoinPrice();
    }

    // Legacy function compatible with old MOC Oracle.
    // returns a tuple (uint256, bool) that corresponds
    // to the price and if it is not expired.
    function peek() external view returns(uint256, bool){
        return IOracle(IMoCState(IMoCState_addr).getBtcPriceProvider()).peek();
    }

    // In the near close future it will implement this function
    // that returns the block number of the last publication.
    function getLastPublicationBlock() external view returns (uint256){
        return IOracle(IMoCState(IMoCState_addr).getBtcPriceProvider()).getLastPublicationBlock();
    }

    function mint(address _to, uint256 quantity) public payable callerIsUser {
        // require positive quantity
        require(quantity > 0);
        // require with this new mint the max supply willl not reach
        require(msg.value >= (mintCost * quantity), 'Not enough funds');
        super._safeMint(_to, quantity);
    }


    function withdraw() external payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }

    function burnOneToken(uint256 tokenId) external payable callerIsUser {
        // we need to tcheck if the token is owned by the function caller
        super._burn(tokenId);
    }

    function currentTime() internal view returns (uint256) {
        return block.timestamp;
    }

    function getCapital() external view returns (uint256) {
        return super._totalMinted() - super._totalBurned();
    }


    function setBaseURI(string memory _newBaseURI) private onlyOwner {
        baseURI = _newBaseURI;
    }
}
