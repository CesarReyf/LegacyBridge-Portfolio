       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-CRUD-MAIN.
       AUTHOR. CESAR DAVID REY FIGUEROA.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-USER-OPTION          PIC 9 VALUE 0.
       01  WS-RUN-FLAG             PIC X VALUE "Y".
       01  WS-NATIONAL-ID          PIC X(20).
       01  WS-RETURN-CODE          PIC 99 VALUE 0.
       01  LINE-SEPARATOR          PIC X(50) VALUE ALL "=".

       PROCEDURE DIVISION.
       MAIN.

           PERFORM INIT-SECTION

           PERFORM UNTIL WS-RUN-FLAG NOT = "Y"
              PERFORM DISPLAY-MENU
              PERFORM PROCESS-OPTION
           END-PERFORM

           PERFORM END-SECTION

           STOP RUN.

       *> ------------------------------------------------------------
       INIT-SECTION.
           DISPLAY LINE-SEPARATOR
           DISPLAY "      BANK CUSTOMER MANAGEMENT SYSTEM"
           DISPLAY LINE-SEPARATOR
           DISPLAY " System ready."
           DISPLAY SPACE.

       *> ------------------------------------------------------------
       DISPLAY-MENU.
           DISPLAY SPACE
           DISPLAY LINE-SEPARATOR
           DISPLAY " Select an option:"
           DISPLAY "   1 - Create Customer"
           DISPLAY "   2 - Read Customer"
           DISPLAY "   3 - Update Customer"
           DISPLAY "   4 - Delete Customer"
           DISPLAY "   5 - Print Receipt"
           DISPLAY "   6 - Exit"
           DISPLAY LINE-SEPARATOR
           DISPLAY " Enter option: "
           ACCEPT WS-USER-OPTION.

       *> ------------------------------------------------------------
       PROCESS-OPTION.
           EVALUATE WS-USER-OPTION

               WHEN 1
                   PERFORM MENU-CREATE

               WHEN 2
                   PERFORM MENU-READ

               WHEN 3
                   PERFORM MENU-UPDATE

               WHEN 4
                   PERFORM MENU-DELETE

               WHEN 5
                   PERFORM MENU-RECEIPT

               WHEN 6
                   MOVE "N" TO WS-RUN-FLAG

               WHEN OTHER
                   DISPLAY " Invalid option. Please try again."

           END-EVALUATE.

       *> ------------------------------------------------------------
       MENU-CREATE.
           DISPLAY SPACE
           DISPLAY "*** CREATE NEW CUSTOMER ***"

           MOVE SPACES TO WS-NATIONAL-ID
           MOVE 0 TO WS-RETURN-CODE

           *> Full parameter list: ACTION, NATIONAL-ID, RETURN-CODE
           CALL "customer-crud"
                USING "CREATE"
                      WS-NATIONAL-ID
                      WS-RETURN-CODE

           IF WS-RETURN-CODE = 0
              DISPLAY " Customer created successfully."
           ELSE
              DISPLAY " Create operation finished with errors."
           END-IF.

       *> ------------------------------------------------------------
       MENU-READ.
           DISPLAY SPACE
           DISPLAY "*** READ CUSTOMER ***"

           PERFORM ASK-ID
           MOVE 0 TO WS-RETURN-CODE

           CALL "customer-crud"
                USING "READ"
                      WS-NATIONAL-ID
                      WS-RETURN-CODE

           IF WS-RETURN-CODE = 23
              DISPLAY " Customer not found."
           ELSE
              IF WS-RETURN-CODE NOT = 0
                 DISPLAY " Read operation finished with errors."
              END-IF
           END-IF.

       *> ------------------------------------------------------------
       MENU-UPDATE.
           DISPLAY SPACE
           DISPLAY "*** UPDATE CUSTOMER ***"

           PERFORM ASK-ID
           MOVE 0 TO WS-RETURN-CODE

           CALL "customer-crud"
                USING "UPDATE"
                      WS-NATIONAL-ID
                      WS-RETURN-CODE

           IF WS-RETURN-CODE = 23
              DISPLAY " Customer not found."
           ELSE
              IF WS-RETURN-CODE NOT = 0
                 DISPLAY " Update operation finished with errors."
              ELSE
                 DISPLAY " Customer updated successfully."
              END-IF
           END-IF.

       *> ------------------------------------------------------------
       MENU-DELETE.
           DISPLAY SPACE
           DISPLAY "*** DELETE CUSTOMER ***"

           PERFORM ASK-ID
           MOVE 0 TO WS-RETURN-CODE

           CALL "customer-crud"
                USING "DELETE"
                      WS-NATIONAL-ID
                      WS-RETURN-CODE

           IF WS-RETURN-CODE = 23
              DISPLAY " Customer not found."
           ELSE
              IF WS-RETURN-CODE NOT = 0
                 DISPLAY " Delete operation finished with errors."
              ELSE
                 DISPLAY " Customer deleted successfully."
              END-IF
           END-IF.

       *> ------------------------------------------------------------
       MENU-RECEIPT.
           DISPLAY SPACE
           DISPLAY "*** PRINT RECEIPT ***"

           PERFORM ASK-ID
           MOVE 0 TO WS-RETURN-CODE

           CALL "receipt-print"
                USING WS-NATIONAL-ID
                      WS-RETURN-CODE

           IF WS-RETURN-CODE = 23
              DISPLAY " Customer not found. Receipt not generated."
           ELSE
              IF WS-RETURN-CODE NOT = 0
                 DISPLAY " Receipt generation finished with errors."
              ELSE
                 DISPLAY " Receipt generated successfully."
              END-IF
           END-IF.

       *> ------------------------------------------------------------
       ASK-ID.
           DISPLAY " Enter National ID: "
           ACCEPT WS-NATIONAL-ID.

       *> ------------------------------------------------------------
       END-SECTION.
           DISPLAY SPACE
           DISPLAY " Exiting system..."
           DISPLAY " Goodbye."
           DISPLAY SPACE.
