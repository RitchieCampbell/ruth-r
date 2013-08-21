STRING STRING PROD { } to locals ( to be removed later )

: test-form-for-identifier ( s -- s )
(
    If identifier starts with a letter and is all alphanumeric, returns argument
    unchanged. Otherwise error message. Also error if a keyword passed.
)
noWSpace
DUP keywords IN IF
    ." Keyword " .AZ ."  used out of correct context." ABORT
THEN
DUP letter stringbegins? OVER alphanumeric stringconsists? AND NOT
IF
    ." Incorrect format for identifier:" 10 EMIT
    ." must begin with letter and contain only letters and numbers: " 10 EMIT
    .AZ ."  passed." ABORT
THEN ;

: Psinglereturnvalue ( s -- )
(
    Where s is in the form "i INT". Adds "i " onto operationEnd, "i ↦ INT" to
    the "locals" relation, "0 VALUE i" to operationDeclarations and "INT" to
    operationBody. After several passes operationEnd might be "i s " and
    operationBody "INT STRING".
)
wSpaceSplit noWSpace Parraytypeforvariables noWSpace
( "i" "INT" or "set" "INT POW" or "iArray" "INT ARRAY" )
OVER locals DOM IN
IF
    ." Local variable " SWAP .AZ ."  declared twice: here return value." ABORT
THEN
SWAP test-form-for-identifier ( "INT" "i" )
SWAP operationType sSpace AZ^ OVER AZ^ to operationType SWAP
( ↑ Add space + 2nd value to operationType. )
operationEnd sSpace AZ^ OVER AZ^ to operationEnd ( ""→"i " or "s"→"s i " )
typeValue OVER AZ^ newline AZ^ operationDeclarations AZ^ to operationDeclarations
OVER operationBody sSpace AZ^ SWAP AZ^ to operationBody
SWAP STRING STRING PROD { ↦ , } locals ∪ to locals
;

: Preturnvalues ( s -- )
(
    Where s is like "i INT, s STRING" and operationDeclarations
    "0 VALUE i 0 VALUE s" or similar, operationEnd "s i ;" and operationBody
    = output type part "INT STRING". Note opposite order.
    The catenation is done by Psinglereturnvalue.
)
comma rsplit
IF ( "i INT" "s STRING": "," removed )
    SWAP Psinglereturnvalue RECURSE
ELSE    ( "i INT" null: null removed )
    DROP Psinglereturnvalue
THEN
;

: Psingleparameter ( s -- )
(
    Where s is in the form "i INT" and s1 "0 VALUE i". Also adds "i ↦ INT" to
    the "locals" relation. Adds "i" to operationStack and "INT" to
    operationInputs.
)
wSpaceSplit noWSpace Parraytypeforvariables noWSpace
( "i" "INT" or "set" "INT POW" or "iArr" "INT ARRAY" )
OVER locals DOM IN
IF
    ." Local variable " SWAP .AZ ."  declared twice: here as input parameter."
    ABORT
THEN
SWAP test-form-for-identifier ( "INT" "i" )
operationStack sSpace
AZ^ OVER AZ^ to operationStack
SWAP operationInputs sSpace AZ^ OVER AZ^ to operationInputs
STRING STRING PROD { ↦ , } locals ∪ to locals
;

: Pparameters ( s -- )
(
    Splits on comma as if comma associated to the right, using Psingleparameter
    on the left and recursing on the right. Psingleparameter does the
    catenating.
    Where s is in the form "i INT, s STRING" or similar. Leaves "INT STRING" as
    operationInputs, "i s" as operationStack, which needs be completed later
    with (: :)
)
comma rsplit
IF ( "i INT" "s STRING" )
    SWAP Psingleparameter RECURSE
ELSE
    DROP Psingleparameter
THEN
;

: Plocalvariable ( s -- )
(
    Similar to Pvariable. Parses a single local variable, where s is a string in
    the form "i INT" and checks that the type is valid and the identifier has
    not already been used as a local, and throws error message in that case.
    Otherwise adds "0 VALUE i" to operationDeclarations and "i ↦ INT" to the
    locals relation.
)
wSpaceSplit            ( "i" "INT" )
noWSpace SWAP noWSpace SWAP
OVER test-form-for-identifier        ( "i" "INT" "i" )
locals DOM IN
IF
    ." Local variable " SWAP .AZ ."  already declared as local variable or " CR
    ." parameter." ABORT
THEN        ( "i" "INT" )
Parraytypeforvariables
OVER SWAP noWSpace STRING STRING PROD { ↦ , } locals ∪ to locals
typeValue SWAP newline AZ^ AZ^
operationDeclarations SWAP AZ^ to operationDeclarations
;

: Plocalvariableslist ( s -- )
(
    Does parsing similar to Pvariableslist.
    Where s is a string of code from which the keywords VARIABLES and END at
    start and end have been removed, leaving a comma-separated list, eg
    "i INT, s STRING, set ℙ(STRING ↦ INT), and uses the Plocalvariable parser
    to add "0 VALUE i 0 VALUE s 0 VALUE set" with newlines to
    operationDeclarations and "i ↦ INT, s ↦ STRING, set ↦ STRING INT PROD POW"
    to the locals relation.
)
comma rsplit
IF  ( Found , so L = single variable, R = shorter list )
    SWAP Plocalvariable RECURSE
ELSE    ( No comma, so single variable in list )
    DROP Plocalvariable
THEN
;

: Poperationheader ( s -- )
(
    Where s is in the form "i INT, s STRING ← foo (f FLOAT, b BOO)" and splits
    on the ← passing "i INT, s STRING" to Preturnvalues and "f FLOAT, b BOO" to
    Pparameters. Passes foo to operationName.
    Adds operationInputs # to operationBody and completes operationStack with
    (: :)
)
returnSeq rsplit
IF ( "i INT, s STRING ← foo (f FLOAT, b BOO)" if not = no return values )
    SWAP Preturnvalues      ( Return values to global variable )
