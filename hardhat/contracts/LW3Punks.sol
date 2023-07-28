// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract LW3Punks is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string _baseTokenURI;

    bool public _paused;

    //  _price is the price of one LW3Punks NFT
    uint256 public _price = 0.01 ether;

    uint256 public maxTokenIds = 10;

    uint256 public tokenIds;

    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract currently paused");
        _;
    }

    constructor(string memory baseURI) ERC721("LW3Punks", "LW3P") {
        _baseTokenURI = baseURI;
    }

    function mint() public payable onlyWhenNotPaused {
        require(maxTokenIds > tokenIds, "EXCEED_MAXIMUM_LW3Punks_SUPPLY");
        require(msg.value >= _price, "SENT_CORRECT_NUMBER_OF_ETHER");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    /**
     * @dev _baseURI overrides the Openzeppelin's ERC721 implementation which by default
     * returned an empty string for the baseURI
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev tokenURI overrides the Openzeppelin's ERC721 implementation for tokenURI function
     * This function returns the URI from where we can extract the metadata for a given tokenId
     */
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();

        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }

    /**
     * @dev setPaused makes the contract paused or unpaused
     */
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    /**
     * @dev withdraw sends all the ether in the contract
     * to the owner of the contract
     */
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "FAILED_TO_SENT_ETHER");
    }

    receive() external payable {}

    fallback() external payable {}
}
