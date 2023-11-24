// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IPOPEventIndex {
    error EventNotRegistered();
    function isEventRegistered(address eventAddress) external view returns (bool);
}
