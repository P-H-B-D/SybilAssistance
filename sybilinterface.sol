pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

// Contract for SybilAssistance events
contract SybilAssistanceEvents {
/// @notice An event emitted when a new research proposal is created
event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);

csharp
Copy code
/// @notice An event emitted when a vote has been cast on a research proposal
/// @param voter The address which casted a vote
/// @param proposalId The proposal id which was voted on
/// @param support Support value for the vote. 0=against, 1=for, 2=abstain
/// @param votes Number of votes which were cast by the voter
/// @param reason The reason given for the vote by the voter
event VoteCast(address indexed voter, uint proposalId, uint8 support, uint votes, string reason);

/// @notice An event emitted when a research proposal has been canceled
event ProposalCanceled(uint id);

/// @notice An event emitted when a research proposal has been queued in the Timelock
event ProposalQueued(uint id, uint eta);

/// @notice An event emitted when a research proposal has been executed in the Timelock
event ProposalExecuted(uint id);

/// @notice An event emitted when the voting delay is set
event VotingDelaySet(uint oldVotingDelay, uint newVotingDelay);

/// @notice An event emitted when the voting period is set
event VotingPeriodSet(uint oldVotingPeriod, uint newVotingPeriod);

/// @notice Emitted when implementation is changed
event NewImplementation(address oldImplementation, address newImplementation);

/// @notice Emitted when research proposal threshold is set
event ProposalThresholdSet(uint oldProposalThreshold, uint newProposalThreshold);

/// @notice Emitted when pendingAdmin is changed
event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

/// @notice Emitted when pendingAdmin is accepted, which means admin is updated
event NewAdmin(address oldAdmin, address newAdmin);
}

// Contract for SybilAssistance delegator storage
contract SybilAssistanceDelegatorStorage {
/// @notice Administrator for this contract
address public admin;

arduino
Copy code
/// @notice Pending administrator for this contract
address public pendingAdmin;

/// @notice Active brains of SybilAssistance
address public implementation;
}

/**

@title Storage for SybilAssistance Delegate

@notice For future upgrades, do not change SybilAssistanceDelegateStorageV1. Create a new

contract which implements SybilAssistanceDelegateStorageV1 and following the naming convention

SybilAssistanceDelegateStorageVX.
*/
contract SybilAssistanceDelegateStorageV1 is SybilAssistanceDelegatorStorage {

/// @notice The delay before voting on a research proposal may take place, once proposed, in blocks
uint public votingDelay;

/// @notice The duration of voting on a research proposal, in blocks
uint public votingPeriod;

/// @notice The number of votes required in order for a voter to become a proposer
uint public proposalThreshold;

/// @notice Initial proposal id set at become
uint public initialProposalId;

/// @notice The total number of research proposals
uint public proposalCount;

/// @notice The address of the SybilAssistance Protocol Timelock
TimelockInterface public timelock;

/// @notice The address of the SybilAssistance