# Test Cases – COBOL Bank Customer CRUD

> All test cases are described in vertical format for better readability.

---

## TC-01 – Create Customer – Happy Path

**Objective**  
Validate that a new customer can be created successfully with all valid data.

**Preconditions**  
- `customers.dat` exists and is accessible.
- The given National ID does not exist in the file.

**Input Data (example)**  
- National ID: `ID12345601`
- First Name: `JOHN`
- Middle Name: `ALAN`
- Last Name: `DOE`
- Second Last Name: *(blank)*
- Date of Birth: `1990-05-10`
- Phone Number: `+5215512345678`
- Email: `john.doe@example.com`
- Street: `MAIN ST`
- Ext Number: `123`
- Int Number: `A`
- City: `MEXICO CITY`
- State: `CDMX`
- Postal Code: `01000`
- Country: `MEXICO`
- Account Type: `SAVINGS`

**Steps**  
1. Start program `bank`.  
2. Select option `1 - Create Customer`.  
3. Enter the input data as specified.  
4. Confirm the end of input.

**Expected Result**  
- Message: `Customer created successfully.`  
- Record with National ID `ID12345601` is written to `customers.dat`.  
- `CUST-ENCRYPTED-CODE` is populated with a non-empty value.  
- `CUST-LAST-UPDATE-TS` contains a timestamp in format `YYYY-MM-DD HH:MM:SS`.

**Notes**  
- This test is the reference happy path for other CRUD scenarios.

---

## TC-02 – Create Customer – Duplicate National ID

**Objective**  
Ensure that creating a customer with an existing National ID is handled correctly.

**Preconditions**  
- `customers.dat` contains a record with National ID `ID12345602`.

**Input Data**  
- National ID: `ID12345602` (existing)  
- Other fields: any valid values.

**Steps**  
1. Start program `bank`.  
2. Select option `1 - Create Customer`.  
3. Enter National ID `ID12345602`.  
4. Fill remaining fields with valid values.  
5. Finish input.

**Expected Result**  
- The write operation fails with file status indicating duplicate key (e.g., `02`).  
- `customer-crud` returns a non-zero return code.  
- A message indicating an error in create operation is displayed.  
- Existing record is not overwritten.

**Notes**  
- Used to validate handling of indexed file duplicate key errors.

---

## TC-03 – Create Customer – Missing Mandatory Fields

**Objective**  
Verify that missing mandatory fields are detected and do not create incomplete records.

**Preconditions**  
- National ID does not exist in `customers.dat`.

**Input Data (example)**  
- National ID: `ID12345603`
- First Name: *(blank)*
- Last Name: *(blank)*
- Date of Birth: `1990-01-01`
- Account Type: `CHECKING`
- Other fields: arbitrary.

**Steps**  
1. Start program `bank`.  
2. Select `1 - Create Customer`.  
3. Enter National ID `ID12345603`.  
4. Leave first name and last name blank when prompted.  
5. Complete the rest of fields with any values.  

**Expected Result**  
- Program should detect missing mandatory fields (First Name, Last Name, etc.).  
- Customer record should **not** be written to `customers.dat`.  
- An error message and/or re-entry request is displayed (depending on final validation implementation).

**Notes**  
- Adjust expected messaging according to the final validation behavior implemented in `customer-crud`.

---

## TC-04 – Create Customer – Invalid Date of Birth Format

**Objective**  
Validate that Date of Birth must follow `YYYY-MM-DD`.

**Preconditions**  
- National ID `ID12345604` does not exist in the file.

**Input Data**  
- National ID: `ID12345604`
- Date of Birth: `10-05-1990` (invalid format)  
- Other fields: valid.

**Steps**  
1. Start program.  
2. Select `1 - Create Customer`.  
3. Enter all fields with valid values except Date of Birth.  
4. For Date of Birth, enter `10-05-1990`.

**Expected Result**  
- Program rejects the input or requests re-entry for Date of Birth.  
- No record is created until a valid `YYYY-MM-DD` date is provided.

**Notes**  
- Behavior depends on how strict the validation logic is implemented (pattern vs. range checks).

