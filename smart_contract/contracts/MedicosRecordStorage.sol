// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./DataTypesRecord.sol";
import "./MedicosCommon.sol";

contract MedicosRecordStorage is MedicosCommon {
    uint256 public adminCount = 0;
    uint256 public doctorCount = 0;
    uint256 public patientCount = 0;
    uint256 public treatmentCount = 0;

    // Admin Mapping
    mapping(uint256 => AdminDetail) public adminIdMap;
    mapping(uint256 => AdminDetail) public adminAadharMap;
    mapping(address => AdminDetail) public adminAddressMap;
    mapping(uint256 => address) public adminReverseMap;

    // Doctor Mapping
    mapping(uint256 => DoctorDetail) public doctorIdMap;
    mapping(uint256 => DoctorDetail) public doctorAadharMap;
    mapping(address => DoctorDetail) public doctorAddressMap;
    mapping(uint256 => address) public doctorReverseMap;

    // Patient Mapping
    mapping(uint256 => PatientDetail) public patientAadharMap;
    mapping(uint256 => uint256) public patientReverseMap;

    // Treatment Mapping
    mapping(uint256 => TreatmentDetail) public treatmentIdMap;

    modifier onlySuperAdminAndAdmin() {
        require(
            adminAddressMap[msg.sender].adminAddress != address(0x0) &&
                msg.sender == superAdmin,
            "Only super admin and admin can call this function"
        );
        _;
    }

    constructor(address _superAdmin) MedicosCommon(_superAdmin) {}

    function add_admin(
        uint256 _adminAadhar,
        address _adminAddress,
        string calldata _name,
        string calldata _location
    ) public onlySuperAdmin {
        bool isExisting = (adminAadharMap[_adminAadhar].adminAadhar != 0);
        if (!isExisting) {
            adminCount += 1;
            require(_adminAadhar != 0, "Admin aadhar must be required");
            AdminDetail memory admin = AdminDetail(
                adminCount,
                _adminAadhar,
                _adminAddress,
                _name,
                _location
            );
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

    function add_doctor(
        uint256 _doctorAadhar,
        address _doctorAddress,
        string calldata _name,
        string calldata _speciality,
        string calldata _location,
        string[] calldata _certifications
    ) public {
        bool isExisting = (doctorAadharMap[_doctorAadhar].doctorAadhar != 0);
        if (!isExisting) {
            doctorCount += 1;
            require(_doctorAadhar != 0, "Doctor aadhar must be required");
            DoctorDetail memory doctor = DoctorDetail(
                doctorCount,
                _doctorAadhar,
                _doctorAddress,
                _name,
                _speciality,
                _location,
                0,
                _certifications
            );
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

    function add_patient(
        uint256 _patientAadhar,
        string calldata _name,
        uint256 _age,
        string calldata _dob,
        string calldata _location,
        uint256 _height,
        uint256 _weight,
        string calldata _bloodGroup,
        string calldata _diagonsis
    ) public {
        bool isExisting = patientAadharMap[_patientAadhar].patientAadhar != 0;
        if(!isExisting){
            patientCount += 1;
            PatientDetail memory patient;
            patient.patientAadhar = _patientAadhar;
            patient.name = _name;
            patient.age = _age;
            patient.dob = _dob;
            patient.location = _location;
            patient.height = _height;
            patient.weight = _weight;
            patient.bloodGroup = _bloodGroup;
            patient.diagonsis = _diagonsis;
            patient.discharged = false;
            patientAadharMap[_patientAadhar] = patient;
            patientReverseMap[patientCount] = _patientAadhar;
        } else {
            PatientDetail memory patient = patientAadharMap[_patientAadhar];
            patient.name = _name;
            patient.age = _age;
            patient.dob = _dob;
            patient.location = _location;
            patient.height = _height;
            patient.weight = _weight;
            patient.bloodGroup = _bloodGroup;
            patient.diagonsis = _diagonsis;
        }
    }
 
    function add_treatment(uint256 _patientAadhar) public {
        treatmentCount += 1;
        TreatmentDetail memory treatment;
        treatment.treatmentId = treatmentCount;
        treatment.patientAadhar = _patientAadhar;
        treatmentIdMap[treatmentCount] = treatment;
        patientAadharMap[_patientAadhar].gonetreatment.push(treatmentCount);
    }

}
