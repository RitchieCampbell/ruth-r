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
( Prints error message s2 is expected result s1 found, test no i if s1 ≠ s2 )
2DUP stringEq
IF
    DROP 2DROP
ELSE
    ." Error without type: Expected: " CR .AZ ." ." CR ." Found: " CR .AZ
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
1005 " CONSTANTS set {  “Campbell”, “Ruth”} END " Pconstants " STRING { "
" Campbell" addQuotes1 "  , " " Ruth" addQuotes1 "  , } VALUE set" newline
AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1005 " CONSTANTS p3 {  “Campbell”, “Ruth”} ↦ {1, 2, 3} END " Pconstants " STRING { "
" Campbell" addQuotes1 "  , " " Ruth" addQuotes1
"  , } INT { 1 , 2 , 3 , } |->S,S VALUE p3" newline AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1006 " CONSTANTS j 123, a 123.45 END " Pconstants " 123 VALUE j" newline AZ^
" 123.45 VALUE a" newline AZ^ AZ^ checkOutput
1007 " CONSTANTS s2  “Campbell”, set2 {1, 2, 3} END " Pconstants " Campbell" addQuotes1
"  VALUE s2" newline AZ^ AZ^ " INT { 1 , 2 , 3 , } VALUE set2" newline AZ^ AZ^ checkOutput
1008 " CONSTANTS s3  “Campbell” ^ “ and Ruth”  END " Pconstants " Campbell"
addQuotes1 sspace AZ^ "  and Ruth" addQuotes1 "  AZ^ VALUE s3" newline AZ^ AZ^ AZ^ checkOutput
1009 " CONSTANTS p4  “Campbell” ↦ “Ruth”, b i > 0 END " Pconstants " Campbell" addQuotes1
sspace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p4" newline AZ^ AZ^
" i 0 > VALUE b" newline AZ^ AZ^ checkOutput
1010 " CONSTANTS set3 {1, 3} ◁  [ “Campbell”, “Ruth”, “Sarah”, “Eleanor”], k 999 END " Pconstants
" INT { 1 , 3 , } STRING [ " " Campbell" addQuotes1 "  , " " Ruth" addQuotes1
"  , " " Sarah" addQuotes1 "  , " " Eleanor" addQuotes1 "  , ] ◁ VALUE set3"
newline " 999 VALUE k" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
STRING STRING PROD { } to constants STRING STRING PROD { } to types
( empty relations to avoid collisions )
1011 " CONSTANTS i 123 END VARIABLES j INT, s STRING END " Pconstants
" 123 VALUE i" newline AZ^ " 0 VALUE j" newline AZ^ AZ^ " 0 VALUE s" newline AZ^ AZ^  checkOutput
1012 " CONSTANTS s  “Campbell” END VARIABLES jj INT, ss STRING END " Pconstants
" Campbell" addQuotes1 "  VALUE s" newline AZ^ AZ^ " 0 VALUE jj" newline AZ^ AZ^
" 0 VALUE ss" newline AZ^ AZ^ checkOutput
1013 " CONSTANTS p  “Campbell” ↦ 123 END VARIABLES iArr INT[] END " Pconstants
" Campbell" addQuotes1 "  123 |->$,I VALUE p" newline AZ^ AZ^ " 0 VALUE-ARRAY iArr"
newline AZ^ AZ^ checkOutput
1014 " CONSTANTS p2  “Campbell” ↦ “Ruth” END VARIABLES iArr2 INT[], ii INT END " Pconstants
" Campbell" addQuotes1 sspace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p2"
newline AZ^ AZ^ " 0 VALUE-ARRAY iArr2" newline AZ^ AZ^ " 0 VALUE ii" newline AZ^ AZ^ checkOutput
1015 " CONSTANTS set {  “Campbell”, “Ruth”} END VARIABLES iSet ℙ(INT) END "
Pconstants " STRING { " " Campbell" addQuotes1 "  , " " Ruth" addQuotes1
"  , } VALUE set" newline " 0 VALUE iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1016 " CONSTANTS j 123, a 123.45 END" newline " VARIABLES iArr3 INT[] END " AZ^
AZ^ Pconstants " 123 VALUE j" newline AZ^ " 123.45 VALUE a" newline AZ^ AZ^
" 0 VALUE-ARRAY iArr3" newline AZ^ AZ^ checkOutput
1017 " CONSTANTS s2  “Campbell”, set2 {1, 2, 3} END" newline AZ^
" VARIABLES iArr4 INT[], sSet ℙ(STRING) END " AZ^ Pconstants " Campbell"
addQuotes1 "  VALUE s2" newline AZ^ AZ^ " INT { 1 , 2 , 3 , } VALUE set2"
newline AZ^ AZ^ " 0 VALUE-ARRAY iArr4" newline
" 0 VALUE sSet" newline AZ^ AZ^ AZ^ AZ^ checkOutput
1018 " CONSTANTS s3  “Campbell” ^ “ and Ruth”  END " newline AZ^
" VARIABLES k INT, iArr5 INT[], pSet ℙ(INT×INT) END " newline AZ^ AZ^ 
Pconstants " Campbell" addQuotes1 sspace AZ^ "  and Ruth" addQuotes1
"  AZ^ VALUE s3" newline " 0 VALUE k" newline " 0 VALUE-ARRAY iArr5" newline
" 0 VALUE pSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1019 " CONSTANTS i3 -123, p4  “Campbell” ↦ “Ruth”, b i3 > 0 END" newline AZ^
" VARIABLES z FLOAT, s4 STRING END " AZ^ Pconstants " 123 -1 * VALUE i3" newline
AZ^ " Campbell" addQuotes1 sspace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p4"
newline AZ^ AZ^ " i3 0 > VALUE b" newline AZ^ AZ^ " 0 VALUE z" newline AZ^ AZ^
" 0 VALUE s4" newline AZ^ AZ^ checkOutput
1020 " CONSTANTS set3 {1, 3} ◁  [ “Campbell”, “Ruth”, “Sarah”, “Eleanor”], kk 999 END " Pconstants
" INT { 1 , 3 , } STRING [ " " Campbell" addQuotes1 "  , " " Ruth" addQuotes1
"  , " " Sarah" addQuotes1 "  , " " Eleanor" addQuotes1 "  , ] ◁ VALUE set3"
newline " 999 VALUE kk" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1021 " CONSTANTS arr ARRAY[ 1 , 2 , 3] END " Pconstants
" 3 VALUE-ARRAY arr" newline AZ^ " HERE 3 , 1 , 2 , 3 ,  to  arr" newline AZ^ AZ^ checkOutput

" HereEndethThe6thTestFile." CR .AZ CR

