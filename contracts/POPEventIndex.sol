// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { IPOPEvent } from "./interfaces/IPOPEvent.sol";
import { Reference } from "./helpers/Reference.sol";
import {
    LSP8IdentifiableDigitalAsset
} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";
import {
    _LSP8_TOKENID_TYPE_ADDRESS
} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8Constants.sol";

interface IPOPEventIndex {
    function isEventRegistered(address eventAddress) external view returns (bool);
}

contract POPEventIndex is LSP8IdentifiableDigitalAsset, Reference {
    
    struct Event {
        address eventAddress;
        bool status;
    }
    
    mapping (address => Event) registeredEvents;
    
    error EventAlreadyRegistered(address eventAddress);
    error EventNotSupported(address eventAddress);

    modifier eventSupported(address eventAddress) {
        if(!isEventSupported(eventAddress)) revert EventNotSupported(eventAddress);
        _;
    }

    constructor() LSP8IdentifiableDigitalAsset("POPEventregister", "POP", msg.sender, _LSP8_TOKENID_TYPE_ADDRESS) {}

    function isEventSupported(address eventAddress) public view returns (bool) {
        return IPOPEvent(eventAddress).supportsIPOPEventInterface(type(IPOPEvent).interfaceId);
    }

    function registerEvent(address eventAddress) external
        eventSupported(eventAddress) 
        isContractReferenced(eventAddress) {
 
            if(registeredEvents[eventAddress].status) revert EventAlreadyRegistered(eventAddress);
            
            registeredEvents[eventAddress] = Event(eventAddress, true);
            // mint to the owner of the event to prove ownership
            _mint(msg.sender, bytes32(abi.encodePacked(eventAddress)), true, "0x0");

    }

    function isEventRegistered(address eventAddress) external view returns (bool) {
        return registeredEvents[eventAddress].status;
    }

   
}