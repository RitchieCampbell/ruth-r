: reportParserError ( i s1 s2 s3 -- )
( Prints an error message s1 is expected result, s2 found, s3 kind, line No i )
CR .AZ
."  error: Found:" SWAP CR .AZ ."  when expecting:" CR .AZ ."  at test No " .
;

: checkOutputAndType ( i s1 s2 s3 s4 -- )
( i=line number. Error message if s1/s3 and s2/s4 are not identical pairs )
ROT 2DUP stringEq
IF
    2DROP
ELSE
    PUSH PUSH ROT DUP PUSH ROT ROT POP POP POP " Type" reportParserError
THEN
2DUP stringEq
IF
    DROP 2DROP
ELSE
    " Output" reportParserError
THEN
;

: checkOutput ( i s1 s2 -- )
( Prints error message s2 is expected result s1 found, line no i )
2DUP stringEq
IF
    DROP 2DROP
ELSE
    ." Error without type: Expected: " .AZ ." ." CR ." Found: " .AZ
    ." . at test No " .
THEN ;

STRING STRING PROD { } to constants ( empty relation to avoid collisions )
1001 " CONSTANTS i 123 END " Pconstants " 123 VALUE i" newline AZ^ checkOutput
1002 " CONSTANTS s  “Campbell” END " Pconstants " Campbell" addQuotes1
"  VALUE s" newline AZ^ AZ^ checkOutput
1003 " CONSTANTS p  “Campbell” ↦ 123 END " Pconstants " Campbell" addQuotes1
"  123 |->$,I VALUE p" newline AZ^ AZ^ checkOutput
1004 " CONSTANTS p2  “Campbell” ↦ “Ruth” END " Pconstants " Campbell" addQuotes1
sspace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p2" newline AZ^ AZ^ checkOutput

" HereEndethThe6thTestFile." CR .AZ CR

