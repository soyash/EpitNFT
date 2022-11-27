// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/utils/Counters.sol";
import {Base64} from "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/utils/Base64.sol";

contract EpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; // _tokenIds is a Counter struct used to keep track of NFTs created

    string[] firstWord = ["Flying", "Swimming", "Walking", "Sitting", "Standing", "Sleeping"];
    string[] secondWord = ["Moneky", "Squirel", "Shark", "Lion", "Dog", "Penguin"];
    string[] thirdWord = ["Swims", "Walks", "Sits", "Stands", "Sleeps", "Flies"];
    string[] colors = ["black", "#625D5D", "#000080", "#00CED1", "#FFD700", "#B87333", "#3B2F2F", "#FF6700", "#FF2400", "#F6358A", "#FF00FF"];

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    
    string colorSvg = "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    event mintedNFT(address _owner, uint256 _newItemId, string _tokenURI);

    constructor() ERC721("SquareNFT", "SQUARE")  {
    }


    function random(string memory _input) internal pure returns(uint256) {
        return(uint256(keccak256(abi.encodePacked(_input))));
    }

    
    function pickRandomFirstWord(uint256 _tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST WORD", Strings.toString(_tokenId))));
        rand = rand % 6;
        return firstWord[rand];
    }


    function pickRandomSecondWord(uint256 _tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND WORD", Strings.toString(_tokenId))));
        rand = rand % 6;
        return secondWord[rand];
    }


    function pickRandomThirdWord(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD WORD", Strings.toString(_tokenId))));
        rand = rand % 6;
        return thirdWord[rand];
    }


    function pickRandomColor(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(_tokenId))));
        rand = rand % 11;
        return colors[rand];
    }

    
    function makeAnEpicNFT(string memory _data) public {
        // unique id for the NFT
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= 50, "No more NFTs can be minted");

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory color = pickRandomColor(newItemId);

        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, color, colorSvg, first, second, third, "</text></svg>"));

        string memory json = Base64.encode(
            abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
        );

        /*
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", _data) //previously json before _data
        );
        */

       string memory finalTokenUri = string(abi.encodePacked("ipfs://", _data));

        // assign the unique id to the sender which is essentially minting
        _safeMint(msg.sender, newItemId);

        // associates the actual NFT data with the unique id value in "" can be anything, image music etc 
        // data is given via a tokenURI
        _setTokenURI(newItemId, finalTokenUri);
        //_setTokenURI(newItemId, "ipfs://Qmb8SzkFST3wUymRuvDPZsqhMh8utccE3tcouxPXFQ8gf");

        _tokenIds.increment();
        emit mintedNFT(msg.sender, newItemId, finalTokenUri);
    }

    function gerTotalNFTsMinted() public returns(uint) {
        return _tokenIds.current();
    }
}