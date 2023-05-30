// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./DataTypesRecord.sol";
import "./MedicosCommon.sol";

contract MedicosRecordStorage is MedicosCommon {
    // event addAdmin(uint256 indexed adminAadhar, string name, string location);
    event addAdmin(uint256 indexed adminId);
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
    mapping(uint256 => address) public adminMap;
    mapping(uint256 => AdminDetail) public adminIdMap;
    mapping(address => AdminDetail) public adminReverseMap;

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

    // In add admin function make one more function that takes direct admin object and make other function for save data 

   

    function create_admin(AdminDetail memory adminDetail) public {
        if(is_admin_created(adminDetail)){
            revert("Admin already created");
        }
        save_admin_map(adminDetail);
        // emit addAdmin(adminDetail.adminAadhar, adminDetail.name, adminDetail.location);
        emit addAdmin(adminDetail.adminId);
    }

    function update_admin(AdminDetail memory adminDetail) public{
        AdminDetail memory adminDetail = adminIdMap[adminDetail.adminId];
        if(!is_admin_created(adminDetail)){
            revert("No such admin found");
        }
        adminAddressMap[msg.sender] = adminDetail;
        adminMap[adminDetail.adminId] = msg.sender;
    }

    function save_admin_map(AdminDetail memory adminDetail) internal {
        AdminDetail storage admin = adminIdMap[adminDetail.adminId];
        admin.adminId = adminDetail.adminId;
        // admin.adminAadhar = adminDetail.adminAadhar;
        admin.adminAddress = adminDetail.adminAddress;
        // admin.name = adminDetail.name;
        // admin.location = adminDetail.location;       
        
        adminMap[adminDetail.adminId] = msg.sender;
        adminAddressMap[adminDetail.adminAddress] = adminDetail;
    }

    function is_admin_created(AdminDetail memory adminDetail) public view returns(bool) {
        AdminDetail memory adminMap = adminIdMap[adminDetail.adminId];
        if(adminMap.adminId == 0){
            return false;
        }
        return true;
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
        doctorAadharMap[_doctorAadhar].totalTreatments += 1;
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
        return adminAddressMap[_adminAadhar];
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
