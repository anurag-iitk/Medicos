// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct PatientDetail {
        uint patientId;
        uint patientAadhar;
        string name;
        uint age;
        string dob;
        string location;
        uint height;
        uint weight;
        string bloodGroup;
        string diagonsis;
        uint[] treatmentDone;
        bool discharged;
    }

    struct DoctorDetail {
        uint doctorId;
        uint doctorAadhar;
        address doctorAddress;
        string name;
        string speciality;
        string location;
        uint[] treatmentDone;
        string[] certification;
    }

    struct AdminDetail{
        uint adminId;
        uint adminAadhar;
        address adminAddress;
        string name;
        string location;
        string role;
    }