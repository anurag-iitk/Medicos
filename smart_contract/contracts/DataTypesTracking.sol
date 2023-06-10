// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Types {
    // Enum defining different user roles
    enum UserRole {
        Manufacturer, // 0
        Supplier, // 1
        Vendor, // 2
        Customer // 3
    }

    // Struct defining user details
    struct UserDetails {
        UserRole role; // User's role
        address id_; // User's address
        string name; // User's name
        string email; // User's email
    }

    // Enum defining different product types
    enum ProductType {
        ANTIBIOTICS, // 0
        VACCINES, // 1
        BIOLOGICS, // 2
        CONTROLLED_SUBSTANCE, // 3
        MEDICAL_DEVICES // 4
    }

    // Struct defining user's history
    struct UserHistory {
        address id_; // Account ID of the user
        uint256 date; // Added or purchased date in epoch in UTC timezone
    }

    // Struct defining product's history
    struct ProductHistory {
        UserHistory manufacturer; // Manufacturer's history
        UserHistory supplier; // Supplier's history
        UserHistory vendor; // Vendor's history
        UserHistory[] customers; // Customers' history (multiple customers)
    }

    // Struct defining a product
    struct Product {
        string name; // Product name
        string manufacturerName; // Manufacturer's name
        address manufacturer; // Manufacturer's address
        uint256 manDateEpoch; // Manufacturing date in epoch
        uint256 expDateEpoch; // Expiry date in epoch
        bool isInBatch; // Flag indicating if the product is part of a batch
        uint256 batchCount; // Quantity packed in a single batch
        string barcodeId; // Product's barcode ID
        string productImage; // URL or path to the product's image
        ProductType productType; // Product type
        string scientificName; // Scientific name of the product
        string usage; // Usage instructions
        string[] composition; // Array of product's composition
        string[] sideEffects; // Array of known side effects
    }
}
