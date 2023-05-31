// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./DataTypesRecord.sol";
import "./MedicosCommon.sol";

contract MedicosRecordStorage is MedicosCommon {
    // event addAdmin(uint256 indexed adminAadhar, string name, string location);
    event addAdmin(uint256 indexed adminId);
    event addDoctor(
        uint256 indexed doctorId,
        DoctorDetail doctorDetail
    );
    event addPatient(
        uint256 indexed patientId,
        PatientDetail patientDetail
    );

    uint256 public adminCount = 0;
    uint256 public doctorCount = 0;
    uint256 public patientCount = 0;
    uint256 public treatmentCount = 0;

    // Admin Mapping
    mapping(uint256 => address) public adminMap;
    mapping(uint256 => AdminDetail) public adminIdMap;
    mapping(address => AdminDetail) public adminAddressMap;

    // Doctor Mapping
    mapping(uint256 => address) public doctorMap;
    mapping(uint256 => DoctorDetail) public doctorIdMap;
    mapping(address => DoctorDetail) public doctorAddressMap;

    // Patient Mapping
    mapping(uint256 => PatientDetail) public patientMap;
    mapping(address => uint256) public patientReverseMap;


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
        save_admin_map(adminDetail);
    }

    function delete_admin(AdminDetail memory adminDetail) public {
        AdminDetail memory admin = adminIdMap[adminDetail.adminId];
        if(!is_admin_created(adminDetail)){
            revert("No such found found");
        }
        delete adminIdMap[adminDetail.adminId];
        delete adminIdMap[adminDetail.adminId];
        delete adminAddressMap[adminDetail.adminAddress];
    }

    function save_admin_map(AdminDetail memory adminDetail) internal {
        AdminDetail storage admin = adminIdMap[adminDetail.adminId];
        admin.adminId = adminDetail.adminId;
        // admin.adminAadhar = adminDetail.adminAadhar;
        admin.adminAddress = adminDetail.adminAddress;
        // admin.name = adminDetail.name;
        // admin.location = adminDetail.location;       
        
        adminMap[adminDetail.adminId] = msg.sender;
        adminIdMap[adminDetail.adminId] = adminDetail;
        adminAddressMap[adminDetail.adminAddress] = adminDetail;
    }

    function is_admin_created(AdminDetail memory adminDetail) public view returns(bool) {
        AdminDetail memory adminMap = adminIdMap[adminDetail.adminId];
        if(adminMap.adminId == 0){
            return false;
        }
        return true;
    }

    function add_doctor(DoctorDetail memory doctorDetail) public {
        AdminDetail memory admin = adminIdMap[doctorDetail.doctorId];
        if(is_doctor_created(doctorDetail.doctorId)){
            revert("Admin already created");
        }
        save_doctor_map(doctorDetail);
        emit add_doctor(doctorDetail.doctorId, doctorDetail);
    }

    function update_doctor(DoctorDetail memory doctorDetail) public {
        DoctorDetail memory doctor = doctorIdMap[doctorDetail.doctorId];
        if(!is_doctor_created(doctorDetail)){
            revert("No such doctor found");
        }
        doctorIdMap[doctorDetail.doctorId] = doctor;
        doctorMap[doctorDetail.doctorId] = doctorDetail.doctorAddress;
        doctorAddressMap[doctorDetail.doctorAddress] = doctorDetail;
    }

    function delete_doctor(DoctorDetail memory doctorDetail) public {
        DoctorDetail memory doctor = doctorIdMap[doctorDetail.doctorId];
        if(!is_doctor_created(doctorDetail)){
            revert("No such doctor found");
        }
        delete doctorIdMap[doctorDetail.doctorId];
        delete doctorMap[doctorDetail.doctorId];
        delete doctorAddressMap[doctorDetail.doctorAddress];
    }

    function save_doctor_map(DoctorDetail memory doctorDetail) internal {
        DoctorDetail storage doctor = doctorIdMap[doctorDetail.doctorId];
        doctor.doctorIdName = doctorDetail.doctorIdName;
        doctor.doctorId = doctorDetail.doctorId;
        doctor.doctorAddress = doctorDetail.doctorAddress;
        doctor.treatmentDone = doctorDetail.treatmentDone;
        doctor.certifications.push(doctorDetail.certifications);

        doctorIdMap[doctorDetail.doctorId] = doctor;
        doctorMap[doctorDetail.doctorId] = doctorDetail.doctorAddress;
        doctorAddressMap[doctorDetail.doctorAddress] = doctorDetail;
    }

    function is_doctor_created(DoctorDetail memory doctorDetail) public {
        DoctorDetail memory doctorMap = doctorIdMap[doctorDetail].doctorId;
        if(doctorMap.doctorId == 0){
            return false;
        }
        return true;
    }

    function create_patient(PatientDetail memory patientDetail) public {
        PatientDetail memory patient = patientMap[patientDetail.patientId];
        if(is_patient_created(patientDetail)){
            revert("Patient already created");
        }
        save_patient_map(patientDetail);
        emit addPatient(patientDetail.patientId, patientDetail);
    }

    function update_patient(PatientDetail memory patientDetail) public {
        PatientDetail memory patient = patientMap[patientDetail.patientId];
        if(!is_patient_created(patientDetail)){
            revert("No such patient found");
        }
        save_patient_map(patientDetail);
    }

    function save_patient_map(PatientDetail memory patientDetail) internal {
        PatientDetail storage patient = patientMap[patientDetail.patientId];
        patient.patientIdName = patientDetail.patientIdName;
        patient.patientId = patientDetail.patientId;
        patient.patientAddress = patientDetail.patientAddress;
        patient.discharged = false;

        patientMap[patientDetail.patientId] = patient;        
        patientReverseMap[patientDetail.patientAddress] = patientDetail.patientId;
    }

    function is_patient_created(PatientDetail memory patientDetail) public view returns(bool){
        PatientDetail memory patientMap = patientMap[patientDetail.patientId];
        if(patientMap.patientId == 0){
            return false;
        }
        return true;
    }



    // function add_treatment(uint256 _patientAadhar) public {
    //     treatmentCount += 1;
    //     TreatmentDetail memory treatment;
    //     treatment.treatmentId = treatmentCount;
    //     treatment.patientAadhar = _patientAadhar;
    //     treatmentIdMap[treatmentCount] = treatment;
    //     patientAadharMap[_patientAadhar].totalTreatments.push(treatmentCount);
    // }

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
