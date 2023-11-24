// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IPOPBadge} from "./interfaces/IPOPBadge.sol";
import {IPOPEventIndex} from "./interfaces/IPOPEventIndex.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import {
    LSP8IdentifiableDigitalAsset
} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";
import {
    _LSP4_METADATA_KEY 
} from "@lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol";
import {
    _LSP8_TOKENID_TYPE_NUMBER
} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8Constants.sol";


contract POPBadge is IPOPBadge, LSP8IdentifiableDigitalAsset, ReentrancyGuard {
    using Strings for uint256;
    modifier onlyRegisteredEvent(address eventAddress) {
        IPOPEventIndex eventIndex = IPOPEventIndex(eventAddress);
        if(!eventIndex.isEventRegistered(msg.sender)) revert IPOPEventIndex.EventNotRegistered();
        _;
    }
    
    constructor() LSP8IdentifiableDigitalAsset("POPBadge", "POPB", msg.sender, _LSP8_TOKENID_TYPE_NUMBER) {
        // 5ffcf195a9af69d6c3d67d0f71def5a1b9d72fdb251d64d40496441e04f2cf7b is the hash of the URI JSON content
        bytes memory jsonUrl = abi.encodePacked(
            bytes4(keccak256('keccak256(utf8)')),
            hex"5ffcf195a9af69d6c3d67d0f71def5a1b9d72fdb251d64d40496441e04f2cf7b",
            bytes('ipfs://QmcDs3Xqh9SfYD5sXme98427JSDNULvdZf2fy2pgx9sNYt'));

        _setData(_LSP4_METADATA_KEY, jsonUrl);
    }

    function supportsIPOPEventBadgeInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IPOPBadge).interfaceId;
    }

    function createBadge(address eventAddress, address to) external onlyRegisteredEvent(msg.sender) nonReentrant {
        uint256 _totalSupply = totalSupply();

        uint256 tokenId = ++_totalSupply;
        /// tokenId = eventAddress + tokenId
        bytes12 _tokenId = bytes12(abi.encodePacked(tokenId.toString()));
        bytes32 btyes32TokenId = bytes32(abi.encodePacked(eventAddress, _tokenId));
        _mint(to, btyes32TokenId, false, "0x0");
    }
}
