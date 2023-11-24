// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {
    LSP8IdentifiableDigitalAsset
    } from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";
import { Reference } from "./helpers/Reference.sol";
import {
    _LSP8_TOKENID_TYPE_ADDRESS,
    _LSP8_REFERENCE_CONTRACT
} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8Constants.sol";


contract TestReference is LSP8IdentifiableDigitalAsset, Reference {

    constructor() LSP8IdentifiableDigitalAsset("test", "TEST", msg.sender, _LSP8_TOKENID_TYPE_ADDRESS){}

    function registerReference(address _referenceAddress) external {
        
       _setData(
            _LSP8_REFERENCE_CONTRACT,
            abi.encodePacked(
                _referenceAddress,
                bytes32(bytes20(address(this)))
            )
        );
    }
}