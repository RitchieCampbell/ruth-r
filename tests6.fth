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


