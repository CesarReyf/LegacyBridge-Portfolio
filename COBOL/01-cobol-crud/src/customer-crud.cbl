       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUSTOMER-CRUD.
       AUTHOR. CESAR DAVID REY FIGUEROA.

       *> ------------------------------------------------------------
       *> Customer CRUD module for bank customer management.
       *> Handles create, read, update and delete operations over
       *> the indexed customer file.
       *> ------------------------------------------------------------

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE ASSIGN TO "data/customers.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CUST-NATIONAL-ID
               FILE STATUS IS CUSTOMER-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  CUSTOMER-FILE.
       COPY "customer-rec.cpy".

       WORKING-STORAGE SECTION.

       01  CUSTOMER-FILE-STATUS       PIC XX VALUE "00".
       01  WS-CONCAT-STRING           PIC X(256).
       01  WS-FULL-NAME               PIC X(60).
       01  WS-ANSWER                  PIC X.
       01  WS-DATE-YYYYMMDD           PIC 9(8).
       01  WS-TIME-HHMMSS             PIC 9(6).

       *> Used to build timestamp YYYY-MM-DD HH:MM:SS
       01  WS-YEAR                    PIC 9(4).
       01  WS-MONTH                   PIC 9(2).
       01  WS-DAY                     PIC 9(2).
       01  WS-HOUR                    PIC 9(2).
       01  WS-MINUTE                  PIC 9(2).
       01  WS-SECOND                  PIC 9(2).

       01  WS-CURRENT-DATE-TIME       PIC X(21).
       01  WS-CURRENT-DATE-RED REDEFINES WS-CURRENT-DATE-TIME.
           05  WS-CDT-DATE            PIC 9(8).
           05  WS-CDT-TIME            PIC 9(6).
           05  WS-CDT-FILLER          PIC X(7).

       LINKAGE SECTION.

       01  LK-ACTION                  PIC X(10).
       01  LK-NATIONAL-ID             PIC X(20).
       01  LK-RETURN-CODE             PIC 99.

       PROCEDURE DIVISION USING LK-ACTION
                                LK-NATIONAL-ID
                                LK-RETURN-CODE.

       MAIN-ENTRY.

           MOVE 0 TO LK-RETURN-CODE

           PERFORM OPEN-FILE

           IF LK-RETURN-CODE = 0
              EVALUATE FUNCTION UPPER-CASE(LK-ACTION)
                 WHEN "CREATE"
                    PERFORM DO-CREATE
                 WHEN "READ"
                    PERFORM DO-READ
                 WHEN "UPDATE"
                    PERFORM DO-UPDATE
                 WHEN "DELETE"
                    PERFORM DO-DELETE
                 WHEN OTHER
                    MOVE 99 TO LK-RETURN-CODE
              END-EVALUATE
           END-IF

           PERFORM CLOSE-FILE

           GOBACK.

       *> ------------------------------------------------------------
       OPEN-FILE.
       *> Open customer file with basic creation if it does not exist
           OPEN I-O CUSTOMER-FILE
           IF CUSTOMER-FILE-STATUS = "35"
              OPEN OUTPUT CUSTOMER-FILE
              CLOSE CUSTOMER-FILE
              OPEN I-O CUSTOMER-FILE
           END-IF

           IF CUSTOMER-FILE-STATUS NOT = "00"
              MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                   TO LK-RETURN-CODE
           END-IF.

       *> ------------------------------------------------------------
       CLOSE-FILE.
       *> Close customer file
           CLOSE CUSTOMER-FILE.

       *> ------------------------------------------------------------
       DO-CREATE.
       *> Collect customer data and create new record
           PERFORM CLEAR-CUSTOMER-RECORD
           PERFORM INPUT-CUSTOMER-DATA

           PERFORM BUILD-FULL-NAME
           PERFORM BUILD-CONCAT-STRING
           PERFORM CALL-ENCRYPTION
           PERFORM SET-TIMESTAMP

           WRITE CUSTOMER-RECORD
           IF CUSTOMER-FILE-STATUS = "00"
              MOVE 0 TO LK-RETURN-CODE
           ELSE
              MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                   TO LK-RETURN-CODE
           END-IF.

       *> ------------------------------------------------------------
       DO-READ.
       *> Read and display existing customer by National ID
           MOVE LK-NATIONAL-ID TO CUST-NATIONAL-ID

           READ CUSTOMER-FILE KEY IS CUST-NATIONAL-ID
           IF CUSTOMER-FILE-STATUS = "00"
              MOVE 0 TO LK-RETURN-CODE
              PERFORM DISPLAY-CUSTOMER-DATA
           ELSE
              MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                   TO LK-RETURN-CODE
           END-IF.

       *> ------------------------------------------------------------
       DO-UPDATE.
       *> Read existing customer, replace data and rewrite record
           MOVE LK-NATIONAL-ID TO CUST-NATIONAL-ID

           READ CUSTOMER-FILE KEY IS CUST-NATIONAL-ID
           IF CUSTOMER-FILE-STATUS = "00"
              MOVE 0 TO LK-RETURN-CODE
              DISPLAY " Current data:"
              PERFORM DISPLAY-CUSTOMER-DATA

              DISPLAY " "
              DISPLAY "Enter data (leave blank to keep current value)."

              PERFORM INPUT-CUSTOMER-DATA-WITH-DEFAULTS

              PERFORM BUILD-FULL-NAME
              PERFORM BUILD-CONCAT-STRING
              PERFORM CALL-ENCRYPTION
              PERFORM SET-TIMESTAMP

              REWRITE CUSTOMER-RECORD
              IF CUSTOMER-FILE-STATUS = "00"
                 MOVE 0 TO LK-RETURN-CODE
              ELSE
                 MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                      TO LK-RETURN-CODE
              END-IF
           ELSE
              MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                   TO LK-RETURN-CODE
           END-IF.

       *> ------------------------------------------------------------
       DO-DELETE.
       *> Delete customer record after confirmation
           MOVE LK-NATIONAL-ID TO CUST-NATIONAL-ID

           READ CUSTOMER-FILE KEY IS CUST-NATIONAL-ID
           IF CUSTOMER-FILE-STATUS = "00"
              MOVE 0 TO LK-RETURN-CODE

              PERFORM DISPLAY-CUSTOMER-DATA
              DISPLAY " "
              DISPLAY " Confirm delete? (Y/N): "
              ACCEPT WS-ANSWER
              IF FUNCTION UPPER-CASE(WS-ANSWER) = "Y"
                 DELETE CUSTOMER-FILE
                 IF CUSTOMER-FILE-STATUS = "00"
                    MOVE 0 TO LK-RETURN-CODE
                 ELSE
                    MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                         TO LK-RETURN-CODE
                 END-IF
              END-IF
           ELSE
              MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                   TO LK-RETURN-CODE
           END-IF.

       *> ------------------------------------------------------------
       CLEAR-CUSTOMER-RECORD.
       *> Reset customer record fields
           MOVE SPACES TO CUSTOMER-RECORD.

       *> ------------------------------------------------------------
       INPUT-CUSTOMER-DATA.
       *> Input full customer data for CREATE
           DISPLAY " Enter National ID: "
           ACCEPT CUST-NATIONAL-ID

           DISPLAY " Enter First Name: "
           ACCEPT CUST-FIRST-NAME

           DISPLAY " Enter Middle Name (optional): "
           ACCEPT CUST-MIDDLE-NAME

           DISPLAY " Enter Last Name: "
           ACCEPT CUST-LAST-NAME

           DISPLAY " Enter Second Last Name (optional): "
           ACCEPT CUST-SECOND-LAST-NAME

           DISPLAY " Enter Date of Birth (YYYY-MM-DD): "
           ACCEPT CUST-DATE-OF-BIRTH

           DISPLAY " Enter Phone Number: "
           ACCEPT CUST-PHONE-NUMBER

           DISPLAY " Enter Email: "
           ACCEPT CUST-EMAIL

           DISPLAY " Enter Street: "
           ACCEPT CUST-STREET

           DISPLAY " Enter External Number: "
           ACCEPT CUST-EXT-NUMBER

           DISPLAY " Enter Internal Number (optional): "
           ACCEPT CUST-INT-NUMBER

           DISPLAY " Enter City: "
           ACCEPT CUST-CITY

           DISPLAY " Enter State/Province: "
           ACCEPT CUST-STATE

           DISPLAY " Enter Postal Code: "
           ACCEPT CUST-POSTAL-CODE

           DISPLAY " Enter Country: "
           ACCEPT CUST-COUNTRY

           DISPLAY " Enter Account Type (SAVINGS/CHECKING/PAYROLL): "
           ACCEPT CUST-ACCOUNT-TYPE.

       *> ------------------------------------------------------------
       INPUT-CUSTOMER-DATA-WITH-DEFAULTS.
       *> Input data for UPDATE, keeping current values when blank
           DISPLAY " Enter First Name (leave blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-FIRST-NAME
           END-IF

           DISPLAY " Enter Middle Name (leave blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-MIDDLE-NAME
           END-IF

           DISPLAY " Enter Last Name (leave blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-LAST-NAME
           END-IF

           DISPLAY " Enter Second Last Name (leave blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-SECOND-LAST-NAME
           END-IF

           DISPLAY " Enter Date of Birth (YYYY-MM-DD, blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-DATE-OF-BIRTH
           END-IF

           DISPLAY " Enter Phone Number (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-PHONE-NUMBER
           END-IF

           DISPLAY " Enter Email (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-EMAIL
           END-IF

           DISPLAY " Enter Street (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-STREET
           END-IF

           DISPLAY " Enter External Number (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-EXT-NUMBER
           END-IF

           DISPLAY " Enter Internal Number (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-INT-NUMBER
           END-IF

           DISPLAY " Enter City (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-CITY
           END-IF

           DISPLAY " Enter State/Province (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-STATE
           END-IF

           DISPLAY " Enter Postal Code (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-POSTAL-CODE
           END-IF

           DISPLAY " Enter Country (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-COUNTRY
           END-IF

           DISPLAY " Enter Account Type (blank to keep): "
           ACCEPT WS-FULL-NAME
           IF WS-FULL-NAME NOT = SPACES
              MOVE WS-FULL-NAME TO CUST-ACCOUNT-TYPE
           END-IF.

       *> ------------------------------------------------------------
       BUILD-FULL-NAME.
       *> Build full name using optional second last name
           MOVE SPACES TO WS-FULL-NAME

           STRING
              CUST-FIRST-NAME DELIMITED BY SPACE
              SPACE
              CUST-LAST-NAME DELIMITED BY SPACE
              INTO WS-FULL-NAME
           END-STRING

           IF CUST-SECOND-LAST-NAME NOT = SPACES
              STRING
                 WS-FULL-NAME DELIMITED BY SPACE
                 SPACE
                 CUST-SECOND-LAST-NAME DELIMITED BY SPACE
                 INTO WS-FULL-NAME
              END-STRING
           END-IF.

       *> ------------------------------------------------------------
       BUILD-CONCAT-STRING.
       *> Build concatenated string for encryption input
           MOVE SPACES TO WS-CONCAT-STRING

           STRING
              CUST-NATIONAL-ID      DELIMITED BY SPACE
              "|"                   DELIMITED BY SIZE
              WS-FULL-NAME          DELIMITED BY SPACE
              "|"                   DELIMITED BY SIZE
              CUST-DATE-OF-BIRTH    DELIMITED BY SIZE
              "|"                   DELIMITED BY SIZE
              CUST-ACCOUNT-TYPE     DELIMITED BY SPACE
              INTO WS-CONCAT-STRING
           END-STRING.

       *> ------------------------------------------------------------
       CALL-ENCRYPTION.
       *> Call external encryption utility to fill CUST-ENCRYPTED-CODE
           CALL "encryption-util"
                USING WS-CONCAT-STRING
                      CUST-ENCRYPTED-CODE
                      LK-RETURN-CODE.

       *> ------------------------------------------------------------
       SET-TIMESTAMP.
       *> Build YYYY-MM-DD HH:MM:SS timestamp into CUST-LAST-UPDATE-TS
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-TIME

           MOVE WS-CDT-DATE TO WS-DATE-YYYYMMDD
           MOVE WS-CDT-TIME TO WS-TIME-HHMMSS

           MOVE WS-DATE-YYYYMMDD(1:4) TO WS-YEAR
           MOVE WS-DATE-YYYYMMDD(5:2) TO WS-MONTH
           MOVE WS-DATE-YYYYMMDD(7:2) TO WS-DAY

           MOVE WS-TIME-HHMMSS(1:2)   TO WS-HOUR
           MOVE WS-TIME-HHMMSS(3:2)   TO WS-MINUTE
           MOVE WS-TIME-HHMMSS(5:2)   TO WS-SECOND

           MOVE SPACES TO CUST-LAST-UPDATE-TS

           STRING
              WS-YEAR     DELIMITED BY SIZE
              "-"         DELIMITED BY SIZE
              WS-MONTH    DELIMITED BY SIZE
              "-"         DELIMITED BY SIZE
              WS-DAY      DELIMITED BY SIZE
              " "         DELIMITED BY SIZE
              WS-HOUR     DELIMITED BY SIZE
              ":"         DELIMITED BY SIZE
              WS-MINUTE   DELIMITED BY SIZE
              ":"         DELIMITED BY SIZE
              WS-SECOND   DELIMITED BY SIZE
              INTO CUST-LAST-UPDATE-TS
           END-STRING.


       *> ------------------------------------------------------------
       DISPLAY-CUSTOMER-DATA.
       *> Display current customer data on screen
           DISPLAY " National ID      : " CUST-NATIONAL-ID
           DISPLAY " First Name       : " CUST-FIRST-NAME
           DISPLAY " Middle Name      : " CUST-MIDDLE-NAME
           DISPLAY " Last Name        : " CUST-LAST-NAME
           DISPLAY " Second Last Name : " CUST-SECOND-LAST-NAME
           DISPLAY " Date of Birth    : " CUST-DATE-OF-BIRTH
           DISPLAY " Phone Number     : " CUST-PHONE-NUMBER
           DISPLAY " Email            : " CUST-EMAIL
           DISPLAY " Street           : " CUST-STREET
           DISPLAY " Ext Number       : " CUST-EXT-NUMBER
           DISPLAY " Int Number       : " CUST-INT-NUMBER
           DISPLAY " City             : " CUST-CITY
           DISPLAY " State/Province   : " CUST-STATE
           DISPLAY " Postal Code      : " CUST-POSTAL-CODE
           DISPLAY " Country          : " CUST-COUNTRY
           DISPLAY " Account Type     : " CUST-ACCOUNT-TYPE
           DISPLAY " Encrypted Code   : " CUST-ENCRYPTED-CODE
           DISPLAY " Last Update      : " CUST-LAST-UPDATE-TS.
