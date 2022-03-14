// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Stripped down transparent upgradable proxy, inlined the assembly
contract TransparentUpgradeableProxy {

    event Upgraded(address indexed implementation);

    event AdminChanged(address previousAdmin, address newAdmin);

    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

///======================================================================================================================================
/// Constructor
///======================================================================================================================================

    constructor(address addr, address adminAddr) {
        _setImpl(addr);
        _setAdmin(adminAddr);
    }

///======================================================================================================================================
/// Admin Funcs
///======================================================================================================================================

    modifier onlyAdmin() {
        if (msg.sender == _admin()) {
            _;
        } else {
            _fallback();
        }
    }

    function upgradeTo(address _newImpl) external onlyAdmin {
        require(_newImpl != address(0));

        _setImpl(_newImpl);

        emit Upgraded(_newImpl);
    }

    function changeAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0));

        address prev = _admin();

        _setAdmin(_newAdmin);

        emit AdminChanged(prev, _newAdmin);
    }

    function admin() external onlyAdmin returns (address addr) {
        return _admin();
    }

    function implementation() external onlyAdmin returns (address) {
        return _implementation();
    }

///======================================================================================================================================
/// Internal View
///======================================================================================================================================

    function _admin() internal view returns (address addr) {
        assembly {
            addr := sload(_ADMIN_SLOT)
        }
    }

    function _implementation() internal view returns (address impl){
        assembly {
            impl := sload(_IMPLEMENTATION_SLOT)
        }
    }

///======================================================================================================================================
/// Internal Mutuable
///======================================================================================================================================

    function _setImpl(address _newImpl) internal {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, _newImpl)
        }
    }

    function _setAdmin(address _newAdmin) internal {
        assembly {
            sstore(_ADMIN_SLOT, _newAdmin)
        }
    }

///======================================================================================================================================
/// Fallback and delegation
///======================================================================================================================================


    function _delegate(address impl) internal virtual {

        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }

    }

    function _fallback() internal virtual {

        // see OZ TransparentProxy
        require(msg.sender != _admin());

        _delegate(_implementation());
    }

    fallback() external payable virtual {
        _fallback();
    }

    receive() external payable virtual {
        _fallback();
    }

}