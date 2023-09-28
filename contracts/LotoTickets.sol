pragma solidity ^0.8.0;

//@author Antoine Libouban
//@title lottoTickets

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

contract LottoTickets is Ownable, ERC721A {
    using Strings for uint256;

    uint256 public mintCost = 0.1 ether;
    uint256 public supplyTotal;
    string public baseURI;
    string public baseExtension = ".json";

    constructor(string memory _initBaseURI) ERC721A('lottoTickets', 'LT') {
        setBaseURI(_initBaseURI);
    }

    // to be sure is not called by another contract
    modifier callerIsUser() {
        require(tx.origin == msg.sender, 'The caller is another contract');
        _;
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

    function getTotalMinted() external view returns (uint256) {
        return super._totalMinted();
    }

    function getMintCost() external view returns (uint256) {
        return mintCost;
    }

    function setBaseURI(string memory _newBaseURI) private onlyOwner {
        baseURI = _newBaseURI;
    }
}
