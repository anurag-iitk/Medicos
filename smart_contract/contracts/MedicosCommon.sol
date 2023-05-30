// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

contract MedicosCommon {

    address public superAdmin;

    constructor(address _superAdminAddress){
        superAdmin = _superAdminAddress;
    }

    modifier onlySuperAdmin{
        require( msg.sender == superAdmin, "Only super admin can call this function");
        _;
    }

    function setSuperAdmin(address _superAdmin) public onlySuperAdmin {
        superAdmin = _superAdmin;
    }
}