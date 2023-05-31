// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct PatientDetail {
        string patientIdName;
        uint256 patientId;
        // uint256 patientAadhar;
        address patientAddress;
        // string name;
        // uint256 age;
        // string dob;
        // string location;
        // uint256 height;
        // uint256 weight;
        // string bloodGroup;
        // string diagonsis;
        uint256[] totalTreatments;
        bool discharged;
    }

    struct DoctorDetail {
        string doctorIdName;
        uint256 doctorId;
        address doctorAddress;
        // string name;
        // string speciality;
        // string location;
        uint256 treatmentDone;
        string[] certifications;
    }

    struct AdminDetail{
        uint256 adminId;
        address adminAddress;
        // uint256 adminAadhar;
        // string name;
        // string location;
        // string role;
    }

    struct TreatmentDetail{
        uint256 treatmentId;
        uint patientId;
        uint[] doctorIds;
        string[] prescriptions;
        string[] reports;
        uint256[] treatmentDone;
    }