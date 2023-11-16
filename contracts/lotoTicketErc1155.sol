pragma solidity ^0.8.0;

//@author Antoine Libouban
//@title lottoTickets
// SPDX-License-Identifier: UNLICENSED

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract LottoTicketsErc1155 is Ownable, ERC1155, ReentrancyGuard {
    uint256 private totalMinted;
    uint256 private totalBurned;
    using Strings for uint256;
    IERC20 public docToken;
    uint256 public mintCost = 1;
    uint256 public supplyTotal;
    string public baseURI;
    uint256 public constant TOKEN_ID = 1;

    constructor(string memory initialBaseURI, address payable _docTokenAddress)
        ERC1155(initialBaseURI)
    {
        baseURI = initialBaseURI;
        docToken = IERC20(address(_docTokenAddress)); // Initialize the DocToken instance with its address
    }

    // to be sure is not called by another contract
    modifier callerIsUser() {
        require(tx.origin == msg.sender, 'The caller is another contract');
        _;
    }

    function mintWithDOC(uint256 quantity)
        public
        nonReentrant
        callerIsUser
    {
        require(quantity > 0, 'Quantity must be positive');

        uint256 totalCost = mintCost * quantity;
        uint256 tokensToSend = totalCost * 10**18;

        require(
            docToken.allowance(msg.sender, address(this)) >= tokensToSend,
            'Approve DocToken first'
        );

        bool sent = docToken.transferFrom(
            msg.sender,
            address(this),
            tokensToSend
        );
        require(sent, 'DocToken transfer failed');

        // Mint the tokens using ERC-1155 _mint function
        _mint(msg.sender, TOKEN_ID, quantity, '');
        totalMinted += quantity;
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(amount == 1, 'Can only transfer 1 unit at a time');
        super.safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public override {
        for (uint256 i = 0; i < amounts.length; i++) {
            require(amounts[i] == 1, 'Can only transfer 1 unit at a time');
        }
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function burnOneToken() external payable callerIsUser {
        _burn(msg.sender, TOKEN_ID, 1);
    }

    function _burn(
        address account,
        uint256 id,
        uint256 amount
    ) internal override {
        super._burn(account, id, amount);
        totalBurned += amount;
    }

    function currentTime() internal view returns (uint256) {
        return block.timestamp;
    }

    function getCapital() external view returns (uint256) {
        return totalMinted - totalBurned;
    }

    function getDocAmountOnContract() external view returns (uint256) {
        return docToken.balanceOf(address(this));
    }


    // we override it to got ntf with same metadatas
    function uri(uint256 tokenId) public view override returns (string memory) {
        return baseURI; // baseURI is the IPFS link to the unified metadata file
    }
}
