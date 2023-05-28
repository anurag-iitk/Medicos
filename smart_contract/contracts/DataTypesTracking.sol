// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Producer {
    uint producerId;
    bytes32 registrationNumber;
    address producerAddress;
    string companyName;
    string location;
}

struct Retailer {
    uint retailerId;
    address retailerAddress;
    bytes32 registrationNumber;
    string retailerName;
    string location;
}

struct Consumer {
    uint consumerId;
    bytes32 consumerAadhar;
    string name;
    string dob;
    uint age;
    string location;
}

struct Medicine {
    string name;
    bytes32 batchNumber;
    Producer producer;
    Retailer retailer;
    Consumer[] consumer;
    uint maxQuantity;
    uint quantitySold;
    bool isSold;
}

