# Architecture – COBOL Bank Customer CRUD

## 1. Overview

The application is a **modular COBOL batch/online program** that runs in a simple console environment. It follows a layered approach:

- **Presentation Layer**: User interaction (menus, prompts, screen or console input/output).
- **Business Logic Layer**: CRUD operations, validation rules, concatenated string creation, encrypted code generation.
- **Data Access Layer**: File access for the customer master file.
- **Utility Layer**: Encryption and receipt generation.

## 2. Components / Modules

### 2.1 Main Program (`main.cbl`)

Responsibilities:
- Display main menu.
- Route user selections to the corresponding CRUD operations.
- Handle program initialization and termination.
- Centralize error messages and user prompts.

### 2.2 Customer CRUD Module (`customer-crud.cbl`)

Responsibilities:
- **Create**:
  - Prompt user for customer data.
  - Validate input fields.
  - Call encryption utility.
  - Write new record to `customers.dat`.
- **Read**:
  - Read customer by National ID key.
  - Return customer data for display.
- **Update**:
  - Retrieve existing record.
  - Allow modifications.
  - Rebuild concatenated string and regenerate encrypted code.
  - Rewrite record in file.
- **Delete**:
  - Remove or mark record as deleted.
- **Search helper routines** for indexed/relative files.

### 2.3 Encryption Utility Module (`encryption-util.cbl`)

Responsibilities:
- Receive the concatenated customer string as input.
- Apply a **simple deterministic transformation**, for example:
  - Shift alphanumeric characters by a fixed offset (Caesar-like).
  - Calculate a checksum (e.g., sum of character codes).
  - Combine both into a short alphanumeric encrypted code.
- Return the encrypted code to the caller.
- Log or handle basic errors (e.g., input string too long).

### 2.4 Receipt Generator Module (`receipt-print.cbl`)

Responsibilities:
- Format the receipt text.
- Include:
  - Header (bank name, “Account Registration Receipt”).
  - Customer name, National ID, account type.
  - Encrypted code.
  - Timestamp and internal reference.
- Send output to:
  - Console/SYSOUT.
  - Optionally, a separate output file (`receipt.out`) for later printing.

### 2.5 Data Access / Files

- **Customer Master File (`customers.dat`)**:
  - COBOL FD definition for an indexed or relative file.
  - Key: National ID.
  - Contains all captured fields plus the encrypted code.

## 3. Flow / Diagrams

### 3.1 High-Level Flow

```text
User
 ↓
Main Menu (main.cbl)
 ↓
+-------------------------+
| 1. Create Customer      |
| 2. Read Customer        |
| 3. Update Customer      |
| 4. Delete Customer      |
| 5. Print Receipt        |
+-------------------------+
         ↓ (selection)
------------------------------------------------
Create:
  - Collect Input → Validate → Build String → Encrypt → Write File → Print Receipt

Read:
  - Ask National ID → Read File → Show Data

Update:
  - Ask National ID → Read File → Modify Data → Rebuild String → Encrypt → Rewrite File

Delete:
  - Ask National ID → Confirm → Delete/Mark Record

Print Receipt:
  - Ask National ID → Read File → Generate Receipt

### 3.2 Data Flow

Customer Input Fields
        ↓
  Validation Logic
        ↓
Concatenated Customer String
        ↓
   Encryption Utility
        ↓
  Encrypted Code (Token)
        ↓
Customer Record (File)
        ↓
Receipt Generator → Text Receipt

### 3.3 Module Interaction

[main.cbl]
   |
   +--> [customer-crud.cbl]
          |
          +--> [encryption-util.cbl]
          |
          +--> [receipt-print.cbl]
          |
          +--> Customer File (customers.dat)


All interactions are synchronous; there is no background or asynchronous processing.