       IDENTIFICATION DIVISION.
       PROGRAM-ID. RECEIPT-PRINT.
       AUTHOR. CESAR DAVID REY FIGUEROA.

       *> ------------------------------------------------------------
       *> Receipt generator for bank customer registration.
       *> Reads customer data by National ID and prints a text receipt.
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

       01  WS-FULL-NAME               PIC X(60) VALUE SPACES.
       01  WS-LINE-SEPARATOR          PIC X(60)
                                       VALUE ALL "-".
       01  WS-TITLE-SEPARATOR         PIC X(60)
                                       VALUE ALL "=".

       LINKAGE SECTION.

       01  LK-NATIONAL-ID             PIC X(20).
       01  LK-RETURN-CODE             PIC 99.

       PROCEDURE DIVISION USING LK-NATIONAL-ID
                                LK-RETURN-CODE.

       MAIN-ENTRY.

           MOVE 0 TO LK-RETURN-CODE

           PERFORM OPEN-FILE

           IF LK-RETURN-CODE = 0
              PERFORM READ-CUSTOMER
              IF LK-RETURN-CODE = 0
                 PERFORM BUILD-FULL-NAME
                 PERFORM PRINT-RECEIPT
              END-IF
           END-IF

           PERFORM CLOSE-FILE

           GOBACK.

       *> ------------------------------------------------------------
       OPEN-FILE.
       *> Open customer file
           OPEN I-O CUSTOMER-FILE
           IF CUSTOMER-FILE-STATUS = "35"
              *> File not found, do not create in this module
              MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                   TO LK-RETURN-CODE
           ELSE
              IF CUSTOMER-FILE-STATUS NOT = "00"
                 MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                      TO LK-RETURN-CODE
              END-IF
           END-IF.

       *> ------------------------------------------------------------
       CLOSE-FILE.
       *> Close customer file
           CLOSE CUSTOMER-FILE.

       *> ------------------------------------------------------------
       READ-CUSTOMER.
       *> Read customer by National ID from linkage
           MOVE LK-NATIONAL-ID TO CUST-NATIONAL-ID

           READ CUSTOMER-FILE KEY IS CUST-NATIONAL-ID
           IF CUSTOMER-FILE-STATUS = "00"
              MOVE 0 TO LK-RETURN-CODE
           ELSE
              MOVE FUNCTION NUMVAL(CUSTOMER-FILE-STATUS)
                   TO LK-RETURN-CODE
           END-IF.

       *> ------------------------------------------------------------
       BUILD-FULL-NAME.
       *> Build full name with optional second last name
           MOVE SPACES TO WS-FULL-NAME

           STRING
              CUST-FIRST-NAME DELIMITED BY SPACE
              SPACE
              CUST-LAST-NAME  DELIMITED BY SPACE
              INTO WS-FULL-NAME
           END-STRING

           IF CUST-SECOND-LAST-NAME NOT = SPACES
              STRING
                 WS-FULL-NAME           DELIMITED BY SPACE
                 SPACE
                 CUST-SECOND-LAST-NAME  DELIMITED BY SPACE
                 INTO WS-FULL-NAME
              END-STRING
           END-IF.

       *> ------------------------------------------------------------
       PRINT-RECEIPT.
       *> Print text receipt to standard output
           DISPLAY SPACE
           DISPLAY WS-TITLE-SEPARATOR
           DISPLAY "FICTIONAL BANK - ACCOUNT REGISTRATION RECEIPT"
           DISPLAY WS-TITLE-SEPARATOR
           DISPLAY SPACE

           DISPLAY " Customer Name   : " WS-FULL-NAME
           DISPLAY " National ID     : " CUST-NATIONAL-ID
           DISPLAY " Account Type    : " CUST-ACCOUNT-TYPE
           DISPLAY " Encrypted Code  : " CUST-ENCRYPTED-CODE
           DISPLAY " Last Update     : " CUST-LAST-UPDATE-TS

           DISPLAY WS-LINE-SEPARATOR
           DISPLAY "This receipt confirms that the customer information"
           DISPLAY " has been registered in the bank customer file."
           DISPLAY WS-LINE-SEPARATOR
           DISPLAY SPACE.
