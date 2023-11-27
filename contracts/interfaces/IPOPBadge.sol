// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IPOPBadge {
    /// supports IChannel interface
    /// @param interfaceId bytes4
    /// @return bool
    function supportsIPOPEventBadgeInterface(bytes4 interfaceId) external view returns (bool);

    function createBadge(address to) external;
}