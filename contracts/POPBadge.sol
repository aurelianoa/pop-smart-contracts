// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IPOPBadge} from "./interfaces/IPOPBadge.sol";
import {IPOPEventIndex} from "./interfaces/IPOPEventIndex.sol";
import {IPOPEvent} from "./interfaces/IPOPEvent.sol";
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

    modifier onlyRegisteredEvent() {
        IPOPEvent eventContract = IPOPEvent(msg.sender);
        IPOPEventIndex eventIndex = IPOPEventIndex(eventContract.getEventIndexReferenced());
        //if(!eventIndex.isEventRegistered(msg.sender)) revert IPOPEventIndex.EventNotRegistered();
        _;
    }
    
    constructor() LSP8IdentifiableDigitalAsset("POPBadge", "POPB", msg.sender, _LSP8_TOKENID_TYPE_NUMBER) {}

    function supportsIPOPEventBadgeInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IPOPBadge).interfaceId;
    }

    function createBadge(address to) external onlyRegisteredEvent() nonReentrant {
        uint256 _totalSupply = totalSupply();

        uint256 tokenId = ++_totalSupply;
        bytes12 _tokenId = bytes12(abi.encodePacked(tokenId.toString()));
        bytes32 btyes32TokenId = bytes32(abi.encodePacked(msg.sender, _tokenId));
        _mint(to, btyes32TokenId, true, "0x0");
    }

}
