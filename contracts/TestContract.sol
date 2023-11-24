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

contract TestContract is LSP8IdentifiableDigitalAsset, Reference {
    constructor() LSP8IdentifiableDigitalAsset("testContract", "TESTC", msg.sender, _LSP8_TOKENID_TYPE_ADDRESS){}

    
}