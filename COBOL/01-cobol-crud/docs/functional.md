# Functional Specification – COBOL Bank Customer CRUD

## 1. Objective

Define the functional behavior of the **Bank Customer CRUD** system, which simulates the onboarding and maintenance of customer records for a fictional bank.

The main objectives are:

- Provide a **console-based interface** to create, read, update and delete customer records.
- Ensure that all **mandatory customer data** required to open a bank account is captured.
- Build a **single concatenated string** with core customer data.
- Generate a **simple encrypted code** based on this string, to be printed on the registration receipt.
- Produce a **text-based receipt** summarizing the registration, suitable as a simple proof of account opening.

## 2. Scope

### 2.1 In-Scope

- Capture and maintenance of customer master data:
  - First Name, Middle Name (optional), Last Name, Second Last Name (optional)
  - National ID / Government ID (unique key)
  - Date of Birth
  - Phone Number and Email Address
  - Address (Street, External Number, Internal Number [optional], City, State/Province, Postal Code, Country)
  - Account Type (e.g., Savings, Checking, Payroll)
- CRUD operations on the customer file:
  - Create new customer
  - Read (inquiry) by National ID
  - Update existing customer data
  - Delete customer record
- Generation of **concatenated customer string** from selected fields.
- Simple encryption routine that:
  - Accepts the concatenated string as input.
  - Returns a short alphanumeric encrypted code.
- Generation of a **registration receipt** that includes:
  - Customer key data (name, national ID, account type).
  - Encrypted code and timestamp.
- Basic input validation:
  - Mandatory fields presence.
  - Date format.
  - Simple format checks for phone and email.

### 2.2 Out-of-Scope

- Real security / cryptography (this is **not** production-grade encryption).
- Real-time integration with other banking systems.
- Transaction posting, balances, and financial movements.
- Multi-user concurrency control.
- User authentication or authorization.
- Graphical user interface.
- Persistence in relational database (project is file-based only).

## 3. Business Context / Use Cases

### 3.1 Business Context

The application is a **training and portfolio project** that emulates the customer onboarding process of a bank. It is meant to:

- Illustrate good practices in **COBOL programming**, code organization and documentation.
- Demonstrate handling of **customer master data** and basic business rules.
- Showcase a simple **encryption utility** and a **receipt generator** within COBOL.

### 3.2 Main Use Cases

1. **UC-01 – Register New Customer**
   - The user selects "Create" from the menu.
   - The system prompts for customer data.
   - Validates mandatory fields and formats.
   - Builds the concatenated string and generates the encrypted code.
   - Stores the new record in the customer file.
   - Prints a registration receipt.

2. **UC-02 – Consult Customer**
   - The user selects "Read" and enters the National ID.
   - The system retrieves the record (if exists).
   - Displays the customer data and the last generated encrypted code.

3. **UC-03 – Update Customer**
   - The user selects "Update" and enters the National ID.
   - The system retrieves the record.
   - The user can change allowed fields (e.g., address, contact info, account type).
   - The system rebuilds the concatenated string, regenerates the encrypted code, and updates the record.

4. **UC-04 – Delete Customer**
   - The user selects "Delete" and enters the National ID.
   - The system confirms the deletion.
   - Marks the record as deleted or physically removes it from the file (depending on technical design).

5. **UC-05 – Print Receipt for Existing Customer**
   - The user selects a “Print Receipt” option (if implemented separately).
   - Enters the National ID.
   - The system retrieves the record and prints a receipt with current data and encrypted code.

## 4. Business Rules

1. **BR-01 – Unique National ID**
   - The National ID must be unique across all customer records.
   - Attempts to create a customer with an existing National ID must be rejected.

2. **BR-02 – Mandatory Fields**
   - The following fields are mandatory:
     - First Name
     - Last Name
     - National ID
     - Date of Birth
     - Account Type
     - Country
   - The record cannot be created or updated if mandatory fields are missing.

3. **BR-03 – Age Validation (optional, basic)**
   - The system may enforce a minimum age (e.g., 18 years) based on Date of Birth.
   - If the customer is younger than the minimum age, the registration must be rejected.

4. **BR-04 – Contact Data Format**
   - Phone Number must contain only allowed characters (digits and optional plus sign).
   - Email must contain “@” and a domain part; otherwise, the system should warn the user.

5. **BR-05 – Concatenated String Composition**
   - The concatenated string must include at least:
     - National ID
     - Full Name (First + Last Names)
     - Date of Birth
     - Account Type
   - Fields are concatenated using a delimiter (e.g., `|`).

6. **BR-06 – Encrypted Code Stability**
   - For the same concatenated string, the encrypted code must always be the same.
   - If any of the fields used in the string change, a new code must be generated.

7. **BR-07 – Receipt Content**
   - The receipt must always include:
     - Customer full name.
     - National ID.
     - Account Type.
     - Encrypted code.
     - Timestamp of creation or last update.
