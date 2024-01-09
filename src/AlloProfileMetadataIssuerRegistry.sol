// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IRegistry.sol";


contract AlloProfileMetadataIssuerRegistry {
    IRegistry alloRegistry;

    mapping(string => address) issuerRegistry;

    constructor(IRegistry _alloRegistry) {
        alloRegistry = _alloRegistry;
    }

    function registerIssuerId(string memory _id) external {
        require(!doesProfileExist(hexStringToBytes32(_id)), "Can't register Allo Profile ID");
        require(!isIssuerIdRegistered(_id), "This ID is already registered");

        issuerRegistry[_id] = msg.sender;
    }

    function changeIssuerIdOwner(string memory _id, address _newOwner) external {
        require(issuerRegistry[_id] == msg.sender, "Only ID Owner can change");
        issuerRegistry[_id] = _newOwner;
    }

    function getOwnerOfId(string memory _id) external view returns (address) {
        return issuerRegistry[_id];
    } 

    function isIssuerIdRegistered(string memory _id) public view returns (bool) {
        return issuerRegistry[_id] != address(0);
    }

    function doesProfileExist(bytes32 _profileId) internal view returns (bool) {
        IRegistry.Profile memory _profile = alloRegistry.getProfileById(_profileId);
        return _profile.id != bytes32(0);
    }

    function hexStringToBytes32(string memory _str) internal pure returns (bytes32 result) {
        if (bytes(_str).length != 66) {
            return bytes32(0);
        }

        if (bytes(_str)[0] != "0" && (bytes(_str)[1] != "x" || bytes(_str)[1] != "X")) {
            return bytes32(0);
        }

        assembly {
            result := mload(add(_str, 32))
        }
    }
}