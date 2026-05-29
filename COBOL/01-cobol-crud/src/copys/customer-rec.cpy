       01  CUSTOMER-RECORD.
           05  CUST-NATIONAL-ID        PIC X(20).   *> Unique key
           05  CUST-FIRST-NAME         PIC X(20).
           05  CUST-MIDDLE-NAME        PIC X(20).
           05  CUST-LAST-NAME          PIC X(20).
           05  CUST-SECOND-LAST-NAME   PIC X(20).   *> Optional
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
