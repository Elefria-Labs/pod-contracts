pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/security/Pausable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";


contract PoDNFT is ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(bytes32 => uint256) public projectTokenIdMap;

    mapping(bytes32 => address) public approvedProjectOwners;

    mapping(bytes32 => mapping(bytes32 => address)) public nftOwners;

    constructor() ERC721("Proof of Development", "PoD") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function approveProject(bytes32 projectIdHash, address owner) public onlyOwner {
        approvedProjectOwners[projectIdHash]=owner;
    }

    function safeMint(address to, bytes32 projectIdHash,bytes32 contributor, string memory uri) public onlyOwner {
        require(approvedProjectOwners[projectIdHash]!=address(0),"Not approved");
        require(nftOwners[projectIdHash][contributor]==address(0),"Minted");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        projectTokenIdMap[projectIdHash]=tokenId;
        nftOwners[projectIdHash][contributor]=to;
    }

 function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }


    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
