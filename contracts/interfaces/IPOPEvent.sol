// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IPOPEvent {
    error EventNotRegistered(msg.sender);

    /// supports IChannel interface
    /// @param interfaceId bytes4
    /// @return bool
    function supportsIPOPEventInterface(bytes4 interfaceId) external view returns (bool);


}