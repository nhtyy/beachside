// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10;

// no 0 checks
abstract contract Owner {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public owner;

    modifier onlyOwner() {
        require (msg.sender == owner, "Not owner");
        _;
    }

    // external function only for the actual owner
    function transferOwnership(address newOwner) public virtual onlyOwner {
        _transferOwnership(newOwner);
    }

    // internal function that actually sets owner
    // init function will call this
    function _transferOwnership(address newOwner) internal {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    // run in derived contract
    // _transferOwnership() can be used in place of authInit()
    // if desired owner is not deployer
    function authInit() internal {
        _transferOwnership(msg.sender);
    }
    
}