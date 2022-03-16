// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Beachside Pausable
/// @notice Pause and unpause an inherited contract.
/// @dev You must create public/external functions for these internal functions
/// and add the modifiers.
abstract contract Pausable {

    ///===========================
    /// STATE
    ///===========================

    ///@notice Thrown if the contract is paused.
    error IsPaused();

    ///@notice Thrown if the contract is not paused.
    error NotPaused();

    ///@notice Emitted when the contract is paused.
    event Paused(address account);

    ///@notice Emitted when the contract is unpaused.
    event Unpaused(address account);

    ///@notice Determines whether the contract is currently paused.
    ///@dev When the variable is at 0, it is not paused. When it is anything above 0, it is.
    uint256 public paused;

    ///===========================
    /// MODIFIERS
    ///===========================

    ///@notice Modifier to verify the contract is not paused.
    modifier whenNotPaused() {
        if (paused != 0) revert IsPaused();
        _;
    }

    ///@notice Modifier to verify the contract is paused.
    modifier whenPaused() {
        if (paused == 0) revert NotPaused();
        _;
    }

    ///===========================
    /// INTERNAL
    ///===========================

    ///@notice Pause.
    function _pause() internal whenNotPaused {
        paused = 1;

        emit Paused(msg.sender);
    }

    ///@notice Unpause.
    function _unpause() internal whenPaused {
        paused = 0;

        emit Unpaused(msg.sender);
    }
    
}