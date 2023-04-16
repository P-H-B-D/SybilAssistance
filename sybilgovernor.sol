pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./GovernorBravoInterfaces.sol";

// GovernorBravoDelegator contract for managing the SybilAssistance DAO.
contract GovernorBravoDelegator is GovernorBravoDelegatorStorage, GovernorBravoEvents {
constructor(
address timelock_,
address comp_,
address admin_,
address implementation_,
uint votingPeriod_,
uint votingDelay_,
uint proposalThreshold_) public {
    // Set admin to the account deploying the contract for initialization
    admin = msg.sender;

    // Delegate the initialization to the implementation contract
    delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,uint256,uint256,uint256)",
                                                        timelock_,
                                                        comp_,
                                                        votingPeriod_,
                                                        votingDelay_,
                                                        proposalThreshold_));

    // Set the implementation contract address
    _setImplementation(implementation_);

	// Set the admin to the provided admin address
	admin = admin_;
}


/**
 * @notice Called by the admin to update the implementation of the SybilAssistance delegator
 * @param implementation_ The address of the new implementation for delegation
 */
function _setImplementation(address implementation_) public {
    require(msg.sender == admin, "GovernorBravoDelegator::_setImplementation: admin only");
    require(implementation_ != address(0), "GovernorBravoDelegator::_setImplementation: invalid implementation address");

    address oldImplementation = implementation;
    implementation = implementation_;

    // Emit an event to notify that the implementation contract has been updated
    emit NewImplementation(oldImplementation, implementation);
}

/**
 * @notice Internal method to delegate execution to another contract for the SybilAssistance DAO
 * @dev It returns to the external caller whatever the implementation returns or forwards reverts
 * @param callee The contract to delegatecall
 * @param data The raw data to delegatecall
 */
function delegateTo(address callee, bytes memory data) internal {
    (bool success, bytes memory returnData) = callee.delegatecall(data);
    assembly {
        if eq(success, 0) {
            revert(add(returnData, 0x20), returndatasize)
        }
    }
}

/**
 * @dev Delegates execution to the SybilAssistance DAO's implementation contract.
 * It returns to the external caller whatever the implementation returns
 * or forwards reverts.
 */
function () external payable {
    // Delegate all other functions to the current implementation of SybilAssistance DAO
    (bool success, ) = implementation.delegatecall(msg.data);

    assembly {
          let free_mem_ptr := mload(0x40)
          returndatacopy(free_mem_ptr, 0, returndatasize)

          switch success
          case 0 { revert(free_mem_ptr, returndatasize) }
          default { return(free_mem_ptr, returndatasize) }
    }
}
}