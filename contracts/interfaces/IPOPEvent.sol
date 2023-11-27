// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IPOPEvent {
    error EventNotRegistered(address eventAddress);

    /// supports IChannel interface
    /// @param interfaceId bytes4
    /// @return bool
    function supportsIPOPEventInterface(bytes4 interfaceId) external view returns (bool);

    function getEventIndexReferenced() external view returns (address);


}