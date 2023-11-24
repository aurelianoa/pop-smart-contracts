// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import { IERC725Y } from "@erc725/smart-contracts/contracts/interfaces/IERC725Y.sol";

import {
    _LSP8_REFERENCE_CONTRACT
} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8Constants.sol";

abstract contract Reference {

    error InvalidReferenceAddress(address referenceAddress);
    
    modifier isContractReferenced(address referenceAddress) {
       if(!verifyReference(referenceAddress)) revert InvalidReferenceAddress(referenceAddress);
        _;
    }
    
    function verifyReference(address tokenIdAddress) public view returns ( bool ) {
        IERC725Y referencedContract = IERC725Y(tokenIdAddress);
        bytes memory referenceContract = referencedContract.getData(_LSP8_REFERENCE_CONTRACT);
        
        return keccak256(abi.encodePacked(bytes20(referenceContract))) == keccak256(abi.encodePacked(bytes20(address(this))));
    }

}