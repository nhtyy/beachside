// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

///@title Initialize
///@dev for running parent contracts "*init()" functions when using a proxy,
/// if you're not using a proxy, consider putting them in the constructor.
abstract contract Initialize {

    ///@notice Determines whether the contract is initialized or not
    ///@dev When the variable is at 0, it is not initialized. When it is anything above 0, it is.
    uint256 public initialized;

    ///@notice Initialize the contract and verify it has not been already.
    modifier initializer() {

        require(initialized != 0, "ALREADY_INITIALIZED");

        _;

        initialized = 1;

    }

}