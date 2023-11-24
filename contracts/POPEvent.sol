// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Reference } from "./helpers/Reference.sol";
import { IPOPEvent } from "./interfaces/IPOPEvent.sol";
import { IPOPBadge } from "./interfaces/IPOPBadge.sol";
import { IPOPEventIndex } from "./interfaces/IPOPEventIndex.sol";

import { LSP7DigitalAsset } from "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/LSP7DigitalAsset.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {
    _LSP4_METADATA_KEY 
} from "@lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol";
import {
    _LSP8_REFERENCE_CONTRACT
} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8Constants.sol";

contract POPEvent is IPOPEvent, LSP7DigitalAsset, Reference, ReentrancyGuard {

    error Unauthorized();
    
    mapping (address => bool) private authorizedAgents;
    mapping (address => bool) private badges;

    /// @dev Modifier to ensure caller is authorized operator
    modifier onlyAuthorizedAgent() {
        if (!authorizedAgents[msg.sender] || msg.sender == owner()) {
            revert Unauthorized();
        }
        _;
    }

    modifier onlyRegisteredEvent() {
        IPOPEventIndex eventIndex = IPOPEventIndex(getEventIndexReferenced());
        if(!eventIndex.isEventRegistered(msg.sender)) revert EventNotRegistered();
        _;
    }

    constructor() LSP7DigitalAsset("MYPOPevent", "POPE", msg.sender, true) {
        // 5ffcf195a9af69d6c3d67d0f71def5a1b9d72fdb251d64d40496441e04f2cf7b is the hash of the URI JSON content
        bytes memory jsonUrl = abi.encodePacked(
            bytes4(keccak256('keccak256(utf8)')),
            hex"5ffcf195a9af69d6c3d67d0f71def5a1b9d72fdb251d64d40496441e04f2cf7b",
            bytes('ipfs://QmcDs3Xqh9SfYD5sXme98427JSDNULvdZf2fy2pgx9sNYt'));

        _setData(_LSP4_METADATA_KEY, jsonUrl);
    }

    /// @inheritdoc IPOPEvent
    function supportsIPOPEventInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IPOPEvent).interfaceId;
    }

    function getTicket(address to) external payable onlyRegisteredEvent nonReentrant {
        // use a signature to aproove the tokens to be burned;
        authorizeOperator(address(this), 1, "Burnable by this contract");    
        _mint(to, 1, false, "0x0");
    }

    function checkIn(address attendee) external onlyRegisteredEvent onlyAuthorizedAgent nonReentrant {
        if(balanceOf(attendee) < 0) revert("POPEvent: attendee does not have a ticket");
        _spendAllowance(address(this), attendee, 1);
        _burn(attendee, 1, "0x0");
        /// mint the badge with the registered badge contract
        IPOPBadge badge = IPOPBadge(getBadgeReferenced());
        badge.createBadge(address(this), attendee);
    }

    //admin functions

    function registerReference(address _referenceAddress) external {
        require(_referenceAddress != address(0x0), "POPEvent: zero address");
        super._setData(
            _LSP8_REFERENCE_CONTRACT,
            abi.encodePacked(
                _referenceAddress,
                bytes32(bytes20(address(this)))
            )
        );
    }

    function registerBadge(address _badgeAddress) external {
        require(_badgeAddress != address(0x0), "POPEvent: zero address");
        /// check if address is IBadge contract
        IPOPBadge badge = IPOPBadge(_badgeAddress);
        require(badge.supportsIPOPEventBadgeInterface(type(IPOPBadge).interfaceId), "POPEvent: badge does not support IPOPBadge interface");
        badges[_badgeAddress] = true;
    } 

    function getEventIndexReferenced() public view returns (address) {
        return address(bytes20(super._getData(_LSP8_REFERENCE_CONTRACT)));
    }

    function setAuthorizedAgent(address _operator, bool status) public virtual onlyOwner {
        /// check if address is not null
        require(_operator != address(0), "Authorized System: Operator address cannot be null");
        
        /// update the operator status
        authorizedAgents[_operator] = status;
    }

    function getAuthorizedAgent(address _operator) external view virtual returns (bool) {
        return authorizedAgents[_operator];
    }

}