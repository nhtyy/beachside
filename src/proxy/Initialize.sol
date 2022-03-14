// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// for running parent contracts "*init()" functions when using a proxy,
// if youre not using a proxy, consider putting them in the constructor
abstract contract Initialize {

    bool public initalized;

    modifier initializer() {

        require(!initalized, "Already Initialized");

        _;

        initalized = true;

    }

}