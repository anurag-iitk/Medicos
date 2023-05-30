// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct PatientDetail {
        uint256 patientAadhar;
        string name;
        uint256 age;
        string dob;
        string location;
        uint256 height;
        uint256 weight;
        string bloodGroup;
        string diagonsis;
        uint256[] gonetreatment;
        bool discharged;
    }

    struct DoctorDetail {
        uint256 doctorId;
        uint256 doctorAadhar;
        address doctorAddress;
        string name;
        string speciality;
        string location;
        uint256 treatmentDone;
        string[] certification;
    }

    struct AdminDetail{
        uint256 adminId;
        uint256 adminAadhar;
        address adminAddress;
        string name;
        string location;
        // string role;
    }

    struct TreatmentDetail{
        uint256 treatmentId;
        uint patientAadhar;
        uint[] doctorAadhar;
        string prescription;
        string[] reports;
        uint256[] treatmentDone;
    }