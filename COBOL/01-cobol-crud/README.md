# README.md

# COBOL Bank Customer CRUD

## Overview / Project Summary

This project is a **COBOL-based CRUD application** that simulates the onboarding of customers for a fictional bank.

The program allows you to:
- Create, read, update and delete customer records.
- Capture realistic bank customer data (name, last name, national ID, contact and address information).
- Build a single concatenated string with the customer’s key data.
- Generate a simple encrypted code from that string.
- Print a textual receipt that includes the captured data and the encrypted code.

## Features

- **Customer Registration (Create):**
  - First Name, Middle Name (optional), Last Name, Second Last Name(optional)
  - National ID / Government ID
  - Date of Birth
  - Phone Number
  - Email Address
  - Full Address (Street, Number, City, State, Postal Code, Country)
  - Account Type (e.g., Savings, Checking)
- **Customer Inquiry (Read)** by National ID.
- **Customer Maintenance (Update)** of existing data.
- **Customer Deletion (Delete)**.
- **Concatenated Customer String** (for traceability and encryption input).
- **Simple Encryption Utility**:
  - Internal COBOL routine that generates an alphanumeric “encrypted” code based on the concatenated string (e.g., character shifting + checksum).
- **Registration Receipt**:
  - Printable text receipt that includes customer core data and the encrypted code.

## Project Structure

```text
.
├── src
│   ├── main.cbl              * Main COBOL program / menu
│   ├── customer-crud.cbl     * CRUD routines
│   ├── encryption-util.cbl   * Simple encryption / hashing
│   ├── receipt-print.cbl     * Receipt generation
│   └── jcl
│       └── run-job.jcl       * Sample JCL (if running on mainframe)
├── data
│   ├── customers.dat         * Main customer file (indexed/relative or sequential)
│   └── customers-test.dat    * Sample test data
├── docs
│   ├── functional.md         * Functional specification / business requirements
│   ├── architecture.md       * High-level and low-level architecture
│   ├── technical.md          * Technical details and data structures
│   └── test-cases.md         * Test case catalog
├── CHANGELOG.md
└── README.md

## How to Run

### Option 1: Using GnuCOBOL (local)

1. **Install GnuCOBOL** (on Linux, macOS, or Windows).
2. **Compile the COBOL modules** (example for Linux/macOS):

   ```bash
   cd src
   cobc -x -o bank_crud main.cbl customer-crud.cbl encryption-util.cbl receipt-print.cbl

3. **Prepare data files**:
-Ensure ../data/customers.dat exists and has proper permissions.
-You can copy customers-test.dat as a starting point.

4. **Run the program**:
./bank_crud

5. **Use the console menu to:

Register a new customer.
Consult / update / delete an existing customer.
Print the registration receipt.


### Option 2: Mainframe (JCL)

If you want to run this on a mainframe:

Use the sample JCL in src/jcl/run-job.jcl as a base.
Adapt dataset names and file locations to your environment.
Compile and link-edit as per your site standards.


Future Improvements

Stronger encryption (e.g., integration with external hashing libraries).
Additional business rules (KYC checks, risk flags, blacklists).
Better receipt formatting (e.g., PDF or structured output).
REST or MQ interface around the COBOL core, for modern integration.