---

## TC-05 – Create Customer – Invalid Email

**Objective**  
Ensure basic email format validation is enforced.

**Preconditions**  
- National ID `ID12345605` does not exist.

**Input Data**  
- Email: `johndoe-at-example.com` (no `@`)  
- All other fields valid.

**Steps**  
1. Start program.  
2. Select `1 - Create Customer`.  
3. Enter valid data for all fields except email.  
4. Enter `johndoe-at-example.com` for email.

**Expected Result**  
- Program detects invalid email format.  
- Record is not saved until a valid email (with `@` and `.` after `@`) is provided.

---

## TC-06 – Create Customer – Invalid Phone Number

**Objective**  
Check that phone number only accepts digits and optional leading `+`.

**Preconditions**  
- National ID `ID12345606` does not exist.

**Input Data**  
- Phone Number: `55A123B678` (contains letters).  
- Other fields: valid.

**Steps**  
1. Start program.  
2. Select `1 - Create Customer`.  
3. Enter valid data for all fields except phone number.  
4. Enter `55A123B678`.

**Expected Result**  
- Phone number validation fails.  
- Program requests correction and does not create the record.

---

## TC-07 – Read Customer – Existing Record

**Objective**  
Validate that reading an existing customer shows correct data.

**Preconditions**  
- `customers.dat` contains a valid record with National ID `IDREAD001`.

**Input Data**  
- National ID: `IDREAD001`.

**Steps**  
1. Start program.  
2. Select `2 - Read Customer`.  
3. Enter National ID `IDREAD001`.

**Expected Result**  
- Customer data is displayed field by field.  
- Return code is `0`.  
- No error message appears.

---

## TC-08 – Read Customer – Non-Existing Record

**Objective**  
Ensure appropriate behavior when trying to read a non-existing customer.

**Preconditions**  
- National ID `IDREAD404` does not exist.

**Input Data**  
- National ID: `IDREAD404`.

**Steps**  
1. Start program.  
2. Select `2 - Read Customer`.  
3. Enter `IDREAD404`.

**Expected Result**  
- Message: `Customer not found.`  
- File status should be `23` and returned via `WS-RETURN-CODE`.  
- No data fields are displayed for the customer.

---

## TC-09 – Update Customer – Partial Update (Keep Some Fields)

**Objective**  
Validate that the update keeps original values when blanks are entered.

**Preconditions**  
- Record exists with National ID `IDUPD001` and known values.

**Input Data (example)**  
- National ID: `IDUPD001`
- New First Name: *(blank)*  
- New Last Name: `SMITH`  
- Other fields: left blank to keep existing values.

**Steps**  
1. Start program.  
2. Select `3 - Update Customer`.  
3. Enter National ID `IDUPD001`.  
4. When prompted for first name, leave blank.  
5. When prompted for last name, enter `SMITH`.  
6. Leave other fields blank to keep.

**Expected Result**  
- First Name remains unchanged.  
- Last Name is updated to `SMITH`.  
- Other fields remain as before.  
- `CUST-ENCRYPTED-CODE` and `CUST-LAST-UPDATE-TS` are regenerated.  
- Message: `Customer updated successfully.`

---

## TC-10 – Update Customer – Non-Existing Record

**Objective**  
Validate that updating a non-existing record is handled correctly.

**Preconditions**  
- National ID `IDUPD404` does not exist.

**Steps**  
1. Start program.  
2. Select `3 - Update Customer`.  
3. Enter `IDUPD404`.

**Expected Result**  
- Message: `Customer not found.`  
- Return code equals file status for "record not found" (e.g., `23`).  
- No update attempt is made.

---

## TC-11 – Delete Customer – Confirm YES

**Objective**  
Ensure delete operation removes an existing record after confirmation.

**Preconditions**  
- Customer with National ID `IDDEL001` exists.

**Steps**  
1. Start program.  
2. Select `4 - Delete Customer`.  
3. Enter `IDDEL001`.  
4. Review displayed data.  
5. When asked `Confirm delete? (Y/N):`, enter `Y`.

