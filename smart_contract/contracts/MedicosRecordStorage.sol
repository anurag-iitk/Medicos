// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './DataTypesRecord.sol';
import './MedicosCommon.sol';

contract MedicosRecordStorage is MedicosCommon {

    uint public adminCount = 0;
    uint public doctorCount = 0;
    uint public patientCount = 0;
    uint public treatmentCount = 0;

    // Admin Mapping
    mapping( uint => AdminDetail) public adminIdMap;
    mapping( uint => AdminDetail) public adminAadharMap;
    mapping( address => AdminDetail) public adminAddressMap;
    mapping( uint => address) public adminReverseMap;

    // Doctor Mapping 
    mapping( uint => DoctorDetail) public doctorIdMap;
    mapping( uint => DoctorDetail) public doctorAadharMap;
    mapping( address => DoctorDetail) public doctorAddressMap;
    mapping( uint => address) public doctorReverseMap;

    // Patient Mapping
    mapping( uint => PatientDetail) public patientAadharMap;
    mapping( uint => uint) public patientReverseMap;

    // Treatment Mapping
    mapping( uint => TreatmentDetail) public treatmentIdMap;

    constructor(address _superAdmin) MedicosCommon(_superAdmin){}

    function create_admin(uint _adminAadhar, address _adminAddress, string calldata _name, string calldata _location) onlySuperAdmin public {
        bool isExisting = (adminAadharMap[_adminAadhar].adminAadhar != 0);
        if (!isExisting){
            adminCount += 1;
            require( _adminAadhar != 0, "Admin aadhar must be required");
            AdminDetail memory admin = AdminDetail(adminCount, _adminAadhar, _adminAddress, _name, _location);
            adminIdMap[adminCount] = admin;
            adminAadharMap[_adminAadhar] = admin;
            adminAddressMap[_adminAddress] = admin;
            adminReverseMap[_adminAadhar] = _adminAddress;   
        } else {
            // If exist, update details
            AdminDetail memory admin = adminAadharMap[_adminAadhar];
            admin.adminAadhar = _adminAadhar;
            admin.adminAddress = _adminAddress;
            admin.name = _name;
            admin.location = _location;
        }
                     
    }

    function create_doctor(uint _doctorAadhar, address _doctorAddress, string calldata _name, string calldata _speciality, string calldata _location, string[] calldata _certifications) public {
        bool isExisting = (doctorAadharMap[_doctorAadhar].doctorAadhar != 0);
        if (!isExisting){
            doctorCount += 1;
            require(_doctorAadhar != 0, "Doctor aadhar must be required");
            DoctorDetail memory doctor = DoctorDetail(doctorCount, _doctorAadhar, _doctorAddress, _name, _speciality, _location, 0, _certifications);
            doctorIdMap[doctorCount] = doctor;
            doctorAadharMap[_doctorAadhar] = doctor;
            doctorAddressMap[_doctorAddress] = doctor;
            doctorReverseMap[_doctorAadhar] = _doctorAddress;
        } else {
            DoctorDetail memory doctor = doctorAadharMap[_doctorAadhar];
            doctor.doctorAddress = _doctorAddress;
            doctor.doctorAddress = _doctorAddress;
            doctor.name = _name;
            doctor.location = _location;
            doctor.certification = _certifications;
        }
    }

    
 
}
