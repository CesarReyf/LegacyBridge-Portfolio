# Technical Design – COBOL Bank Customer CRUD

## 1. Module Breakdown

### 1.1 `main.cbl`

- **ENTRY-POINT**: `MAIN-PROGRAM`.
- **Sections / Paragraphs** (example):
  - `INIT-SECTION` – Initialize variables, open files.
  - `DISPLAY-MENU` – Show options and accept user choice.
  - `PROCESS-CHOICE` – `EVALUATE` of user input.
  - `END-PROGRAM-SECTION` – Close files and stop run.
- **Dependencies**:
  - Calls CRUD, encryption and receipt routines (via `CALL "customer-crud"` etc.).

### 1.2 `customer-crud.cbl`

- **ENTRY-POINTS** (example):
  - `CUST-CREATE`
  - `CUST-READ`
  - `CUST-UPDATE`
  - `CUST-DELETE`
- **Key internal paragraphs**:
  - `COLLECT-INPUT-DATA`
  - `VALIDATE-INPUT-DATA`
  - `BUILD-CONCAT-STRING`
  - `CALL-ENCRYPTION-UTIL`
  - `WRITE-RECORD`
  - `READ-RECORD-BY-ID`
  - `REWRITE-RECORD`
  - `DELETE-RECORD`
- **File Handling**:
  - Uses customer file FD from `FILE SECTION`.
  - Indexed or relative organization (to be selected based on target platform).

### 1.3 `encryption-util.cbl`

- **ENTRY-POINT**: `ENCRYPT-STRING`.
- **Input**:
  - `CUSTOMER-CONCAT-STRING` (PIC X(...) up to maximum length).
- **Output**:
  - `ENCRYPTED-CODE` (PIC X(20), for example).
- **Logic** (example):
  - Iterate over characters.
  - For letters and digits, shift by +3 positions in ASCII (wrap if needed).
  - Calculate checksum (sum of character codes modulo 9999).
  - Combine prefix from shifted substring + numeric checksum formatted as 4 digits.

### 1.4 `receipt-print.cbl`

- **ENTRY-POINT**: `PRINT-RECEIPT`.
- **Input Parameters**:
  - Full customer structure (or separate fields).
  - `ENCRYPTED-CODE`.
- **Output**:
  - Lines written to standard output or separate file.
- **Logic**:
  - Build header lines.
  - Build customer section.
  - Write encrypted code.
  - Add footer with timestamp (system date/time).

## 2. Data Structures / File Layouts

### 2.1 Customer Record Layout (COBOL Copybook Style)

Example (can be extracted into `copybooks/customer-rec.cpy`):

```cobol
01  CUSTOMER-RECORD.
    05  CUST-NATIONAL-ID        PIC X(20).   *> Unique key
    05  CUST-FIRST-NAME         PIC X(20).
    05  CUST-MIDDLE-NAME        PIC X(20).
    05  CUST-LAST-NAME          PIC X(20).
    05  CUST-SECOND-LAST-NAME   PIC X(20).
    05  CUST-DATE-OF-BIRTH      PIC X(10).   *> Format: YYYY-MM-DD
    05  CUST-PHONE-NUMBER       PIC X(20).
    05  CUST-EMAIL              PIC X(40).
    05  CUST-STREET             PIC X(40).
    05  CUST-EXT-NUMBER         PIC X(10).
    05  CUST-INT-NUMBER         PIC X(10).
    05  CUST-CITY               PIC X(30).
    05  CUST-STATE              PIC X(30).
    05  CUST-POSTAL-CODE        PIC X(10).
    05  CUST-COUNTRY            PIC X(30).
    05  CUST-ACCOUNT-TYPE       PIC X(15).   *> SAVINGS / CHECKING / PAYROLL
    05  CUST-ENCRYPTED-CODE     PIC X(20).   *> Generated token
    05  CUST-LAST-UPDATE-TS     PIC X(19).   *> YYYY-MM-DD HH:MM:SS

## 2.2 File Definition Example

```cobol
SELECT CUSTOMER-FILE ASSIGN TO "data/customers.dat"
    ORGANIZATION IS INDEXED
    ACCESS MODE IS DYNAMIC
    RECORD KEY IS CUST-NATIONAL-ID
    FILE STATUS IS CUSTOMER-FILE-STATUS.
```

## 2.3 Concatenated String Layout

### Working-Storage Definition

```cobol
01  CUSTOMER-CONCAT-STRING      PIC X(256).
```

### Composition (Example)

```text
<NATIONAL-ID>|<FULL-NAME>|<DOB>|<ACCOUNT-TYPE>
```

Where:

```text
<FULL-NAME> = FIRST-NAME + SPACE + LAST-NAME
```

---

# 3. Key Logic / Algorithms

## 3.1 Concatenated String Builder

### Steps

1. Initialize `CUSTOMER-CONCAT-STRING` to spaces.  
2. Concatenate the fields using `|` as a delimiter in the following order:
   - National ID  
   - Full Name  
   - Date of Birth  
   - Account Type  
3. Trim trailing spaces after building the string.

---

## 3.2 Simple Encryption Algorithm (Caesar + Checksum Example)

### Input
`CUSTOMER-CONCAT-STRING`

### Output
`CUST-ENCRYPTED-CODE`

### Pseudo-Logic

1. Initialize `checksum = 0`.  
2. For each non-space character in the input string:
   - Add `FUNCTION ORD(character)` to checksum.  
   - If character is alphanumeric:
     - Shift its ASCII value by `+3`, wrapping around if it exceeds the ranges `A–Z` or `0–9`.  
3. Build the **shifted string** from the transformed characters.  
4. Compute `checksum MOD 9999`.  
5. Convert checksum into a **4-digit zero-filled string**.  
6. Extract the **first 8 non-space characters** from the shifted string.  
7. Build the encrypted code:

```text
<8-CHARS><4-DIGIT-CHECKSUM>
```

> This encryption algorithm is **not secure** and is meant only for demonstration.

---

# 4. Error Handling & Validation

## 4.1 Input Validation

### Mandatory Fields
- If any mandatory field is missing, display an error and prompt user to re-enter.

### Date Format
- Validate DOB format as `YYYY-MM-DD`.  
- Optional: ensure that month/day/year values fall within valid numeric ranges.

### Email
- Must contain `@` and at least one `.` after the `@`.

### Phone
- Must contain only digits or an optional leading plus sign (`+`).

---

## 4.2 File Errors

### FILE STATUS Handling

- `00` – Successful operation  
- `02` – Duplicate key (National ID already exists)  
- `23` – Record not found  
- Other codes – Display a generic error message and stop or return to the menu safely  

---

## 4.3 Encryption Errors

- If the input string is empty:
  - Return `"ERR-EMPTY-STR"`.  
- If the string exceeds the maximum allowed size:
  - Truncate or reject with an error message.

---

## 4.4 Receipt Generation Errors

- If the system cannot retrieve the customer record:
  - Display: `"Customer not found, receipt cannot be generated."`  
  - Do **not** produce partial receipts.