**Expected Result**  
- Record is deleted from `customers.dat`.  
- Return code `0`.  
- Message: `Customer deleted successfully.`  
- A subsequent Read for `IDDEL001` should return "Customer not found."

---

## TC-12 – Delete Customer – Confirm NO

**Objective**  
Validate that choosing NO does not delete the record.

**Preconditions**  
- Customer with National ID `IDDEL002` exists.

**Steps**  
1. Start program.  
2. Select `4 - Delete Customer`.  
3. Enter `IDDEL002`.  
4. When asked for confirmation, enter `N`.

**Expected Result**  
- Record is **not** deleted.  
- No "deleted successfully" message.  
- A subsequent Read for `IDDEL002` still shows the record.

---

## TC-13 – Print Receipt – Existing Customer

**Objective**  
Validate receipt generation for an existing customer.

**Preconditions**  
- Customer with National ID `IDREC001` exists.  
- `CUST-ENCRYPTED-CODE` and `CUST-LAST-UPDATE-TS` are populated.

**Steps**  
1. Start program.  
2. Select `5 - Print Receipt`.  
3. Enter `IDREC001`.

**Expected Result**  
- A receipt is printed showing at least:
  - Customer Name (with optional second last name)
  - National ID
  - Account Type
  - Encrypted Code
  - Last Update timestamp
- Return code is `0`.

---

## TC-14 – Print Receipt – Non-Existing Customer

**Objective**  
Verify that receipt is not generated for non-existing customers.

**Preconditions**  
- National ID `IDREC404` does not exist.

**Steps**  
1. Start program.  
2. Select `5 - Print Receipt`.  
3. Enter `IDREC404`.

**Expected Result**  
- Message: `Customer not found. Receipt not generated.`  
- Return code with file status `23`.  
- No receipt details displayed.

---

## TC-15 – Encryption – Deterministic Behavior

**Objective**  
Ensure the encryption utility always produces the same output for the same input string.

**Preconditions**  
- Encryption utility (`encryption-util`) is compiled and callable.

**Input Data (example)**  
- Concatenated string:  
  `IDENC001|JOHN DOE|1990-05-10|SAVINGS`

**Steps**  
1. Call the encryption utility twice with the exact same input string.  
2. Capture the output code of both calls.

**Expected Result**  
- Both output codes are identical.  
- No error return code is set.

---

## TC-16 – Encryption – Empty Input String

**Objective**  
Validate behavior when the encryption input string is empty.

**Preconditions**  
- Encryption utility accessible.

**Input Data**  
- Concatenated string: all spaces (empty from application perspective).

**Steps**  
1. Call `encryption-util` with an all-spaces string.  

**Expected Result**  
- Output code: `ERR-EMPTY-STR`.  
- Return code ≠ 0 (e.g., `1`).  

---

## TC-17 – Second Last Name Optional

**Objective**  
Verify that second last name is optional in full name and concatenated string.

**Preconditions**  
- System compiled with `CUST-SECOND-LAST-NAME` as optional field.

**Scenario A – Without Second Last Name**  
- Input:  
  - First Name: `JOHN`  
  - Last Name: `DOE`  
  - Second Last Name: *(blank)*  

**Expected Result A**  
- Full Name: `JOHN DOE`  
- No extra space or separator for missing second last name.  

**Scenario B – With Second Last Name**  
- Input:  
  - First Name: `JOHN`  
  - Last Name: `DOE`  
  - Second Last Name: `SMITH`  

**Expected Result B**  
- Full Name: `JOHN DOE SMITH`.  

---

## TC-18 – File Error Handling – File Not Found (Receipt Module)

**Objective**  
Ensure receipt module handles missing file gracefully.

**Preconditions**  
- Temporarily rename or remove `customers.dat`.  

**Steps**  
1. Start `receipt-print` via main menu (option 5).  
2. Enter any National ID.

**Expected Result**  
- Module fails to open the file.  
- A non-zero return code is set.  
- A meaningful error or generic file error is displayed.  
- Program does not crash.

