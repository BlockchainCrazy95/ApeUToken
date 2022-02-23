// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "../interfaces/IPlanetsManager.sol";

abstract contract PlanetsManagerImplementationPointerUpgradeable is OwnableUpgradeable {
    IPlanetsManager internal planetsManager;

    event UpdatePlanetsManager(
        address indexed oldImplementation,
        address indexed newImplementation
    );

    modifier onlyPlanetsManager() {
        require(
            address(planetsManager) != address(0),
            "Implementations: PlanetsManager is not set"
        );
        address sender = _msgSender();
        require(
            sender == address(planetsManager),
            "Implementations: Not PlanetsManager"
        );
        _;
    }

    function getPlanetsManagerImplementation() public view returns (address) {
        return address(planetsManager);
    }

    function changePlanetsManagerImplementation(address newImplementation)
        public
        virtual
        onlyOwner
    {
        address oldImplementation = address(planetsManager);
        require(
            AddressUpgradeable.isContract(newImplementation) ||
                newImplementation == address(0),
            "PlanetsManager: You can only set 0x0 or a contract address as a new implementation"
        );
        planetsManager = IPlanetsManager(newImplementation);
        emit UpdatePlanetsManager(oldImplementation, newImplementation);
    }

    uint256[49] private __gap;
}