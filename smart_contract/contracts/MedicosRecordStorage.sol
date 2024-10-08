// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./DataTypesRecord.sol";
import "./MedicosCommon.sol";

contract MedicosRecordStorage is MedicosCommon {
    event addAdmin(uint256 indexed adminAadhar, string name, string location);
    event addDoctor(
        uint256 indexed doctorAadhar,
        string name,
        string location,
        string indexed speciality
    );
    event addPatient(
        uint256 indexed patientAadhar,
        string name,
        uint256 indexed age,
        string location,
        string diagonsis
    );

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
            emit addAdmin(_adminAadhar, _name, _location);
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
                _certifications,
                0
            );
            doctorIdMap[doctorCount] = doctor;
            doctorAadharMap[_doctorAadhar] = doctor;
            doctorAddressMap[_doctorAddress] = doctor;
            doctorReverseMap[_doctorAadhar] = _doctorAddress;
            emit addDoctor(_doctorAadhar, _name, _location, _speciality);
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
        if (!isExisting) {
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
            emit addPatient(_patientAadhar, _name, _age, _location, _diagonsis);
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
        patientAadharMap[_patientAadhar].totalTreatments.push(treatmentCount);
    }

    function add_doctor_with_treatment(
        uint256 _treatmentId,
        uint256 _doctorAadhar
    ) public {
        treatmentIdMap[_treatmentId].doctorAadhar.push(_doctorAadhar);
    }

    function add_precaution_with_treatment(
        uint256 _treatmentId,
        string memory _prescription
    ) public {
        treatmentIdMap[_treatmentId].prescription.push(_prescription);
    }

    function add_report_with_treatment(
        uint256 _treatmentId,
        string memory _report
    ) public {
        treatmentIdMap[_treatmentId].reports.push(_report);
    }

    function get_gone_treatments(
        uint256 _patientAadhar
    ) public view returns (uint256[] memory) {
        return patientAadharMap[_patientAadhar].totalTreatments;
    }

    function get_treatment_doctors(
        uint256 _treatmentId
    ) public view returns (uint256[] memory) {
        return treatmentIdMap[_treatmentId].doctorAadhar;
    }

    function get_prescreption_doctors(
        uint256 _treatmentId
    ) public view returns (string[] memory) {
        return treatmentIdMap[_treatmentId].prescription;
    }

    function get_report_doctors(
        uint256 _treatmentId
    ) public view returns (string[] memory) {
        return treatmentIdMap[_treatmentId].reports;
    }

    function get_admin_detail(
        uint256 _adminAadhar
    ) public view returns (AdminDetail memory) {
        return adminAadharMap[_adminAadhar];
    }

    function get_doctor_detail(
        uint256 _doctorAadhar
    ) public view returns (DoctorDetail memory) {
        return doctorAadharMap[_doctorAadhar];
    }

    function get_patient_detail(
        uint256 _patientAadhar
    ) public view returns (PatientDetail memory) {
        return patientAadharMap[_patientAadhar];
    }

}
