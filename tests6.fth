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

: stringComparer ( s1 s2 -- .. ) ( Displays difference between 2 strings )
2DUP myAZLength SWAP myAZLength <>
IF
    ." Lengths differ: " OVER myAZLength . ."  and " DUP myAZLength . CR
THEN
BEGIN
    DUP head
WHILE
    DUP head PUSH OVER head POP = NOT
    IF
        OVER head EMIT ."   and  " DUP head EMIT ."  at " DUP . CR
    THEN
    1+ SWAP 1+ SWAP 
REPEAT 2DROP ;

STRING STRING PROD { } to constants ( empty relation to avoid collisions )
1001 " CONSTANTS i 123 END " Pconstants " 123 VALUE i" newline AZ^ checkOutput
1002 " CONSTANTS s  “Campbell” END " Pconstants " Campbell" addQuotes1
"  VALUE s" newline AZ^ AZ^ checkOutput
1003 " CONSTANTS p  “Campbell” ↦ 123 END " Pconstants " Campbell" addQuotes1
"  123 |->$,I VALUE p" newline AZ^ AZ^ checkOutput
1004 " CONSTANTS p2  “Campbell” ↦ “Ruth” END " Pconstants " Campbell" addQuotes1
sSpace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p2" newline AZ^ AZ^ checkOutput
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
addQuotes1 sSpace AZ^ "  and Ruth" addQuotes1 "  AZ^ VALUE s3" newline AZ^ AZ^ AZ^ checkOutput
1009 " CONSTANTS p4  “Campbell” ↦ “Ruth”, b i > 0 END " Pconstants " Campbell" addQuotes1
sSpace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p4" newline AZ^ AZ^
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
1013 " CONSTANTS p  “Campbell” ↦ 123 END VARIABLES iArr INT[5] END " Pconstants
" Campbell" addQuotes1 "  123 |->$,I VALUE p" newline AZ^ AZ^ " 5 VALUE-ARRAY iArr"
newline AZ^ AZ^ checkOutput
1014 " CONSTANTS p2  “Campbell” ↦ “Ruth” END VARIABLES iArr2 INT[5], ii INT END " Pconstants
" Campbell" addQuotes1 sSpace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p2"
newline AZ^ AZ^ " 5 VALUE-ARRAY iArr2" newline AZ^ AZ^ " 0 VALUE ii" newline AZ^ AZ^ checkOutput
1015 " CONSTANTS set {  “Campbell”, “Ruth”} END VARIABLES iSet ℙ(INT) END "
Pconstants " STRING { " " Campbell" addQuotes1 "  , " " Ruth" addQuotes1
"  , } VALUE set" newline " 0 VALUE iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1016 " CONSTANTS j 123, a 123.45 END" newline " VARIABLES iArr3 INT[5] END " AZ^
AZ^ Pconstants " 123 VALUE j" newline AZ^ " 123.45 VALUE a" newline AZ^ AZ^
" 5 VALUE-ARRAY iArr3" newline AZ^ AZ^ checkOutput
1017 " CONSTANTS s2  “Campbell”, set2 {1, 2, 3} END" newline AZ^
" VARIABLES iArr4 INT[5], sSet ℙ(STRING) END " AZ^ Pconstants " Campbell"
addQuotes1 "  VALUE s2" newline AZ^ AZ^ " INT { 1 , 2 , 3 , } VALUE set2"
newline AZ^ AZ^ " 5 VALUE-ARRAY iArr4" newline
" 0 VALUE sSet" newline AZ^ AZ^ AZ^ AZ^ checkOutput
1018 " CONSTANTS s3  “Campbell” ^ “ and Ruth”  END " newline AZ^
" VARIABLES k INT, iArr5 INT[5], pSet ℙ(INT×INT) END " newline AZ^ AZ^ 
Pconstants " Campbell" addQuotes1 sSpace AZ^ "  and Ruth" addQuotes1
"  AZ^ VALUE s3" newline " 0 VALUE k" newline " 5 VALUE-ARRAY iArr5" newline
" 0 VALUE pSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1019 " CONSTANTS i3 -123, p4  “Campbell” ↦ “Ruth”, b i3 > 0 END" newline AZ^
" VARIABLES z FLOAT, s4 STRING END " AZ^ Pconstants " 123 -1 * VALUE i3" newline
AZ^ " Campbell" addQuotes1 sSpace AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ VALUE p4"
newline AZ^ AZ^ " i3 0 > VALUE b" newline AZ^ AZ^ " 0 VALUE z" newline AZ^ AZ^
" 0 VALUE s4" newline AZ^ AZ^ AZ^ checkOutput
1020 " CONSTANTS set3 {1, 3} ◁  [ “Campbell”, “Ruth”, “Sarah”, “Eleanor”], kk 999 END"
newline " VARIABLES pair INT×STRING END " AZ^ AZ^ Pconstants
" INT { 1 , 3 , } STRING [ " " Campbell" addQuotes1 "  , " " Ruth" addQuotes1
"  , " " Sarah" addQuotes1 "  , " " Eleanor" addQuotes1 "  , ] ◁ VALUE set3"
newline " 999 VALUE kk" newline " 0 VALUE pair" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1021 " CONSTANTS arr ARRAY[ 1 , 2 , 3] END" newline " VARIABLES pair2 STRING×INT END "
AZ^ AZ^ Pconstants " 3 VALUE-ARRAY arr" newline AZ^ " HERE 3 , 1 , 2 , 3 ,  to  arr"
newline " 0 VALUE pair2" newline AZ^ AZ^ AZ^ AZ^ checkOutput
STRING STRING PROD { } to types ( empty relation to avoid collisions )
1022 " VARIABLES i INT, j INT, s STRING END " Pconstants
" 0 VALUE i" newline AZ^ " 0 VALUE j" newline AZ^ AZ^ " 0 VALUE s" newline AZ^ AZ^  checkOutput
1023 " VARIABLES s1 STRING, jj INT, ss STRING END " Pconstants
" 0 VALUE s1" newline AZ^ " 0 VALUE jj" newline AZ^ AZ^ " 0 VALUE ss" newline
AZ^ AZ^ checkOutput
1024 " VARIABLES p STRING×STRING, iArr INT[5] END " Pconstants " 0 VALUE p" newline AZ^
" 5 VALUE-ARRAY iArr" newline AZ^ AZ^ checkOutput
1025 " VARIABLES p2 STRING×STRING, iArr2 INT[5], ii INT END " Pconstants
" 0 VALUE p2" newline AZ^ " 5 VALUE-ARRAY iArr2" newline AZ^ AZ^ " 0 VALUE ii"
newline AZ^ AZ^ checkOutput
1026 " VARIABLES set ℙ(STRING), iSet ℙ(INT) END " Pconstants " 0 VALUE set"
newline " 0 VALUE iSet" newline AZ^ AZ^ AZ^ checkOutput
1027 " VARIABLES j1 INT, a FLOAT,iArr3 INT[5] END " Pconstants
" 0 VALUE j1" newline AZ^ " 0 VALUE a" newline AZ^ AZ^
" 5 VALUE-ARRAY iArr3" newline AZ^ AZ^ checkOutput
1028 " VARIABLES s2 STRING, set2 ℙ(INT), iArr4 INT[5], sSet ℙ(STRING) END "
Pconstants " 0 VALUE s2" newline AZ^ " 0 VALUE set2" newline AZ^ AZ^
" 5 VALUE-ARRAY iArr4" newline " 0 VALUE sSet" newline AZ^ AZ^ AZ^ AZ^ checkOutput
1029 " VARIABLES s3  STRING × STRING, k INT, iArr5 INT[5], pSet ℙ(INT×INT) END " 
Pconstants " 0 VALUE s3" newline " 0 VALUE k" newline " 5 VALUE-ARRAY iArr5" newline
" 0 VALUE pSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1030 " VARIABLES i3 INT, p4 STRING×STRING, b BOO, z FLOAT, s4 STRING END " Pconstants
" 0 VALUE i3" newline AZ^ " 0 VALUE p4" newline AZ^ AZ^ " 0 VALUE b" newline AZ^ AZ^
" 0 VALUE z" newline AZ^ AZ^ " 0 VALUE s4" newline AZ^ AZ^ checkOutput
1031 " VARIABLES set3 ℙ (INT × STRING), kk INT, pair INT×STRING END "
Pconstants " 0 VALUE set3" newline " 0 VALUE kk" newline " 0 VALUE pair" newline
AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1032 " VARIABLES arr INT[5], pair2 STRING×INT END " Pconstants
" 5 VALUE-ARRAY arr" newline AZ^ " 0 VALUE pair2" newline AZ^ AZ^ checkOutput
STRING STRING PROD { } to types ( empty relation to avoid collisions )
1033 " VARIABLES i INT, j INT, s STRING END " Pvariables
" 0 VALUE i" newline AZ^ " 0 VALUE j" newline AZ^ AZ^ " 0 VALUE s" newline AZ^ AZ^  checkOutput
1034 " VARIABLES s1 STRING, jj INT, ss STRING END " Pvariables
" 0 VALUE s1" newline AZ^ " 0 VALUE jj" newline AZ^ AZ^ " 0 VALUE ss" newline
AZ^ AZ^ checkOutput
1035 " VARIABLES p STRING×STRING, iArr INT[5] END " Pvariables " 0 VALUE p" newline AZ^
" 5 VALUE-ARRAY iArr" newline AZ^ AZ^ checkOutput
1036 " VARIABLES p2 STRING×STRING, iArr2 INT[5], ii INT END " Pvariables
" 0 VALUE p2" newline AZ^ " 5 VALUE-ARRAY iArr2" newline AZ^ AZ^ " 0 VALUE ii"
newline AZ^ AZ^ checkOutput
1037 " VARIABLES set ℙ(STRING), iSet ℙ(INT) END " Pvariables " 0 VALUE set"
newline " 0 VALUE iSet" newline AZ^ AZ^ AZ^ checkOutput
1038 " VARIABLES j1 INT, a FLOAT,iArr3 INT[5] END " Pvariables
" 0 VALUE j1" newline AZ^ " 0 VALUE a" newline AZ^ AZ^
" 5 VALUE-ARRAY iArr3" newline AZ^ AZ^ checkOutput
1039 " VARIABLES s2 STRING, set2 ℙ(INT), iArr4 INT[5], sSet ℙ(STRING) END "
Pvariables " 0 VALUE s2" newline AZ^ " 0 VALUE set2" newline AZ^ AZ^
" 5 VALUE-ARRAY iArr4" newline " 0 VALUE sSet" newline AZ^ AZ^ AZ^ AZ^ checkOutput
1040 " VARIABLES s3  STRING × STRING, k INT, iArr5 INT[5], pSet ℙ(INT×INT) END " 
Pvariables " 0 VALUE s3" newline " 0 VALUE k" newline " 5 VALUE-ARRAY iArr5" newline
" 0 VALUE pSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1041 " VARIABLES i3 INT, p4 STRING×STRING, b BOO, z FLOAT, s4 STRING END " Pvariables
" 0 VALUE i3" newline AZ^ " 0 VALUE p4" newline AZ^ AZ^ " 0 VALUE b" newline AZ^ AZ^
" 0 VALUE z" newline AZ^ AZ^ " 0 VALUE s4" newline AZ^ AZ^ checkOutput
1042 " VARIABLES set3 ℙ (INT × STRING), kk INT, pair INT×STRING END "
Pvariables " 0 VALUE set3" newline " 0 VALUE kk" newline " 0 VALUE pair" newline
AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1043 " VARIABLES arr2 INT[5], pair2 STRING×INT END " Pvariables
" 5 VALUE-ARRAY arr2" newline AZ^ " 0 VALUE pair2" newline AZ^ AZ^ checkOutput
1044 " VARIABLES arr3 INT[i], pair3 STRING×INT END " Pvariables
" i VALUE-ARRAY arr3" newline AZ^ " 0 VALUE pair3" newline AZ^ AZ^ checkOutput
1045 " ii := 123" Passignment " 123 to ii" newline AZ^ checkOutput
1046 " ii := 123" Pinstruction " 123 to ii" newline AZ^ checkOutput
1047 " s1 := “Campbell”" Passignment " Campbell" addQuotes1 "  to s1" newline AZ^ AZ^ checkOutput
1048 " s1 := “Campbell”" Pinstruction " Campbell" addQuotes1 "  to s1" newline AZ^ AZ^ checkOutput
1049 " pair := 123 ↦ “Campbell”" Passignment " 123 " " Campbell" addQuotes1
"  |->I,$ to pair" newline AZ^ AZ^ AZ^ checkOutput
1050 " pair := 123 ↦ “Campbell”" Pinstruction " 123 " " Campbell" addQuotes1
"  |->I,$ to pair" newline AZ^ AZ^ AZ^ checkOutput
1051 " iArr := ARRAY[99, 100, 101]" Passignment " HERE 3 , 99 , 100 , 101 ,  to iArr"
newline AZ^ checkOutput
1052 " iArr := ARRAY[99, 100, 101]" Pinstruction " HERE 3 , 99 , 100 , 101 ,  to iArr"
newline AZ^ checkOutput
1053 " iArr[2] := 999" Passignment " 999 to  << 2 >> of iArr" newline AZ^ checkOutput
1054 " iArr[2] := 999" Pinstruction " 999 to  << 2 >> of iArr" newline AZ^ checkOutput
1055 " iSet := {1, 2, 3}" Passignment " INT { 1 , 2 , 3 , } to iSet" newline AZ^ checkOutput
1056 " iSet := {1, 2, 3}" Pinstruction " INT { 1 , 2 , 3 , } to iSet" newline AZ^ checkOutput
1057 " PRINT ii" Pprint " ii . " newline AZ^ checkOutput
1058 " PRINT ii" Pinstruction " ii . " newline AZ^ checkOutput
1059 " PRINT 1 + 2 * 3" Pprint " 1 2 3 * + . " newline AZ^ checkOutput
1060 " PRINT 1 + 2 * 3" Pinstruction " 1 2 3 * + . " newline AZ^ checkOutput
1061 " PRINT “Campbell” " Pprint " Campbell" addQuotes1 "  .AZ " newline AZ^ AZ^ checkOutput
1062 " PRINT “Campbell” " Pinstruction " Campbell" addQuotes1 "  .AZ " newline AZ^ AZ^ checkOutput
1063 " PRINT “Campbell” ↦ “Ruth”" Pprint " Campbell" addQuotes1 sSpace
" Ruth" addQuotes1 "  |->$,$ .PAIR " newline AZ^ AZ^ AZ^ AZ^ checkOutput
1064 " PRINT “Campbell” ↦ “Ruth”" Pinstruction " Campbell" addQuotes1 sSpace
" Ruth" addQuotes1 "  |->$,$ .PAIR " newline AZ^ AZ^ AZ^ AZ^ checkOutput
1065 " PRINT ii > jj" Pprint " ii jj > booleanPrint " newline AZ^ checkOutput
1066 " PRINT ii > jj" Pinstruction " ii jj > booleanPrint " newline AZ^ checkOutput
1067 " PRINT 1.2 + 0.000234 * 3.45e67" Pprint " 1.2 0.000234 3.45e67 F* F+ F."
newline AZ^ checkOutput
1068 " PRINT 1.2 + 0.000234 * 3.45e67" Pinstruction " 1.2 0.000234 3.45e67 F* F+ F."
newline AZ^ checkOutput
1069 " IF b THEN PRINT “Campbell” END" Pselection
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1070 " IF b THEN PRINT “Campbell” END" Pinstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1071 " IF b THEN PRINT “Campbell” ELSE PRINT “Ruth” END" Pselection
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " ELSE"
newline " Ruth" addQuotes1 "  .AZ " newline newline  " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1072 " IF b THEN PRINT “Campbell” ELSE PRINT “Ruth” END" Pinstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " ELSE"
newline " Ruth" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1073 " IF i < 3 THEN jj := 4 END" Pselection " i 3 <" newline " IF" newline
" 4 to jj" newline newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1074 " IF i < 3 THEN jj := 4 END" Pinstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1075 " IF i < 3 THEN jj := 4 ELSE jj := jj - 1 END" Pselection " i 3 <" newline " IF" newline
" 4 to jj" newline newline " ELSE" newline " jj 1 - to jj" newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1076 " IF i < 3 THEN jj := 4 ELSE jj := jj - 1 END" Pinstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " ELSE" newline " jj 1 - to jj" newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1077 " WHILE jj < 3 DO jj := jj + 1 END" Ploop " BEGIN" newline " jj 3 <" newline
" WHILE" newline " jj 1 + to jj" newline newline " REPEAT" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
checkOutput
1078 " WHILE jj < 3 DO jj := jj + 1 END" Pinstruction " BEGIN" newline " jj 3 <" newline
" WHILE" newline " jj 1 + to jj" newline newline " REPEAT" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
checkOutput
types STRING STRING PROD { " bb" boolean |-> , } ∪ to types STRING STRING PROD { } to locals
1079 " bb := ∀i2 • i2 ∈ iSet ⇒ i2 < 3  " Pinstruction " INT { <COLLECT" newline
"     iSet CHOICE to i2 i2 3 < NOT --> 0" newline " TILL CARD SATISFIED> } CARD 0="
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1080 " bb := ∀i3 • i3 ∈ iSet ⇒ i3 < 3  " Passignment " INT { <COLLECT" newline
"     iSet CHOICE to i3 i3 3 < NOT --> 0" newline " TILL CARD SATISFIED> } CARD 0="
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1081 " bb := ∃i4 • i4 ∈ iSet ∧ i4 < 3  " Pinstruction " INT { <COLLECT" newline
"     iSet CHOICE to i4 i4 3 < --> 0" newline " TILL CARD SATISFIED> } CARD 0 <>"
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1082 " bb := ∃i5 • i5 ∈ iSet ∧ i5 < 3  " Passignment " INT { <COLLECT" newline
"     iSet CHOICE to i5 i5 3 < --> 0" newline " TILL CARD SATISFIED> } CARD 0 <>"
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1083 " ii := 1 ▯ ii := 2" Pchoice " <CHOICE" newline " 1 to ii" newline
"  [] 2 to ii" newline "  CHOICE>" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1084 " iSet := {ii := 1 ▯ ii := 2 ♢ ii * 2}" Passignment " INT { <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> }  to iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
types STRING STRING PROD POW { " iSeq" " INT INT PROD POW" |-> , }  ∪ to types
1085 " iSet := {ii := 1 ▯ ii := 2 ♢ ii * 2}" Pinstruction " INT { <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> }  to iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
types STRING STRING PROD POW { " iSeq" " INT INT PROD POW" |-> , }  ∪ to types
1086 " iSeq := (ii := 1 ▯ ii := 2 ∇ ii * 2)" Passignment " INT [ <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> ]  to iSeq" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1087 " iSeq :=(ii := 1 ▯ ii := 2 ∇ ii * 2)" Pinstruction " INT [ <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> ]  to iSeq" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1088 " " Pinstruction blankString checkOutput
1089 " " Pskip blankString checkOutput
1090 " SKIP" Pinstruction blankString checkOutput
1091 " SKIP" Pskip blankString checkOutput
1092 " (ii := 123)" PbracketedInstruction " 123 to ii" newline AZ^ checkOutput
1093 " (ii := 123)" Pinstruction " 123 to ii" newline AZ^ checkOutput
1094 " (s1 := “Campbell”)" PbracketedInstruction " Campbell" addQuotes1 "  to s1" newline AZ^ AZ^ checkOutput
1095 " (s1 := “Campbell”)" Pinstruction " Campbell" addQuotes1 "  to s1" newline AZ^ AZ^ checkOutput
1096 " (pair := 123 ↦ “Campbell”)" PbracketedInstruction " 123 " " Campbell" addQuotes1
"  |->I,$ to pair" newline AZ^ AZ^ AZ^ checkOutput
1097 " (pair := 123 ↦ “Campbell”)" Pinstruction " 123 " " Campbell" addQuotes1
"  |->I,$ to pair" newline AZ^ AZ^ AZ^ checkOutput
1098 " (iArr := ARRAY[99, 100, 101])" PbracketedInstruction " HERE 3 , 99 , 100 , 101 ,  to iArr"
newline AZ^ checkOutput
1099 " (iArr := ARRAY[99, 100, 101])" Pinstruction " HERE 3 , 99 , 100 , 101 ,  to iArr"
newline AZ^ checkOutput
1100 " (iArr[2] := 999)" PbracketedInstruction " 999 to  << 2 >> of iArr" newline AZ^ checkOutput
1101 " (iArr[2] := 999)" Pinstruction " 999 to  << 2 >> of iArr" newline AZ^ checkOutput
1102 " (iSet := {1, 2, 3})" PbracketedInstruction " INT { 1 , 2 , 3 , } to iSet" newline AZ^ checkOutput
1103 " (iSet := {1, 2, 3})" Pinstruction " INT { 1 , 2 , 3 , } to iSet" newline AZ^ checkOutput
1104 " (PRINT ii)" PbracketedInstruction " ii . " newline AZ^ checkOutput
1105 " (PRINT ii)" Pinstruction " ii . " newline AZ^ checkOutput
1106 " (PRINT 1 + 2 * 3)" PbracketedInstruction " 1 2 3 * + . " newline AZ^ checkOutput
1107 " (PRINT 1 + 2 * 3)" Pinstruction " 1 2 3 * + . " newline AZ^ checkOutput
1108 " (PRINT “Campbell” )" PbracketedInstruction " Campbell" addQuotes1 "  .AZ " newline AZ^ AZ^ checkOutput
1109 " (PRINT “Campbell” )" Pinstruction " Campbell" addQuotes1 "  .AZ " newline AZ^ AZ^ checkOutput
1110 " (PRINT “Campbell” ↦ “Ruth”)" PbracketedInstruction " Campbell" addQuotes1 sSpace
" Ruth" addQuotes1 "  |->$,$ .PAIR " newline AZ^ AZ^ AZ^ AZ^ checkOutput
1111 " (PRINT “Campbell” ↦ “Ruth”)" Pinstruction " Campbell" addQuotes1 sSpace
" Ruth" addQuotes1 "  |->$,$ .PAIR " newline AZ^ AZ^ AZ^ AZ^ checkOutput
1112 " (PRINT ii > jj)" PbracketedInstruction " ii jj > booleanPrint " newline AZ^ checkOutput
1113 " (PRINT ii > jj)" Pinstruction " ii jj > booleanPrint " newline AZ^ checkOutput
1114 " (PRINT 1.2 + 0.000234 * 3.45e67)" PbracketedInstruction " 1.2 0.000234 3.45e67 F* F+ F."
newline AZ^ checkOutput
1115 " (PRINT 1.2 + 0.000234 * 3.45e67)" Pinstruction " 1.2 0.000234 3.45e67 F* F+ F."
newline AZ^ checkOutput
1116 " (IF b THEN PRINT “Campbell” END)" PbracketedInstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1117 " (IF b THEN PRINT “Campbell” END)" Pinstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1118 " (IF b THEN PRINT “Campbell” ELSE PRINT “Ruth” END)" PbracketedInstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " ELSE"
newline " Ruth" addQuotes1 "  .AZ " newline newline  " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1119 " (IF b THEN PRINT “Campbell” ELSE PRINT “Ruth” END)" Pinstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " ELSE"
newline " Ruth" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1120 " (IF i < 3 THEN jj := 4 END)" PbracketedInstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1121 " (IF i < 3 THEN jj := 4 END)" Pinstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1122 " (IF i < 3 THEN jj := 4 ELSE jj := jj - 1 END)" PbracketedInstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " ELSE" newline " jj 1 - to jj" newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1123 " (IF i < 3 THEN jj := 4 ELSE jj := jj - 1 END)" Pinstruction " i 3 <" newline
" IF" newline " 4 to jj" newline newline " ELSE" newline " jj 1 - to jj" newline
newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1124 " (WHILE jj < 3 DO jj := jj + 1 END)" PbracketedInstruction " BEGIN" newline " jj 3 <" newline
" WHILE" newline " jj 1 + to jj" newline newline " REPEAT" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
checkOutput
1125 " (WHILE jj < 3 DO jj := jj + 1 END)" Pinstruction " BEGIN" newline " jj 3 <" newline
" WHILE" newline " jj 1 + to jj" newline newline " REPEAT" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
checkOutput
types STRING STRING PROD { " bb" boolean |-> , } ∪ to types
STRING STRING PROD { } to locals
1126 " (bb := ∀i2 • i2 ∈ iSet ⇒ i2 < 3  )" Pinstruction " INT { <COLLECT" newline
"     iSet CHOICE to i2 i2 3 < NOT --> 0" newline " TILL CARD SATISFIED> } CARD 0="
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1127 " (   bb := ∀i3 • i3 ∈ iSet ⇒ i3 < 3  )" PbracketedInstruction " INT { <COLLECT"
newline "     iSet CHOICE to i3 i3 3 < NOT --> 0" newline " TILL CARD SATISFIED> } CARD 0="
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1128 " (bb := ∃i4 • i4 ∈ iSet ∧ i4 < 3  )" Pinstruction " INT { <COLLECT" newline
"     iSet CHOICE to i4 i4 3 < --> 0" newline " TILL CARD SATISFIED> } CARD 0 <>"
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1129 " bb := ∃i5 • i5 ∈ iSet ∧ i5 < 3  " PbracketedInstruction " INT { <COLLECT" newline
"     iSet CHOICE to i5 i5 3 < --> 0" newline " TILL CARD SATISFIED> } CARD 0 <>"
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1130 " (ii := 1 ▯ ii := 2)" PbracketedInstruction " <CHOICE" newline " 1 to ii" newline
"  [] 2 to ii" newline "  CHOICE>" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1131 " (ii := 1 ▯ ii := 2)" Pinstruction " <CHOICE" newline " 1 to ii" newline
"  [] 2 to ii" newline "  CHOICE>" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
STRING STRING PROD { } to locals
1132 " (iSet := {ii := 1 ▯ ii := 2 ♢ ii * 2})" PbracketedInstruction " INT { <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> }  to iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
types STRING STRING PROD POW { " iSeq" " INT INT PROD POW" |-> , }  ∪ to types
1133 " (iSet := {ii := 1 ▯ ii := 2 ♢ ii * 2})" Pinstruction " INT { <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> }  to iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1134 " iSeq := (ii := 1 ▯ ii := 2 ∇ ii * 2)" PbracketedInstruction " INT [ <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> ]  to iSeq" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1135 " iSeq := (ii := 1 ▯ ii := 2 ∇ ii * 2)" Pinstruction " INT [ <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline " ] " DROP
" ii 2 * RUN> ]  to iSeq" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1136 " " PmultipleInstruction blankString checkOutput
1137 " SKIP" PmultipleInstruction blankString checkOutput
1138 " ii := 123" PmultipleInstruction " 123 to ii" newline AZ^ checkOutput
1139 " s1 := “Campbell”" PmultipleInstruction " Campbell" addQuotes1 "  to s1" newline AZ^ AZ^ checkOutput
1140 " iArr := ARRAY[99, 100, 101]" PmultipleInstruction " HERE 3 , 99 , 100 , 101 ,  to iArr"
newline AZ^ checkOutput
1141 " iArr[2] := 999" PmultipleInstruction " 999 to  << 2 >> of iArr" newline AZ^ checkOutput
1142 " iSet := {1, 2, 3}" PmultipleInstruction " INT { 1 , 2 , 3 , } to iSet" newline AZ^ checkOutput
1143 " PRINT ii" PmultipleInstruction " ii . " newline AZ^ checkOutput
1144 " PRINT 1 + 2 * 3" PmultipleInstruction " 1 2 3 * + . " newline AZ^ checkOutput
1145 " PRINT “Campbell” " PmultipleInstruction " Campbell" addQuotes1 "  .AZ " newline AZ^ AZ^ checkOutput
1146 " PRINT “Campbell” ↦ “Ruth”" PmultipleInstruction " Campbell" addQuotes1 sSpace
" Ruth" addQuotes1 "  |->$,$ .PAIR " newline AZ^ AZ^ AZ^ AZ^ checkOutput
1147 " PRINT ii > jj" PmultipleInstruction " ii jj > booleanPrint " newline AZ^ checkOutput
1148 " PRINT 1.2 + 0.000234 * 3.45e67" PmultipleInstruction " 1.2 0.000234 3.45e67 F* F+ F."
newline AZ^ checkOutput
1149 " IF b THEN PRINT “Campbell” END" PmultipleInstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1150 " IF b THEN PRINT “Campbell” ELSE PRINT “Ruth” END" PmultipleInstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " ELSE"
newline " Ruth" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1151 " IF i < 3 THEN jj := 4 END" PmultipleInstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1152 " IF i < 3 THEN jj := 4 ELSE jj := jj - 1 END" PmultipleInstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " ELSE" newline " jj 1 - to jj" newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1153 " WHILE jj < 3 DO jj := jj + 1 END" PmultipleInstruction " BEGIN" newline " jj 3 <" newline
" WHILE" newline " jj 1 + to jj" newline newline " REPEAT" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
checkOutput
1154 " bb := ∀i6 • i6 ∈ iSet ⇒ i6 < 3  " Pinstruction " INT { <COLLECT" newline
"     iSet CHOICE to i6 i6 3 < NOT --> 0" newline " TILL CARD SATISFIED> } CARD 0="
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1155 " bb := ∃i7 • i7 ∈ iSet ∧ i7 < 3  " Passignment " INT { <COLLECT" newline
"     iSet CHOICE to i7 i7 3 < --> 0" newline " TILL CARD SATISFIED> } CARD 0 <>"
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1156 " ii := 1 ▯ ii := 2" PmultipleInstruction " <CHOICE" newline " 1 to ii" newline
"  [] 2 to ii" newline "  CHOICE>" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1157 " iSeq := (ii := 1 ▯ ii := 2 ∇ ii * 2)" Passignment " INT [ <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> ]  to iSeq" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1158 " ;" PmultipleInstruction newline newline AZ^ checkOutput
1159 " SKIP" PmultipleInstruction blankString checkOutput
1160 " ii := 123" Passignment " 123 to ii" newline AZ^ checkOutput
1161 " ii := 123" Pinstruction " 123 to ii" newline AZ^ checkOutput
1162 " s1 := “Campbell”" Passignment " Campbell" addQuotes1 "  to s1" newline AZ^ AZ^ checkOutput
1163 " s1 := “Campbell”" Pinstruction " Campbell" addQuotes1 "  to s1" newline AZ^ AZ^ checkOutput
1164 " pair := 123 ↦ “Campbell”" Passignment " 123 " " Campbell" addQuotes1
"  |->I,$ to pair" newline AZ^ AZ^ AZ^ checkOutput
1165 " pair := 123 ↦ “Campbell”" Pinstruction " 123 " " Campbell" addQuotes1
"  |->I,$ to pair" newline AZ^ AZ^ AZ^ checkOutput
1166 " iArr := ARRAY[99, 100, 101]" Passignment " HERE 3 , 99 , 100 , 101 ,  to iArr"
newline AZ^ checkOutput
1167 " iArr := ARRAY[99, 100, 101]" Pinstruction " HERE 3 , 99 , 100 , 101 ,  to iArr"
newline AZ^ checkOutput
1168 " iArr[2] := 999" Passignment " 999 to  << 2 >> of iArr" newline AZ^ checkOutput
1169 " iArr[2] := 999" Pinstruction " 999 to  << 2 >> of iArr" newline AZ^ checkOutput
1170 " iSet := {1, 2, 3}" Passignment " INT { 1 , 2 , 3 , } to iSet" newline AZ^ checkOutput
1171 " iSet := {1, 2, 3}" Pinstruction " INT { 1 , 2 , 3 , } to iSet" newline AZ^ checkOutput
1172 " PRINT ii" Pprint " ii . " newline AZ^ checkOutput
1173 " PRINT ii" Pinstruction " ii . " newline AZ^ checkOutput
1174 " PRINT 1 + 2 * 3" Pprint " 1 2 3 * + . " newline AZ^ checkOutput
1175 " PRINT 1 + 2 * 3" Pinstruction " 1 2 3 * + . " newline AZ^ checkOutput
1176 " PRINT “Campbell” " Pprint " Campbell" addQuotes1 "  .AZ " newline AZ^ AZ^ checkOutput
1177 " PRINT “Campbell” " Pinstruction " Campbell" addQuotes1 "  .AZ " newline AZ^ AZ^ checkOutput
1178 " PRINT “Campbell” ↦ “Ruth”" Pprint " Campbell" addQuotes1 sSpace
" Ruth" addQuotes1 "  |->$,$ .PAIR " newline AZ^ AZ^ AZ^ AZ^ checkOutput
1179 " PRINT “Campbell” ↦ “Ruth”" Pinstruction " Campbell" addQuotes1 sSpace
" Ruth" addQuotes1 "  |->$,$ .PAIR " newline AZ^ AZ^ AZ^ AZ^ checkOutput
1180 " PRINT ii > jj" Pprint " ii jj > booleanPrint " newline AZ^ checkOutput
1181 " PRINT ii > jj" Pinstruction " ii jj > booleanPrint " newline AZ^ checkOutput
1182 " PRINT 1.2 + 0.000234 * 3.45e67" Pprint " 1.2 0.000234 3.45e67 F* F+ F."
newline AZ^ checkOutput
1183 " PRINT 1.2 + 0.000234 * 3.45e67" Pinstruction " 1.2 0.000234 3.45e67 F* F+ F."
newline AZ^ checkOutput
1184 " IF b THEN PRINT “Campbell” END" Pselection
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1185 " IF b THEN PRINT “Campbell” END" Pinstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1186 " IF b THEN PRINT “Campbell” ELSE PRINT “Ruth” END" Pselection
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " ELSE"
newline " Ruth" addQuotes1 "  .AZ " newline newline  " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1187 " IF b THEN PRINT “Campbell” ELSE PRINT “Ruth” END" Pinstruction
" b" newline " IF" newline " Campbell" addQuotes1 "  .AZ " newline newline " ELSE"
newline " Ruth" addQuotes1 "  .AZ " newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1188 " IF i < 3 THEN jj := 4 END" Pselection " i 3 <" newline " IF" newline
" 4 to jj" newline newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1189 " IF i < 3 THEN jj := 4 END" Pinstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " THEN" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1190 " IF i < 3 THEN jj := 4 ELSE jj := jj - 1 END" Pselection " i 3 <" newline " IF" newline
" 4 to jj" newline newline " ELSE" newline " jj 1 - to jj" newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1191 " IF i < 3 THEN jj := 4 ELSE jj := jj - 1 END" Pinstruction " i 3 <" newline " IF" newline
" 4 to jj" newline newline " ELSE" newline " jj 1 - to jj" newline newline " THEN"
AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1192 " WHILE jj < 3 DO jj := jj + 1 END" Ploop " BEGIN" newline " jj 3 <" newline
" WHILE" newline " jj 1 + to jj" newline newline " REPEAT" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
checkOutput
1193 " WHILE jj < 3 DO jj := jj + 1 END" Pinstruction " BEGIN" newline " jj 3 <" newline
" WHILE" newline " jj 1 + to jj" newline newline " REPEAT" AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^
checkOutput
types STRING STRING PROD { " bb" boolean |-> , } ∪ to types
1194 " bb := ∀i2 • i2 ∈ iSet ⇒ i2 < 3  " Pinstruction " INT { <COLLECT" newline
"     iSet CHOICE to i2 i2 3 < NOT --> 0" newline " TILL CARD SATISFIED> } CARD 0="
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1195 " bb := ∀i3 • i3 ∈ iSet ⇒ i3 < 3  " Passignment " INT { <COLLECT" newline
"     iSet CHOICE to i3 i3 3 < NOT --> 0" newline " TILL CARD SATISFIED> } CARD 0="
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1196 " bb := ∃i4 • i4 ∈ iSet ∧ i4 < 3  " Pinstruction " INT { <COLLECT" newline
"     iSet CHOICE to i4 i4 3 < --> 0" newline " TILL CARD SATISFIED> } CARD 0 <>"
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1197 " bb := ∃i5 • i5 ∈ iSet ∧ i5 < 3  " Passignment " INT { <COLLECT" newline
"     iSet CHOICE to i5 i5 3 < --> 0" newline " TILL CARD SATISFIED> } CARD 0 <>"
newline "  to bb" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1198 " ii := 1 ▯ ii := 2" Pchoice " <CHOICE" newline " 1 to ii" newline
"  [] 2 to ii" newline "  CHOICE>" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1199 " iSet := {ii := 1 ▯ ii := 2 ♢ ii * 2}" Passignment " INT { <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> }  to iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
types STRING STRING PROD POW { " iSeq" " INT INT PROD POW" |-> , }  ∪ to types
1200 " iSet := {ii := 1 ▯ ii := 2 ♢ ii * 2}" Pinstruction " INT { <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> }  to iSet" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
types STRING STRING PROD POW { " iSeq" " INT INT PROD POW" |-> , }  ∪ to types
1201 " iSeq := (ii := 1 ▯ ii := 2 ∇ ii * 2)" Passignment " INT [ <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> ]  to iSeq" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1202 " iSeq := (ii := 1 ▯ ii := 2 ∇ ii * 2)" Pinstruction " INT [ <RUN <CHOICE"
newline " 1 to ii" newline "  [] 2 to ii" newline "  CHOICE>" newline
" ii 2 * RUN> ]  to iSeq" newline AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ checkOutput
1203 " " Pinstruction blankString checkOutput
1204 " " Pskip blankString checkOutput
1205 " SKIP" PmultipleInstruction blankString checkOutput
1206 " SKIP" Pskip blankString checkOutput
1207 " 1 + 2 * 3 % 4" Pexpression " 1 2 3 * 4 % +" int checkOutputAndType
1208 " 1 + 2 * 3 % 4" Parith " 1 2 3 * 4 % +" int checkOutputAndType
1209 " i2 := 1 + 2 * 3 % 4" Pinstruction " 1 2 3 * 4 % + to i2" AZN^ checkOutput
1212 " i2 := 1 + 2 * 3 % 4" Passignment " 1 2 3 * 4 % + to i2" AZN^ checkOutput
1213 " i2 := 1 + 2 * 3 % 4" PmultipleInstruction " 1 2 3 * 4 % + to i2" AZN^ checkOutput
1214 " i2 := 87 + 65 * 43 % 21" Passignment " 87 65 43 * 21 % + to i2" AZN^ checkOutput
1215 " i2 := 87 + 65 * 43 % 21" Pinstruction " 87 65 43 * 21 % + to i2" AZN^ checkOutput
1216 " (i2 := i; ii := i)  ▯ (i2 := i + 1; ii := i + 1); PRINT i2 + ii" PmultipleInstruction
" <CHOICE" AZN^ " i to i2" AZN^^ AZN^ " i to ii" AZN^^ AZN^ "  [] i 1 + to i2" AZN^^ AZN^
" i 1 + to ii" AZN^^ AZN^ "  CHOICE>" AZN^^ AZN^ " i2 ii + . " AZN^^ AZN^ checkOutput
1217 " i2 := i; ii := i ▯ i2 := i + 1; ii := i + 1; PRINT i2 + ii" PmultipleInstruction
" i to i2" AZN^ AZN^ " <CHOICE" AZN^^ " i to ii" AZN^^ "  [] i 1 + to i2" AZN^^
"  CHOICE>" AZN^ AZN^^ " i 1 + to ii" AZN^^ AZN^ " i2 ii + . " AZN^^ AZN^ AZN^ AZN^
checkOutput
1218 " ii := 123; ii < 100 → PRINT ii" PmultipleInstruction " 123 to ii" AZN^ AZN^
" ii 100 < --> ii . " AZN^^ AZN^ AZN^ checkOutput
1219 " ii := 123; ii < 100 → PRINT ii ▯ PRINT “Campbell”" PmultipleInstruction
" 123 to ii" AZN^ AZN^ " <CHOICE" AZN^^
" ii 100 < --> ii . " AZN^^ AZN^ "  [] " AZ^ " Campbell" addQuotes1 "  .AZ " AZ^
AZN^^ "  CHOICE>" AZN^^ AZN^ checkOutput
1220 " ii := 2 ▯ ii := 3" Pchoice " <CHOICE" AZN^ " 2 to ii" AZN^^ "  [] 3 to ii"
AZN^^ "  CHOICE>" AZN^^ checkOutput
1221 " ii := 2 ▯ ii := 3" PmultipleInstruction " <CHOICE" AZN^ " 2 to ii" AZN^^
"  [] 3 to ii" AZN^^ "  CHOICE>" AZN^^ checkOutput
1222 " ii < 3 → ii := 4" Pguard " ii 3 < --> 4 to ii" AZN^ AZN^ checkOutput
1223 " ii < 3 → ii := 4" Pchoice " ii 3 < --> 4 to ii" AZN^ AZN^ checkOutput
1224 " ii < 3 → ii := 4" PmultipleInstruction " ii 3 < --> 4 to ii" AZN^ AZN^ checkOutput
L functions.fth ( may be redundant )
STRING STRING PROD { " factorial" " INT # INT" |->$,$ , } to types
1225 " jj INT ← factorial(i INT) ≙ IF i = 0 THEN jj := 1 ELSE jj := i * factorial(i - 1) END END"
Poperation " : factorial (: i :)" AZN^ " 0 VALUE jj" AZN^^ " i 0 =" AZN^^ " IF" AZN^^
" 1 to jj" AZN^ AZN^^ " ELSE" AZN^^ " i i 1 - RECURSE * to jj" AZN^ AZN^^ " THEN" AZN^^
" jj" AZN^^ " ;" AZN^^ checkOutput

" HereEndethThe6thTestFile." CR .AZ CR
