       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENCRYPTION-UTIL.
       AUTHOR. CESAR DAVID REY FIGUEROA.

       *> ------------------------------------------------------------
       *> Simple deterministic encryption utility.
       *> Input : concatenated customer string (LK-IN-STRING)
       *> Output: alphanumeric code (LK-OUT-CODE)
       *> ------------------------------------------------------------

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-INDEX                PIC 9(4) VALUE 0.
       01  WS-LENGTH               PIC 9(4) VALUE 0.
       01  WS-CHAR                 PIC X    VALUE SPACE.
       01  WS-ORD                  PIC 9(4) VALUE 0.
       01  WS-CHECKSUM             PIC 9(9) VALUE 0.
       01  WS-CHECKSUM-MOD         PIC 9(4) VALUE 0.
       01  WS-CHECKSUM-EDIT        PIC 9(4) VALUE 0.
       01  WS-CHECKSUM-TEXT        PIC X(4) VALUE "0000".

       01  WS-SHIFTED-STRING       PIC X(256) VALUE SPACES.

       01  WS-OUT-BASE             PIC X(8) VALUE SPACES.
       01  WS-OUT-INDEX            PIC 9(2) VALUE 0.

       01  WS-ORD-SHIFTED          PIC 9(4) VALUE 0.

       LINKAGE SECTION.

       01  LK-IN-STRING            PIC X(256).
       01  LK-OUT-CODE             PIC X(20).
       01  LK-RETURN-CODE          PIC 99.

       PROCEDURE DIVISION USING LK-IN-STRING
                                LK-OUT-CODE
                                LK-RETURN-CODE.

       MAIN-ENTRY.

           MOVE 0      TO LK-RETURN-CODE
                         WS-CHECKSUM
           MOVE SPACES TO WS-SHIFTED-STRING
                         WS-OUT-BASE
                         LK-OUT-CODE

           *> Check empty input
           IF LK-IN-STRING = SPACES
              MOVE "ERR-EMPTY-STR" TO LK-OUT-CODE
              MOVE 1 TO LK-RETURN-CODE
              GOBACK
           END-IF

           *> Compute length of input string
           MOVE FUNCTION LENGTH(LK-IN-STRING) TO WS-LENGTH

           PERFORM VARYING WS-INDEX FROM 1 BY 1
                     UNTIL WS-INDEX > WS-LENGTH

              MOVE LK-IN-STRING(WS-INDEX:1) TO WS-CHAR

              IF WS-CHAR NOT = SPACE
                 *> Update checksum with original character
                 MOVE FUNCTION ORD(WS-CHAR) TO WS-ORD
                 ADD WS-ORD TO WS-CHECKSUM

                 *> Apply shift only for alphanumeric characters
                 IF (WS-CHAR >= "0" AND WS-CHAR <= "9")
                    PERFORM SHIFT-DIGIT
                 ELSE
                    IF (WS-CHAR >= "A" AND WS-CHAR <= "Z")
                       PERFORM SHIFT-UPPER-LETTER
                    ELSE
                       IF (WS-CHAR >= "a" AND WS-CHAR <= "z")
                          *> Normalize lowercase to uppercase and shift
                          MOVE FUNCTION UPPER-CASE(WS-CHAR) TO WS-CHAR
                          PERFORM SHIFT-UPPER-LETTER
                       ELSE
                          *> Non-alphanumeric, keep as is
                          CONTINUE
                       END-IF
                    END-IF
                 END-IF
              END-IF

              MOVE WS-CHAR TO WS-SHIFTED-STRING(WS-INDEX:1)

           END-PERFORM

           *> Reduce checksum and build 4-digit text
           COMPUTE WS-CHECKSUM-MOD = FUNCTION MOD(WS-CHECKSUM, 9999)
           MOVE WS-CHECKSUM-MOD TO WS-CHECKSUM-EDIT
           MOVE WS-CHECKSUM-EDIT TO WS-CHECKSUM-TEXT

           *> Build first 8 non-space characters from shifted string
           MOVE 0   TO WS-OUT-INDEX
           MOVE SPACES TO WS-OUT-BASE

           PERFORM VARYING WS-INDEX FROM 1 BY 1
                     UNTIL WS-INDEX > WS-LENGTH
                       OR WS-OUT-INDEX = 8

              MOVE WS-SHIFTED-STRING(WS-INDEX:1) TO WS-CHAR
              IF WS-CHAR NOT = SPACE
                 ADD 1 TO WS-OUT-INDEX
                 MOVE WS-CHAR TO WS-OUT-BASE(WS-OUT-INDEX:1)
              END-IF

           END-PERFORM

           *> Compose final code: <8-CHARS><4-DIGIT-CHECKSUM>
           MOVE SPACES TO LK-OUT-CODE
           MOVE WS-OUT-BASE      TO LK-OUT-CODE(1:8)
           MOVE WS-CHECKSUM-TEXT TO LK-OUT-CODE(9:4)

           GOBACK.

       *> ------------------------------------------------------------
       SHIFT-DIGIT.
       *> Shift digits by +3 with wrap at '9'
           MOVE FUNCTION ORD(WS-CHAR) TO WS-ORD
           ADD 3 TO WS-ORD
           IF WS-ORD > FUNCTION ORD("9")
              COMPUTE WS-ORD-SHIFTED =
                      FUNCTION ORD("0")
                      + (WS-ORD - FUNCTION ORD("9") - 1)
              MOVE WS-ORD-SHIFTED TO WS-ORD
           END-IF
           MOVE FUNCTION CHAR(WS-ORD) TO WS-CHAR.

       *> ------------------------------------------------------------
       SHIFT-UPPER-LETTER.
       *> Shift uppercase letters by +3 with wrap at 'Z'
           MOVE FUNCTION ORD(WS-CHAR) TO WS-ORD
           ADD 3 TO WS-ORD
           IF WS-ORD > FUNCTION ORD("Z")
              COMPUTE WS-ORD-SHIFTED =
                      FUNCTION ORD("A")
                      + (WS-ORD - FUNCTION ORD("Z") - 1)
              MOVE WS-ORD-SHIFTED TO WS-ORD
           END-IF
           MOVE FUNCTION CHAR(WS-ORD) TO WS-CHAR.
