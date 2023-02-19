// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {
    function getPrice() external view returns (uint256);
    function available(uint256 _tokenId)  external view returns (bool);
    function purchase(uint256 _tokenId) external payable;
}

interface ICryptoDevsNFT {
    function balanceOf(address owner) external view returns (uint256);
    function tokenOfOwnerByIndex (address owner, uint256 index) external view returns (uint256);
}

contract CryptoDevsDAO is Ownable {

    struct Proposal {
        uint256 nftTokenId;
        uint256 deadline;
        uint256 yayvotes;
        uint256 nayvotes;
        bool executed;
        mapping (uint256 => bool) voters;
    }
    mapping (uint256 => Proposal) public proposals;
    uint256 public numProposals;
    IFakeNFTMarketplace nftMarketplace;
    ICryptoDevsNFT cryptoDevsNFT;
    constructor (address _nftMarketplace, address _cryptoDevsNFT ) payable {
        nftMarketplace = IFakeNFTMarketplace (_nftMarketplace);
        cryptoDevsNFT = ICryptoDevsNFT (_cryptoDevsNFT);
    }
    modifier nftHolderOnly {
        require(cryptoDevsNFT.balanceOf(msg.sender) > 0, "Not A Dao Memver");
        _;
    }
    function createProposal(uint256 _nftTokenId) external nftHolderOnly returns (uint256)
    {
        require(nftMarketplace.available(_nftTokenId), "NFT Not For Sale");
        Proposal storage proposal = proposals[numProposals];
        proposal.nftTokenId = _nftTokenId;
        proposal.deadline = block.timestamp + 5 minutes;
        numProposals++;
        return numProposals - 1;
    }

    modifier activeProposalOnly(uint256 proposalIndex) {
        require
        (
            proposals[proposalIndex].deadline > block.timestamp,
            "DEADLINE EXCEEDED"
        );
        _;
        
    }
    

}