// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "../../contracts/interfaces/IUniverse.sol";

abstract contract UniverseImplementationPointerUpgradeable is OwnableUpgradeable {
    IUniverse internal universe;

    event UpdateUniverse(
        address indexed oldImplementation,
        address indexed newImplementation
    );

    modifier onlyUniverse() {
        require(
            address(universe) != address(0),
            "Implementations: Universe is not set"
        );
        address sender = _msgSender();
        require(
            sender == address(universe),
            "Implementations: Not Universe"
        );
        _;
    }

    function getUniverseImplementation() public view returns (address) {
        return address(universe);
    }

    function changeUniverseImplementation(address newImplementation)
        public
        virtual
        onlyOwner
    {
        address oldImplementation = address(universe);
        require(
            AddressUpgradeable.isContract(newImplementation) ||
                newImplementation == address(0),
            "Universe: You can only set 0x0 or a contract address as a new implementation"
        );
        universe = IUniverse(newImplementation);
        emit UpdateUniverse(oldImplementation, newImplementation);
    }

    uint256[49] private __gap;
}