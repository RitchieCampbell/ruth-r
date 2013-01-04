: reportParserError ( i s1 s2 s3 -- ) 
( Prints an error message s1 is expected result, s2 found, s3 kind, line No i ) 
CR .AZ 
."  error: Found:" SWAP CR .AZ ."  when expecting:" CR .AZ ."  at test No " . 
;

: checkOutputAndType ( i s1 s2 s3 s4 -- ) 
( i=line number. Error message if s1/s3 and s2/s4 are not identical pairs ) 
ROT 2DUP string-eq 
IF 
    2DROP 
ELSE 
    PUSH PUSH ROT DUP PUSH ROT ROT POP POP POP " Type" reportParserError 
THEN 
2DUP string-eq 
IF 
    DROP 2DROP 
ELSE 
    " Output" reportParserError 
THEN 
;

( The tests follow. )
401 " ({“Campbell”} ∪ {“Andy”}) ◁- {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" Pexpression
SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^
" Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1
AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor"
addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
402 " ({“Campbell”} ∪ {“Andy”}) ◁- ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})"
PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { "
AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy"
addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^
" Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
403 " ({“Campbell”} ∪ {“Andy”}) ◁- ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})"
PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^
" , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^
"  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^
" Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
404 " ({“Campbell”} ∪ {“Andy”}) ◁ {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}"
PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^
" , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^
"  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^
" Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
405 " ({“Campbell”} ∪ {“Andy”}) ◁ ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})"
PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy"
addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^
" John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^
"  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor"
addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
406 " ({“Campbell”} ∪ {“Andy”}) ◁- {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}"
PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy"
addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^
" John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^
"  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor"
addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
407 " ({“Campbell”} ∪ {“Andy”}) ◁- ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})"
PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy"
addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^
" John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^
"  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor"
addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
408 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ({“Sarah”} ∪ {“Eleanor”})"
PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1
AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
409 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})"
PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1
AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
410 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ({“Sarah”} ∪ {“Eleanor”})"
Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
411 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})"
Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
412 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ({“Sarah”} ∪ {“Eleanor”})"
PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
413 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})"
PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
414 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}▷ ({“Sarah”} ∪ {“Eleanor”})"
PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
415 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})"
PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
416 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})"
PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1
AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
417 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})"
PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1
AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
418 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})"
Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
419 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})"
Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
420 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})"
PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
421 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})"
PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
422 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})"
PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
423 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})"
PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^
"  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah"
addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1
AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor"
addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
424 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
425 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedExp SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
426 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
427 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
428 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedExp SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
429 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷ ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
430 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah"
addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah"
addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW"
checkOutputAndType
431 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
432 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷- ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
433 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷- ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedExp SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
434 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷- ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
435 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷- ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
436 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷- ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedExp SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
437 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷- ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^
" , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
438 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷- ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah"
addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah"
addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW"
checkOutputAndType
439 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷- ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah"
addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah"
addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " INT STRING PROD POW"
checkOutputAndType
440 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda”" PrangeRestrictedSeq SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
441 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda”" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
442 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda”" Pexpression SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
443 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda”" PrangeRestrictedSeq SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
444 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda”" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
445 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda”" Pexpression SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
446 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”] ← “Linda”" PrangeRestrictedSeq SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
447 " (([“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”])) ← “Linda”" Pexpression SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
448 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedSeq SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↓" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
449 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedExp SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↓" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
450 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↓ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↓" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
451 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedSeq SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^
" ← 3 2 * 1 - ↓" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
452 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedExp SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^
" ← 3 2 * 1 - ↓" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
453 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↓ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↓" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
455 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”] ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedSeq SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↓" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
455 " (([“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”])) ← “Linda” ↑ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
456 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedSeq SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
457 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedExp SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
458 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↑ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
459 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedSeq SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^
" ← 3 2 * 1 - ↑" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
460 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedExp SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^
" ← 3 2 * 1 - ↑" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
461 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↑ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
462 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”] ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedSeq SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
463 " (([“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”])) ← “Linda” ↑ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
464 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda”" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
465 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda”" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
466 " (([“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”])) ← “Linda”" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ←" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
467 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedSet SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↓" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
468 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^
" ← 3 2 * 1 - ↓" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
469 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”] ← “Linda” ↓ 3 * 2 - 1" PrangeRestrictedSet SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↓" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
470 " (([“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”])) ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah"
addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1
AZ^ " ← 3 2 * 1 - ↑" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
471 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedSet SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
472 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ← “Linda” ↑ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover SWAP
" STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
473 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedSet SWAP
doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1
AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^
" ← 3 2 * 1 - ↑" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
474 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”]) ← “Linda” ↑ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
475 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”] ← “Linda” ↑ 3 * 2 - 1" PrangeRestrictedSeq SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
476 " (([“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”])) ← “Linda” ↑ 3 * 2 - 1" Pexpression SWAP doubleSpaceRemover
SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^
" Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] " AZ^ " Linda" addQuotes1 AZ^ " ← 3 2 * 1 - ↑" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
477 " [1, 2, 3]" Psequence " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 478 " [1, 2, 3]" Pexpression " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 479 " [1, 2, 3]" Pset " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 480 " (( [((1)), 2, 3]))" Psequence " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 481 " (( [((1)), 2, 3]))" Pexpression " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 482 " (( [((1)), 2, 3]))" Pset " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 483 " [“Campbell”, “Ruth”, “Sarah”, “Eleanor”]" Psequence " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^
" Ruth" addQuotes1 AZ^ "  , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ]" AZ^
" INT STRING PROD POW" checkOutputAndType " ]
DROP 484 " [“Campbell”, “Ruth”, “Sarah”, “Eleanor”]" Pexpression " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^
" Ruth" addQuotes1 AZ^ "  , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ]" AZ^
" INT STRING PROD POW" checkOutputAndType " ]
DROP 485 " [“Campbell”, “Ruth”, “Sarah”, “Eleanor”]" Pset " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^
" Ruth" addQuotes1 AZ^ "  , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ]" AZ^
" INT STRING PROD POW" checkOutputAndType " ]
DROP 486 " (([((“Campbell”)), “Ruth”, “Sarah”, “Eleanor”]))" Psequence " STRING [ " " Campbell" addQuotes1 AZ^ "  , "
AZ^ " Ruth" addQuotes1 AZ^ "  , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ]" AZ^
" INT STRING PROD POW" checkOutputAndType " ]
DROP 487 " (([((“Campbell”)), “Ruth”, “Sarah”, “Eleanor”]))" Pexpression " STRING [ " " Campbell" addQuotes1 AZ^
"  , " AZ^ " Ruth" addQuotes1 AZ^ "  , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ]"
AZ^ " INT STRING PROD POW" checkOutputAndType " ]
DROP 488 " (([((“Campbell”)), “Ruth”, “Sarah”, “Eleanor”]))" Pset " STRING [ " " Campbell" addQuotes1 AZ^ "  , "
AZ^ " Ruth" addQuotes1 AZ^ "  , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ]" AZ^
" INT STRING PROD POW" checkOutputAndType " ]
DROP
CR " HereEndethThe3rdTestFile" .AZ CR