ELSE
    DROP                    ( No return values, so lose that bit )
THEN                        ( Awkward way to split on brackets )
DUP [CHAR] ( stringcontainschar?
IF
    DUP CLONE-STRING DUP [CHAR] ( first-character 0 SWAP C!
    SWAP OVER myAZLength +
    [CHAR] ( [CHAR] ) bracketRemover2 Pparameters
THEN
noWSpace test-form-for-identifier to operationName
newline operationEnd -blanks AZ^ newline " ;" newline AZ^ AZ^ AZ^ to operationEnd
( Consider whether you always need a # in the middle of operation type )
operationInputs -blanks "  #" operationBody AZ^ AZ^ to operationInputs
;

: Poperation
(
    split on ≙ left to Poperationheader, right to Plocalvariablelist and
    PmultipleInstruction, then add ": " operationName operationStack
    operationDeclarations stack contents and operationEnd, leave whole
    operation on stack for future catenation.
    Example:
    " i INT, s STRING ← foo(f FLOAT, b BOO) ≙ VARIABLES x INT END
    x := 3; IF f > x THEN s := “Campbell” ELSE s := “Ruth” END;
    IF b THEN i := i + x ELSE i := i - x END END"
    →
    : foo (: f b :) 0 VALUE x 3 to x
    f 3 S>F F> IF "Campbell" to s ELSE "Ruth" to s THEN
    b IF i x + to i ELSE i x - to i THEN i s ;
    Which will have a type error, trying to assign a FLOAT to an INT!
)
blankString to operationEnd
blankString to operationInputs
blankString to operationBody
blankString to operationStack
blankString to operationName
blankString to operationDeclarations
STRING STRING PROD { } to locals ( Empty the "locals" relation )
defSeq rsplit 0=
IF
    ." Operation without ≙ " ABORT
THEN
SWAP Poperationheader
-wspace variables OVER prefix? OVER variables whitespace followed-by? AND
IF
    endString rSplitForKeywords 0=
    IF
        ." VARIABLES without END error." ABORT
    THEN
    SWAP variables decapitate Plocalvariableslist
THEN
locals CARD
IF
    " (:" operationStack "  :)" AZ^ AZN^^ to operationStack
THEN
( Put this operation's type into the types relation, so it can be called later )
STRING STRING PROD { operationName operationInputs ↦ , } types ∪ to types
PmultipleInstruction
operationEnd -blanks AZ^
operationDeclarations SWAP AZ^
operationStack SWAP AZ^
" : " operationName sSpace AZ^ AZ^ SWAP AZ^ doubleLineRemover AZN^
;

: Pmultipleoperations ( s -- s1 ) 
sequence startKeywords2 endKeywords rsplitForBlocks 
IF
    SWAP noWSpace endString truncate Poperation SWAP RECURSE AZ^ 
ELSE 
    DROP Poperation "  CR " operationName AZ^ "  CR" AZ^ AZN^^
THEN
;

: Pprogram ( s -- s2 )
(
    Calls Pconstants, Pvariables and Pmultipleoperations in turn as required.
    Beware: any pre-existing values on the stack should be removed before using
    this word, otherwise it will attempt to catenate them to the output, with
    undefined results.
)
STRING { } to constants STRING STRING PROD { } to types ( relations emptied )
(
    If you ever use library routines, they would need to have their types added
    back to types: example
    : divMod ( i j -- iMODj i÷j ) /MOD ; 
    STRING STRING PROD { " divMod" " INT INT # INT INT" |->$,$ , } types ∪ to
        types
)
-wspace
constantsString OVER prefix? OVER constantsString whitespace followed-by? AND
IF
    endString rSplitForKeywords
    IF
        PUSH Pconstants POP
    ELSE
        ." CONSTANTS without END error." ABORT
    THEN
THEN  
-wspace variables OVER prefix? OVER variables whitespace followed-by? AND
IF 
    endString rSplitForKeywords
    IF
        PUSH Pvariables POP
    ELSE
        ." VARIABLES without END error." ABORT
    THEN
THEN
Pmultipleoperations 
BEGIN
    DEPTH 1 >
WHILE
    AZ^
REPEAT ;

(
    What follows is copied-and-pasted from the f2s.r file
)
: READ-WHOLE ( s -- addr u )
( open the file named in counted string s )
( read the entire file into memory at addr, )
( leaving addr and the no. of bytes read. )
( buffer will be terminated with 0 byte so that )
( addr is also an ascii string )
  COUNT R/O OPEN-FILE
  ABORT" Unable to open file"
  DUP ( fileid fileid ) FILE-SIZE
  ABORT" Unable to get file size"
  ( fileid size )
  ( now allocvating space for file buffer, with an extra byte )
  DUP 1+ ALLOCATE ( fileid size buff err)
  ABORT" memory allocation failure"
  3FRAME 
  ( ARG1 = fileid, ARG2 = size, ARG3 = buff )
    ARG3@ ARG2@ ARG1@ READ-FILE
  ( write a zero to the extra byte allocated at end of buffer )
    0 ARG3@ ARG2@ + C!
    ABORT" Error reading file"
    ARG3@ SWAP 
  2LEAVE ;

: F2AZ ( -- az, parse following file name and leave file contents as az string )
  BL WORD READ-WHOLE DROP ;

( testing, 
0 VALUE MYFILE

F2AZ f2s.r to MYFILE  ( CR KEY DROP   MYFILE .AZ )
F2AZ sendMoreMoney.ru DUP .AZ Pprogram doubleLineRemover CR .AZ
)
  
