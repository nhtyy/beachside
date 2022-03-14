// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)

pragma solidity ^0.8.0;

// Adds Internal Pauseable functions, and modifiers to the child contract.
// You must create public/external function for these internal functions
// and add the modifiers
abstract contract Pausable {

    event Paused(address account);
    event Unpaused(address account);

    // bools default to false, therefore no constructor/init needed
    bool public paused;

///======================================================================================================================================
/// Modifiers
///======================================================================================================================================

    modifier whenNotPaused() {
        require(!paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "Pausable: not paused");
        _;
    }

///======================================================================================================================================
/// Internal
///======================================================================================================================================

    function _pause() internal whenNotPaused {
        paused = true;
        emit Paused(msg.sender);
    }

    function _unpause() internal whenPaused {
        paused = false;
        emit Unpaused(msg.sender);
    }
    
}