pragma solidity ^0.8.0;

//@author Antoine Libouban
//@title lottoTickets
// SPDX-License-Identifier: UNLICENSED

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract LottoTickets is Ownable, ERC721A, ReentrancyGuard {
    using Strings for uint256;
    IERC20 public docToken;

    uint256 public mintCost = 1;
    uint256 public supplyTotal;
    string public baseURI;
    string public baseExtension = '.json';

    constructor(string memory _initBaseURI, address payable _docTokenAddress)
        ERC721A('LottoTickets', 'LT') // <-- Added this line
    {
        setBaseURI(_initBaseURI);
        docToken = IERC20(address(_docTokenAddress)); // Initialize the DocToken instance with its address
    }

    // to be sure is not called by another contract
    modifier callerIsUser() {
        require(tx.origin == msg.sender, 'The caller is another contract');
        _;
    }

    function mintWithDOC(address _to, uint256 quantity)
        public
        nonReentrant
        callerIsUser
    {
        require(quantity > 0, 'Quantity must be positive');

        uint256 totalCost = mintCost * quantity;

        uint256 tokensToSend = totalCost * 10**18;
        require(
            docToken.allowance(msg.sender, address(this)) >= totalCost,
            'Approve DocToken first'
        );
        bool sent = docToken.transferFrom(
            msg.sender,
            address(this),
            tokensToSend
        );
        require(sent, 'DocToken transfer failed');
        super._mint(_to, quantity);

        // Mint the tokens
        // for (uint256 i = 0; i < quantity; i++) {
        //      super._safeMint(_to, supplyTotal + i);
        // }
        // i think erc721a no need that
        // supplyTotal += quantity;
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

    function getDocAmountOnContract() external view returns (uint256) {
        return docToken.balanceOf(address(this));
    }

    function setBaseURI(string memory _newBaseURI) private onlyOwner {
        baseURI = _newBaseURI;
    }
}
