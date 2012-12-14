( This document contains the operations for a higher-level language
  Each operation comes in two parts; the part which executes the operation,
  called by the operator with a _ tag, and the part which checks the types
  for that operation. There are a few operations which require no type-
  checking, and a few whose type-checking is too complex to be done in
  one stage.
  These operations all add whitespace between their tokens. The alternative
  approach would have been for the parsers to 
  prepend a space to all their tokens

  The operations, except for unary operators,
  all have the type comment on the next line

 s1 s2 s3 s4 l-operand, l-type, r-operand r-type --
 ss1 ss2 resultant operation string, and type string
)

: >= ( n1 n2 -- f greater or equal ) < NOT
( There is no built-in >= operator ) ; : ≤ <= ; : ≥ >= ; ( Use short forms too )


: ⇒ ( Implication operator: f1 f2 -- f whether f1 ⇒ f2 ) 0= NOT SWAP 0= OR ;
: ⇔ ( Equivalence operator: f1 f2 -- f: whether f1 ⇔ f2 ) 0= SWAP 0= = ;
( There was no built-in implication or equivalence connective )

: ⊂ <<: ;
: ⊄ <<: NOT ;
: ⊆ <: ;
: ⊈ <: NOT ;
( The subset operators were only defined in terms of ASCII characters )

: ⁀ ^ ; ( Duplicate the catenation operator )

: head ( az -- c 1st character of az. ) C@ ;

: tail
( az -- az2 starting with 2nd character. Error message if empty String passed. )
    DUP C@ 0 = IF ." Can't implement tail on empty String." ABORT THEN 1 + ;

: string-eq ( az1 az2 -- f Whether the two Strings are identical )
    BEGIN 2DUP DUP head ROT ROT head SWAP head = AND WHILE
       tail SWAP tail SWAP
    REPEAT
    head 0 = OVER head 0 = AND NIP ;

: endaz ( az -- az2 last "real" character )
    BEGIN DUP head WHILE tail REPEAT 1 - ;

: -blanks ( az -- az2 with leading spaces removed )
    BEGIN DUP head 32 = WHILE tail REPEAT ;
    
: blanks- ( az -- az2 with trailing spaces removed )
    DUP endaz
        BEGIN DUP head 32 = WHILE 1 - REPEAT 1 + 0 SWAP C! ;

: noblanks ( az -- az2 with leading and trailing spaces removed )
    -blanks blanks- ;

: myazlength ( az -- n number of "real" ASCII characters ) 0 BEGIN
    OVER C@ WHILE
        1 + SWAP 1 + SWAP REPEAT
    NIP
;

" true" CONSTANT true
" false" CONSTANT false
" TRUE" CONSTANT True
" FALSE" CONSTANT False
" BOO" CONSTANT boolean ( Can be changed to " BOOLEAN" or " boolean" if required )
" INT" CONSTANT int
" INT " CONSTANT int-space
" FLOAT" CONSTANT float
"  S>F" CONSTANT StoF    ( Note has additional leading space )
" STRING" CONSTANT string
" “" CONSTANT l-quote
" ”" CONSTANT r-quote
"  " CONSTANT sspace ( String containing a single space )
" "  CONSTANT blank-string ( the empty String )
" =" CONSTANT equals
" F=" CONSTANT f-equals
"  --> " CONSTANT guard-string
" .." CONSTANT dots
" 0 VALUE " CONSTANT 0value
" , " CONSTANT comma-space
"  VALUE-ARRAY " CONSTANT value-array
" ♢" CONSTANT diamondString
" ∇" CONSTANT nablaString
0value VALUE type-value
10 CONSTANT \n ( the line feed character, 0x0a = 10 in decimal )
"  " \n OVER C! CONSTANT newline
"  to " CONSTANT to_     ( Note has additional leading space )
" <CHOICE" newline AZ^ CONSTANT choice< ( Note additional trailing newline )
"  CHOICE>" newline AZ^ CONSTANT choice> ( Note has leading space and new line )
" ⊓" CONSTANT choice-string
"  [] " CONSTANT sq-brackets ( Note leading and trailing spaces )
l-quote myazlength CONSTANT lquote-length
r-quote myazlength CONSTANT rquote-length
" SKIP" CONSTANT skip
" VARIABLES" CONSTANT variables
" END" CONSTANT endstring
" CONSTANTS" CONSTANT constants-string
" WHILE" CONSTANT while
" ARRAY" VALUE array
"  VALUE " VALUE value-string ( Note leading and trailing spaces )
" RECURSE" CONSTANT recurse
sspace VALUE operation-name

( this types set only for testing purposes: to be removed later )
STRING STRING PROD { " abc1" " foo" |-> , " i" " INT" |-> , " j" " INT" |-> ,
                     " k" " INT" |-> , " iset" " INT POW" |-> ,
                     " Middlesbrough" " team" |-> , " Sunderland" " team" |-> ,
                     " Leeds" " team" |-> , " b" boolean |-> ,
                     " foo2" " INT1 INT2 INT3 # foofoo baa" |-> ,
                     " ii" " INT1" |-> , " jj" " INT2" |-> , " kk" " INT3" |-> ,
                     " fooo" " INT INT INT # foofoo" |-> ,
                     " foo" " INT INT INT # foo" |-> ,
                     " s" string |-> , " iArr" " INT ARRAY" |-> ,
                     " iseq" " INT INT PROD POW" |-> ,
                     " seq" " INT INT INT # INT foo PROD POW" |-> ,
                     " lower" " INT POW" |-> ,
                     " upper" " INT POW" |-> ,
                     " arr" " foo ARRAY" |-> ,
                     " arrr" " foo ARRAY ARRAY" |-> ,
                     " factorial" " INT # INT" |-> ,
                   }
VALUE types ( Any declared [global] variables with their types )
STRING STRING PROD { }
VALUE locals ( Any local variables, parameters, etc with their types )
STRING { int , string , float , } VALUE builtin-types
STRING { } VALUE declared-user-types
STRING { } VALUE user-types ( These three to supplement the types relation )
( User types not yet implemented, but these relations are for that purpose )
STRING { } VALUE constants ( Any declared constants can be added in parsing )
STRING STRING PROD { } VALUE locals ( Similar for local variables )

(
    Sets containing letters, etc. The "antecedents" set consists of characters
    which can precede a subtraction operator; a minus preceded by an identifier
    or number or close round bracket is a subtraction operator, but a minus
    preceded by anything else is a sign-change operator.
    An open bracket preceded by something in alphanumeric (ie an identifier) is
    a function arguments bracket, but preceded by anything else it is a
    precedence bracket.
)
CHAR a CHAR z .. CONSTANT lower
CHAR A CHAR Z .. CONSTANT upper
lower upper \/ CONSTANT letter
CHAR 1 CHAR 9 .. CONSTANT digits  
INT { CHAR 0 , } CONSTANT zero
digits zero \/ CONSTANT digits0
digits0 INT { CHAR . , } \/ CONSTANT digits0.
digits0 letter \/ CONSTANT alphanumeric
alphanumeric INT { CHAR ) , CHAR . , } \/ CONSTANT antecedents
(
    Those characters ie close brackets and numbers or letters which can precede
    a minus sign - which may be a binary infix operator = subtraction,
    or a unary prefix operator = sign change. If any of those characters is
    found (except 'e' in a floating-point number) it is a subtraction or infix
    or binary operator; if not then it is unary prefix or sign-change. The full
    stop may be a radix point eg in 123.45
)
INT { 9 , 10 , 11 , 12 , 13 , 32 , } CONSTANT whitespace
whitespace INT { 0 , CHAR ; , } ∪ CONSTANT whitespace0;
( 0009 = HT tab \t, 000A(10) = LF new line \n, 000B(11) = VT 000C(12) = FF,
000D(13) = CR, 0020(32) = space )
STRING [ while , " IF" , " (" , ] CONSTANT start-keywords
STRING [ while , " IF" , " (" , " ≙" , variables , ] CONSTANT start-keywords2
STRING [ endstring , " )" , ] CONSTANT end-keywords
(
    Preceding 3 sets include brackets and words which can begin or end a block,
    eg WHILE . . . DO . . . END.
)
STRING { endstring , while , " IF" , " THEN" , " ELSE" , " DO" , array ,
         constants-string , " PRINT" , " SKIP" , variables , recurse , }
    CONSTANT keywords
( A set of words equalling keywords. )

STRING [ "  " , " ," , " (" , " +" , " -" , " *" , " /" , " >" , " =" , " <" ,
         " ≤" , " ≥" , " =!" , " =/" , " ≠" , ] CONSTANT float-antecedents
(
    Those strings which can precede the beginning of a floating-point number,
    including open bracket; a floating-point number can also be preceded by a
    space or the start of the text, or a comma in a list. One can't use an INT
    set because ≤ ≠ and ≥ all come out as 226, their first byte in UTF-8. So one
    has to use a STRING sequence and iterate it.
)
INT { CHAR [ , CHAR ] , CHAR { , CHAR } , CHAR ( , CHAR ) , } CONSTANT brackets
INT { CHAR , , } CONSTANT comma-set
INT { CHAR e , CHAR . , } CONSTANT e-dot
(
    The following sequences contain the operators which can be used by different
    parsers at different precedences. Note the high precedence operators are
    shown and handled after the low precedence operators, but the RVM FORTH
    syntax requires the high precedence operations be declared first.
)
STRING [ " +" , " -" , ] CONSTANT plusminus
STRING [ " *" , " /" , ] CONSTANT timesdivide
STRING [ " -" , ] CONSTANT uminus
STRING [ " >" , " <" , " ≤" , " ≥" , ] CONSTANT ineq
STRING [ " :/" , " :" , " ∈" , " ∉" , " =!" , " =/" , " =" , " ≠" , ]
        CONSTANT eqmem
STRING [ " ¬" , ] CONSTANT not
STRING [ " &" , " |" , " ∧" , " ∨" , ] CONSTANT andOr
STRING [ " ," , ] CONSTANT comma
STRING [ " ⊂" ,  " ⊄" , " ⊆" , " ⊈" , ] CONSTANT subset
STRING [ " ↦" , ] CONSTANT maplet
STRING [ " \" , "    " 226 OVER C! 136 OVER 1+ C! 150 OVER 2 + C! , " ∪" ,
        " ∩" , " ⊕" , ] CONSTANT unionIntersect : ∖ \ ;
STRING [ " ◁-" , " ◁" , ] CONSTANT domRestriction
STRING [ " ^" , " ⁀" , " ▷-" , " ▷" , " ←" , " ↑" , " ↓" , ]
        CONSTANT rangeRestriction
STRING [ " ^" , " ⁀" , " ←" , " ↑" , " ↓" , ]
        CONSTANT rangeRestriction2 ( for taking ▷- ▷ out of sequence use )
: ▷- |>> ;
( Have to define & use ▷- rather than -▷, otherwise you always find ▷ first )
STRING [ dots , ] CONSTANT dots-seq
STRING [ " #" , ] CONSTANT hash
STRING [ " e-" , " e" , ] CONSTANT e-minus
STRING [ " ." , ] CONSTANT dot
STRING [ " =>" , " ⇒" , ] CONSTANT implies
STRING [ " <=>" , " ⇔" , ] CONSTANT equivalence
STRING [ " :=" , " :∈" , ] CONSTANT assignment
STRING [ " THEN" , ] CONSTANT then-ops
STRING [ " ELSE" , ] CONSTANT else-ops
STRING [ " ;" , ] CONSTANT sequence ( instructions separated by ; )
STRING [ choice-string , ] CONSTANT choice ( instructions separated by ⊓  )
STRING [ guard-string , " →" , ] CONSTANT guard
" ×" CONSTANT times        ( For creating pair types with the × operator )
STRING [ times , ] CONSTANT times-sq
" ℙ" CONSTANT pow          ( For creating set  types with the ℙ operator )
STRING [ pow   , ] CONSTANT pow-seq
" ≙" CONSTANT def
STRING [ def , ] CONSTANT def-seq
" ←" CONSTANT return
STRING [ return , ] CONSTANT return-seq
STRING [ " ♢" ,  " ∇" , ] CONSTANT diamond
STRING [ " •" , ] CONSTANT bullet-seq
STRING [ " ⇒" , " ∧" , ] CONSTANT and-implies
STRING [ " [" , ] CONSTANT array-seq
"  " CONSTANT dquote CHAR " dquote C!
"   "  CHAR " OVER C! CONSTANT quotespace
( How to put a quote character 0x0022=34 into a string, with or without space. )
" _*"  10 OVER 1+  C! CONSTANT bar-line  ( String containing _ and \n character  )
" ,_*" 10 OVER 2 + C! CONSTANT comma-bar ( string containing ,_ and \n character )
(
    Mappings from a synonym string to the operator string follow:
)
STRING STRING PROD { " &" " ∧" |-> , " |"  " ∨" |-> , } CONSTANT andOr-swaps
STRING STRING PROD { " :/"  " ∉" |-> , " :" " ∈" |-> , " =!" " ≠" |-> , 
    " =/" " ≠" |-> , } CONSTANT eqmem-swaps
STRING STRING PROD { " ^" " ⁀" |-> , " <-" " ←" |-> , " /|\" " ↑" |-> ,
    " \|/" " ↓" |-> , } CONSTANT rangeRestriction-swaps
" *_*" \n OVER 2 + C! CONSTANT star-bar
( Placeholder string with *_\n in; the * will be replaced by another character )
(
    Relation linking } and }_\n, for example. Allows one to find a bracket and
    find a string with bracket, bar and \n. Can be used like this
    bracket-swaps DUP CHAR [ APPLY "i, j, k" Plist2 AZ^ SWAP CHAR ] APPLY AZ^
    . . . after Plist2 is written!
)
INT STRING PROD { CHAR [ star-bar CLONE-STRING 2DUP C! ↦ ,
    CHAR ] star-bar CLONE-STRING 2DUP C! ↦ ,
    CHAR { star-bar CLONE-STRING 2DUP C! ↦ ,
    CHAR } star-bar CLONE-STRING 2DUP C! ↦ , } CONSTANT bracket-swaps
    
INT INT PROD { CHAR [ CHAR ]  ↦ , CHAR ( CHAR )  ↦ , CHAR { CHAR }  ↦ , }
    CONSTANT bracket-chars
    
( Used for turning an int number into a String. )
STRING [ " 0" , " 1" , " 2" , " 3" , " 4" , " 5" , " 6" , " 7" , " 8" , " 9" , ]
CONSTANT numbers

blank-string VALUE operation-end
blank-string VALUE operation-inputs
blank-string VALUE operation-body
blank-string VALUE operation-type
blank-string VALUE operation-stack
blank-string VALUE operation-name
(
   Consider using operation-name for recursion; if the name of a function is
   the same as operation-name, change it to RECURSE.
   You can do it like this
   " foo(1, 2, 3)" Pexpression SWAP last-wspace-split 0 SWAP C! " RECURSE" AZ^ SWAP
   If you do it in Pfunction, you would have to move these above declarations to
   the operations.fth file.
   For recursion through two "word"s, you would have to use
   NULL OP foo ... : bar ... foo ... ; : P ... ; ' P to foo
   This would necessitate an additional keyword in the language, maybe DEFERRED
)
blank-string VALUE operation-declarations

: iToAZ ( i -- s )        
(
    Where i is an int number and s is its String representation, eg 123→"123",
    0→"0", and -1000→"-1000".
    Accepts values ≥ 2147483648, but converts them to negative values.
    Works by using a combined division and remainder operator /MOD and picking
    Strings out of the numbers sequence. Leading 0s are removed.
)
DUP 0=
IF
    DROP " 0"       ( Zero-string only: no need to enter the loop )
ELSE
    DUP 0 <
    IF
        " -"recurse
    ELSE
        blank-string
    THEN
        blank-string ROT
    BEGIN
        DUP     ( Continue until division reduces int to 0. )
    WHILE
        10 /MOD SWAP ABS        ( "-" "" -123 → "-" "" -12 3 )
        numbers SWAP 1+ APPLY ROT AZ^ SWAP ( "-" "" -12 "3" → "-" "3" -12 )
    REPEAT
    DROP AZ^    ( "-" "123" 0 → "-123" )
THEN
;

: azToI ( s -- i )
(
    Where s is a String in format "123456" or similar, with or without - and 
    leading 0s. The value must not be outwith the range -2147483648→2147483647
)
DUP head [CHAR] - =
IF
    -1 SWAP tail
ELSE
    1 SWAP
THEN
0
BEGIN
    OVER head
WHILE
    10 * OVER head [CHAR] 0 - +
    SWAP tail SWAP
REPEAT
NIP *
;

: boolean-print ( f -- ) ( Prints "true" or "false" as appropriate. )
IF ." true" ELSE ." false" THEN ;

: digits? ( c -- f Whether decimal digit ) digits IN ;

: digit? ( c -- f Whether decimal digit or 0 ) digits0 IN ;

: upper? ( c -- f Whether "upper" letter ) upper IN ;

: lower? ( c -- f Whether "lower" letter ) lower IN ;

: letter? ( c -- f Whether "upper" or "lower" letter)
   DUP upper? SWAP lower? OR ;

: alphanumeric? ( c -- f Whether letter or "digit" )
   DUP letter? SWAP digit? OR ;

: truncate ( az1 az2 -- az1T which is az1 truncated by the removal of the 
                             same number of characters as the length of az2.
                             If az2 is same length as az1 or longer, returns
                             blank string
           )
    2DUP myazlength SWAP myazlength
    OVER > IF
        NIP OVER endaz SWAP - 1 + 0 SWAP C!
    ELSE
        2DROP DROP blank-string
    THEN
;

: decapitate ( az1 az2 --az1C which is az1 shortened by the removal from its
                              start of the same number of characters as the
                              length of az2 )
    myazlength +
;

: -wspace ( az -- az with leading whitespace removed )
    BEGIN DUP head whitespace IN WHILE tail REPEAT ;

: nowspace ( az -- az2 with leading and trailing whitespace removed )
    -wspace
    DUP endaz
        BEGIN DUP head whitespace IN WHILE 1 - REPEAT 1 + 0 SWAP C! ;

: prefix?
    ( az1 az2 -- f )
    ( Whether az1 is a prefix, not necessarily shorter, of az2. )
    ( Accepts empty String as either argument. )
    BEGIN 2DUP DUP head ROT ROT head SWAP head = AND WHILE
       tail SWAP tail SWAP
    REPEAT
    DROP head 0 =
;

: suffix?
(
    az1 az2 -- f
    Whether az1 is a suffix, not necessarily shorter, of az2.
)
    2DUP myazlength SWAP myazlength
    2DUP < NOT IF       ( if top string no shorter than second: otherwise false )
        - +             ( add the difference in lengths to the start of the top )
                        ( String )
        prefix?         ( use previously created word )
    ELSE
        2DROP 2DROP     ( clear 4 values from stack )
        0               ( push "false" )
    THEN
;

: followed-by? ( s s1 set -- f )
(
    Whether the string s1 which is a prefix of the string at the pointer s is
    followed by a member of the set. For example
    " PRINT i + 3" " PRINT" whitespace returns true, whereas
    " PRINTER i + 3" " PRINT" whitespace returns false, as PRINT isn't followed
    by whitespace
)
ROT ROT myazlength + head SWAP IN ;

: doubleSpaceRemover ( s -- s )
(
    Same string with all multiple spaces converted to single spaces.
    Works by copying all the characters into itself from source to destination;
    if there is a double space (32-32 or 0x20-0x20 in ASCII) simply moves the
    source pointer and doesn't move the destination pointer.
    Sacrifices efficiency and memory economy for simplicity to write.
)
DUP DUP ( Copy String into destination and source )
BEGIN
    DUP head ( while not yet reached null terminator )
WHILE
    ( Take source character and put into destination )
    DUP head ROT DUP ROT ROT C!
    OVER head 32 = ROT DUP ROT ROT 1+ head 32 = AND ( If consecutive spaces )
    IF
        1+   ( Increment source only )
    ELSE
        1+ SWAP 1+ SWAP ( Increment source and destination )
    THEN
REPEAT
( Last source character no longer needed: put null in destination string. )
DROP 0 SWAP C! 
;

: doubleLineRemover
( s -- s1 being s minus double newlines. Similar to above operation )
DUP DUP
BEGIN
    DUP head
WHILE
    DUP head ROT DUP ROT ROT C!
    OVER head DUP 10 = SWAP 13 = OR ROT DUP ROT ROT 1+ head DUP 10 = SWAP 13 = OR AND
    IF
        1+
    ELSE
        1+ SWAP 1+ SWAP
    THEN
REPEAT
DROP 0 SWAP C!
;

: doubleWhitespaceRemover ( s -- s )
(
    Same string with all multiple whitespace converted to single spaces.
    Works by copying all the characters into itself from source to destination;
    if there is double whitespace, copies 32 into destination simply moves the
    source pointer and doesn't move the destination pointer.
    Sacrifices efficiency and memory economy for simplicity to write.
)
DUP DUP ( copy into destination and source )
BEGIN
    DUP head ( Not yet reached end of source )
WHILE
    ( Take source character, swapping whitespace for space, into destination )
    DUP head
    DUP whitespace IN IF DROP 32 THEN
    ROT DUP ROT ROT C!
    DUP head 32 = ROT DUP ROT ROT 1+ head whitespace IN AND ( double wspace )
    IF
        1+ ( Increment source only )
    ELSE
        1+ SWAP 1+ SWAP ( Increment source and destination )
    THEN
REPEAT
( No longer need last source character: put 0 in destination to terminate. )
DROP 0 SWAP C! ( Two values off stack: leave original string now shortened. )
;

: first-character ( s c -- s1 )
(
    The String s1 being s starting at first occurrence of ASCII character
    selected. If the character is not found, returns the very end of the string
    which will appear as the empty String, ie the location of the terminating 0.
    See also last-character
)
BEGIN
    OVER head 2DUP = NOT AND ( Check not end of String, nor matching character )
WHILE
    SWAP tail SWAP ( next character in String )
REPEAT DROP ( Character no longer required )
;

: last-character
(
    az c -- az2 being the last point the character was found in that string; if
    c not found, returns the beginning of the string.
    ASCII characters only for 2nd argument. If the string ends with that
    character, the end of the string will be returned.
    To display string after that point, try 1+ .AZ
    See also first-character
)
OVER endaz ( stack = string, character, string end )
BEGIN
    ROT 2DUP >= PUSH ( Whether not yet reached 1st character onto user stack )
    ROT ROT ( stack now as before )
    2DUP head = NOT POP AND ( AND with whether characters different )
WHILE
    1- ( Previous character )
REPEAT
NIP NIP ( Two unneeded values off the stack )
;

: preceded-by? ( s set -- f )
(
    Where s is a substring, not a prefix of a longer string. Tests whether
    the character immediately preceding the substring is in the set of
    characters. For example, test whether "Rit" in "Campbell Ritchie" is
    preceded by whitespace with this usage:
    "Rit" whitespace
    Note the "Rit" pointer must be 9 more than the "Campbell Ritchie" pointer
    in this example. If this is not the case, the result is undefined.
)
SWAP 1- head SWAP IN ;

: addQuotes1 ( s -- s1
Where s is an input string and s1 has pairs of quotes (and a trailing space)
added, eg abc becomes " abc" . See also addQuotes2, etc
)
quotespace SWAP OVER AZ^ AZ^
;

: addQuotes2 ( s s1 -- s2 )
(
    Where s and s1 are input strings and s2 has pairs of quotes and a trailing space
    added. See also addQuotes1, etc.
    For example abc and INT becomes " abc" " INT" .
)
quotespace ROT ROT ( quotespace now 3rd on stack )
quotespace DUP ROT ( now 2nd string top on stack )
OVER               ( now 4 sets of quotes in appropriate locations )
AZ^ AZ^ AZ^ AZ^ AZ^ ( catenate 5 times )
;

: addQuotesIfString1 ( s type -- "s" ) 
(
    If the "type" is "STRING" adds quotes to the original string. This is
    required because printing out a string like "FORTH" causes FORTH to appear
    on screen; this cannot be copied-and-pasted, but it could if the quotes were
    added. If not string, removes top value and returns 2nd value unchanged.
) 
nowspace string string-eq
IF
    addQuotes1
THEN
;

: stringbegins? ( s set -- f whether begins with member of that set )
SWAP C@ SWAP IN
;

(
" 123" digits stringbegins? . -1 
" 0123" digits stringbegins? . 0 
)

: stringcontains? ( s char-set -- f whether contains any member/s of that set )
BEGIN
    ( See whether not reached null )
    OVER head DUP PUSH 
    ( Bring set value up and test whether set not found )
    OVER IN NOT POP AND
WHILE
    ( Try next character )
    SWAP tail SWAP
REPEAT
( If reached end of string before finding anything in set, false. So 0= NOT )
DROP head 0= NOT
;

: stringcontainschar? ( s c -- f whether that "char" is in the string anywhere )
( A cut-down version of stringcontains? for use when only one char is sought. )
BEGIN
    ( See whether not yet reached null )
    OVER head DUP PUSH
    ( Bring up char sought and test whether it is not yet matched. )
    OVER = NOT POP AND
WHILE
    SWAP tail SWAP
REPEAT
DROP head 0= NOT
;

: stringconsists?
(
    s set -- f whether whole of string in characters in set. Returns true from
    a zero-length string.
)  
(: text set :)  
-1  
BEGIN
DUP
    text head 0 <> AND
WHILE 
    text head set IN AND 
    text 1+ to text 
REPEAT
;

: isSubstringOf? ( s1 s2 -- f whether s1 completely contained in s2 )
( If s1 expected to be found at beginning of s2, suggest prefix? instead )
FALSE ROT ROT ( s1 s2 0 )
BEGIN
    DUP head PUSH ROT DUP 0= POP AND ( s1 s2 found-flag repeat-flag )
WHILE    
    DROP 2DUP prefix? ROT ROT 1+ 
REPEAT ( s1 s2+1 found-flag )
NIP NIP ( found-flag )
;

: myutf8length ( s -- n Count of code points in UTF-8 encoding )
0 
    BEGIN OVER head
    WHILE ( Check not reached null terminator )
        ( Depending on higher-order bits, may consist of several bytes )
        OVER head 247 > IF 4 - ELSE 
        OVER head 239 > IF 3 - ELSE 
        OVER head 223 > IF 2 - ELSE 
        OVER head 191 > IF 1 - THEN THEN THEN THEN
    ( Add 1 to byte count and move to next pointer )
    1 + SWAP tail SWAP 
    REPEAT 
NIP
;

: Pint ( s -- s s Checks whether int, then returns s and "INT" )
     ( Throws error if "s" not in correct format, e.g. 0123 or 123.4 )
     ( Does not allow numbers beginning with - sign: this must be handled )
     ( elsewhere. Special cases for 0 and 2147483648. )
nowspace
DUP DUP
digits stringbegins?
SWAP
digits0 stringconsists? AND OVER " 0" string-eq OR
IF
    int ( Only necessary to put "INT" onto stack )
ELSE
    .AZ ."  not in correct format for integer." ABORT
THEN
OVER " 2147483648" string-eq
IF
    ." A minimum value integer, 2147483648 has been used; this will come out "
    ." negative." 10 EMIT
THEN ;

NULL OP rsplit

: Pfloat-without-e ( s -- f )
(
    Tests whether the string passed is in the correct format for a float number
    without exponential notation, eg 123. .123 0.123 123.0 123.45, 0.00123.
    Multiple 0s are permitted. One decimal point must be included, but "." is
    not permitted, not even when succeeded by e123 or e-123.
    String cloned to prevent alteration to original string input.
)
DUP " ." string-eq NOT SWAP
CLONE-STRING dot rsplit
IF
    digits0 stringconsists? SWAP digits0 stringconsists? AND
ELSE
    2DROP FALSE
    THEN
AND
;

: Pfloat ( s -- s1 "FLOAT" )
(
    Tests whether in correct form for floating point number, eg 0.123, .123,
    0.123e45, 0.123e-45, .123e45, .123e-45, 123e45, 123e-45, 0.123e-0045.
    This is done by splitting first with the sequence [ "e-", "e" ] then with
    [ "." ]. If the first splits at all, what is on the right consists entirely
    of the members of digits0, and must have a length > 0. 
    The part of the input on the left must contain something from digits0, and
    not more than one decimal point. So it should split on decimal point to two
    strings either empty, or entirely digits0.
    Note that Strings without "e" or "." in should never be passed here if this
    operation is only ever called from Pnumber. Strings beginning with 1..9 and
    not containing "e" or "." will be passed to Pint as integers and this should
    detect any errors.
    The stack contents after passing "1.23e45" or "123.45" are shown.
)
DUP CLONE-STRING ( stack = "1.23e45" "1.23e45" )
e-minus rsplit ( stack = "1.23e45" "1.23" "45" "e" )
IF ( Found e/e- )
    DUP myazlength 0 >          ( stack = "1.23e45" "1.23" "45" -1 )
    SWAP digits0 stringconsists? AND ( stack = "1.23e45" "1.23" -1 )
    SWAP DUP digits0 stringconsists?
                                ( stack = "1.23e45" -1 "1.23" 0 )
                                ( Allow for all digits or 0s left of the "e" )
    SWAP Pfloat-without-e       ( stack = "1.23e45" -1 0 -1 )
    OR AND                      ( stack = "1.23e45" -1 )
ELSE ( stack = "123.45" null )
    DROP Pfloat-without-e   ( stack = "123.45" -1 )
THEN
IF                              ( stack = "123.45" or similar. )
    float
ELSE
    ." Incorrect format of input for floating-point number: " .AZ ."  passed."
    ABORT
THEN
;

: Pnumber ( Tests whether e or . in string = floating-point; otherwise integer )
DUP e-dot stringcontains?
IF
    Pfloat
ELSE
    Pint
THEN
;

: test-form-for-identifier ( s -- s )
(
    If identifier starts with a letter and is all alphanumeric, returns argument
    unchanged. Otherwise error message. Also error if a keyword passed.
)
nowspace
DUP keywords IN IF
    ." Keyword  " .AZ ."  used out of correct context." ABORT
THEN
DUP letter stringbegins? OVER alphanumeric stringconsists? AND NOT
IF
    ." Incorrect format for identifier: must begin with letter and contain"
    10 EMIT ." only letters and numbers: " .AZ ."  passed." ABORT
THEN
( For use with recursive calls of the same function name )
operation-name OVER string-eq
IF
    DROP recurse
THEN
;

NULL OP Parray

: Pid
(
    s -- s s Checks whether correct format for identifier and finds whether it
    is already in the "types" relation domain; otherwise throws errors. Returns
    the identifier unchanged followed by the type.
    Example: "abc1" -- "abc1" "foo" where types contains abc1 |-> foo.
    Enhance by changing to RECURSE if same as operation name. Types for local
    variables take precedence over global: uses the "locals" relation.
    Also accepts array elements eg arr[1], which are passed to Parray
)
nowspace
DUP keywords IN IF ." Keyword " .AZ ."  used out of correct context." ABORT THEN
DUP [CHAR] [ stringcontainschar?
IF
    Parray
ELSE
    DUP letter stringbegins? OVER alphanumeric stringconsists? AND NOT
    IF
        ." Incorrect format for identifier: must begin with letter and contain"
        10 EMIT ." only letters and numbers: " .AZ ."  passed." ABORT
    THEN
    DUP types DOM locals DOM ∪ IN NOT
    IF
        ." Un-declared variable: not permitted: " .AZ ."  passed." ABORT
    THEN
    DUP locals DOM IN
    IF
        locals OVER APPLY
    ELSE
        types OVER APPLY
    THEN
THEN
;

: string-end-finder 
( s -- s2 s String beginning with ”, gives pointer 1 beyond matching “ ) 
    DUP
    l-quote OVER prefix? IF 1 ELSE 0 THEN  
    BEGIN  
        OVER C@ 0 <> OVER AND WHILE  
        SWAP tail SWAP  
        OVER r-quote SWAP prefix? IF 1 - ELSE  
        OVER l-quote SWAP prefix? IF 1 + THEN THEN  
    REPEAT
    IF
        ." Unmatched quotes: still inside String as follows:"
        10 EMIT DROP .AZ ABORT
    THEN  
    r-quote myazlength + NIP
;

: string-start-finder 
(
    s1 s2 -- s1 s3 String starting s1 ending with ” at s2 -- s3 is pointer
    to the open quote matching that close quote at s2.
    Note that s2 is the pointer to the 1st of the 3 bytes making up the ”.
    If String doesn't end with ”, both values unchanged.
) 
(: start end :) 
r-quote end suffix?
IF
    1
    BEGIN
        DUP start end <= AND
    WHILE
        end 1- to end
        l-quote end prefix?
        IF
            1-
        ELSE
            r-quote end prefix?
            IF
                1+
            THEN
        THEN
    REPEAT
    IF
        ." Unmatched quotes: String doesn't start: original:" 10 EMIT
        start .AZ ABORT
    THEN
THEN
start end
;

: bracketRemover
( s c1 c2 -- s2 which is s with the starting and ending brackets removed )
( Only removes a matching pair so anything after that is lost )
( c1 and c2 are chars representing the opening and closing brackets-ASCII )
( only. )
( If text not starting with the appropriate bracket is passed, no change )
0 0
(: string cl cr old-string brackets :)
string nowspace to old-string
string head cl =
IF
    1 to brackets
    string 1+ to string
    BEGIN
        string head 0 <> brackets AND
    WHILE
        string head cl =
        IF
            brackets 1+ to brackets
        ELSE
            string head cr =
            IF
                brackets 1- to brackets
            THEN
        THEN
        l-quote string prefix?
        IF
            string string-end-finder 1- to string
        THEN
        string 1+ to string ( not required if “”, hence 1- above )
    REPEAT
    brackets
    IF
        ." Open " cl EMIT ."  not closed with enough " cr EMIT ." s in "
        old-string .AZ ABORT
    THEN
    0 string 1- C!
    old-string 1+ to old-string
THEN
old-string
;

: bracketRemover2
( s c1 c2 -- s2 which is s with the starting and ending brackets removed )
( Only removes a matching pair so anything after that is lost )
( c1 and c2 are chars representing the opening and closing brackets-ASCII )
( only. Example "(1 + 2)" [CHAR] ( [CHAR] ) bracketRemover2 → "1 + 2" )
( If text not starting with the appropriate bracket is passed, no change )
( Error if the closing bracket is not the last printing character in the text )
0 0
(: string cl cr old-string brackets :)
string to old-string
string head cl =
IF
    1 to brackets
    string 1+ to string
    BEGIN
        string head 0 <> brackets AND
    WHILE
        string head cl =
        IF
            brackets 1+ to brackets
        ELSE
            string head cr =
            IF
                brackets 1- to brackets
            THEN
        THEN
        l-quote string prefix?
        IF
            string string-end-finder 1- to string
        THEN
        string 1+ to string ( not required if “”, hence 1- above )
    REPEAT
    brackets
    IF
        ." Open " cl EMIT ."  not closed with enough " cr EMIT ." s in "
        old-string .AZ ABORT
    THEN
    0 string 1- C!
    BEGIN
        string head
    WHILE
        string head 32 <>
        IF
            ." Text after paired closing bracket in the String starting "
            old-string .AZ ." . . ." 10 EMIT ABORT
        THEN
        string 1+ to string
    REPEAT
    old-string 1+ to old-string
THEN
old-string
;

: close-bracket-finder
( s c1 c2 -- s2 "s" must start with a specified bracket type in c1, whose )
( pair is supplied as c2, eg [ = 91 and ] = 93 in dec ASCII. Works from left )
( to right counting brackets except those in “ ”, and returns the pointer )
( to the matching closing bracket. Any pair of characters can be matched. )
( Original pointer returned unchanged if String doesn't begin with bracket. )
0
(: string cl cr brackets :)
string head cl =
IF
    1 to brackets
    BEGIN
        string head 0 <> brackets AND
    WHILE
        string 1+ to string
        string head cl =
        IF
            brackets 1+ to brackets
        ELSE
            string head cr =
            IF
                brackets 1- to brackets
            ELSE
                l-quote string prefix?
                IF
                    string string-end-finder 1- to string
                THEN
            THEN
        THEN
    REPEAT
    brackets
    IF
        ." String with more " cl EMIT ."  than " cr EMIT ABORT
    THEN
THEN
string
;

: open-bracket-finder  
( s s1 cl cr -- s s2 where s is the start of a string ending with a right )  
( bracket or similar at the pointer s1. The right bracket is the char cr )  
( and its pair (left) is cl. Leaves s2 which is a pointer to the matching )  
( left bracket in the same String )  
( If brackets not matched, error message. If no right bracket at end, s1 )  
( is returned unchanged  )  
0  
(: start-string string cl cr brackets :)  
string head cr =    
IF  
    1 to brackets  
THEN  
BEGIN  
string start-string < NOT brackets AND  
WHILE  
    string 1- to string  
    r-quote string prefix?  
    IF  
        string string-start-finder to string  
    ELSE  
        string head cr =   
        IF  
            brackets 1+ to brackets  
        ELSE  
            string head cl =  
            IF  
                brackets 1- to brackets  
            THEN
        THEN
    THEN 
REPEAT 
brackets
IF  
    ." Unmatched brackets: too many " cr EMIT ." and too few " cl EMIT ."  in"
    10 EMIT string .AZ ABORT  
THEN  
start-string string
;

: check-type-int ( s1 s2 -- )
(
    Where s1 is the operator/array index and s2 the type, which ought to be int.
    If not, error message
)
nowspace DUP int string-eq
IF
    2DROP
ELSE
    ." Incorrect type for " SWAP .AZ ."  operator: should be " int .AZ ABORT
THEN ;

: check-types-both-int ( s1 s2 s3 --  )
(
    Where s1 is the operator and s2 and s3 the two types, which should both be
    "INT"; throws error message otherwise
)
nowspace SWAP nowspace SWAP 2DUP string-eq OVER int string-eq AND NOT
IF
    ." Incorrect types for " ROT .AZ ."  operator: both should be " int .AZ CR
    SWAP .AZ ."  and " .AZ ."  passed." ABORT
THEN
DROP 2DROP
;

: .._ ( s1 s2 s3 s4 -- ss1 ss2 )
(
    Creates an enumerated set of integers.
    s1 is left value eg "123" s3 is right value eg "234" s2 and s4 both "INT".
    Tests correct types, then returns "123 234 .." and "INT POW".
)
(: l-value l-type r-value r-type :) dots l-type r-type check-types-both-int
l-value digits0 stringconsists?
IF
    r-value digits0 stringconsists?
    IF
        l-value azToI r-value azToI >
        IF  ( Don't allow 234..123 or similar )
            ." Enumerated sets must run from smaller to larger" CR
            l-value .AZ dots .AZ r-value .AZ ."  passed."
            ABORT
        THEN
    THEN
THEN
l-value sspace r-value sspace dots AZ^ AZ^ AZ^ AZ^ int "  POW" AZ^ ;

: check-types-for-arithmetic
( s1 s2 s3 -- Check types appropriate for arithmetic: "INT" or "FLOAT" both )
    SWAP nowspace SWAP nowspace
    2DUP DUP float string-eq SWAP int string-eq OR
    SWAP DUP float string-eq SWAP int string-eq OR
    AND NOT
    IF
        ." Type error for " ROT .AZ ."  operator: "
        SWAP .AZ ."  and " .AZ ."  offered. Should be INT or FLOAT for both." ABORT
    THEN
    DROP 2DROP
;

: addSubtract ( s1 s2 s3 s4 s5 -- ss1 ss2 )
    ( As with all arithmetic operations, this must be changed to incorporate )
    ( floating-point numbers as well as INTs )
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type check-types-for-arithmetic
    l-type float string-eq r-type float string-eq OR
    IF
        r-type int string-eq
        IF
            r-value StoF AZ^ to r-value
        ELSE
            l-type int string-eq
            IF
                l-value StoF AZ^ to l-value
            THEN
        THEN
        " F" operator AZ^ to operator
        float to l-type
    THEN
    l-value sspace AZ^ r-value AZ^ sspace AZ^ operator AZ^ l-type
;

: +_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    ( This can incorporate floating-point numbers as well as INTs )
    "  +" VALUE op ( note additional space, also in F+ and S>F )
    op l-type r-type check-types-for-arithmetic
    l-type float string-eq r-type float string-eq OR
    ( Either or both is float )
    IF
        l-type int string-eq
        IF  ( Add S>F as appopriate )
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        "  F+" to op
        float to l-type
    THEN
    l-value sspace AZ^ r-value AZ^ op AZ^ l-type
;

: -_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    "  -" VALUE op
    op l-type r-type check-types-for-arithmetic
    l-type nowspace float string-eq r-type nowspace float string-eq OR
    IF
        l-type int string-eq
        IF
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        float to l-type
        "  F-" to op
    THEN
    l-value sspace AZ^ r-value AZ^ op AZ^ l-type
;

: *_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    "  *" VALUE op
    op l-type r-type check-types-for-arithmetic
    l-type nowspace float string-eq r-type nowspace float string-eq OR
    IF
        l-type int string-eq
        IF
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        float to l-type
        "  F*" to op
    THEN
    l-value sspace AZ^ r-value AZ^ op AZ^ l-type
;

: /_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    ( As with all arithmetic operations, this must be changed to incorporate )
    ( floating-point numbers as well as INTs )
    "  /" VALUE op
    op l-type r-type check-types-for-arithmetic
    l-type nowspace float string-eq r-type nowspace float string-eq OR
    IF
        l-type int string-eq
        IF
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        float to l-type
        "  F/" to op
    THEN
    l-value sspace AZ^ r-value AZ^ op AZ^ l-type
;

: multiplyDivide ( s1 s2 s3 s4 s5 -- ss1 ss2 )
(
 s1 is the left substring, s3 the right substring, s2 and s4 their types, which
 must be checked, and s5 the operator. Returns a postfix substring and type, eg
 IN: "i" "INT" "j" "INT" "*": OUT: "i j *" "INT". )
    ( Since this operation is indistinguihable from addSubtract, use that! )
(    operator l-type r-type check-types-for-arithmetic             )
(    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ r-type )
addSubtract
;

: check-type-for-uminus ( az -- Check type appropriate for uminus op )
( This operation stands on its own as the only unary arithmetic operation )
    nowspace DUP DUP int string-eq NOT SWAP float string-eq NOT AND
    IF
        ." Type error for unary - operator: " .AZ ."  offered; INT and FLOAT"
        ."  permitted." ABORT
    THEN
    DROP
;

: uminus_ ( s1 s2 -- s1 s2 operand with -1 * added and type )
( This operation can be done without local variables )
( Using -1 * rather than prepending - allows a whole expression to be negated. )
    DUP check-type-for-uminus
    DUP float string-eq
    IF
        SWAP "  -1.0 F*" AZ^ SWAP
    ELSE
        SWAP "  -1 *" AZ^ SWAP
    THEN
;

: check-types-for-booleans ( s1 s2 s3 -- Check both Booleans )
(
    Pass "⇒" "Boolean" "Boolean" or similar. Throws error if not both Boolean.
)
    OVER nowspace boolean string-eq OVER nowspace boolean string-eq AND NOT
    IF
        ." Type error for " ROT .AZ ."  operator. "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    DROP 2DROP
;

: ⇔_ ( s1 s2 s3 s4 -- ss1 boolean )
(
    Executes the tagged tree and type testing for the equivalence operator. For
    example, "x" "boolean" "y" "boolean" --> "x y ⇔" "boolean".
)
(: l-value l-type r-value r-type :)
" ⇔" l-type r-type check-types-for-booleans
l-value sspace AZ^ r-value AZ^ "  ⇔" AZ^ l-type ;
: <=>_ ⇔_ ; ( As above operation, so that <=> can be used as a synomym for ⇔ )

: ⇒_ ( s1 s2 s3 s4 -- ss1 boolean )
(
    Executes the tagged tree and type testing for the implies operator. For
    example, "x" "boolean" "y" "boolean" --> "x y ⇒" "boolean".
)
(: l-value l-type r-value r-type :)
" ⇒" l-type r-type check-types-for-booleans   
l-value sspace AZ^ r-value AZ^ "  ⇒" AZ^ r-type ;
: =>_ ⇒_ ; ( As above operation, so that => can be used as a synomym for ⇒ )

: ∧_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    " ∧" l-type r-type check-types-for-booleans
    l-value sspace AZ^ r-value AZ^ "  ∧" AZ^ r-type
;

: ∨_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    " ∨" l-type r-type check-types-for-booleans
    l-value sspace AZ^ r-value AZ^ "  ∨" AZ^ r-type
;

: andOr_ ( s1 s2 s3 s4 s5 -- ss1 ss2 )
(
    s1 and s3 are the two operands, s2 and s4 are the two types which ought to
    be both "BOO" and s5 the operator, eg ∧, ∨. Calls the type checking function
    and returns a postfix representation of this expression, with its type.
    eg "b" "BOO" "bb" "BOO" "∧" --> "b bb ∧" "BOO"
)
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type check-types-for-booleans
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ l-type
;

: check-type-for-not ( s1 -- Check appropriate type for unary not ¬ )
( Operation standing alone because there is only one unary boolean connective )
    DUP nowspace boolean string-eq NOT
    IF
        ." Type error for ¬ not operator: " .AZ ."  offered. " ABORT        
    THEN
    DROP
;

: ¬_ ( s1 s2 -- ss1 ss2 )
    DUP check-type-for-not
    SWAP "  ¬" AZ^ SWAP
;

: check-types-for-set-membership ( s1 s2 s3 -- Check appropriate types for ∈ etc )
    ( s2 has "POW" as a suffix and the remainders of the two strings are identical )
    OVER nowspace OVER nowspace SWAP "  POW" AZ^ string-eq NOT
    IF
        ." Type error for " ROT .AZ ."  operator. "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    DROP 2DROP
;

: membership_ ( s1 s2 s3 s4 s5 -- ss1 ss2 )
(
    s1 and s3 are the two operands, s2 and s4 types and s5 the operator, eg ∈
    and ∉. Returns the expression in postfix form, followed by the type, which
    is always "BOO" for boolean.
    Example "x" "FOO" "s" "FOO POW" "∈" --> "x s ∈" "BOO"
    Calls a type-testing function, check-types-for-set-membership.
    Calls the operation to add quotes if the left operand is a String.
)
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type check-types-for-set-membership
(   l-value l-type addQuotesIfString1 to l-value )
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ boolean
;

: ∈_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " ∈" l-type r-type check-types-for-set-membership
(   l-value l-type addQuotesIfString1 to l-value )
    l-value sspace AZ^ r-value AZ^ "  ∈" AZ^ boolean
;

: ∉_ ( s1 s2 s3 s4 -- ss1 "BOO2 )
    (: l-value l-type r-value r-type :)
    " ∉" l-type r-type check-types-for-set-membership
(   l-value l-type addQuotesIfString1 to l-value )
    l-value sspace AZ^ r-value AZ^ "  ∉" AZ^ boolean
;

: test-two-types-same ( s1 s2 s3 -- Check two types identical )
    OVER nowspace OVER nowspace string-eq NOT
    IF
        ." Type error for " ROT .AZ ."  operator. Should both be same: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    DROP 2DROP
;

: test-two-types-different ( s1 s2 s3 -- check two types different )
    2DUP nowspace SWAP nowspace string-eq
    IF
        ." Type error for " ROT .AZ ."  operator. Cannot accept " .AZ
        ABORT
    THEN
    DROP 2DROP
;

: equality_ ( s1 s2 s3 s4 s5 -- ss1 ss2 )
(
    s1 and s3 are the two operands, s2 and s4 their types which are tested for
    equality, and s5 the operator. Returns the expression in postfix and the
    type, which is always boolean. Does not accept booleans as operands.
    Example "ff" "foo" "f" "foo" "=" --> "ff f =" "BOO"
) ( Not used: because of type difficulties =_ and ≠_ used individually. )
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type test-two-types-same
    operator l-type boolean test-two-types-different
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ boolean
;

( The only built-in float inequality words are F< F0< and F0=, but it is easy to
create all the other words required from F< and F0=. )
: F≠ ( fp fp -- f Whether the two floats are not equal ) F- F0= NOT ; : F=/ F≠ ;
: F= ( fp fp -- f Whether the two floats are equal ) F- F0= ;
: F> ( fp fp -- f Whether the first float is greater than the other) SWAP F< ;
: F≥ ( fp fp -- f Whether the first float is greater than or equal to the other)
     F< NOT ; : F>= F≥ ;
: F≤ ( fp fp -- f Whether the first float is less than or equal to the other)
     SWAP F< NOT ; : F<= F≤ ;

: =_ ( s1 s2 s3 s4 -- ss1 "BOO" )
(
    The basic type tests for equality of reference, which means only integers
    return true.
    It should however be possible to test for more types with PAIR= SET= STRING=
    or string-eq and F=. If type = FLOAT use F=, if it ends in PROD use PAIR=,
    etc. Note that [1, 2, 3] and {1 ↦ 1, 2 ↦ 2, 3 ↦ 3} will return "true"; both
    type to "INT INT PROD POW".
    however; one is a SEQ and the other an INT INT PROD.
    Note that there PAIR= will throw a segmentation error if certain types are
    compared, eg I,I with $,$.
)
(: l-value l-type r-value r-type :)
equals VALUE op
l-type nowspace to l-type r-type nowspace to r-type
l-type int string-eq r-type float string-eq AND
IF
    l-value StoF AZ^ to l-value float to l-type
    f-equals to op
ELSE
    l-type float string-eq r-type int string-eq AND
    IF
        r-value StoF AZ^ to r-value float to r-type
        f-equals to op
    ELSE    ( Lines adding quotes appear to create " " text " " )
(        l-value l-type addQuotesIfString1 to l-value )
(        r-value r-type addQuotesIfString1 to r-value )
        l-type r-type string-eq NOT
        IF
        ELSE
            l-type string string-eq
            IF
                " string-eq" to op
            ELSE
                l-type float string-eq
                IF
                    f-equals to op
                ELSE
                "  PROD" l-type suffix?
                    IF
                        " PAIR=" to op
                    ELSE
                        "  POW" l-type suffix?
                        IF
                            "  SET=" to op
                        THEN
                    THEN
                THEN
            THEN
        THEN
    THEN
THEN
l-value sspace AZ^ r-value AZ^ sspace AZ^ op AZ^ boolean ;

: ≠_ ( s1 s2 s3 s4 -- ss1 "BOO" ) ( Whether the operands s1 and s3 are unequal )
    =_ SWAP "  NOT" AZ^ SWAP ( Because of multiplicity of types, use =_ NOT )
;

: inequality_ ( s1 s2 s3 s4 s5 -- ss1 "BOO" )
(
    Where s1 and s3 are the two operands, s2 and s4 their types (must be checked
    as suitable for arithmetic), and s5 the operator eg > <.
    ss1 is the output in postfix format which is always a boolean value.
)
(: l-value l-type r-value r-type operator :)
operator l-type r-type check-types-for-arithmetic
l-type " FLOAT" string-eq r-type " FLOAT" string-eq OR
IF
    " F" operator AZ^ to operator
    l-type " INT" string-eq
    IF
        l-value StoF AZ^ to l-value
    ELSE
        r-type " INT" string-eq
        IF
            r-value StoF AZ^ to r-value
        THEN
    THEN
THEN        
l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ boolean
;

: <_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " <" VALUE op
    op l-type r-type check-types-for-arithmetic
    l-type float string-eq r-type float string-eq OR
    IF
        l-type int string-eq
        IF
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        " F" op AZ^ to op
    THEN
    l-value sspace AZ^ r-value AZ^ sspace AZ^ op AZ^ boolean
;

: ≤_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " ≤" VALUE op
    op l-type r-type check-types-for-arithmetic
    l-type float string-eq r-type float string-eq OR
    IF ( See <_: this looks like a candidate for refactoring. )
        l-type int string-eq
        IF
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        " F" op AZ^ to op        
    THEN
    l-value sspace AZ^ r-value AZ^ sspace AZ^ op AZ^ boolean
;

: >_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " >" VALUE op
    op l-type r-type check-types-for-arithmetic
    l-type float string-eq r-type float string-eq OR
    IF
        l-type int string-eq
        IF
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        " F" op AZ^ to op
    THEN
    l-value sspace AZ^ r-value AZ^ sspace AZ^ op AZ^ boolean
;

: ≥_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
     " ≥" VALUE op
    op l-type r-type check-types-for-arithmetic
    l-type float string-eq r-type float string-eq OR
    IF
        l-type int string-eq
        IF
            l-value StoF AZ^ to l-value
        ELSE
            r-type int string-eq
            IF
                r-value StoF AZ^ to r-value
            THEN
        THEN
        " F" op AZ^ to op
    THEN
    l-value sspace AZ^ r-value AZ^ sspace AZ^ op AZ^ boolean
;

: check-single-tree ( s1 -- s1 Error message if not single parse tree )
( INT INT PROD STRING PROD POW would be single tree, for example. )
( If single-letter String assume a true tree with 1 token in. )
( This version uses 32=space, but it could be changed to accept any whitespace. )
nowspace
DUP myazlength 0=
IF
    ." Empty type received: not permitted." ABORT
THEN
DUP myazlength 1 = NOT
IF
    sspace AZ^ ( Strip off spaces, leaving 1 trailing space )
    ( Put 0 to count tokens onto stack as 2nd element )
    0 OVER CLONE-STRING ( az1 0 az1-copy )
    BEGIN
    ( Iterate through String to its end )
    DUP head
    WHILE
    ( test current character = space & previous = letter )
        tail DUP head 32 = OVER 1 - head letter? AND
        ( 1 more token found )
        IF
            SWAP 1 + SWAP
            ( increment count: test whether everything off stack )
            OVER 1 <
            IF
                ." Not a single tree" ABORT
            THEN
        THEN
        "  PROD " OVER prefix?
        IF
        ( " PROD " consumes 2 arguments. Remember trailing space earlier )
            SWAP 2 - SWAP
        ELSE
            "  POW " OVER prefix? OVER "  ARRAY " SWAP prefix? OR
            ( " POW "/" ARRAY " consumes 1 argument. Still trailing space )
            IF
                SWAP 1 - SWAP
            THEN
        THEN
    REPEAT
    DROP 1 <>
    IF
        ." A multiple tree" ABORT
    THEN
THEN
;

: check-same-types ( s s1 s2 -- )
(
    Check the two strings s1 and s2 are the same type for the operation in s;
    if the same after stripping leading and trailing spaces drops everything,
    otherwise error message and crashes application.
    Assumes s1 is what is required and s2 is what is supplied.
)
nowspace SWAP nowspace 2DUP string-eq NOT
( After 1 SWAP now has s1=required on top of stack and s2=supplied second. )
IF
    ." Type error for " ROT .AZ ."  operator: types ought to be the same."
    10 EMIT ." Type required:  " .AZ 10 EMIT
    ." Type supplied: " .AZ ABORT
THEN
DROP 2DROP ( empty three values from stack )
;

: check-same-kind-set ( s1 s2 s2 -- Check two sets of same type )
    OVER nowspace OVER nowspace
    DUP " POW" SWAP suffix? ROT ROT string-eq AND NOT
    IF
        ." Type error for " ROT .AZ
        ."  operator, requires two the same ending POW: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    check-single-tree
    2DROP DROP
;

: subset_ ( s1 s2 s3 s4 s5 -- ss1 "BOO" )
(
    Where s1 and s3 are the two operands, s2 and s4 their types and s5 the
    operator. Returns the expression in postfix format and "BOO" since this
    always returns a boolean value
)
    (: l-value l-type r-value r-type operator :)
    operator r-type l-type check-same-kind-set
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ boolean
;

: ⊂_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " ⊂" l-type r-type check-same-kind-set
    l-value sspace AZ^ r-value AZ^ "  ⊂" AZ^ boolean
;

: ⊄_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " ⊄" l-type r-type check-same-kind-set
    l-value sspace AZ^ r-value AZ^ "  ⊄" AZ^ boolean
;

: ⊆_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " ⊆" l-type r-type check-same-kind-set
    l-value sspace AZ^ r-value AZ^ "  ⊆" AZ^ boolean
;

: ⊈_ ( s1 s2 s3 s4 -- ss1 "BOO" )
    (: l-value l-type r-value r-type :)
    " ⊈" l-type r-type check-same-kind-set
    l-value sspace AZ^ r-value AZ^ "  ⊈" AZ^ boolean
;

: -->_ ( s1 s2 s3 -- s4 )
(
    Where s1 is a Boolean value, s2 is "boolean" or similar and s3 an
    instruction. Tests s2 for marking as Boolean type.
    "i 3 <" "boolean" "i 1 + to i" returns "i 3 < --> i 1 + to i", for example.
)
ROT ROT guard-string SWAP boolean check-types-for-booleans
guard-string ROT newline AZ^ AZ^ AZ^
;
( Synonym for above ) : →_ -->_ ;

: []_ ( s1 s2 -- s3 )      
(
    Where s1 is the first choice, s2 the second and s3 the output.
    There are no types or similar to consider; each input String must be a
    multiple instruction, with or without sequence guard or choice already
    embedded, in postfix. for example,
    " i 1 + to i" " i 2 + to i" []_ returns
    "<CHOICE i 1 + to i [] i 2 + to i CHOICE>", and
    " i 1 - to i" "<CHOICE i 1 + to i [] i 2 + to i CHOICE>" []_ returns
    "<CHOICE i 1 - to i [] i 1 + to i [] i 2 + to i CHOICE>"
    [] associates to the right. Does not throw any error messages.
    Uses the choice< "<CHOICE ", choice> " CHOICE>" and sq-brackets " [] "
    strings, which are global variables.
)
choice< OVER prefix? ( Already a choice: take <CHOICE off start )
IF 
    choice< decapitate choice< ROT sq-brackets AZ^ AZ^ SWAP AZ^
ELSE ( Not already choice: Add both <CHOICE and CHOICE> )
    choice< ROT sq-brackets AZ^ AZ^ SWAP choice> AZ^ AZ^
THEN
;

: ;_ ( s s1 -- s2 )
newline SWAP newline AZ^ AZ^ AZ^ ;

: WHILE_ ( s s1 s2 -- s3 )
(: boolean-string type block :)   
" WHILE loop" type boolean test-two-types-same  
" BEGIN" newline AZ^  
boolean-string newline AZ^ AZ^ 
while newline AZ^ AZ^ 
block newline " REPEAT" AZ^ AZ^ AZ^ ;

: test-one-type-boolean ( type operator -- )
(
    Tests that the type is Boolean, otherwise throws an error message and aborts
)
OVER boolean string-eq NOT
IF
    SWAP .AZ ." Incorrect type for " .AZ ."  operator: only boolean types permitted."
    ABORT
THEN 2DROP
;

: IF-THEN_ ( s1 s2 s3 -- s4 )
(
  Where s1 is a Boolean expression, s2 is the boolean type,
  and s3 a postfix block for the THEN. Tests correctness of
  the left type, then catenates to “i 3 < IF i1 + to i END” or
  similar.
)
SWAP  " IF block" test-one-type-boolean   
newline " THEN" AZ^ AZ^   
newline " IF" newline AZ^ AZ^   
SWAP AZ^ AZ^ ;

: IF-THEN-ELSE_ ( s1 s2 s3 s4 -- s5 )
( if-string boolean then-string else-string -- postfix-string )
(
    Where s1 is a postfix Boolean expression (eg 1 3 <) s2 is the Boolean type,
    s3 is the instruction for "then" (eg i 1 + to i) and s4 the "else"
    instruction (eg i 1 - to i). Uses the test-one-type-boolean operation to
    check correctness of typing, then returns one string with keywords and new
    lines added, eg 1 3 < IF i 1 + to i ELSE i 1 - to i THEN.
)
( Check the 3rd value is the Boolean type )
ROT " IF-ELSE block" test-one-type-boolean
newline " THEN" newline AZ^ AZ^ AZ^
SWAP newline " ELSE" newline AZ^ AZ^ AZ^ SWAP AZ^
SWAP newline " IF" newline AZ^ AZ^ AZ^ SWAP AZ^
;

: ELSE_ ( then-string else-string -- if-else-string ) 
(
    Takes two strings, eg i 1 + to i, i 1 - to i, and catenates them with ELSE
    as part of a "then" block. Must always be used in conjunction with IF-THEN_.
) 
newline " ELSE" newline AZ^ AZ^ SWAP AZ^ AZ^ ;

: check-types-not-null ( s1 s2 s2 -- Check both types actually exist )
    2DUP AND 0 =
    IF
        ." Type error for " ROT .AZ ."  operator: null not permitted: "
        SWAP DUP
        IF
            .AZ
        ELSE
            DROP ." null"
        THEN
        ."  and "
        DUP IF
            .AZ
        ELSE
            DROP ." null"
        THEN
        ."  offered." ABORT
    THEN
    DROP 2DROP
;

( No need to aggregate this operation since there is only one operator with )
( that particular precedence. )
: ↦_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    "  |->" VALUE op
    l-type nowspace to l-type r-type nowspace to r-type
    " ↦" l-type r-type check-types-not-null
    l-type float string-eq r-type float string-eq OR
    IF
       ." Cannot accept FLOAT as a type for pairs in the present implementation"
       ABORT
    THEN
    l-type int string-eq
    IF
        op " I," AZ^ to op
    ELSE
        l-type string string-eq
        IF
            op " $," AZ^ to op
        ELSE
            "  PROD" l-type suffix?
            IF
                op " P," AZ^ to op
            ELSE
            (   "  POW" l-type suffix?
                IF  )
                    op " S," AZ^ to op
            (    THEN    )
            THEN
        THEN
    THEN
    r-type int string-eq
    IF
        op " I" AZ^ to op
    ELSE
        r-type string string-eq
        IF
            op " $" AZ^ to op
        ELSE
            "  PROD" r-type suffix?
            IF
                op " P" AZ^ to op
            ELSE
            (   "  POW" r-type suffix?
                IF  )
                    op " S" AZ^ to op
            (    THEN    )
            THEN
        THEN
    THEN
    l-value sspace AZ^ r-value AZ^ op AZ^ l-type sspace AZ^ r-type AZ^
            "  PROD" AZ^
;

: setunion_ ( s1 s2 s3 s4 s5 -- ss1 ss2 )
(
    Where s1 and s3 are the operands, s2 and s4 their types, which must be the
    same type of set, and s5 the operator. Returns the expression in postfix
    format, and its type eg "x" "FOO POW" "y" "FOO POW" "∪" becomes
    "x y ∪" "FOO POW"
)
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type check-same-kind-set
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ l-type
;

: \_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    " \" l-type r-type check-same-kind-set
    l-value sspace AZ^ r-value AZ^ "  \" AZ^ l-type
;

: ∪_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    " ∪" l-type r-type check-same-kind-set
    l-value sspace AZ^ r-value AZ^ "  ∪" AZ^ l-type
;

: ∩_ ( s2 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    " ∩" l-type r-type check-same-kind-set
    l-value sspace AZ^ r-value AZ^ "  ∩" AZ^ l-type
;

: check-same-kind-relation ( s1 s2 s3 -- Check s2+s2 same kind of relation )
2DUP
    nowspace "  PROD POW" SWAP suffix?
    SWAP nowspace "  PROD POW" SWAP suffix?
    AND NOT
IF
    ." Type error for " ROT .AZ
    ."  operator: both types should end PROD POW: "
    SWAP .AZ ."  and " .AZ ."  offered." ABORT
THEN
    2DUP string-eq NOT
IF
    ." Type error for " ROT .AZ
    ."  operator: both types should be identical: "
    SWAP .AZ ."  and " .AZ ."  offered." ABORT
THEN
check-single-tree
DROP 2DROP
; 

: ⊕ ( Relational override from RVM_FORTH manual page 27 set1 set2 --set1⊕set2 )
    DUP DOM ROT <<| ∪ ;

: ⊕_ ( s1 s2 s3 s4 -- ss1 ss2 )
    (: l-value l-type r-value r-type :)
    " ⊕" l-type r-type check-same-kind-relation
    l-value sspace AZ^ r-value AZ^ "  ⊕" AZ^ l-type
;

: check-types-domain-restriction
    ( s1 s2 s3 (cloned) -- Check appropriate types for domain restriction )
    "  PROD POW" OVER nowspace suffix? NOT
    IF
        ." Type error for " ROT .AZ
        ."  operator: right type should end in PROD POW: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    OVER nowspace "  POW" SWAP suffix? NOT
    IF
        ." Type error for " ROT .AZ
        ."  operator: left type should end in POW: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    OVER nowspace CLONE-STRING "  POW" truncate OVER prefix? NOT
    IF
        ." Type error for " ROT .AZ
        ."  operator: both types should start the same way: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    SWAP "  POW" truncate decapitate "  PROD POW" truncate
   check-single-tree 2DROP
;

: domRestriction_ ( s1 s2 s3 s4 s5 -- ss1 ss2 )
(
    Where s1 and s3 are the two operand subexpressions, s2 and s4 their types,
    and s5 the operator. Returns the expression in postfix form, using the
    check-types-domain-restriction function to test the types, as ss1, and the
    type of set as ss2, eg
    "x" "foo POW" "y" "foo bar PROD POW" "◁" becomes "x y ◁" "foo bar PROD POW"
)
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type CLONE-STRING check-types-domain-restriction
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ r-type
;

: ◁_ ( s1 s2 s3 s4 -- ss1 ss2 ) 
    (: l-value l-type r-value r-type :) 
    " ◁" l-type r-type CLONE-STRING check-types-domain-restriction 
    l-value sspace AZ^ r-value AZ^ "  ◁" AZ^ r-type
;

: ◁-_ ( s1 s2 s3 s4 -- ss1 ss2 Should use \u2a65 really )
    (: l-value l-type r-value r-type :) 
    " ◁-" l-type r-type CLONE-STRING check-types-domain-restriction 
    l-value sspace AZ^ r-value AZ^ "  ◁-" AZ^ r-type
;

: ^_ ( s1 s2 s3 s4 -- ss1 ss2 )
(
   Where s1 and s3 are strings representing sequence values, and s2 and s4 their
   types. Returns a postfix expression of the catenation eg " x y ^" and the
   type, eg INT FOO PROD POW. Uses the check-same-kind-relation operation and
   checks that "INT" is a prefix of the types. Strings can be catenated with the
   same operation, using the AZ^ word in the output
)
    (: l-value l-type r-value r-type :)
    l-type string string-eq r-type string string-eq AND
    IF
        l-value sspace AZ^ r-value AZ^ "  AZ^"  AZ^ l-type
    ELSE
        " ^" l-type r-type check-same-kind-relation
        int-space l-type -blanks prefix?
        IF
            l-value sspace AZ^ r-value AZ^ "  ^" AZ^ l-type
        ELSE
            ." Type error for ^ operator: should begin with INT: " l-type .AZ
            ."  passed" ABORT
        THEN
    THEN
;

: check-types-range-restriction
    ( s1 s2 s3 (cloned) -- check appropriate types )
    nowspace SWAP nowspace SWAP
    "  POW" OVER suffix? NOT
    IF
        ." Type error for " ROT .AZ
        ."  operator. Right type should end in POW : " .AZ ."  offered."
        ABORT
    THEN
    OVER "  PROD POW" SWAP suffix? NOT
    IF
        ." Type error for " ROT .AZ
        ."  operator: left type should end PROD POW : " SWAP .AZ ."  offered."
        ABORT
    THEN
    2DUP CLONE-STRING "  POW" truncate "  PROD POW" AZ^ OVER 
    suffix? NOT
    IF
        ." Type error for " ROT .AZ
        ."  operator: Lt type should contain centrally Rt type minus POW : "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    check-single-tree
    2DROP 2DROP ( There would still be four unnecessary values on the stack )
;

: rangeRestriction_ ( s1 s2 s3 s4 s5 -- ss1 type )
(
    Where s1 is a set of type FOO BAR PROD POW, s3 a set of type BAR POW, s2 and
    s4 the two types expressed as Strings, and s5 the operator eg "▷" or "▷-".
    Checks types with the check-types-range-restriction operation, then returns
    the postfix expression and resultant type, eg
    "x" "FOO BAR PROD POW" "y" "BAR POW" "▷" becomes "x y ▷" "FOO BAR PROD POW"
)
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type check-types-range-restriction
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ l-type
;

: ▷_ ( s1 s2 s3 s4 -- ss1 ss2 )
   (: l-value l-type r-value r-type :) 
   " ▷" l-type CLONE-STRING r-type CLONE-STRING check-types-range-restriction
   l-value sspace AZ^ r-value AZ^ "  ▷" AZ^ l-type
;

: ▷-_ ( s1 s2 s3 s4 -- ss1 ss2 )
   (: l-value l-type r-value r-type :) 
   " ▷-" l-type CLONE-STRING r-type CLONE-STRING check-types-range-restriction
   l-value sspace AZ^ r-value AZ^ "  ▷-" AZ^ l-type
;

: check-types-set-catenation ( s1 s2 s3 -- Whether appropriate types )
" INT " OVER nowspace prefix? NOT
IF
    ." Type error for " ROT .AZ
    ."  operator: Both types must start with INT: "
    SWAP .AZ ."  and " .AZ ."  offered." ABORT
THEN
OVER "  PROD POW" SWAP suffix? NOT
IF
    ." Type error for " ROT .AZ
    ."  operator: Both types must end with PROD POW: "
    SWAP .AZ ."  and " .AZ ."  offered." ABORT
THEN
DUP nowspace OVER nowspace string-eq NOT
IF
    ." Type error for " ROT .AZ ."  operator: Both types must be identical: "
    SWAP .AZ ."  and " .AZ ."  offered." ABORT
THEN    ( 3 unnecessary values on stack ) DROP 2DROP
;

: ⁀_ ( s1 s2 s3 s4 -- ss1 ss2 )
(
    Types and other details as for ^_ Strings acceptable, using AZ^ instead of ^
)
    (: l-value l-type r-value r-type :)
    l-type string string-eq r-type string string-eq AND
    IF
        l-value sspace AZ^ r-value AZ^ "  AZ^" AZ^ l-type
    ELSE
    " ⁀" l-type r-type check-types-set-catenation
    l-value sspace AZ^ r-value AZ^ "  ⁀" AZ^ l-type
    THEN
;

: check-types-set-append ( s1 s2 s3 -- Check appropriate type )
    2DUP nowspace " INT " SWAP AZ^ "  PROD POW" AZ^ SWAP nowspace
    string-eq NOT
    IF
            ." Type error for " ROT .AZ
            ."  operator: 1st type must equal INT (2nd type) PROD POW: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    DROP 2DROP
;

: ←_ ( s1 s2 s3 s4 -- ss1 ss2 ) ( Use alt-gr-Y for ← )
    (: l-value l-type r-value r-type :)
    " ←" l-type r-type check-types-set-append
    l-value sspace AZ^ r-value AZ^ "  ←" AZ^ l-type
;

: check-types-set-truncation ( s1 s2 s3 -- Check appropriate types )
    DUP nowspace int string-eq NOT
    IF
        ." Type error for " ROT .AZ ."  operator: right type must be INT: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    OVER nowspace " INT " OVER prefix? NOT OVER "  PROD POW" SWAP suffix? NOT OR
    IF
        ." Type error for " ROT .AZ
        ."  operator. Right type must start with INT and end PROD POW: "
        SWAP .AZ ."  and " .AZ ."  offered." ABORT
    THEN
    2DROP 2DROP
;

: truncate_ ( s1 s2 s3 s4 s5 -- ss1 type )
( Use alt-gr-sft-U and alt-gr-U as ↑↓ respectively )
(
    Where s1 (a sequence or INT FOO PROD POW set) and s3 (an INT) are the two
    sub-expressions, s2 and s4 the types (as above) and s5 the operator eg "↓"
    or "↑".
    Tests the types with the check-types-set-truncation operation, and returns
    an expression in postfix format with its type, the same as the type of the
    set. For example "x" "INT FOO PROD POW" "i" "INT" "↓" returns "x i ↓" and
    "INT FOO PROD POW".
)
    (: l-value l-type r-value r-type operator :)
    operator l-type r-type check-types-set-truncation
    l-value sspace r-value sspace operator AZ^ AZ^ AZ^ AZ^ l-type
;

: ↑_ ( s1 s2 s3 s4 -- ss1 ss2 ) ( alt-gr-sft-U = ↑ )
( ↑ for truncation, lose the end of the sequence )
    (: l-value l-type r-value r-type :)
    " ↑" l-type r-type check-types-set-truncation
    l-value sspace AZ^ r-value AZ^ "  ↑" AZ^ l-type
;
 
: ↓_ ( s1 s2 s3 s4 -- ss1 ss2 ) ( alt-gr-U = ↓ )
( ↓ for decapitation, lose the beginning of the sequence )
     (: l-value l-type r-value r-type :)
    " ↓" l-type r-type check-types-set-truncation
    l-value sspace AZ^ r-value AZ^ "  ↓" AZ^ l-type
;

: test-same-bracket ( s1="[" or similar s2=ditto -- error if different )
    2DUP string-eq NOT
    IF
        ." Unmatched bracket types: " .AZ ."  expected and " .AZ ."  found."
        ABORT
    THEN
    2DROP
;
 
: {_ ( -- "{" "{" null )
(
 Returns the opening brace for a set, twice and "null" because the type of the
 set is not yet known.
)
    ( No need for any checking in this instance. )
    " {" " {" NULL
;

: [_ ( -- "[" "[" null )
(
 Returns the opening square bracket for a sequence, twice and "null" because
 the type of the sequence is not yet known.
)
 ( Again no need for type-checking )
    " [" " [" NULL
;

: ,_ ( s1 s2 s3 s4 s5 -- ss1 ss2 ss3 )
(
 Requires the s1 = opening bracket type, s2 = start of a set, s3 = type,
 s4 = next element and s5 = type, or if we are at the first element,
 "{" "{" null "1" "INT" → "{" "{ 1 ," "INT"
 "{" "{ 1 , 2 ," "INT" "3" "INT" → "{" "{ 1 , 2 , 3 ," "INT"
 "(" "1 Forth" "INT STRING" "2.34" "FLOAT" →
            "(" "1 "Forth" 2.34" "INT STRING FLOAT" or similar.
 (Balance brackets here:)))
 Returns ss1 = bracket type, ss2 = set to this point and ss3 = type of element.
 Takes the bracket type and checks it is not a round bracket, otherwise the
 type checking is unnecessary since multiple types are allowed in a list in ().
 If the brackets are not () then the types of all members must be the same; the
 test-two-types-same function throws an error otherwise. There is no need for
 such a test if the s3 is null.
 Takes the starting string, adds the first element and a comma, then leaves the
 element type on the stack.
 Note this operation does not add commas, nor test the type when the bracket is
 round eg ( . . . ) because this is an argument list, which is output without
 commas in postfix, and many be heterogeneous.
)
    (: bracket l-value l-type r-value r-type :)
    bracket " (" string-eq
    IF
        l-type
        IF
        (
            Not null type: ie information already on stack; no need to catenate
            otherwise.
        )
            l-type sspace r-type AZ^ AZ^ to r-type
            l-value sspace r-value AZ^ AZ^ to r-value
        THEN
    ELSE
        l-type
        ( Again not null, so there is information on stack. )
        IF
            " ," l-type r-type check-same-types
        THEN
        ( Have to catenate regardless )
        l-value sspace r-value "  ," AZ^ AZ^ AZ^ to r-value
    THEN
    bracket r-value r-type
;

: empty-set-error
    ( " {}" " set/seq" -- ABORT )
    ( Takes the type of set/sequence brackets, the word set or sequence, and )
    ( throws an error, if empty sets are prohibited in the grammar. )
    ." Empty " DUP .AZ ."  applied to " SWAP .AZ
    ."  operator. Empty " .AZ ." s not allowed."
    ABORT
;

: }_ ( s1 s2 s3 s4 s5 -- ss1 ss2 )
(
    Where s1 is "{" to match the closing brace, s2 is the first half of the set
    expression, s3 and s5 the type of variable, which must be the same, and s4
    is the last element in the set. Example: 
" {" " { 1 , 2 , 3 ," " INT" " 4" " INT" → " INT { 1 , 2 , 3 , 4 , }" " INT POW"
)
    DUP 0= ( type is only null if we are at the beginning of the set )
    IF
        " {}" " set" empty-set-error
    THEN
(: bracket l-value l-type r-value r-type :)
    bracket " {" test-same-bracket ( feed bracket type, check correct to match } )
    l-type
    IF
        " }" l-type r-type test-two-types-same
    THEN
    r-type sspace AZ^ l-value AZ^ sspace AZ^ r-value AZ^ "  , }" AZ^
    r-type "  POW" AZ^
;

: ]_ ( s1 s2 s3 s4 s5 -- ss1 ss2 )
    DUP 0=
    IF
        " []" " sequence" empty-set-error
    THEN
    (
        " [" " [ 1 , 2 , 3" " INT" " 4" " INT" →
        " INT [ 1 , 2 , 3 , 4 , ]" " INT PROD POW"
    )
    (: bracket l-value l-type r-value r-type :)
    bracket " [" test-same-bracket ( feed bracket type, check correct to match ] )
    l-type
    IF
        " ]" l-type r-type test-two-types-same
    THEN
    r-type sspace AZ^ l-value AZ^ sspace AZ^ r-value AZ^ "  , ]" AZ^
    " INT " r-type AZ^ "  PROD POW" AZ^
;

: (_ ( (
        s1 -- s1 "brk" "" null where s1 is the function name and brk=bracket.
        Since () brackets are only used in function calls, this type of bracket
        is handled differently from [] or {}. See the )_ function.
     )
    " (" blank-string NULL
;

: ♢_ ( sub exp type op -- S♢E_exp type2 )
(
    Returns the S♢E postfix formed from the substitution and expression entered.
    The type returned is the expression's type plus "POW"; there is no
    restriction on types permitted. The only operators acceptable are "♢" & "∇",
    so the "diamond" sequence mustn't contain anything else.
) 
(: sub exp type op :) 0 VALUE obracket 0 VALUE cbracket 0 VALUE type-out
op " ♢" string-eq
IF      ( diamond found )
    "  { " to obracket "  } " to cbracket type "  POW" AZ^ to type-out
ELSE    ( nabla found )
    "  [ " to obracket "  ] " to cbracket
    int sspace type "  PROD POW" AZ^ AZ^ AZ^ to type-out
THEN 
type obracket "  <RUN " sub exp "  RUN> " cbracket AZ^ AZ^ AZ^ AZ^ AZ^ AZ^ 
type-out ;

: :=_ ( s1 s2 s3 s4 -- ss )
(
    Takes strings of the form "foo" "fooType" "exp" "expType", checks that the
    two types are the same, and returns a single string in the format
    "exp to foo". Note there is no result type required.
)
(: l-value l-type r-value r-type :)
l-value constants IN
IF
    ." Cannot assign to " l-value .AZ ." : declared as constant." ABORT
THEN    ( If l-type ends ARRAY and r-type is ARRAY, assume is empty array )
"  ARRAY" l-type nowspace suffix? array r-type string-eq AND NOT
IF
    " := (assignment)" l-type r-type test-two-types-same
THEN
r-value to_ l-value newline AZ^ AZ^ AZ^ 1LEAVE ( Why do I need 1LEAVE?? )
;

: :∈_ ( s1 s2 s3 s4 -- s5 ) (: l-value l-type r-value r-type :)
(
    Similar to :=_ above, but the r-value is a set from which an element is
    non-deterministically chosen. "x" "foo" "S" "foo POW" → "S CHOICE to x"
)
" :∈" VALUE op op l-type r-type check-types-for-set-membership
r-value "  CHOICE to " l-value AZ^ AZ^
;

: ×_ ( s1 s2 -- s3 ) 
(
    Where s1 and s2 are types eg "INT" "foo" and s3 their postfix representation
    eg "INT foo PROD".
)
sspace SWAP "  PROD" AZ^ AZ^ AZ^ ;

: ℙ_ ( s1 s2 -- s3 )
(
    Where s1 is a type eg "foo" and s3 is postfix representation eg "foo POW".
)
"  POW"  AZ^ ;

: wspace-split ( s -- s1 s2 )
(
    Where s is a string in the format "i 123" and it is split on the first
    whitespace after non-whitespace. Strips leading whitespace, goes through the
    string looking for whitespace, splitting on the first found. Throws error if
    no whitespace in the middle
)
-wspace
DUP BEGIN DUP head whitespace IN NOT OVER head AND WHILE tail REPEAT
DUP head 0= IF ." No middle space found in " .AZ ABORT THEN 
0 OVER C! 1+
;

: last-wspace-split ( s -- s s1  )
(
    Where s is a String in the format "<< 123 >> of iArr" and returns the
    original String unchanged and a pointer to the first non-whitespace
    character after the last whitespace character. No error messages. If no
    whitespace found, simply returns a duplicate of the original String
)
nowspace DUP endaz
BEGIN
    2DUP < OVER C@ whitespace IN NOT AND ( Not reached start or not w-space )
WHILE
    1-          ( Previous character )
REPEAT
    2DUP <      ( Not reached the beginning of string )
IF
    1+          ( Next character otherwise starts with w-space )
THEN
;

(
 To be used instead of multiple if-elses to call a particular bar-decorated
 operation, depending on the operator found. The seq-ops set is there so you can
 call a sequence parser if the operator found is applicable to sequences.
)
STRING INT PROD
{
    " ⁀"  ' ⁀_ |->$,I  , " ^"   ' ^_ |->$,I ,
    " ▷-" '  ▷-_ |->$,I , " ▷"   ' ▷_ |->$,I ,
    " ←"  '  ←_ |->$,I  , " ↓"   ' ↓_ |->$,I ,
    " ↑"  '  ↑_ |->$,I  ,
} CONSTANT operation-swaps
( STRING { " ⁀" , " ^" , " ←" , " ↓" , " ↑" , } CONSTANT seq-ops )

: P ( to be renamed : rsplit )
(
  s seq -- s1 s2 s3
  Where s is an expression, seq is a sequence of Strings 
  representing right-associative operators, and the result is s1, s truncated
  to the location of the 1st operator found, s2 string decapitated after
  said operator and s3 is the operator.
  Goes from left to right for right-associative operators only.
  If the operator is not found, the original string is unchanged and the
  other two results are 0 = null. In which case,
  the two null = 0 values must be deleted before the other results are used.
  The common three types of brackets () [] {} and “ ” quotes are used to ignore
  text when scanning for the operators.
)
OVER 0 0 0 (: start seq current size count op :)
seq CARD to size
BEGIN   
    current head op 0= AND  
WHILE
    l-quote current prefix?
    IF
        current string-end-finder to current
    ELSE
        current head [CHAR] ( =
        IF
            current [CHAR] ( [CHAR] ) close-bracket-finder to current
        ELSE
            current head [CHAR] [ =
            IF
                current [CHAR] [ [CHAR] ] close-bracket-finder to current
            ELSE
                current head [CHAR] { =
                IF
                    current [CHAR] { [CHAR] } close-bracket-finder to current
                THEN
            THEN
        THEN
    THEN
    0 to count  
    BEGIN  
        count size < op 0= AND
    WHILE  
        count 1+ to count  
        seq count APPLY current prefix?  
        IF
            seq count APPLY to op
        THEN  
    REPEAT  
    current 1+ to current  
REPEAT
current 1- to current
start ( 1st result on stack )
op  
IF  
    0 current C! ( truncate 1st string ) 
    current op myazlength + to current
    current ( 2nd result on stack if op /= 0 )
ELSE
    0 ( 2nd result on stack if op = 0 )
THEN
op  ( 3rd result on stack )
;
' P to rsplit

: get-return-type-function ( s1 s2 -- s3 )
(
    Where s1 is the function name and s2 the list of input types received. Calls
    the type from the "types" relation, which is in the form "foo baa # buz".
    The input type is before the # and the output type(s) after the #; it is
    permissible to have no output type, but an input type must be given.
    Uses a split operator to separate the string, check the left part is equal
    to the input string, and returns the right part, which may be blank.
    Note the types must be separated by single spaces.
)
(: f-name in-types :)
f-name nowspace to f-name in-types nowspace to in-types
types f-name APPLY CLONE-STRING hash rsplit VALUE left VALUE right VALUE op
left nowspace in-types string-eq NOT
IF
    ." Incorrect input types for function " f-name .AZ ." ." CR left nowspace
    .AZ ."  required and " in-types .AZ ."  received." ABORT
THEN
op
IF
    right nowspace
ELSE
    blank-string
THEN
;

: )_ ( s1 s2 s3 s4 s5 s6 -- ss1 ss2 )
( 
    Where s1 is type of open bracket, s2 list start, s3 is start of input type,
    s4 last element, s5 last type and s6 name of function.
    Returns arguments string, followed by type.
    eg "(" "i j k" "INT foo baa" "l" "baz" "multiply" → "i j k l multiply" "boz"
    if "multiply" takes "INT foo baa baz # boz"
    Note the types of the arguments "INT foo baa baz" must be the same as the
    function's type left of the # and the resultant type the type after the #,
    ie "boz". The types must be separated by single spaces, or they will be
    mismatched.
    This operation should be used by the Pfunction and Pfunction2 operations,
    and preceded by the (_ and ,_ operations.
) match brackets ) )
    (: bracket l-value l-type r-value r-type f-name :)
    bracket " (" test-same-bracket ( feed bracket, check correct to match () )
    ( No need to check whether same types in this instance )
    l-value sspace r-value AZ^ AZ^ nowspace sspace f-name AZ^ AZ^
    l-type 0= IF sspace to l-type THEN
    f-name l-type sspace r-type AZ^ AZ^ get-return-type-function
;

: PRINT_ ( s type -- s1 being the original formula with the instruction to print
                        appended. Type must be one of the basic types. )
nowspace
DUP int string-eq ( . for ints )
IF
    DROP "  . " AZ^
ELSE
    DUP boolean string-eq ( true or false )
    IF
        DROP "  boolean-print " AZ^
    ELSE
        DUP float string-eq ( F. for floats )
        IF
            DROP "  F." AZ^
        ELSE
            "  POW" OVER suffix? ( .SET for sets )
            IF
                DROP "  .SET " AZ^
            ELSE
                "  PROD" OVER suffix? ( .PAIR for pairs )
                IF
                    DROP "  .PAIR " AZ^
                ELSE
                    string string-eq
                    IF
                        "  .AZ " AZ^
                    ELSE
                        ." Unrecognised type to print." ABORT
                    THEN
                THEN
            THEN
        THEN
    THEN
THEN ;
(
    Above can be refactored something like this:
    STRING STRING PROD { int "  . " ↦ , boolean "  boolean-print " ↦ ,
        float "  F. " ↦ , string "  .AZ " ↦ , } VALUE print-swaps
    : PRINT_ ( DUP string string-eq IF SWAP addQuotes1 SWAP THEN "" unnecessary )
     DUP print-swaps DOM IN IF print-swaps SWAP APPLY AZ^   
    ELSE "  POW" OVER suffix? IF DROP "  .SET " AZ^ ELSE "  PROD" OVER suffix? IF   
    "  .PAIR " AZ^ THEN THEN THEN ; ( " “Campbell”" Patom PRINT_  ok.
    .AZ " Campbell"  .AZ ok
    " Campbell"  .AZ Campbellok
You can reinstate the bit about unknown type; you can institute a way to
decapitate at the last space and add "PROD"↦".PAIR" and "POW"↦".SET" to that
relation. )
)

: bracket-avoider-for-lsplit ( s s1 -- s2 )
(
 s is a string, ending in brackets or close quotes at s1, and this function
 looks for the opening half of brackets etc from the following list:
 ie “”, (), [] and {}. If one is found it uses existing functions to find the
 "pair" of that character and return a pointer to that point in the string as s2
)
(
    This can probably be refactored like this, only that goes L>R and I want R>L:
    INT INT PROD { CHAR ( CHAR ) |-> , CHAR [ CHAR ] |-> , CHAR { CHAR } |-> , }
    VALUE bracket-pairs
    CHAR ( bracket-pairs OVER APPLY SWAP EMIT EMIT ()
    CHAR : bracket-pairs DOM IN . 0 ok
    CHAR ( bracket-pairs DOM IN . -1
    Then use the type of bracket as an argument to get the type of close bracket
    (
    : bracket-avoider 
    l-quote OVER prefix?
    IF
        string-end-finder
    ELSE 
        DUP head bracket-pairs DOM IN
        IF
            DUP head bracket-pairs OVER APPLY close-bracket-finder
        THEN
    THEN
    ;
    ) balance brackets: ))
)
r-quote OVER prefix?
IF
    string-start-finder
ELSE
DUP head [CHAR] ) =
IF
    [CHAR] ( [CHAR] ) open-bracket-finder
ELSE
DUP head [CHAR] ] =
IF
    [CHAR] [ [CHAR] ] open-bracket-finder
ELSE
DUP head [CHAR] } = 
IF
    [CHAR] { [CHAR] } open-bracket-finder
THEN THEN THEN THEN
( Probably amenable to refactoring with a bracket-matching relation. )
;

: lsplit ( s seq -- s1 s2 op )
( s is a string in the form "a + b" and seq is a sequence of strings eg )
( ["+", "-"], s1 is the string as far as the operator, s2 after it, and op )
( is the operator. If op is null = 0, the value below it must be regarded as a )
( nonsense value and deleted from the stack. )
( This function skips over any text in “”, (), [] and {} )
( string seq already on stack ) 0 0 0 0 ( 6 values now on stack )
(: string seq end op count size :) 
string endaz to end ( One of the 0s gone )
seq CARD to size    ( Second 0 gone      )
BEGIN
    end string >= op 0= AND 
WHILE
    0 to count
    end bracket-avoider-for-lsplit to end ( Skip text in brackets etc )
    BEGIN
        size count > op 0= AND ( Not reached start of string, nor found op )
    WHILE 
        count 1+ to count      ( Go through potential operators )
        seq count APPLY end
        prefix? 
        IF 
            seq count APPLY to op
        THEN 
    REPEAT 
    end 1- to end    ( Count backwards to start of string )
REPEAT
op
IF
    end 1+ to end    ( Terminate string at op )
    0 end C!
    end op myazlength + to end ( Move forward length of op )
THEN
string end op
;

: lsplit-for-minus ( s seq set op-string -- s1 s2 op )
(
 s is a string in the form "a + b" and seq is a sequence of strings 
 eg  ["+", "-"], s1 is the string as far as the operator, s2 after it, and op
 is the operator, eg "-"
 This is for "-" which is an operator that can have two uses: subtraction and
 sign-change. The subtraction operator is preceded by a number, identifier or
 a close round bracket. If any other character precedes the minus, it is a
 sign-change operator which needs to be parsed differently. Obviously this
 operation can be used for other Jekyll-and-Hyde operators mutandis mutatis.
 Usage: text plusminus antecedents " -" lsplit-for-minus.
 Similar to the ordinary lsplit operation with the additional check for the
 operator, and which character [whitespace excepted] precedes it.
 Note that if the op value on the stack is null = 0, the value below it must
 be regarded as a nonsense value and deleted from the stack.
 Typical usage: (text) plusminus antecedents " -" lsplit-for-minus
)
( string seq set minus: already on stack ) 0 0 0 0 ( 8 values now on stack )
(: string seq set minus end op count size :)
string endaz to end ( One of the 0s gone )
seq CARD to size    ( Second 0 gone      )
BEGIN
    end string >= op 0= AND
WHILE
    0 to count
    end bracket-avoider-for-lsplit to end ( skip text in brackets, etc )
    BEGIN
        size count > op 0= AND
    WHILE
        count 1+ to count
        seq count APPLY end prefix?
        IF
            seq count APPLY to op
            ( Like ordinary lsplit in that it applies the string found to op )
            op minus string-eq
            ( If we have the Jekyll-and-Hyde operator, count back to last )
            ( printing character before it. )
            IF
                BEGIN
                    end 1- head 32 = end string > AND
                WHILE
                    end 1- to end
                REPEAT
                end 1- head set IN NOT
                IF
                    0 to op
                THEN
            THEN
        THEN
    REPEAT
    end 1- to end
REPEAT
op
IF
    end 1+ -blanks to end ( Go after next space )
    0 end C!              ( Terminate string with null character )
    end op myazlength + to end ( Move forward length of "op" string )
THEN
string end op
;


( All four redefined to "P" below. )
NULL OP Pexpression
NULL OP Pexpression2
NULL OP Plist
NULL OP Plist2

: PargumentList ( "(" "" 0 s -- s1 type ) 
(
    Where s is the original string in a format like "x, y, z" and s1 is that
    string in a suitable postfix format eg "x y z" and type is the types
    eg "foo foo bar".
    Assuming the comma operator associates to the left (as in the grammar; it
    should really be non-associative), this function uses lsplit to divide up
    the string on commas. The right part is put onto the user stack and the
    function recurses on the left part.
    When the bottom of the recursion is reached, the variable name and type are
    retrieved from Pexpression. The names are catenated, the types being shunted
    onto and off the user stack and catenated later.
    Uses the ,_ operation, which requires "(" "" null on the stack before 1st
    execution: use the (_ operation to achieve that: must be followed by )_
) balance brackets ) )
comma lsplit 0=
IF ( no , operator found )
    DROP Pexpression 
ELSE 
    PUSH                ( right substring onto user stack ) 
    RECURSE             ( on left substring ) 
    ,_                  ( join results to date with ,_ operation )
    POP Pexpression     ( on former right substring )
THEN ;

NULL OP Puminus

: Pfunction ( s -- ss1 ss2 )
(
    Where s is an infix string in the format foo(x, y, z) and ss1 is its postfix
    representation, "x y z foo" and ss2 its type. The type is found by entering
    input and output types for the function joined by a hash sign eg
    "int int int # foo baa".
    Note single spaces must be used between types: "int int" not "int  int".
    Takes the expression, separates out the argument list inside (), throwing an
    error if the arguments list is empty. For no-arguments functions write "foo"
    rather than "foo()".
    What follows is done with the PargumentList operation.
    The arguments list is parsed and each subexpression, separated by commas, is
    an expression which is sent to the Pexpression parser. This produces a
    postfix argument and its type. The arguments and types are put back and
    forth onto the user stack and catenated on the stack.
    Finds the types for the function from the types set, splits around the at
    sign, and checks that the left half (minus spaces) is the same as the
    combination of the types for the arguments.
    Returns the output type of the function, in the example "foo baa".
    A function with a single output type should be used for assignments, but a
    function with a multiple return type can be used as the argument for another
    function taking multiple input types, which types must be identical.
)
( comments for stack contents after passing "  foo(ii, jj, kk)  " )
PUSH (_ POP nowspace DUP endaz
( stack: 5 items = "(" "" null "foo(ii, jj, kk)" ")" )
DUP ROT ROT [CHAR] ( [CHAR] ) open-bracket-finder
( stack: 6 items = "(" "" null ")" "foo(ii, jj, kk)" "(ii, jj, kk)" )
( Now we have "(" "" null end of string, start of string, and open bracket on stack ) )
ROT 0 SWAP C! ( Get rid of final close bracket )
( stack: 5 items  = "(" "" null "foo(ii, jj, kk" "(ii, jj, kk" ) ) )  )
0 OVER C! ( Get rid of open bracket, then to next character with 1+ ) 1+
( stack = "(" "" null "foo" "ii, jj, kk" ) )
( Put name of function onto user stack for use later on. )
SWAP PUSH
( stack = "(" "" null "ii, jj, kk" Ustack = "foo" ) )
PargumentList
( stack = "(" "ii jj" "INT1 INT2 "kk" INT3" Ustack = "foo" ) )
( Retrieve function name )
POP ( stack = "(" "ii jj" "INT1 INT2" "kk" "INT3" "foo" ) )
)_ 
SWAP last-wspace-split operation-name string-eq
IF  ( Change name of operation to "RECURSE" for recursive programming. )
    operation-name truncate recurse AZ^
THEN
SWAP
;

: PargumentList2 ( "(" "" 0 s -- s1 )
(
    Where s is the input text eg 1, 2, 3 and s1 the output, including the "" and
    newlines (not shown), eg " 1" " INT" ,_ " 2" " INT" ,_ " 3" " INT"
    Splits on the comma with lsplit, recursing to the left and parsing the right
    subexpression as an "expression". Catenates all the strings to form a single
    output value.
    The output can be executed, and uses the ,_ operation which requires ( "" 0
    on the stack beforehand, so " (_" must be added to the start of the string.
) balance brackets ) ) )
comma lsplit 0= ( No operator found: right string is nonsense )
IF
    DROP Pexpression2 ( On left string )
ELSE
    PUSH ( Retain right for later use )
    RECURSE comma-bar AZ^ ( Parse, and add ,_ )
    POP Pexpression2 AZ^ ( Retrieve right, parse and catenate )
THEN ;

: Pfunction2 ( s -- s1 )
(
    Where s is an infix string as input eg foo(x, y, z) and ss1 its intermediate
    representation, eg (_ " x" " xfoo" ,_ " y" " ytype" ,_ " z" " typez" )_
    including those quotes and newlines.
    Splits a string on its ( paired to the last ), inserting null characters
    there and at the end, so as to remove that pair of ().
    The right substring is parsed as a list with the Plist2 
)
( Start by putting bracket on stack )
" (" bar-line AZ^ SWAP ( stack = "(_" "foo(x, y, z)" ) )
( Split by matching brackets )
nowspace DUP endaz DUP ROT ROT ( ( stack = "(_" ")" "foo(x, y, z)" ")" )
[CHAR] ( [CHAR] ) open-bracket-finder
( stack = "(_" ")" "foo(x, y, z)" "(x, y, z)" )
( Split string by putting \0 instead of the brackets )
ROT 0 SWAP C! 0 OVER C! 1+
( stack = "(_" "foo" "x, y, z" ) )
( Put name on user stack ) SWAP PUSH
PargumentList2 AZ^
( stack = (_ " x" " xfoo" ,_ " y" " ytype" ,_ " z" " typez" ) )
( Need to add " foo" with "" to end of text. )
POP addQuotes1 AZ^
( stack = (_ " x" " xfoo" ,_ " y" " ytype" ,_ " z" " typez" "foo" ) )
" )" bar-line AZ^ AZ^
( stack = (_ " x" " xfoo" ,_ " y" " ytype" ,_ " z" " typez" "foo" )_ )
;

: Pstring ( s -- s1 "STRING" )  
(
    Take a String delimited by “...” and using string-end-finder, parse it by
    removing the outermost pair of quote marks.
    Returns that shortened String with added "" and the type STRING without "".
)
DUP string-end-finder rquote-length - ( One quote before end of String )
0 SWAP C!
lquote-length + ( One quote length after start of String ) addQuotes1
string ( STRING )
;

: array[_ ( i -- i "" 0 ) ( Where i is 0 for an empty array, 1 for a full array )
blank-string 0 ;

: array,_ ( i l-value l-type/null r-value r-type -- i+1 l-value,r-value type )
(
    Changes 1 "" 0 "1" "INT" to 2 ", 1" "INT" testing whether the types are the
    same or the left type is null.
)
(: count l-value l-type r-value r-type :)
l-type IF " Array membership" l-type r-type test-two-types-same THEN
count 1+
l-value comma-space r-value sspace AZ^ AZ^ AZ^ r-type
;

: array]_ ( i value l-type r-value r-type -- array-text type-array )
(
    Where i is the number of members, and value a list of elements starting with
    comma and l-type the type of the members, eg 3 ", 1 , 2 " "INT" "3" "INT"
    Returns "HERE 3 , 1 , 2 , 3 , " and "INT ARRAY"
    Tests whether the types passed, if not null, are the same.
)
(: count l-value l-type r-value r-type :)
l-type IF " Array membership" l-type r-type test-two-types-same THEN
" HERE " count iToAZ AZ^ sspace AZ^ l-value AZ^ comma-space AZ^
r-value AZ^ sspace AZ^ comma-space AZ^
r-type sspace array AZ^ AZ^
;

( NULL OP Patom )

: ParrayList ( i "" 0 "1, 2, 3" -- i+3 ", 1 , 2" "INT" "3" "INT" )
(
    Requires the array[_ be called first leaving 0/1 for empty/full arrays, ""
    and 0 for the type on the stack first.
    Recursively iterates the "1, 2, 3" String, calling Patom and array,_ if
    there are multiple members, leaving the last element for ParrayLiteral to
    add with array]_
)
comma rsplit
IF
    PUSH Pexpression array,_ POP RECURSE
ELSE
    DROP Pexpression
THEN
;

: ParrayLiteral ( s -- s1 s2 )
(
    Where s is in the form "ARRAY[1, 2, 3]" and returns "HERE 3 , 1 , 2 , 3 ,"
    and the type "INT ARRAY". Strips the beginning and the end with bracket
    remover, and passes the contents to ParrayList.
)
nowspace
" ]" OVER suffix? NOT
IF ." [ without ending ] in array: " .AZ ."  passed" ABORT THEN
array decapitate [CHAR] [ [CHAR] ] bracketRemover2
DUP nowspace myazlength
    IF 1 SWAP PUSH array[_ POP ParrayList array]_
ELSE
    DROP " HERE 0 , " array
THEN ;

NULL OP Pdiamond ( used in Patom, defined 3000 lines below! )

: Patom ( s -- s1 s2 )
(
    Where s is the text of an "atom" and s1 is its type. Accepts true/TRUE and
    false/FALSE as Booleans, anything starting with letters as identifiers (or
    functions if they contain round brackets), anything starting with a digit/0
    as a number, or bracketed expressions with () [] and {}.
    Does not accept lists; these are parsed by the Plist operation.
)
nowspace
DUP true string-eq OVER True string-eq OR
IF
    DROP True boolean
ELSE
    DUP false string-eq OVER False string-eq OR
    IF
        DROP False boolean
    ELSE
        DUP letter stringbegins?
        IF
            " ARRAY[" OVER prefix?
            IF
                ParrayLiteral
            ELSE
                DUP [CHAR] ( stringcontainschar?
                IF
                    Pfunction
                ELSE
                    Pid
                THEN 
            THEN
        ELSE
            DUP digits0. stringbegins?
            IF
                Pnumber
            ELSE
                DUP head [CHAR] ( =
                IF
                    [CHAR] ( [CHAR] ) bracketRemover
                    Pexpression
                ELSE
                    DUP head [CHAR] - =
                    IF
                        Puminus
                    ELSE    ( Ripe for refactoring with [] function: duplicate code should be in Psequence or Pset )
                        DUP head [CHAR] [ =
                        IF
                            [CHAR] [ [CHAR] ] bracketRemover
                            " ♢" OVER isSubstringOf?
                            IF   ( Can't nest S♢E inside [] or S∇E )
                                ." Error: Expression " CR .AZ
                                ."  contains ♢ inside [...]"
                                ABORT
                            THEN
                            " ∇" OVER isSubstringOf?
                            IF   ( Preferential choice with ∇ in )
                                Pdiamond
                            ELSE ( Ordinary sequence )
                                PUSH [_ POP Plist ]_
                            THEN
                        ELSE    ( refactor as above with Pset, moving NULL OP Pset earlier )
                            DUP head [CHAR] { =
                            IF
                                [CHAR] { [CHAR] } bracketRemover
                                " ∇" OVER isSubstringOf?
                                IF   ( Can't nest S∇E inside S♢E )
                                    ." Error: Expression " CR .AZ
                                    ."  contains ∇ inside {...}"
                                    ABORT
                                THEN
                                " ♢" OVER isSubstringOf?
                                IF   ( An S ♢ E expression )
                                    Pdiamond
                                ELSE ( An ordinary set )
                                    PUSH {_ POP Plist }_
                                THEN
                            ELSE
                                l-quote OVER prefix?
                                IF
                                    Pstring
                                ELSE
                                    DUP ." Passed: " .AZ
                                    ."  Type not yet used" 10 EMIT ABORT
                                    ( Other types can be added, eg arrays )
                                THEN
                            THEN
                        THEN
                    THEN
                THEN
            THEN
        THEN
    THEN
THEN
;

: Patom2 ( s -- s1 )
(
    Where s is the text of an atom and s1 is it returned along with its type.
    Examples are 123 --> " 123" " INT" and i --> " i" " INT" and
    foo(i, j, k) --> " i j k foo" " foo" where the postfix representation is
    followed by the return type. Note that quotes are added to the strings.
    Note some of the inputs accepted by this function are not actually atoms.
    Other examples are bracketed expressions, where the () may be removed, or
    a set/sequence where the {}/[] are removed and replaced by calls to {_ }_ or
    similar. For example: {1, 2, 3} --> {_ " 1" ,_ " 2" ,_ " 3" }_
    These output strings can be fed back to the FORTH RVM so the {_ ,_ and }_
    may be executed.
    See also Patom and ParithAtom2.
)
nowspace
DUP true string-eq OVER True string-eq OR
IF
    DROP True boolean addQuotes2
ELSE
    DUP false string-eq OVER False string-eq OR
    IF
        DROP False boolean addQuotes2
    ELSE
        DUP letter stringbegins?
        IF
            DUP [CHAR] ( stringcontainschar?
            IF
                Pfunction2
            ELSE
                Pid addQuotes2 ( Add other possibilities here eg lambda )
            THEN
        ELSE
            DUP digits0. stringbegins?
            IF
                Pnumber addQuotes2
            ELSE
                DUP head [CHAR] ( =
                IF
                    [CHAR] ( [CHAR] ) bracketRemover2 Pexpression2
                ELSE
                (
                    This bit can be refactored for other brackets eg in UTF-8 by
                    altering the lengths of strings catenated with _
                    The [] and {} don't seem to work
                )
                    DUP head [CHAR] [ = OVER head [CHAR] { = OR
                    IF ( Either [foobar] or {foobar} )
                        DUP CLONE-STRING 0 OVER 1+ C! bar-line AZ^
                        ( Copy and keep 1st character only, catenate _ )
                        SWAP DUP endaz bar-line AZ^
                        ( Duplicate and find last character and catenate _ )
                        PUSH ( Keep 2nd value, hiding top value for later )
                        1+ 0 OVER endaz C! Plist2
                        ( Take 1st and last characters off, parse as list )
                        POP AZ^ AZ^ ( Retrieve former top value and catenate )
                    ELSE
                        l-quote OVER prefix?
                        IF
                            Pstring addQuotes1 AZ^
                        ELSE
                            ." Un-parseable string: " .AZ ."  passed." ABORT
                        THEN
                    THEN
                THEN
            THEN
        THEN
    THEN
THEN
;

NULL OP Parith
NULL OP Parith2

: array_ ( s1 s2 s3 -- s4 s5 )
( arrString arrType iString -- postfixString type )  
(
    Where s1 is the name of an array and s2 its type and s3 an arithmetic
    expression returning an int. Checks the types, returning the postfix
    expression for the i-th    member of the array, and its type, which is the
    type of the array truncated by the word ARRAY.
    "arr" "FOO ARRAY" "1 + 2 * 3" → "<< 1 2 3 * + >> of arr" "FOO"
)
(
    Recurse for multiple indices: "arr" Pid "3" array_ "4" array_ works nicely.
)
nowspace ROT nowspace ROT nowspace CLONE-STRING ( iString arrString arrType )
ROT DUP ( Clone & retain original iString in case needed for error message )
CLONE-STRING Parith ( arrString arrType iString iStringPostfix iType )
DUP int string-eq    
IF         
DROP NIP     ( arrString arrType iStringPostfix )
ELSE    
." Array index should be of type INT: index given = "
ROT .AZ ." , whose type is " .AZ ABORT     
THEN  
OVER "  ARRAY" SWAP suffix?     
IF  
SWAP "  ARRAY" truncate SWAP  ( arrString outputType iStringPostfix )
ELSE  
." Type of " ROT .AZ ."  should end in ARRAY: actual type = " SWAP .AZ ABORT  
THEN  
"  << " SWAP "  >> of " AZ^ AZ^ ROT AZ^ SWAP ( <<i>>-of-arrString outputType )
;

: split-for-arrays ( s1 -- s2 s3 )
(
    Where s1 is an array-type expression eg "arr[1]" and the output is the
    first part and the index. Can accept multiple indices. For example,
    "arr[1]" → "arr" "1" or "array[2][3]" → "array[2]" "3".
    Splits on [ assuming there are no other possible characters separating
    array indices
)
DUP endaz [CHAR] [ [CHAR] ] open-bracket-finder 0 OVER C! 1+ " ]" truncate
( SWAP Pid ROT array_ )
;

: P ( to become : Parray ) ( s -- s1 s2 )
(
    Where s is an array expression, eg "arr[1][2][3]" and it must be in types as
    "foo ARRAY ARRAY ARRAY" with exactly one "ARRAY" per [i], and the output is
    the array element in postfix eg << 3 >> of << 2 >> of << 1 >> of arr" and
    its type "foo". Uses the array_ operation recursively like this
    "arr" "foo ARRAY ARRAY ARRAY" "1" array_ "2" array_ "3" array_ →
    "<< 3 >> of << 2 >> of << 1 >> of arr" "foo".
    Splits on [ with the split-for-arrays operation.
)
( arr[1] ) split-for-arrays    ( arr    1 )
OVER [CHAR] [ stringcontainschar? ( Recurse to the left if arr2[1] on left )
IF
    PUSH RECURSE POP array_
ELSE
    SWAP Pid ROT array_
THEN
; ' P to Parray

: ParithAtom ( s -- s1 s2 )
(
    Where s is a string input which may represent an arithmetical value, eg 123,
    123.45, i, foo(i, j, k), (bar). s1 is the original string unchanged or with
    brackets taken off, except for function calls which are returned in postfix
    format like "i j k foo". s2 is the type, eg "INT" "FLOAT".
    In the case of (exp) the brackets are removed and the text passed back to
    the Parith parser (any text which reaches this parser must represent arith-
    metical values), otherwise the identifier, function and number parsers are
    chosen, depending on the beginning of the text and whether it contains any
    brackets.
    Differs from the Patom operation in that this operation only handles arith-
    metical values.
)
nowspace
DUP head [CHAR] ( =
IF
    [CHAR] ( [CHAR] ) bracketRemover2
    Parith
ELSE
    DUP digits0. stringbegins? ( Begins 0123456789, must be a number )
    IF
        Pnumber
    ELSE
        DUP letter stringbegins? ( Begins A-Za-z, must be identifier )
        IF
            DUP [CHAR] ( stringcontainschar?
            IF         ( Must be function call )
                Pfunction
            ELSE       ( Must be ordinary identifier )
                Pid
            THEN
        ELSE           ( Anything else is an error )
            ." Text in incorrect format for arithmetic atom: " .AZ ."  passed."
            ABORT
        THEN
    THEN
THEN
;

: ParithAtom2 ( s1 -- s2 )
(
    Where s1 is in the form i,  and s2 " i" " INT" or similar. Like ParithAtom,
    taking a String known to represent an arithmetical value. The left half is
    the original String (or function calls in postfix eg foo(i, j, k) becomes
    i j k foo) and the right half the type, both with " quotes" as appropriate.
    Bracketed expressions have the brackets removed and are passed back to
    Parith2
)
(
    function calls not yet implemented. Consider how to refactor out the
    duplication with ParithAtom.
)
nowspace
DUP head [CHAR] ( =
IF
    [CHAR] ( [CHAR] ) bracketRemover2
    Parith2 ( returns one value with quotes already supplied: no need to alter )
ELSE
    DUP digits0. stringbegins? ( starts with 0123456789, must be a number )
    IF
        Pnumber ( returns two strings, needs quotes adding )
        addQuotes2
    ELSE
        DUP letter stringbegins? ( Begins A-Za-z, must be identifier )
        IF
            DUP [CHAR] ( stringcontainschar? ( Function call )
            IF         ( Must be function call )
                Pfunction2 ( .AZ ."  passed: function not yet implemented." ABORT )
            ELSE       ( Must be ordinary identifier )
                Pid    ( returns two strings which need quotes adding )
                addQuotes2
            THEN
        ELSE
            ." Text in incorrect format for arithmetic atom: " .AZ ."  passed."
        THEN
    THEN
THEN
;

: rsplit-for-uminus ( s seq -- s1 s2 s3 )
(
    Where s is an input string, eg "-123" "-123.45" "-123.45e67" "123.45e-67" or
    "-123.45e-67" or similar, which is split on the strings in the seq, eg
    STRING [ " -" , ] into a left subexpression (s1) right subexpression (s2)
    and operator (s3), if the appropriate operator is found. The left substring
    will be empty if an operator is found.
    Takes advantage of the uminus operator being unary and right-associative, so
    it must be the first real character found; if anything other than whitespace
    precedes it, this operation returns the input unchanged (s1) and 0 for the
    other two values; this means it behaves the same way as rsplit.
)
(: string seq :) seq CARD VALUE size 0 VALUE count 0 VALUE op
string -blanks to string
BEGIN
    count size < op 0= AND
WHILE
    count 1+ to count
    seq count APPLY string prefix?
    IF
        seq count APPLY to op
    THEN
REPEAT
op
IF
    blank-string string op myazlength +
ELSE
    string 0
THEN
op
;

: rsplit-for-keywords ( s  s1 -- s2 s3 s1 )
(
    Where s is a string of the form "i < 3 THEN i := i + 1" and s1 a keyword eg
    "THEN" sought. Finds the keyword, preceded and followed by whitespace, but
    ignores it in quotes preceding. This is only suitable for keywords like THEN
    or DO which must be preceded by a single Boolean expression, not for ELSE
    which may have nested instructions to its left.
    Returns the left part "i < 3" as s2 right part "i := i + 1" as S3 and s1; if
    the keyword was not found, s1 is replaced by NULL which means it must be
    regarded as a syntax error.
)
TRUE PUSH   ( TRUE means you need to continue the loop )
OVER        ( "i < 3 THEN i := i + 1" "THEN" "i < 3 THEN i := i + 1" )
BEGIN 
    DUP head POP DUP PUSH AND ( Non-0 character on string, TRUE on US )
WHILE 
    l-quote OVER prefix?
    IF      ( Quoted String: go to end of String )
        string-end-finder
    THEN 
    2DUP prefix?
    IF      ( Keyword found: check preceded & followed by whitespace )
        DUP 1- head whitespace IN
        IF
            2DUP SWAP whitespace followed-by?
            IF  ( Put FALSE on US )
                POP DROP FALSE PUSH
            THEN
        THEN
    THEN 
    1+      ( Next character )
REPEAT 
0 OVER 1- C!        ( Put null just before keyword )
1- OVER myazlength + SWAP   ( 1 character beyond keyword )
POP IF DROP NULL THEN
( If TRUE on US, failed to find keyword, so leave NULL as error marker )
;

: rsplit-for-keywords2
(
    Similar to rsplit-for-blocks, but splits around a single keyword, eg ELSE,
    which must be a separate word from the rest of the code (unlike operators,
    which can run against operands like this "i:=99"). Takes a string, already
    stripped of its surrounding keywords, and counts pairs of keywords until it
    finds the sought token. For example
    "IF j > 4 THEN i := 99 ELSE i := 1 END ELSE i := 0" is the THEN part of an
    IF-THEN but can itself split on the second ELSE. Typical usage:
    <text above> "ELSE" start-keywords end-keywords rsplit-for-keywords2, which
    returns "IF j > 4 THEN i := 99 ELSE i := 1 END " " i := 0" "ELSE", spaces
    retained as shown.
)
(: string split starts ends :)
( The bit about skipping IF...END etc should be refactored into another operation )
0 VALUE op
0 VALUE count
starts CARD VALUE start-size
ends CARD VALUE end-size
0 VALUE end-count
0 VALUE token
string nowspace to string
string VALUE current
BEGIN
    current head op 0= AND ( Iterate until found end of String or "op" found )
WHILE
    0 to count
    BEGIN
        count start-size < ( Iterate all members of "starts" )
    WHILE   ( Increment end-count if start token found, eg IF not QUIFF )
        count 1+ to count
        starts count APPLY to token
        token current prefix? current token whitespace followed-by? AND
        ( Found token followed by whitespace )
        IF
            current token >
            IF
                current 1- head alphanumeric IN NOT ( Not preceded by alphanum )
                IF
                    end-count 1+ to end-count
                THEN
            ELSE    ( . . . or is beginning of string )
                end-count 1+ to end-count
            THEN
            current token myazlength + to current ( Move beyond "token" )
        THEN
    REPEAT 
    l-quote current prefix?
    IF  ( Skip text in quotes )
        current string-end-finder to current
    THEN
    current head [CHAR] ( =
    IF  ( Skip (). If they have managed to put (...END...) it's an error )
        current [CHAR] ( [CHAR] ) close-bracket-finder to current
    THEN
    current 1+ to current ( this line can be moved upward in other operation too )
    0 to count
    end-count
    IF  ( No point in seeking END if no START has been found. )
        BEGIN
            count end-size <
        WHILE   ( Decrement end-count if END or similar found )
            count 1+ to count
            ends count APPLY to token
            token current prefix? current 1- head alphanumeric IN NOT
            current token whitespace0; followed-by? AND AND ( Allow \0 at string end )
            IF
                current token myazlength + to current
                end-count 1- to end-count
            THEN
        REPEAT
    THEN
    end-count 0=
    IF
        split current prefix? current 1- head alphanumeric IN NOT
        current split whitespace followed-by? AND AND ( Never end of string here )
        IF
            split to op
        THEN
    THEN
REPEAT
op
IF
    0 current C!
    current op myazlength + to current
THEN
string current op
;

: rsplit-for-blocks ( s split-seq start-seq end-seq -- s1 s2 s3 )
(
    Where s is a text in a format like "i := i + 3; PRINT i" or
    "i := 0; WHILE i < 10 DO i := i + 1; PRINT i END".
    In the latter case, a recursive splitting on the ; will result in the WHILE
    and END being dissociated from each other on the second pass. To this end,
    a similar technique to counting brackets ()[]{} is used; whenever a member
    of the "start" sequence (eg ["WHILE", "IF", "CHOICE"]) is encountered, a
    counter is incremented, and for each member of the "end" sequence
    (eg ["END", "FI"]) that counter is decremented.
    Until that counter is 0, this operation simply iterates the string looking
    for end keywords. When there are no end keywords to look for, splits the
    string on the members of the "split" sequence (eg [";"]),
    into left text (=s1) right text (=s2) and operator (=s3).
    If an operator is found, three values on the stack can be used.
    If no operator is found, the top value on the stack will be 0, and both top
    and 2nd values on the stack must be discarded as nonsense values. I
    Typical usage:
    "WHILE i < 3 DO i := i + 1; PRINT i END; j := j * 2" sequence start-keywords
       end-keywords rsplit-for-blocks
    To find the ; at the end of an operation, add "VARIABLES" and "≙" to the
    start-keywords seq.
)
(: string splits starts ends :) 0 VALUE op 0 VALUE count
splits CARD VALUE split-size starts CARD VALUE start-size
ends CARD VALUE end-size 0 VALUE end-count 0 VALUE token
string nowspace to string string VALUE current
BEGIN
    current head op 0= AND ( Iterate until end of string or "op" found. )
WHILE
    0 to count ( Seek a "start" token )
    BEGIN
        count start-size < ( Iterate the "start" keywords sequence. )
    WHILE
    ( Increment end-count if . . . )
        count 1+ to count
        starts count APPLY to token
        token current prefix? ( . . . IF CHOICE WHILE etc at this point . . . )
        current token whitespace followed-by? AND ( . . . followed by wspace )
        IF
            current string >
           IF
                current 1- head alphanumeric IN NOT
                IF                      ( . . . and not preceded by alphanum. )
                    end-count 1+ to end-count
                THEN
            ELSE
                end-count 1+ to end-count  ( . . . or at beginning of the text )
                current token myazlength + to current
                ( Move on length of the token )
            THEN
        THEN
    REPEAT
    l-quote current prefix?
    IF  ( Skip over all parts in quotes. )
        current string-end-finder to current
    THEN
    current C@ [CHAR] ( =
    IF  ( Skip all text in brackets )
        current [CHAR] ( [CHAR] ) close-bracket-finder to current
    THEN
    0 to count
    BEGIN
        count end-size <
    WHILE
    ( Decrement end-count if . . . )
        count 1+ to count
        ends count APPLY to token
        token current prefix? ( . . . END etc at this point . . . )
        current 1- head alphanumeric IN NOT ( not preceded by alphanum . . . )
        current token whitespace0; followed-by?
            AND AND     ( . . . and followed by w " ∇" space ; or end of string. )
        IF
            end-count 1- to end-count
            current token myazlength + to current
            ( Move on length of the keyword )
        THEN
        
    REPEAT
    end-count 0=
    IF
        0 to count
        BEGIN
            count split-size < op 0= AND
        WHILE
            count 1+ to count
            splits count APPLY to token
            token current prefix?
            IF
                token to op
            THEN
        REPEAT
    THEN
    current 1+ to current
REPEAT
op
IF
    0 current 1- C!
    current op myazlength + 1- to current
THEN
string
current
op ;

: Puminus2
( s -- s1 )
(
    where s might be in the form -123 or -i and s1 is in the form
    " 123" " INT" uminus_ or " i" " INT" uminus_ which can be passed to uminus_
    later, when any error messages will appear. Uses rsplit to find uminus; if
    no operator, goes directly to ParithAtom2.
    This version only accepts something already presumed to be an arithmetical
    expression
)
uminus rsplit-for-uminus
DUP 0=
IF
    2DROP ParithAtom2
ELSE
    ( No need to check operator type: only one kind available. Recurse right
    subexpression only. )
    DROP NIP RECURSE " uminus" bar-line AZ^ AZ^
THEN
;

( : Puminus ) : P ( s -- s1 s2 )
(
    To be redefined as Puminus
    s is the original String eg " - x" which may or may not have a sign-change
    operator at its top level. Works by using rsplit to divide into 3 parts; if
    the operator is null, returns the string unchanged and its type. Otherwise
    it takes the sign-change operator off and returns the string in the format
    " 33 -1 *" and " INT". The sign-change operator is right-associative and
    unary.
)
uminus rsplit-for-uminus
DUP 0=
IF
    2DROP ParithAtom
ELSE
    DROP NIP RECURSE uminus_
THEN
;

' P to Puminus

: PuminusExp2 ( s -- s1)
(
    Where s is the input, eg -123 and s1 the output eg " 123" " INT" uminus_
    catenated with the quotes and _\n This might not necessarily be arithmetical
    (cf Puminus and PuminusExp); in which case the text is passed unchanged to
    Patom2. The output can be fed to the FORTH RVM for execution of the tagged
    operations, which may throw errors.
    Uses rsplit because sign-change - is a right-associative unary operator.
)
uminus rsplit-for-uminus
0=
IF
    DROP Patom2
ELSE
    NIP RECURSE " uminus" bar-line AZ^ AZ^ ( No need to test type of operator )
THEN
;

: PuminusExp ( s -- s1 s2 )
(
    Where s is the original string, eg "-3" which is split with rsplit. If no
    operator is found, the "right subexpression" is passed to Patom and returned
    unchanged with its type, otherwise passes the right subexpression to Puminus
    which only handles arithmetic expressions, returning a postfix string eg
    "3 -1 *" and type eg "INT". The sign-change operator is a right-associative
    unary operator.
)
uminus rsplit-for-uminus
DUP 0=
IF
    2DROP Patom
ELSE
    DROP NIP Puminus ( Must be arithmetic-Puminus rather than recurse ) uminus_
THEN
;

: Pterm ( s -- s1 s2 )
(
 s being the original string eg "a * b" which might have a multiply or divide
 operator at its top level. Uses lsplit to divide into three parts; if the 3rd
 part (the operator) is null, passes on to the next parser (Puminus),otherwise
 returns the expression in postfix format "a b *". In all cases, the postfix
 expression is followed by its type. The left part from the
 lsplit is parsed resursively.
)
timesdivide lsplit
DUP 0=
IF
    2DROP Puminus
ELSE
    PUSH PUSH RECURSE ( Recursively parse left half )
    POP Puminus       ( Pass right half to next parser )
    POP               ( Operator )
    multiplyDivide    ( Three values to */ operator )
THEN
;

: Pterm2 ( s -- s1 )
(
    Where s is in the form 123 * 456 or similar, and the String is split with
    timesdivide and the lsplit operation. Assuming an operator is found, the
    left subexpression recurses, the right subexpression is passed to the next
    parser (Puminus2) and the whole lot is catenated with the operator to form a
    String in this format: " 123" " INT" " 456" " INT" *_ which is later passed
    to the *_ operation; any errors should become obvious then.
    If no operator, the right subexpression and operator are dropped as nonsense
    and the left subexpression passed to Puminus2.
)
timesdivide lsplit
DUP 0=
IF
( left subexpression to next parser: returns two strings catenated with quotes )
    2DROP Puminus2
ELSE
    PUSH PUSH RECURSE    ( recurse on left subexpression )
    POP Puminus2 AZ^     ( right subexpression to Puminus2 )
    POP AZ^ bar-line AZ^ ( add *_ or /_ )
THEN
;

: PtermExp ( s -- s1 s2 )
(
    Takes the string s in the format "i * j" and returns it in postfix "i j *"
    with its type, eg "INT". Differs from Pterm only in that Pterm should only
    receive arithmetic expressions to parse.
    Uses the lsplit operation to split into left and right subexpressions and an
    operator. If no operator is found, discards top two values as "nonsense" and
    passes to PuminusExp parser, otherwise to Pterm on the left, Puminus on the
    right, and uses multiplyDivide to create the postfix expression. If an
    operator is found, the expression must be arithmetical, so the arithmetic
    parsers are used.
)
timesdivide lsplit
DUP 0=
IF
    2DROP PuminusExp
ELSE
    PUSH PUSH Pterm   ( Left subexpression to Pterm: must be arithmetic )
    POP Puminus       ( Pass right subexpression to next parser )
    POP               ( Operator )
    multiplyDivide    ( Three values to */ operation )
THEN
;

: PtermExp2 ( s -- s1 )
(
    Where s is the input string which might be i * j or similar, or might be
    another type of non-arithmetical expression. Returned in the form
    " i" " INT" " j" " INT" *_ including quotes; this can be passed back to the
    FORTH RVM and executed, at which point there might be error messages.
    Uses the usual lsplit function and the */ sequence to divide the input; if
    an operator is found, recurses on the left subexpression and passes the
    right subexpression to Puminus2 because both must be arithmetical type. If
    no operator is found, this might be a unary minus expression or something
    else, so it is parsed further accordingly.
)
timesdivide lsplit
( If no operator, string-nonsense-null. If operator, left-right-operator left )
DUP 0=
IF
    2DROP PuminusExp2
ELSE
    PUSH PUSH Pterm2     ( Left must be arithmetic: to Pterm2 Result ends ??_ )
    POP Puminus2 AZ^     ( Right also arithmetic: to Puminus2 Again ends ??_ )
    POP bar-line AZ^ AZ^ ( Catenate and add _\n  )
THEN
;

: lsplit-for-minus-and-float ( s seq set op-string set2 set3 c -- s1 s2 op )
(
 s is a string in the form "a + b" and seq is a sequence of strings
 eg  ["+", "-"], s1 is the string as far as the operator, s2 after it, and op
 is the operator, eg "-"
 This is for "-" which is an operator that can have three uses: subtraction,
 sign-change, part of the exponent part of a floating-point literal.
 The subtraction operator is preceded by a number, identifier or
 a close round bracket. If any other character precedes the minus, it may be a
 sign-change operator which needs to be parsed differently.
 Similar to the ordinary lsplit operation with the additional check for the
 operator, and which character [whitespace excepted] precedes it.
 Also if the character one before the operator is that passed (ie small e,
 capital E not being acceptable), this operation counts back through
 float-contents (ie 0123456789.) which are the characters permissible in a
 floating-point number. If those character are preceded by anything other than a
 letter (in which case it would be an identifier) or the start of the string,
 the - is part of the exponent and the - is ignored, and the next - sought.
 If another character precedes the 0123456789. the - found is an infix
 (subtraction) minus, and op is -.
 Note that if the op value on the stack is null = 0, the value below it must
 be regarded as a nonsense value and deleted from the stack.
 Typical usage:
 (text) plusminus antecedents " -" digits0. letter CHAR e
 lsplit-for-minus-and-float
)
(: string seq set minus float-contents letters e-char :)
0 0 0 0 VALUE op VALUE count VALUE backtrack VALUE count2
string nowspace to string
string endaz VALUE end
seq CARD VALUE size
float-antecedents CARD VALUE size2
BEGIN
    end string >= op 0= AND
WHILE
    0 to count
    end bracket-avoider-for-lsplit to end ( skip text in brackets, etc )
    BEGIN
        size count > op 0= AND
    WHILE
        count 1+ to count
        seq count APPLY end prefix?
        IF
            seq count APPLY to op
            op minus string-eq
            IF
                end 1- string > string end 1- MAX head e-char = AND op AND
                IF
                    end 2 - to backtrack
                    BEGIN
                        backtrack string >= backtrack head float-contents IN AND
                    WHILE ( See whether found start of string or letter )
                        backtrack string =
                        IF
                            NULL to op
                        ELSE
                            backtrack 1- head letters IN NOT
                            IF
                                NULL to op
                            THEN
                        THEN
                        backtrack 1- to backtrack
                    REPEAT
                THEN ( If 'e' found: otherwise back to end )
                BEGIN
                    string end 1- MAX head 32 = end string > AND
                WHILE
                    end 1- to end
                REPEAT
                end string >
                IF
                    end 1- head set IN NOT
                    IF
                        0 to op
                    THEN
                ELSE
                    0 to op
                THEN
            THEN
        THEN
    REPEAT
    end 1- to end
REPEAT
op
IF
    end 1+ -blanks to end ( Go after next space )
    0 end C!              ( Terminate string with null character )
    end op myazlength + to end ( Move forward length of "op" string )
THEN
string end op
;

: P ( to be redefined as Parith ) ( s -- s1 s2 )
(
    Where s is the original string, eg "a + b" and s1 the string converted to
    postfix notation and s2 the type, returned from parsers farther down the
    line. Uses lsplit-for-minus to split the string into three parts, left and
    right operands and operator. If the operator is null, passes unchanged to
    the next parser. Otherwise parses left operand recursively, passes right
    operand to the next parser (Pterm) and returns the postfix representation
    of the expression.
)
plusminus antecedents " -" digits0. letter [CHAR] e
lsplit-for-minus-and-float
DUP 0=
IF
    2DROP Pterm
ELSE
    PUSH PUSH RECURSE ( recurse on left subexpression )
    POP Pterm         ( right subexpression to Pterm )
    POP               ( Operator )
    addSubtract       ( Three values to +/- operation )
THEN
;


' P to Parith

: P ( to be redefined as Parith2 ) ( s -- s1 )
(
    Where s is in the form i + j and s1 " i" " INT" " j" " INT" +_ which can be
    fed later and produces error messages at that stage.
    Uses the lsplit-for-minus operation; if no operator passes on to Pterm2,
    otherwise recurses on the left subexpression and passes the right substring
    to Pterm2, and catenates with the operator
)
plusminus antecedents " -" digits0. letter [CHAR] e
lsplit-for-minus-and-float
( Distinguish subtraction minus from sign-change minus from negative exponent )
DUP 0=
IF
    2DROP Pterm2 ( No operator found )
ELSE
    PUSH PUSH RECURSE ( recurse on left subexpression )
    POP Pterm2 AZ^    ( right substring to Pterm2 and catenate )
    POP AZ^ bar-line AZ^ ( add +_ or -_ )
THEN
;

' P to Parith2

: ParithExp2 ( s -- s1 )
(
    Parses a string in the format "a + b" into " a" " INT" " b" " INT" +_ or
    similar. This is similar to Parith2, except that expressions of non-numeric
    type can be received here. The output can be passed directly to a FORTH RVM
    for execution, which produces typed postfix code, or error messages.
    Uses the lsplit-for-minus operation to split the String; if an operator is
    found, the right subexpression is a term (Pterm2) and the left arithmetical
    (Parith2). If no operator is found, (NULL value on stack) only the left
    operand is used; this is passed to PtermExp2 as a term or another sort of
    expression.
)
plusminus antecedents " -" digits0. letter [CHAR] e
lsplit-for-minus-and-float
( Distinguishes subtraction minus from sign-change minus and negative exponent )
DUP 0=
IF
    2DROP PtermExp2
ELSE
    PUSH PUSH Parith2   ( Left is arithmetical )
    POP Pterm2          ( Right has to be a "term" )
    POP                 ( Operator )
    bar-line ( now 4 values on stack to catenate ) AZ^ AZ^ AZ^
THEN
;

: ParithExp
(
    Parses a string s which might be an arithmetic expression or some other
    expression; a String in the format "a + b" comes out in postfix as "a b +",
    with its type, eg "INT" returned from other parsers.
    Uses the lsplit-for-minus operation to split on + or -, ignoring sign-change
    minus; this produces left and right subexpressions and operator. If the
    operator is NULL, discards it and right operand and passes left string to
    PuminusExp operation unchanged. Otherwise uses the multiplyDivide operation
    to parse and check types for the three Strings, recursing on the left sub-
    expression.
    Differs from Parith only in that Parith "knows" it has an arithmetic sub-
    expression passed to it.
)
plusminus antecedents " -" digits0. letter [CHAR] e
lsplit-for-minus-and-float
( Distinguishes subtraction minus from sign-change minus and negative exponent )
DUP 0=
IF
    2DROP PtermExp
ELSE
    PUSH PUSH Parith  ( Left to Parith; must be arithmetical )
    POP Pterm         ( Right substring to next parser )
    POP               ( Operator )
    addSubtract       ( three values to +/- operation )
THEN
;

: PenumeratedExp ( s -- s1 s2 )
(
    Where s is a string in the form "123 .. 234" which is split on the set
    enumeration operator ..; the left and right subexpressions must be INT type.
    Splits with rsplit; .. is non-associative. Returns "123 234 .." using the
    .._ operation, which tests the types, and also returns the type "INT POW".
)
dots-seq rsplit
IF
( Operator is found. Note this operator only has two operands; can't recurse )
    PUSH Parith POP Parith
    .._    
ELSE
    DROP ParithExp
THEN
;

NULL OP Pset

: PenumeratedSet ( s -- s1 s2 )
(
    Where s is a string in the form "123 .. 234" which is split on the set
    enumeration operator ..; the left and right subexpressions must be INT type.
    Splits with rsplit; .. is non-associative. Returns "123 234 .." using the
    .._ operation, which tests the types, and also returns the type "INT POW".
    Differs from PenumeratedExp only in that one knows the expression represent
    a set before reaching this stage of parsing.
)
dots-seq rsplit
IF
( Operator is found. Note this operator only has two operands; can't recurse )
    PUSH Parith POP Parith
    .._    
ELSE
    DROP Pset
THEN
;

NULL OP Pboolean
NULL OP Pboolean2

: PbooleanAtom ( s -- s1 "BOO" )
(
    Takes a string s which must represent a boolean value or expression,
    including "true" and "false" (All upper-case permitted). Also a bracketed
    expression, which is passed back to PequivBoolean.
    For identifiers and TRUE/FALSE, the string is returned unchanged.
)
nowspace
DUP true string-eq OVER True string-eq OR
IF
    DROP True boolean
ELSE
    DUP false string-eq OVER False string-eq OR
    IF
        DROP False boolean
    ELSE
        DUP head [CHAR] ( =
        IF
            [CHAR] ( [CHAR] ) bracketRemover2 Pboolean
        ELSE
            DUP letter stringbegins?
            IF
                DUP [CHAR] ( stringcontainschar?
                IF
                    Pfunction
                ELSE
                    Pid DUP nowspace boolean string-eq NOT
                    IF
                        ." The identifier " SWAP .AZ ."  ought to be " boolean
                        .AZ ."  type and is actually " .AZ ABORT
                    THEN
                THEN
            ELSE
                ." Undefined type: " .AZ ABORT
            THEN
        THEN
    THEN
THEN
;

: PbooleanAtom2 ( s -- s1 )
(
    See PbooleanAtom. Takes input string s eg true, bbb, (i < j) and returns it
    in forms like " TRUE" " BOO" or " bbb" " BOO" or " i j <" " BOO" including
    the type and quotes. Bracketed expressions are passed back to PequivBoolean2
    and true/false TRUE/FALSE and identifiers 
)
nowspace
DUP true string-eq OVER True string-eq OR
IF
    DROP True boolean addQuotes2
ELSE
    DUP false string-eq OVER False string-eq OR
    IF
        DROP False boolean addQuotes2
    ELSE
        DUP head [CHAR] ( =
        IF
            [CHAR] ( [CHAR] ) bracketRemover2
            Pboolean2
        ELSE
            DUP letter stringbegins?
            IF
                DUP [CHAR] ( stringcontainschar?
                IF
                    Pfunction addQuotes2 ( refactor if Pfunction2 written )
                ELSE
                    Pid DUP nowspace boolean string-eq NOT
                    IF
                        ." The identifier " SWAP .AZ ." ought to be " boolean
                        .AZ ."  type and is actually " .AZ ABORT
                    THEN
                    addQuotes2
                THEN
            ELSE
                ." Undefined type: " .AZ ABORT
            THEN
        THEN
    THEN
THEN
;

: swap-synonyms-for-range-restriction ( s -- s1)
(
    Where s is the top value on the stack, supposedly representing an operator
    in the range-restriction precedence: it is replaced by the operator it is
    paired with.
)
DUP rangeRestriction-swaps DOM IN
IF
    rangeRestriction-swaps SWAP APPLY
THEN
;

: Pset2 ( s -- s1 )
(
    Where s is the input text which must represent a set. Examples are "abc"
    which uses Pid and adds quotes, "{i, j, k}" which comes back as
    {_ " i" " type" ,_ " j" " type" ,_ " k" "type" }_ with quotes, but divided
    over several lines, and "foo(i, j, k)" which comes out as
    " i j k foo" " foo POW".
    These outputs can all be fed back to the FORTH RVM so as to produce a second
    output, which process usually involves error checking.
    Note the similarity to Psequence2 and Patom2; in this case one can be sure
    the operand represents a set, but in those other functions the input means
    something different.
)
nowspace
DUP letter stringbegins?
IF
    DUP [CHAR] ( stringcontainschar?
    IF      ( Must be function call )
        Pfunction ( refactor to Pfunction2 when available )
        nowspace "  POW" OVER suffix? NOT
        IF
            ." Type received not set: " .AZ ."  received." ABORT
        THEN addQuotes2
    ELSE    ( Presumed to be identifier )
        DUP alphanumeric stringconsists?
        IF
            Pid
            nowspace "  POW" OVER suffix? NOT
            IF
                ." Type received not set: " .AZ ."  received." ABORT
            THEN
            addQuotes2
        ELSE
            ." Unknown type in Pset2: " .AZ ABORT ( Or add lambda etc later )
        THEN
    THEN
ELSE ( If we have got here it should be in the format {i, j, k} )
( Consider adding something in format [1, 2, 3] and passing to Psequence2 )
    DUP " {" OVER prefix? " }" ROT suffix? AND NOT
    IF
        ." Input in set parser is: " .AZ CR
        ." Doesn't match {a, b, c} format." ABORT
    THEN
(
    Should be refactored to pull out duplicated code here, in Patom2 and in
    Psequence2
)
    DUP CLONE-STRING 0 OVER 1+ C! bar-line AZ^ ( Keep 1st letter --> {_ )
    SWAP DUP endaz bar-line AZ^ ( Keep last letter --> }_ )
    PUSH ( Hide }_ on user stack to retrieve later. )
    1+ 0 OVER endaz C! Plist2 ( Parse all but {} as a list )
    POP AZ^ AZ^ ( Retrieve }_ and catenate twice )
THEN
;

NULL OP Psequence
NULL OP Psequence2

: PrangeRestrictedSeq ( s -- s2 t2 )
(
    Where s is a string in a format like
    "[“Campbell”, “Bill”, “Steve”] ← “Bill”" and the output is the postfix
    expression
    STRING [ " Campbell"  , " Bill"  , " Steve" , ] " Bill" ←
    along with its type. same as left type INT STRING PROD POW. The operators
    ^, ⁀, ←, ↑, and ↓ are all tested for; they have the same precedences, but
    different requirements for type of their operands.
    They are all left-associative operators.
    Note the range restriction and range subtraction operations might give an
    exception if the resultant set is used as a sequence, and it does not have a
    domain equal to 1..i. That is why ▷ and ▷- were removed.
    On 19th Sep 2012 enhanced to take Strings as operands so
    “Campbell“ ^ ”Ritchie” is acceptable, returning
    " Campbell "  " Ritchie"  AZ^ and "STRING"
    Experimental version using a relation to pick bar-decorated operations.
)
rangeRestriction2 lsplit DUP 0=
IF  ( No operator found: must be plain old sequence; String OK, but only for ^ )
    2DROP nowspace l-quote OVER prefix?
    IF
        Pstring
    ELSE
        Psequence
    THEN
ELSE
(    swap-synonyms-for-range-restriction ( \|/ and /|\ become ↓ and ↑ etc ) )
    operation-swaps SWAP APPLY ( Function pointer )
    PUSH PUSH
    RECURSE
    POP Pexpression
    POP EXECUTE
THEN
;

: PrangeRestrictedSeq2
(
    Similar to PrangeRestrictedSeq but runs in two stages. Input is like
    "[“Campbell”, “Bill”, “Steve”] ▷ {“Bill”}" and the output is the executable
    FORTH, in five parts catenated to form a single string
    " STRING [ " Campbell"  , " Bill"  , " Steve" , ]" " INT STRING PROD POW"
    " STRING { " Bill" , }" " STRING POW" ▷_
)
rangeRestriction lsplit DUP 0=
IF      ( No operator: pass to Psequence2 )
    2DROP Psequence2
ELSE
THEN ;

: P ( : Psequence2  s -- s1 )
(
    Similar to Psequence, and Pset2. Takes input text as "s" and outputs s1; it
    has different outputs depending on the input. For example [i, j, k] gives
    [_ " i" " INT" ,_ " j" " INT" ,_ " k" " INT" ]_ with newlines added, xxx
    gives " xxx" " INT foo PROD POW" and foo(1, 2, 3) gives
    " 1 2 3 foo" " INT baa PROD POW".
    The forms with the _ bars in can be fed back to the FORTH RVM for execution
    which produces the postfix format with type, or error messages.
    This function uses the Plist2 or Pfunction2 or Pid functions; in the latter
    case quotes must be added. Error reporting from those functions, if
    appropriate.
)
nowspace
DUP letter stringbegins?
IF
    DUP [CHAR] ( stringcontainschar?
    IF  ( Must be function call )
        Pfunction addQuotes2 ( Change to Pfunction2 when available )
    ELSE ( Must be identifier; other types can be added )
        Pid addQuotes2 ( Can change to Pid2 )
    THEN
ELSE ( Must begin with [ and end with ] or () )
    DUP head [CHAR] ( =
    IF ( Change ([foo, bar, baz]) to [foo, bar, baz] and parse again )
        [CHAR] ( [CHAR] ) bracketRemover2 Pexpression2
    ELSE
        DUP head [CHAR] [ = OVER endaz head [CHAR] ] = AND NOT
        IF
            ." Text in incorrect format for sequence: should be [i, j, k]: " .AZ
            CR ." received." ABORT
        ELSE ( To be refactored just as in Patom2 and Pset2 )
            DUP CLONE-STRING 0 OVER 1+ C! bar-line AZ^ ( 1st character + _ = [_\n )
            SWAP DUP endaz bar-line AZ^ ( last letter + _ = ]_\n )
            PUSH ( Hide ]_ on user stack for future reference )
            1+ 0 OVER endaz C! Plist2 ( take [ and ] off, parse remainder as list )
            POP AZ^ AZ^ ( Retrieve ]_\n and catenate the three Strings. )
        THEN
    THEN
THEN
;
' P to Psequence2

: P ( : Psequence ) ( s -- s1 type )
(
    Very similar to Pset: s is the input text, eg [i, j, k] where the [] are
    removed and the contents parsed with Plist and [_ and later ]_ to
    INT FOO PROD [ i , j , k , ]
    or an identifier abc with Pid, or something starting with letters and
    containing () with Pfunction eg foo(i, j, k) to i j k foo.
    In all cases the type is INT foo PROD POW: throws an error if the type is
    not in this format.
)
nowspace
DUP head [CHAR] [ =
IF
    [CHAR] [ [CHAR] ] bracketRemover2 ( Remove []: should be refactored )
    diamondString OVER isSubstringOf?
    IF ( S♢E nested inside [] = error )
        ." Error: expression " CR .AZ ."  contains ♢ inside [...]" ABORT
    THEN
    nablaString OVER isSubstringOf?
    IF
        Pdiamond
    ELSE
        PUSH [_ POP      ( Put [ [ null below present text )
        Plist            ( Parse remaining text as list )
        ]_ 
    THEN
ELSE
    DUP letter stringbegins?
    IF
        DUP alphanumeric stringconsists?
        IF
            Pid
        ELSE
            DUP [CHAR] ( stringcontainschar?
            IF
                Pfunction
            ELSE
                ." Text in wrong format for sequence: " .AZ ."  received" ABORT
                ( Can be changed later )
            THEN
        THEN
    ELSE
        ." The string " .AZ ."  is not in the correct format for a sequence."
        ABORT ( No [] or doesn't start with letter: can be altered for lambda )
    THEN
THEN
" INT " OVER prefix? OVER "  PROD POW"  SWAP suffix? AND NOT
IF
    ." Incorrect type received as sequence: should be INT foo PROD POW format: "
    CR .AZ ."  found" ABORT
THEN
;
' P to Psequence

NULL OP PjoinedSet

: P ( : Pset ) ( s -- s1 type )
(
    Where s is the input text and must return a set. Examples are "abc" using
    Pid, "{a, b, c}" using {} and then the list parsers, "foo(x, y, z)" as a
    function call or a lambda.
    The output s1 from the input "{a, b, c}" reads "FOO { a , b , c , }"
    and the type is "FOO POW". This is achieved by using the {_ and }_
    operations as well as Plist. Throws error if the type doesn't end in " POW".
    This function works similarly to Patom or similar; by looking at the text
    used, one can tell the type: if it starts with { it needs to have the {}
    removed and the contents parsed as a list; if it starts with a letter it
    might be an identifier or a function call; in the latter case it must have
    () as well. A set beginning [ is presumed to be a sequence and parsed by
    Psequence. ( Blank pairs of round brackets in this function to maintain
    syntax highlighting.
) )
nowspace
DUP head [CHAR] { =
IF
    [CHAR] { [CHAR] } bracketRemover2 ( Remove {} ) ( Can be refactored )
    nablaString OVER isSubstringOf?
    IF  ( Error having ∇ inside {} )
        ." Error: expression " CR .AZ ."  contains ∇ inside {...}" ABORT
    THEN
    diamondString OVER isSubstringOf?
    IF
        Pdiamond
    ELSE
    PUSH {_ POP         ( Put { { null underneath present text )
    Plist               ( Parse present text )
    }_                  ( Terminate with } and type )
    THEN
ELSE
    DUP
        head [CHAR] [ = ( ??Can be refactored analogously to Pset2?? )
    IF
        Psequence
    ELSE
        DUP letter stringbegins?
        IF
            DUP alphanumeric stringconsists?
            IF
                Pid
            ELSE
                DUP [CHAR] ( ( ) stringcontainschar?
                IF
                    Pfunction
                ELSE
                    ." Text in wrong format for set: " .AZ
                    ."  received." ABORT
                THEN
            THEN
        ELSE ( Doesn't start with { or letters with or without () )
            dots-seq rsplit
            IF
                PUSH Parith POP Parith .._
            ELSE
                DROP DUP head [CHAR] ( ( remove top 0 before trying head! ) =
                IF
                    [CHAR] ( [CHAR] ) bracketRemover2 PjoinedSet
                ELSE
                    ." Text in wrong format for set: " .AZ
                    ."  received." ABORT
                THEN
            THEN
        THEN
    THEN
THEN
"  POW" OVER suffix? NOT ( test whether top value ends " POW" )
IF
    ." Incorrect type received as set: should end POW. Type found = " .AZ ABORT
THEN
;
' P to Pset

: PrangeRestrictedSet ( s -- s1 type )
(
    Takes a string of the format "x ▷ y" or "x ← y" or similar, and converts it
    to its postfix forms, "x y ▷" or "x y ←" or similar, along with a type. The
    types vary:-
    For range restriction and subtraction a relation on the left and a set on
    the right, eg FOO BAR PROD POW and a set in this case FOO POW on right.
    for appending, a set representing a sequence, eg INT FOO PROD POW and an
    element on the right, eg FOO.
    For catenation, two sets representing sequences, eg both INT FOO PROD POW.
    For truncation and decapitation, a set representing a sequence on the left,
    eg INT FOO PROD POW and an INT on the right. Note that in this instance the
    left operand ought to represent a sequence, ie dom(x) = 1 .. card(x), but we
    have no means of verifying that at this stage.
    Uses the lsplit operation to divide the String into three; if the operator
    is "null" discards the top two values from the stack as nonsense and passes
    the left operand to the ParithExp operation.
    Otherwise the left operand is passed to the corresponding set parser (or
    sequence parser) in lieu of recursion, and the right operand might be an
    expression, set sequence or number (arithmetic), which parse it.
    It is possible to use the synonym ^ for ⁀; in fact the fundamental
    catenation operator is ^.
)
rangeRestriction lsplit
DUP 0=
IF  ( top and middle elements nonsense, 3rd value is a string or set. )
    2DROP nowspace l-quote OVER prefix?
    IF
        Pstring
    ELSE
        Pset
    THEN
ELSE
    ( 3rd element recurses, top element=operator, middle element varies=exp )
( Consider changing RECURSE only to operate when op not in DOM swap-relation,
  otherwise using the sequence equivalent. )
    DUP rangeRestriction2 RAN IN
    IF
        PUSH PUSH PrangeRestrictedSeq
    ELSE
        PUSH PUSH RECURSE
    THEN
    POP Pexpression
    operation-swaps POP APPLY EXECUTE
THEN
;

: PrangeRestrictedSet2 ( s -- s1 )
(
    Has similar functionality to PrangeRestrictedSet, qv but emits an output in
    a format like
    " INT INT PROD { 1 99 ↦ , 2 123 ↦ , }" " INT INT PROD POW" " INT { 99 , }"
    " INT POW" ▷_ from an input like {1 ↦ 99, 2 ↦ 123} ▷ {99}
    with the _ and quotes included. This output can be fed directly to the FORTH
    RVM which can perform type checking and error reporting from the operations
    tagged with a _.
    Several operations are included in this function, eg range restriction which
    takes a relation as its left argument and a set, the same type as the range,
    as its right argument.
    Appending takes a sequence on the left and an element of the same type as
    that sequence on the right.
    For catenation two sequences of the same type.
    For truncation and decapitation, a sequence on the left and an integer on
    the right.
    Differs from the PrangeRestrictedExp2 function in that only operands
    suitable for these operations are passed hither, no other types being
    permissible.
    The operation uses lsplit to divide the input into three; if the operator
    part is null, the right part is nonsense and only the left part is parsed,
    as being arithmetical.
    If there is an operator, the the left substring is a set or sequence, the
    right substring is an integer, set or element, and the third value is the
    operator. The left and right subexpressions are returned with their type and
    quotes from those parsers, and catenated along with the operator and _\n to
    form the output.
    It is possible to use the synonym ^ for ⁀; in fact the fundamental
    catenation operator is ^.
)
rangeRestriction lsplit
DUP 0=
IF
    2DROP Pset2 ( top and middle elements nonsense or null, 3rd is a set )
ELSE
    swap-synonyms-for-range-restriction ( Change <- to ← etc. )
    DUP " ←" string-eq
    IF
        ( Top is operator, middle element = expression, 3rd = similar set )
        PUSH PUSH RECURSE POP Pexpression2 POP
    ELSE
        DUP " ⁀" string-eq
        IF ( Catenate: 3rd value is a range-restricted sequence, middle a
             sequence, and top the operator
           )
            PUSH PUSH PrangeRestrictedSeq2 POP Psequence2
        ELSE
            DUP " ▷" string-eq OVER " ▷-" string-eq OR
            ( Restrict: 3rs and 2nd values are set (relation) and set: top value
              is the operator
            )
            IF
                PUSH PUSH Pset2 POP Pset2 POP
            ELSE
                DUP " ↑" string-eq OVER " ↓" string-eq OR
                (
                    Left value a set(sequence) right value a number, top is the
                    operator
                )
                IF
                    PUSH PUSH Pset2 POP Parith2 POP
                ELSE
                    ." Unrecognised operator in PrangeRestrictedSet2: " .AZ ABORT
                THEN
            THEN
        THEN
    THEN
    bar-line AZ^ AZ^ AZ^ ( Add _\n which makes 4 value, so catenate thrice. )
THEN
;

: PrangeRestrictedExp2 ( s -- s1 )
(
    Where s is an input like "x ▷ y" or "x ← y" or similar, and s1 the output eg
    " x" " foo bar PROD POW" " y" " bar POW" ▷_ or
    " x" " INT foo PROD POW" " y" " foo" ←_ including the quotes and newline at
    the end. This output can be fed back to the FORTH RVM for execution, which
    produces an output in postfix, or error messages.
    Uses the lsplit operation to split the string; if no operator is found the
    left subexpression is arithmetical and the other two values are discarded.
    If ▷ or ▷- is found, the left operand is a set (relation) and the right a
    set.
    If the operator is ←, the left operand is a set representing a sequence and
    the right an element of the same type.
    For ↑ or ↓, the left operand again represents a sequence and the right a
    number (integer).
    For ⁀, the operands represent two sequences of the same type.
    All subexpressions are passed on to the next parsers down, then catenated
    along with the operator and _\n to form the output. The quotes are added to
    the expressions by the other parsers.
    It is possible to use the synonym ^ for ⁀; in fact the fundamental
    catenation operator is ^.
)
rangeRestriction lsplit
DUP 0=
IF
    2DROP ParithExp2
ELSE
    ( Stack = left subexpression, right subexpression and operator )
    swap-synonyms-for-range-restriction
    DUP " ←" string-eq
    IF
        PUSH PUSH PrangeRestrictedSet2 POP Pexpression2 POP
        ( Left = set, right = element, using expression, then operator. )
    ELSE
        DUP " ⁀" string-eq
        IF
            ( Left and right are both sequences, then operator )
            PUSH PUSH PrangeRestrictedSeq2 POP Psequence2 POP
        ELSE
            DUP " ▷" string-eq OVER " ▷-" string-eq OR
            IF
                ( Left = set, right = set of range type, and operator )
                PUSH PUSH PrangeRestrictedSet2 POP Pset2 POP
            ELSE
                DUP " ↑" string-eq OVER " ↓" OR
                IF
                    ( Left = set as sequence, right = number, and operator )
                    PUSH PUSH PrangeRestrictedSet2 POP Parith2 POP
                ELSE
                    ." Unrecognised operator " .AZ ."  in PrangeRestrictedExp2"
                    ABORT
                THEN
            THEN
        THEN
    THEN
    bar-line ( Now 4 values on stack to catenate ) AZ^ AZ^ AZ^
THEN
;

: PrangeRestrictedExp ( s -- s1 type )
(
    Takes a string of the format "x ▷ y" or "x ← y" or similar, and converts it
    to its postfix forms, "x y ▷" or "x y ←" or similar, along with a type. The
    types vary:-
    For range restriction and anti-restriction a relation on the left and a set
    on the right, eg FOO BAR PROD POW and a set in this case FOO POW on right.
    For appending, a set representing a sequence, eg INT FOO PROD POW and an
    element on the right, eg FOO.
    for catenation, two sets representing sequences, eg both INT FOO PROD POW.
    For truncation and decapitation, a set representing a sequence on the left,
    eg INT FOO PROD POW and an INT on the right. Note that in this instance the
    left operand ought to represent a sequence, ie dom(x) = 1 .. card(x), but we
    have no means of verifying that at this stage.
    Uses the lsplit operation to divide the String into three; if the operator
    is "null" discards the top two values from the stack as nonsense and passes
    the left operand to the ParithExp operation.
    Otherwise the left operand is passed to the corresponding set parser (or
    sequence parser) in lieu of recursion, and the right operand might be an
    expression, set sequence or number (arithmetic), which parse it.
    It is possible to use the synonym ^ for ⁀; in fact the fundamental
    catenation operator is ^.
)
rangeRestriction lsplit
DUP 0=
IF
    2DROP PenumeratedExp
ELSE
    DUP rangeRestriction2 RAN IN
    IF
        PUSH PUSH PrangeRestrictedSeq  ( Left subexpression=seq )
    ELSE
        PUSH PUSH PrangeRestrictedSet  ( Left subexpression=set )
    THEN
    POP Pexpression                 ( Right subexpression )
    operation-swaps POP APPLY       ( F-pointer and Operation )   EXECUTE
THEN
;

NULL OP PdomainRestrictedSet

: PdomainRestrictedExp2 ( s -- s1 )
(
    See also PdomainRestrictedExp and PdomainRestrictedSet about this operation
    permitting other types of expressions as well as sets, and the problem about
    the right-associativity of the ◁ operator.
    Takes a string in the format x ◁ y and returns "x" "xtype" "y" "ytype" ◁_ or
    similar, which can be executed as FORTH code to check types and throw errors
    or emit type and postfix representation.
    Uses rsplit to divide the input string into three; if an operator is found,
    the left string is a range restricted set and is parsed accordingly and the
    right string needs recursive parsing. If no operator is found, the left
    string is parsed as range restricted sets or expressions and the other two
    must be discarded as null or nonsense.
)
domRestriction rsplit
DUP
IF  ( operator found, so both subexpressions are sets )
    PUSH PUSH PrangeRestrictedSet2 sspace AZ^ ( Parse left only, add space )
    POP RECURSE AZ^ sspace AZ^                ( Parse right and add space  )
    POP bar-line AZ^ AZ^                      ( Add operator and _ )
ELSE
    2DROP PrangeRestrictedExp2
THEN
;

: PdomainRestrictedExp ( s -- s1 type )
(
    This operation is, unfortunately, separated from the corresponding range
    restriction expression because domain restriction associates to the right
    and range restriction associates to the left, which would be awkward to
    parse; in a string like "x ◁ y ▷ z" the parser will find two top-level
    operators! Although these are associative operators such that x ◁ (y ▷ z) =
    (x ◁ y) ▷ z, it is difficult to handle such expressions in a parser. The
    domain restriction operator ◁ is therefore artifically treated as having a
    lower precedence than range restriction ▷.
    Takes a string in the format "x ◁ y" and returns it in postfix form "x y ◁",
    along with its type eg "FOO BAR PROD POW". Note the types for the two
    operands are crucial; the right operand is a set representin◁g a relation
    whose domain is the same type as the elements of the set represented by the
    left operand, in this case "FOO POW".
    Splits the expression with the rsplit operation, recursing on the right and
    passing the left operand to the PrangeRestrictedExp operation; if there is
    a "null" return for the operator from rsplit both the operator and the
    second value on the stack are "nonsense" values and are discarded.
    It is not straightforward to create a synonym for ◁ or ◁-.
)
domRestriction rsplit
DUP 0=
IF
    2DROP PrangeRestrictedExp
ELSE
    PUSH PUSH PrangeRestrictedSet
    POP PdomainRestrictedSet
    POP domRestriction_
THEN
;

: P ( : PdomainRestrictedSet s -- s1 type )
(
    This operation is, unfortunately, separated from the corresponding range
    restriction expression because domain restriction associates to the right
    and range restriction associates to the left, which would be awkward to
    parse; in a string like "x ◁ y ▷ z" the parser might find two top-level
    operators! Although these are associative operators such that x ◁ (y ▷ z) =
    (x ◁ y) ▷ z, it is difficult to handle such expressions in a parser. The
    domain restriction operator ◁ is therefore artifically treated as having a
    lower precedence than range restriction ▷.
    Takes a string in the format "x ◁ y" and returns it in postfix form "x y ◁",
    along with its type eg "FOO BAR PROD POW". Note the types for the two
    operands are crucial; the right operand is a set representing a relation
    whose domain is the same type as the elements of the set represented by the
    left operand, in this case "FOO POW".
    Splits the expression with the rsplit operation, recursing on the right and
    passing the left operand to the PrangeRestrictedSet operation; if there is
    a "null" return for the operator from rsplit both the operator and the
    second value on the stack are "nonsense" values and are discarded.
    It is not straightforward to create a synonym for ◁ or ◁-.
    This operation differs from the PdomainRestrictedExp operation only in that
    one can be certain the expression passed here represents a set.
)
domRestriction rsplit
DUP
IF
    PUSH PUSH PrangeRestrictedSet
    POP RECURSE
	POP domRestriction_
ELSE
    2DROP PrangeRestrictedSet
THEN
;

: PdomainRestrictedSet2 ( s -- s1 )
(
    See PdomainRestrictedSet etc about the problems with precedence and right-
    and left-associative operators.
    Takes a string in the format x ◁ y and returns "x" "xtype" "y" "ytype" ◁_ or
    similar, which can be executed as FORTH code to check types and throw errors
    or emit type and postfix representation.
    Uses rsplit to divide the input into thre, the left and right subexpressions
    and operator; if no operator is found only the left substring can be used.
    The right string recurses and the left string is passed to
    PrangeRestrictedSet2.
    Differs from PdomainRestrictedExp only in that one can be sure the operands
    here are both sets.
)
domRestriction rsplit
DUP
IF
    PUSH PUSH PrangeRestrictedSet2 sspace
        POP RECURSE AZ^ AZ^ POP AZ^ bar-line AZ^
ELSE
    2DROP PrangeRestrictedSet2
THEN
;

' P to PdomainRestrictedSet

: PjoinedSet2 ( s -- s1 )
(
    Similar to PjoinedSet, and PjoinedSetExp2, but one can be sure that input
    arriving here represents sets. Takes a string like x \ y or x ∪ y, returning
    "x" "xtype" "y" "ytype" ∪_ or similar, which is executable FORTH code and
    tests for type errors, returning the FORTH postfix representation of the
    input, and its type.
    Uses lsplit to divide the input into three: the left subexpression, which is
    parsed reursively, the right which is parsed as a domain restriction, and
    the operator. If no operator is found, the left subexpression is parsed as
    for a domain restriction and the other two discarded as nonsense values.
    No synonyms for the connectives possible.
    Note types for union intersection and difference are different from types
    for overriding.
)
unionIntersect lsplit
DUP
IF      ( operator found )
    PUSH PUSH RECURSE   ( on left subexpression )
    sspace POP PdomainRestrictedSet2 AZ^ AZ^ ( right subexpression, catenated. )
    sspace AZ^ POP AZ^ bar-line AZ^ ( catenate operator and _ )
ELSE    ( no operator )
    2DROP PdomainRestrictedSet2
THEN
;

: P ( : PjoinedSet s -- s1 type )
(
    Takes a String similar to "x \ y" or "x ∪ y" and creates the union,
    intersection, overriding or difference between the two sets. In the case of
    overriding, the operands must be relations eg FOO BAR PROD POW, but for the
    other three, takes sets of the same type eg FOO POW.
    Returns the input in postfix form and its type, eg "x y ∪" "FOO POW".
    Uses the ordinary lsplit operation; if there is no operator string, passes
    the whole string on to the next operation, ie PdomainRestrictedSet.
    Otherwise passes the left string to PjoinedSet, and the right subexpression
    to Pdomainrestriction, since we now know both subexpressions must represent
    sets.
    This cannot use any synomyms for its operators, because /\ will always be
    mistakenly picked up by \. \ turns into \u2216 because of a markup.
    Differs only from the PjoinedSetExp operation in that one "knows" the
    expression represents a set at this stage, so the results are passed to the
    "set" version of the parser.  
)
unionIntersect lsplit
DUP 0=
IF
    2DROP PdomainRestrictedSet
ELSE
    PUSH PUSH RECURSE POP PdomainRestrictedSet
    ( Both subexpressions now parsed )
    POP ( operator )
    DUP " ⊕" string-eq
    IF
        DROP ( Override takes 4 values ) ⊕_
    ELSE ( Other three possibilities, taking 5 values each )
        setunion_
    THEN
THEN
;
' P to PjoinedSet

: PjoinedSetExp2
(
    Takes a String similar to "x \ y" or "x ∪ y" and creates the union,
    intersection, overriding or difference between the two sets. In the case of
    overriding, the operands must be relations eg FOO BAR PROD POW, but for the
    other three, sets of the same type eg FOO POW.
    Returns the input in FORTH which can be executed to get any type errors and
    create postfix form and its type, eg "x" "xtype" "y" "ytype" ∪_
    Uses the ordinary lsplit operation; if there is no operator string, passes
    the whole string on to the next operation, ie PdomainRestrictedExp.
    Otherwise passes the left string to PjoinedSet, and the right subexpression
    to PdomainRestrictedSet, since we now know both subexpressions must represent
    sets.
    This cannot use any synomyms for its operators because \ will mistakenly be
    found for /\.
)
unionIntersect lsplit
DUP 0=
IF
    2DROP PdomainRestrictedExp2
ELSE
    PUSH PUSH PjoinedSet2                           ( Left substring only )
    sspace AZ^ POP PdomainRestrictedSet2 AZ^        ( Right substring )
    ( Both subexpressions now parsed )
    sspace AZ^ POP                                  ( operator )
    AZ^ bar-line AZ^                                ( Catenate with _ )
THEN
;

: PjoinedSetExp ( s -- s1 type )
(
    Takes a String similar to "x \ y" or "x ∪ y" and creates the union,
    intersection, overriding or difference between the two sets. In the case of
    overriding, the operands must be relations eg FOO BAR PROD POW, but for the
    other three, sets of the same type eg FOO POW.
    Returns the input in postfix form and its type, eg "x y ∪" "FOO POW".
    Uses the ordinary lsplit operation; if there is no operator string, passes
    the whole string on to the next operation, ie PdomainRestrictedExp.
    Otherwise passes the left string to PjoinedSet, and the right subexpression
    to Pdomainrestriction, since we now know both subexpressions must represent
    sets.
    This cannot use any synomyms for its operators because \ will mistakenly be
    found for /\.   
)
unionIntersect lsplit
DUP 0=
IF
    2DROP PdomainRestrictedExp
ELSE
    PUSH PUSH PjoinedSet POP PdomainRestrictedSet
    ( Both subexpressions now parsed )
    POP ( operator )
    DUP " ⊕" string-eq
    IF
        DROP ⊕_
    ELSE ( Other three possibilities )
        setunion_
    THEN
THEN
;

: Ppair ( s -- s1 s2 )
(
    Parses anything described as a pair, eg "x ↦ y" and returns it in postfix
    format "x y ↦" with its type "xType yType PROD". Uses the lsplit operation
    with the "maplet" singleton sequence; if an operator is returned, the left
    subexpression recurses and the middle subexpression is passed to the next
    parser, PjoinedSetExp. If no operator [null value] is returned, the top two
    values on the stack are discarded as nonsense and the third value passed to
    PjoinedSetExp.
    It would not be possible to use "|->" as a synonym for the maplet operator
    because of potential confusion with ">".
)
maplet lsplit
0= ( There is only ever one operator type, so "DUP" would be unnecessary )
IF
    DROP PjoinedSetExp
ELSE
    PUSH RECURSE      ( Left subexpression )
    POP PjoinedSetExp ( Right subexpression )
    ↦_
THEN
;

: Ppair2 ( s -- s1 )
(
    Parses anything described as a pair, eg "x ↦ y" and returns it in
    intermediate format "x" "xType" "yType" "y" ↦_ which is executable on the
    FORTH VM to obtain a postfix representation.
    Uses the lsplit operation with the "maplet" singleton sequence; if an
    operator is returned, the left subexpression recurses and the middle
    subexpression is passed to the next parser, PjoinedSetExp.
    If no operator [null value] is returned, the top two values on the stack are
    discarded as nonsense and the third value passed to PjoinedSetExp.
    It would not be possible to use "|->" as a synonym for the maplet operator
    because of potential confusion with ">".
)
maplet lsplit
0= ( There is only ever one operator type, so "DUP" would be unnecessary )
IF
    DROP PjoinedSetExp2
ELSE
    PUSH RECURSE       ( Left subexpression )
    sspace AZ^
    POP PjoinedSetExp2 ( Right subexpression )
    AZ^ maplet 1 APPLY bar-line AZ^ AZ^
THEN
;

: Psubset ( s -- s1 s2 )
(
    Where "s" is a String in the form "x ⊆ y" and gives the result "x y ⊆" and
    "BOO" for boolean.
    Uses the usual lsplit and the subset sequence of Strings to split into left
    operand, right operand and operator; the two operands are sets, passed to
    the PjoinedSet operation.
    If operator is null, simply passes the left operand on to the next parser,
    Ppair.
    Uses the subset_ operation to create the String; this also checks that the
    expressions passed are tagged with the correct types, eg "FOO POW"
)
subset lsplit
DUP 0=
IF
    2DROP Ppair ( If top value is "null" 2nd value is a "nonsense" result )
ELSE
    PUSH PUSH PjoinedSet ( left operand to joinedset )
    POP PjoinedSet       ( retrieve right operand, also to joinedset )
    POP subset_
THEN
;

: Psubset2 ( s -- s1 s2 )
(
    Where "s" is a String in the form "x ⊆ y" and gives the result
    "x" "xType POW" "y" "yType" ⊆_ including the quotes.
    Uses the usual lsplit and the subset sequence of Strings to split into left
    operand, right operand and operator; the two operands are sets, passed to
    the PjoinedSet operation.
    If operator is null, simply passes the left operand on to the next parser,
    Ppair2.
    The ⊆_ operation means the String output is executable on the FORTH VM, with
    a result like "x y ⊆" and "BOO" for boolean; if there is a type error, that
    will be picked up by ⊆_.
)
subset lsplit
DUP 0=
IF
    2DROP Ppair2 ( If top value is "null" 2nd value is a "nonsense" result )
ELSE
    PUSH PUSH PjoinedSet2 ( left operand to joinedset )
    sspace AZ^
    POP PjoinedSet2 AZ^   ( retrieve right operand, also to joinedset )
    sspace AZ^
    POP bar-line AZ^ AZ^
THEN
;

: PsubsetBoolean ( s -- s1 "BOO" )
(
    Takes a String of the type "s ⊂ y" and returns it in postfix format "x y ⊂"
    and "BOO". this operation differs from Psubset in that the subexpression
    must give a boolean return from this operation.
    Uses the subset sequence and the lsplit operation; if no operator is found,
    passes the string unchanged to PbooleanAtom, otherwise both the operands
    must be sets, so they are passed to the lowest-precedence set parser, ie
    PjoinedSet.
    The subset_ word used by this operation all check the sets are the same type
    (eg FOO POW) before returning a result.
)
subset lsplit
DUP 0=
IF
    2DROP PbooleanAtom ( Lose null value and 2nd value on stack is "nonsense" )
ELSE
    PUSH PUSH PjoinedSet POP PjoinedSet
                       ( 2nd and 3rd values passed to set parser )
    POP                ( Find operator )
    subset_
THEN
;

: PsubsetBoolean2 ( s -- s1 )
(
    Takes a String of the type "s ⊂ y" and returns it in intermediate format
    "x" "xType POW" "y"  "Type POW" ⊂_ This operation differs from Psubset2 in
    that the subexpression must give a boolean return from this operation.
    The output is directly executable FORTH code on the VM, producing the type
    and postfix code.
    Uses the subset sequence and the lsplit operation; if no operator is found,
    passes the string unchanged to PbooleanAtom, otherwise both the operands
    must be sets, so they are passed to the lowest-precedence set parser, ie
    PjoinedSet.
    The ⊂_ and similar words used by this operation all check the sets are the
    same type (eg FOO POW) before returning a result.
)
subset lsplit
DUP 0=
IF
    2DROP PbooleanAtom2 ( Lose null value and 2nd value on stack is "nonsense" )
ELSE
    PUSH PUSH PjoinedSet2 sspace AZ^ POP PjoinedSet2 sspace AZ^ AZ^
                       ( 2nd and 3rd values passed to set parser )
    POP AZ^            ( Find operator )
    bar-line AZ^
THEN
;

: PineqBoolean ( s -- s1 "BOO" )
( >_ <_ etc. operations check that the types are appropriate for the
    operator.
    Beware: >= and ≥ cannot be used as synonymous by this parser, nor <=,
    because of potential confusion with the = operator, nor => in case it is
    used as an implication operator.

    Similar to Pineq, except that at this point we already know this must be a
    boolean expression.
    The original String is in the format "x < y" and the s1 output is in the
    format "x y <". Uses the usual lsplit operation to split the input; if there
    is no operator ("null" returned), passes the string to the next parser, on
    the assumption it is a boolean about subsets, otherwise both the operands
    must be numbers, so they are passed to the Parith (arithmetic) parser.
    The >_ <_ etc. operations check that the types are appropriate for the
    operator.
)
ineq lsplit
DUP 0=
IF
( If "op" is null, both it and the second value on the stack must be deleted )
    2DROP PsubsetBoolean
ELSE
( Both values on the stack are arithmetical, otherwise there is a syntax error )
    PUSH PUSH Parith POP Parith ( Call the arithmetic parsers on both operands )
    POP
    inequality_
THEN
;

: PineqBoolean2 ( s -- s1 )
(
    Similar to Pineq2, except that at this point we already know this must be a
    boolean expression.
    The original String is in the format "x < y" and the s1 output is in the
    format "x" "INT" "y" "INT" <_ including the quotes etc.
    Uses the usual lsplit operation to split the input; if there is no operator
    ("null" returned), passes the string to the next parser, on the assumption
    it is a boolean about subsets, otherwise both the operands must be numbers,
    so they are passed to the Parith2 (arithmetic) parser.
    The >_ <_ etc. operations check that the types are appropriate for the
    operator. The output can be directly executed as FORTH code to produce the
    postfix result.
    Beware: >= and ≥ cannot be used as synonymous by this parser, nor <=,
    because of potential confusion with the = operator, nor => in case it is
    used as an implication operator.
)
ineq lsplit
DUP 0=
IF
( If "op" is null, both it and the second value on the stack must be deleted )
    2DROP PsubsetBoolean2
ELSE
( Both values on the stack are arithmetical, otherwise there is a syntax error )
    PUSH PUSH Parith2 sspace AZ^
    POP Parith2 AZ^ sspace AZ^ ( Call the arithmetic parsers on both operands )
    POP bar-line AZ^ AZ^
THEN
;

: Pineq ( s -- s1 "BOO" )
(
    Where s is the original string, eg " a < 3" and s1 the String converted to
    postfix notation, using the lsplit operation and the "ineq" sequence, and
    BOO is the type "BOO" for Boolean. Since the operands can only be arithmetic
    expressions, this parser passes the two subexpressions if lsplit returns a
    non-null operator to the Parith parser. Otherwise it might be a subset or
    other expression, in which case the operator will be "null" and the sedond
    value on the stack is deleted as a "nonsense" value.
    The >_ <_ etc. operations check that the types are appropriate for the
    operator.
    Beware: >= and ≥ cannot be used as synonymous by this parser, nor <=,
    because of potential confusion with the = operator. similarly => is not a
    potential synonym in case it is used for implication.
)
ineq lsplit
DUP 0=
IF
    2DROP
    ( If "op" is null, the 2nd value on the stack is "nonsense" to be deleted )
    Psubset
ELSE
    PUSH PUSH Parith
    POP Parith
    POP
    inequality_
THEN
;

: Pineq2 ( s -- s1 )
(
    Where s is the original string, eg " a < 3" and s1 the String converted to
    intermediate form, using the lsplit operation and the "ineq" sequence, eg
    "a" "INT" "3" "INT" <_ including the quotes and a new line at the end.
    Since the operands can only be arithmetic expressions, this parser passes
    the two subexpressions if lsplit returns a non-null operator to the Parith2
    parser. Otherwise it might be a subset or other expression, in which case
    the operator will be "null" and the second value on the stack is deleted as
    a "nonsense" value.
    The >_ <_ etc. operations check that the types are appropriate for the
    operator. The output can be directly executed as FORTH code to produce the
    postfix result.
    Beware: >= and ≥ cannot be used as synonymous by this parser, nor <=,
    because of potential confusion with the = operator. similarly => is not a
    potential synonym in case it is used for implication.
)
ineq lsplit
DUP 0=
IF
    2DROP
    ( If "op" is null, the 2nd value on the stack is "nonsense" to be deleted )
    Psubset2
ELSE
    PUSH PUSH Parith2 sspace AZ^
    POP Parith2 AZ^ sspace AZ^
    POP AZ^ bar-line AZ^
THEN
;

: swap-synonyms-for-eqmem ( s -- s1 )
(
    Changes the operators ":/", ":" "=!" and "=/" to " ∉" "∈" " ≠" and " ≠"
    respectively.
)
    DUP eqmem-swaps DOM IN IF eqmem-swaps SWAP APPLY THEN
;

: Peqmem ( s -- s1 "BOO" )
(
    Where s is the original String in the form "a = b" or "a ∈ b" or similar.
    Those operators have the same precedence and associate to the left.
    Uses lsplit to split and passes on the two substrings (or left substring
    only if "op" is null) to the next parsers: recursing on the left and to
    Pineq on the right.
    Passes on the strings to the =_, ∈_ etc operators, which check that the
    operands have the correct type.
    Synonyms can be used: Colon : for ∈, and :/ for ∉. Unfortunately, reading
    from right to left, "=" would always be matched first, so one cannot use the
    synonyms /= or != for ≠; =/ or =! are used instead.
    If ∈/∉ is found, the expression divides into expression ∈ joined set (or
    similar); if =/≠, this is equality/membership (recurse) = inequality or
    similar.
) ( Take colon out if required for type declaration )
eqmem lsplit
DUP 0=
IF
    2DROP Pineq
ELSE
    swap-synonyms-for-eqmem
    DUP " ∈" string-eq OVER " ∉" string-eq OR
    IF
        PUSH PUSH Pexpression ( left token any type )
        POP PjoinedSet  ( right token here  = set  )
        POP membership_
    ELSE            ( = or ≠ found: must be equality left, inequality right. )
        PUSH PUSH RECURSE POP Pineq
        POP " =" string-eq
            IF
                =_
            ELSE    ( Must be ≠ )
                ≠_
            THEN
    THEN
THEN
;

: Peqmem2 ( s -- s1 )
(
    Where s is the original String in the form "a = b" or "a ∈ b" or similar.
    Those operators have the same precedence and associate to the left.
    Uses lsplit to split and passes on the two substrings, or left substring
    only if "op" is null, to the next parsers: recursing on the left and to
    Pineq2 on the right.
    Produces an output in a format like "x" "xType" "y" "xType POW" ∈_ including
    the quotes and new line at the end. This output can be executed directly as
    FORTH code to produce the 
    Synonyms can be used: Colon : for ∈, and :/ for ∉. Unfortunately, reading
    from right to left, "=" would always be matched first, so one cannot use the
    synonyms /= or != for ≠; =/ or =! are used instead.
    If ∈/∉ is found, the expression divides into expression ∈ joined set or
    similar; if =/≠, this is equality/membership recursively = inequality or
    similar.
) ( Take colon out if required for type declaration )
eqmem lsplit 
DUP 0=
IF
    2DROP Pineq2
ELSE
    swap-synonyms-for-eqmem
    DUP " ∈" string-eq OVER " ∉" string-eq OR ( test for set membership )
    IF
        PUSH PUSH Pexpression2 ( left token any type )
        sspace AZ^
        POP PjoinedSet2 AZ^    ( right token here = set  )
        sspace AZ^ POP AZ^ bar-line AZ^
    ELSE            ( = or ≠ found: must be equality left, inequality right. )
        PUSH PUSH RECURSE sspace AZ^ POP Pineq2 AZ^
        sspace AZ^ POP AZ^ bar-line AZ^
    THEN
THEN
;

: Peqmemboolean ( s -- s1 "BOO" )
(
    Similar to the Peqmem routine, but here we are sure we are dealing with a
    Boolean value.
    Where s is the original String in the form "a = b" or "a ∈ b" or similar.
    Those operators have the same precedence and associate to the left.
    Uses lsplit to split and passes on the two substrings (or left substring
    only if "op" is null) to the next parsers.
    Passes on the strings to the =_, ∈_ etc operators, which check that the
    operands have the correct type.
    A string in the form "a = b" is parsed as "pair = pair" whilst "a ∈ b" is
    interpreted as "expression ∈ set", 
    Synonyms can be used: Colon : for ∈, and :/ for ∉. Unfortunately, reading
    from right to left, "=" would always be matched first, so one cannot use the
    synonyms /= or != for ≠; =/ or =! are used instead.
) ( Take colon out if required for type declaration )
eqmem lsplit 
DUP 0=
IF
    2DROP PineqBoolean
ELSE
    swap-synonyms-for-eqmem
    DUP " ∈" string-eq OVER " ∉" string-eq OR
    IF
        PUSH PUSH Pexpression ( left token any type )
        POP PjoinedSet  ( right token = set )
        POP membership_
    ELSE                ( equality/non-equality )
        PUSH PUSH Ppair
        POP Ppair
        POP equality_
    THEN
THEN
;

: Peqmemboolean2 ( s -- s1 )
(
    Similar to the Peqmem2 routine, but here we are sure we are dealing with a
    Boolean value.
    Where s is the original String in the form "a = b" or "a ∈ b" or similar.
    Those operators have the same precedence and associate to the left.
    Uses lsplit to split and passes on the two substrings (or left substring
    only if "op" is null) to the next parsers: recursing on the left and to
    Pineq2 on the right.
    Produces an output in a format like "x" "xType" "y" "xType POW" ∈_ including
    the quotes and new line at the end. This output can be executed directly as
    FORTH code to produce the 
    Synonyms can be used: Colon : for ∈, and :/ for ∉. Unfortunately, reading
    from right to left, "=" would always be matched first, so one cannot use the
    synonyms /= or != for ≠; =/ or =! are used instead.
    If ∈/∉ is found, the expression divides into expression ∈ joined set (or
    similar); if =/≠, this is equality/membership (recurse) = inequality or
    similar.
) ( Take colon out if required for type declaration )
eqmem lsplit 
DUP 0=
IF
    2DROP PineqBoolean2
ELSE
    swap-synonyms-for-eqmem
    DUP " ∈" string-eq OVER " ∉" string-eq OR
    IF
        PUSH PUSH Pexpression2 ( left token any type )
        sspace AZ^
        POP PjoinedSet2  ( right token = set )
        sspace AZ^ AZ^
        POP bar-line AZ^ AZ^
    ELSE                ( equality/non-equality )
        PUSH PUSH Ppair2 sspace AZ^
        POP Ppair2 AZ^ sspace AZ^
        POP AZ^ bar-line AZ^
    THEN
THEN
;

: PnotBoolean ( s -- s1 "BOO" )
(
    Where s is the original String in the form "¬a" or similar. This is a right-
    -associative operator, which here has a lower precedence than = etc.
    Uses rsplit to split the string and passes on the resultant string to the
    Peqmem parser. If there is an operator, it is in the format " a ¬" otherwise
    the (null) operator string is deleted and s is passed unchanged.
    Since the ¬ symbol is available on most British keyboards, it is considered
    there is no need for any synonyms.
)
not rsplit
DUP 0=
IF
    2DROP Peqmemboolean
ELSE
    DROP NIP RECURSE ¬_
THEN
;

: PnotBoolean2 ( s -- s1 )
(
    Where s is the original String in the form "¬a" or similar. This is a right-
    -associative operator, which here has a lower precedence than = etc.
    [Note that, if anything, ⇔ is used for equivalence for Booleans.]
    Uses rsplit to split the string and passes on the resultant string to the
    Peqmem2 parser. If there is an operator, the output is in the format
    "a" "BOO" ¬_ including the quotes etc, otherwise the (null) operator string
    is deleted and s is passed unchanged to Peqmem2.
    Since the ¬ symbol is available on most British keyboards, it is considered
    there is no need for any synonyms.
)
not rsplit
DUP 0=
IF
    2DROP Peqmemboolean2
ELSE
    SWAP 
    RECURSE  
    sspace AZ^ SWAP AZ^ bar-line AZ^ NIP
THEN
;
: Pnot ( s -- s1 "BOO" )
(
    Where s is the original String in the form "¬a" or similar. This is a right-
    -associative operator, which here has a lower precedence than = etc.
    [Note that, if anything, ⇔ is used for equivalence for Booleans.]
    Uses rsplit to split the string and passes on the resultant string to the
    Peqmem parser. If there is an operator, it is in the format " a ¬" otherwise
    the (null) operator string is deleted and s is passed unchanged.
    Since the ¬ symbol is available on most British keyboards, it is considered
    there is no need for any synonyms.
)
not rsplit
DUP 0=
IF
    2DROP Peqmem
ELSE
    DROP NIP PnotBoolean ¬_
THEN
;

: Pnot2 ( s -- s1 )
(
    Where s is the original String in the form "¬a" or similar. This is a right-
    -associative operator, which here has a lower precedence than = etc.
    [Note that ⇔ is used for equivalence for Booleans.]
    Uses rsplit to split the string and passes on the resultant string to the
    Peqmem2 parser. If there is an operator, the output is in the format
    "a" "BOO" ¬_ including the quotes etc, otherwise the (null) operator string
    is deleted and s is passed unchanged to Peqmem2.
    Since the ¬ symbol is available on most British keyboards, it is considered
    there is no need for any synonyms.
)
not rsplit
DUP 0=
IF
    2DROP
    Peqmem2
ELSE
    SWAP
    PnotBoolean2  
    sspace AZ^ SWAP AZ^ bar-line AZ^ NIP
THEN
;


: swap-synonyms-for-andOr ( s1 -- s2 )
( Swaps & and | for ∧ and ∨ respectively using the andOr-swaps relation )
    DUP andOr-swaps DOM IN IF andOr-swaps SWAP APPLY THEN
;

: PandOrBoolean ( s -- s1 "BOO" )
(
    Does exactly the same as the PandOr operation. Uses s in the format "a ∧ b"
    or similar. As with PandOr, this can only cope with Boolean values, so it
    always adds the "BOO" type; in fact only Boolean values can be passed hither
    It returns s1 in the format "a b ∧", using the andOr_ function.
    This function uses the lsplit function; if the operator string is "null" it
    passes on the string unchanged to the next parser.
    The ampersand & can be used as a synonym for ∧ and the pipe (vertical bar) |
    for ∨ by using the swap-synonyms-for-andOr function.
)
andOr lsplit
DUP 0=
IF
    2DROP PnotBoolean
ELSE
    PUSH PUSH RECURSE ( Left value recurses )
    POP PnotBoolean   ( Right value sent to PnotBoolean )
    POP               ( Retrieve operator )
    swap-synonyms-for-andOr
    andOr_
THEN
;

: PandOr2 ( s -- s1 "BOO" )
(
    Does exactly the same as the PandOr2 operation. Uses s in the format "a ∧ b"
    or similar, and returns s1 in the format "a" "BOO" "b" "BOO" ∧_, which is
    executable in FORTH producing the postfix output "BOO" and "a b ∧".
    This function uses the lsplit function; if the operator string is "null" it
    passes on the string unchanged to the next parser.
    The ampersand & can be used as a synonym for ∧ and the pipe (vertical bar) |
    for ∨ by using the swap-synonyms-for-andOr function.
)
andOr lsplit
DUP 0=
IF
    2DROP
    Pnot2
ELSE
    PUSH PUSH RECURSE ( Left value recurses )
    sspace AZ^
    POP PnotBoolean2  ( Right value sent to PnotBoolean2 )
    AZ^ sspace AZ^
    POP               ( Retrieve operator )
    swap-synonyms-for-andOr
    AZ^ bar-line AZ^
THEN
;

: PandOrBoolean2 ( s -- s1 "BOO" )
(
    Does exactly the same as the PandOr2 operation. Uses s in the format "a ∧ b"
    or similar, and returns s1 in the format "a" "BOO" "b" "BOO" ∧_, which is
    executable in FORTH producing the postfix output "BOO" and "a b ∧".
    This function uses the lsplit function; if the operator string is "null" it
    passes on the string unchanged to the next parser.
    The ampersand & can be used as a synonym for ∧ and the pipe (vertical bar) |
    for ∨ by using the swap-synonyms-for-andOr function.
)
andOr lsplit
DUP 0=
IF
    2DROP
    PnotBoolean2
ELSE
    PUSH PUSH RECURSE ( Left value recurses )
    sspace AZ^
    POP PnotBoolean2  ( Right value sent to PnotBoolean )
    AZ^ sspace AZ^
    POP               ( Retrieve operator )
    swap-synonyms-for-andOr
    AZ^ bar-line AZ^
THEN
;

: PandOr ( s -- s1 "BOO" )
(
    Where s is the original String in the form "a ∧ b" or similar. Unless a
    bit-wise AND is introduced, applied to INTs, this parser is only applicable
    to boolean values, so the second result is the String "BOO". The first
    result is the string turned into postfix format, viz "a b ∧", using the ∧_
    and ∨_ functions.
    This function uses the lsplit function; if the operator string is "null" it
    passes on the string unchanged to the next parser.
    The ampersand & can be used as a synonym for ∧ and the pipe (vertical bar) |
    for ∨.
)
andOr lsplit
DUP 0=
IF
    2DROP Pnot
ELSE
    PUSH PUSH PandOrBoolean ( Left value definitely boolean: to parser )
    POP PnotBoolean         ( right value to Pnot )
    POP                     ( Retrieve operator   )
    swap-synonyms-for-andOr
    andOr_
THEN
;

: Pimplies ( s -- s1 boolean_string )
(
    Parses a string representing an implication, eg "x ⇒ y" into postfix format
    "x y ⇒" and "BOO" or similar. Uses the rsplit operation, since ⇒ is a binary
    right-associative connective. If no ⇒ is found, the right subexpression is
    discarded as nonsense.
    The left substring is passed to PandOr and this operation recurses if an
    operator is found and the strings and types are passed to the ⇒_ operation,
    which checks that both operands are boolean type.
    Cannot accept => as a synomym connective because of confusion with =.
)
implies rsplit
0=
IF
    DROP PandOr ( Only a left substring: try and/or )
ELSE ( try and/or on the left and recurse on right )
    PUSH PandOrBoolean ( Must be a boolean value ) POP RECURSE ⇒_
THEN ;

: Pimplies2 ( s -- s2 )
(
    Takes a string in the format x ⇒ y and returns "x" "BOO" "y" "BOO" ⇒_ with
    quotes, or similar: this can be executed directly by the FORTH RVM to give
    the postfix output "x y ⇒" "BOO", using the ⇒_ operation. This tests the two
    operands to confirm they are correct type (both booleans) and emits an error
    otherwise.
    Uses the rsplit operation since ⇒ is a binary right-associative operation,
    passing the left subexpression to the next parser as possibly an and/or
    expression. If there is no operator the right substring is discarded as
    nonsense; otherwise recurses on the right and catenates the results and the
    operator to form the output.
)
implies rsplit
DUP 0=
IF ( discard right and operator values, pass left on as possible and/or )
    2DROP PandOr2
ELSE ( left is and/or boolean, recurse on right, catenate with operator )
    PUSH PUSH PandOrBoolean2 sspace AZ^ POP RECURSE AZ^ sspace AZ^
    POP AZ^ bar-line AZ^
THEN
;

: PimpliesBoolean  ( s -- s1 boolean_string )
(
    Takes a string in the format x ⇒ y and returns "x" "BOO" "y" "BOO" ⇒_ with
    quotes, or similar: this can be executed directly by the FORTH RVM to give
    the postfix output "x y ⇒" "BOO", using the ⇒_ operation. This tests the two
    operands to confirm they are correct type (both booleans) and emits an error
    otherwise.
    Uses the rsplit operation since ⇒ is a binary right-associative operation,
    passing the left subexpression to the next parser as possibly an and/or
    expression. If there is no operator the right substring is discarded as
    nonsense; otherwise recurses on the right and catenates the results and the
    operator to form the output.
    Differs from Pimplies in that only boolean expressions should be passed to
    this operation.
)
implies rsplit
0=
IF    ( Only one value: lose right value and try and/or on left value )
    DROP PandOrBoolean
ELSE  ( Two values found: try and/or on left and recurse on right )
    PUSH PandOrBoolean POP RECURSE ⇒_
THEN ;

: PimpliesBoolean2 ( s -- s2 )
(
    Takes a string in the format x ⇒ y and returns "x" "BOO" "y" "BOO" ⇒_ with
    quotes, or similar: this can be executed directly by the FORTH RVM to give
    the postfix output "x y ⇒" "BOO", using the ⇒_ operation. This tests the two
    operands to confirm they are correct type, both booleans, and emits an error
    otherwise.
    Uses the rsplit operation since ⇒ is a binary right-associative operation,
    passing the left subexpression to the next parser as possibly an and/or
    expression. If there is no operator the right substring is discarded as
    nonsense; otherwise recurses on the right and catenates the results and the
    operator to form the output.
    The only difference from Pimplies2 is that only boolean expressions should
    be passed to this operation.
)
implies rsplit
DUP 0=
IF      ( No operator: discard right and try left as an and/or )
    2DROP PandOrBoolean2
ELSE    ( Operator found: try left as an and/or and recurse on the right )
    PUSH PUSH PandOrBoolean2 sspace AZ^ POP RECURSE AZ^ sspace AZ^
    POP AZ^ bar-line AZ^
THEN
;

(
space for Pquantified and PquantifiedBoolean: will need moving later in this
file. )
(
: PquantifiedBoolean ( s -- s1 boolean Comment as above, but from its context
one can tell this is a Boolean expression before attempting to evaluate it. )

)

: Pequiv  ( s1 -- s2 boolean ) 
(
    Where s1 is "a ⇔ b" and output is "a b ⇔" "boolean" or similar. Takes an
    equivalence expression and converts it to postfix, using the usual lsplit
    operation with the equivalence sequence. If an operator is found, recurses
    on the left (⇔ is a left-associative binary operator) and passes the right
    substring on to PimpliesBoolean. Otherwise the operator and right substring
    are discarded and the left substring passed to Pimplies.
    Calls the ⇔_ operation which assembles the postfix String and checks the
    types as Booleans.
)
equivalence lsplit
0=
IF ( No operator: only left subexpression means anything. )
    DROP Pimplies
ELSE ( Operator found: recurse on left, right to PimpliesBoolean. )
    PUSH RECURSE POP PimpliesBoolean ⇔_
THEN ;

: PequivBoolean  ( s1 -- s2 boolean ) 
(
    Where s1 is "a ⇔ b" and output is "a b ⇔" "boolean" or similar. Takes an
    equivalence expression and converts it to postfix, using the usual lsplit
    operation with the equivalence sequence. If an operator is found, recurses
    on the left (⇔ is a left-associative binary operator) and passes the right
    substring on to PimpliesBoolean. Otherwise the operator and right substring
    are discarded and the left substring passed to Pimplies.
    Calls the ⇔_ operation which assembles the postfix String and checks the
    types as Booleans. Only difference from Pequiv: this operation must take a
    boolean expression
)
equivalence lsplit
0=
IF ( No operator: only left subexpression means anything. )
    DROP PimpliesBoolean
ELSE ( Operator found: recurse on left, right to PimpliesBoolean. )
    PUSH RECURSE POP PimpliesBoolean ⇔_
THEN ;

: Pequiv2 ( s1 -- s2 )
(
    Takes a string in the format x ⇒ y and returns "x" "BOO" "y" "BOO" ⇒_ with
    quotes, or similar: this can be executed directly by the FORTH RVM to give
    the postfix output "x y ⇒" "BOO", using the ⇒_ operation. This tests the two
    operands to confirm they are correct type (both booleans) and emits an error
    otherwise.
    Uses the rsplit operation since ⇒ is a binary right-associative operation,
    passing the left subexpression to the next parser as possibly an and/or
    expression. If there is no operator the right substring is discarded as
    nonsense; otherwise recurses on the right and catenates the results and the
    operator to form the output.
)
equivalence lsplit
DUP 0=
IF ( If no operator, lose "right" substring and left is an implies expression )
    2DROP Pimplies2
ELSE ( If operator found, assume right is an "implies" and recurse on the left )
    PUSH PUSH RECURSE sspace AZ^
    POP PimpliesBoolean2 AZ^ sspace AZ^ POP AZ^ bar-line AZ^
THEN ;

: PequivBoolean2 ( s1 -- s2 )
(
    Takes a string in the format x ⇒ y and returns "x" "BOO" "y" "BOO" ⇒_ with
    quotes, or similar: this can be executed directly by the FORTH RVM to give
    the postfix output "x y ⇒" "BOO", using the ⇒_ operation. This tests the two
    operands to confirm they are correct type (both booleans) and emits an error
    otherwise.
    Uses the rsplit operation since ⇒ is a binary right-associative operation,
    passing the left subexpression to the next parser as possibly an and/or
    expression. If there is no operator the right substring is discarded as
    nonsense; otherwise recurses on the right and catenates the results and the
    operator to form the output. Differs from Pequiv2 in that the argument must
    be of boolean type.
)
equivalence lsplit
DUP 0=
IF ( If no operator, lose "right" substring and left is an implies expression )
    2DROP PimpliesBoolean2
ELSE ( If operator found, assume right is an "implies" and recurse on the left )
    PUSH PUSH RECURSE sspace AZ^
    POP PimpliesBoolean2 AZ^ sspace AZ^ POP AZ^ bar-line AZ^
THEN ;

NULL OP Pmultipleinstruction
NULL OP Pmultipleinstruction2

: quantified_
(
    Takes 6 strings like "∀ x • x ∈ iset ⇒ x > 3" "∀" "x" "iset" "x 3 >o" "BOO"
    The first is left over from Pquantified and is not used. Puts them together
    preceded by "INT { <COLLECT", then "iset CHOICE to x x 3 >" [for ∀ "NOT"]
    "--> 0 TILL CARD SATISFIED> } CARD" and for ∧ and ∃, "0=" and "0 <>".
    It goes through the set, testing the predicate for each element: a false
    for ∧ and a true for ∃ will insert a value [here 0, any INT would do] into a
    new set. If the final set is empty, then ∀ is true, and a full set is true
    for ∃. Whitespace inserted to break output into three lines.
)
(: text quantifier bound-variable set predicate type :) 
type quantifier test-one-type-boolean ( Check predicate is boolean type. )
" INT { <COLLECT" newline AZ^ "     " AZ^
set AZ^ "  CHOICE to " AZ^ bound-variable AZ^ sspace AZ^ predicate AZ^
quantifier " ∀" string-eq
IF 
    "  NOT" AZ^    
THEN
"  --> 0" AZ^ newline AZ^ " TILL CARD SATISFIED> } CARD" AZ^
quantifier " ∀" string-eq
IF
    "  0=" AZ^
ELSE
    "  0 <>" AZ^
THEN
newline AZ^ boolean
;

: Pquantified ( s -- s1 boolean )
(
    Where s is an expression starting with ∀ or ∃ and containing • later on.
    It must be in the form "∀x • x ∈ S ⇒ Px" or "∃x • x ∈ S ∧ Px" where S is a
    set and Px is a predicate on x. An expression starting with ∀ or ∃ must
    contain • otherwise an error will be thrown.
    Uses rsplit, and parses x as a new local variable, which is added to the
    locals relation, obtaining its type from the set S. The variable x must be
    the correct form for an identifier and not yet exist as a local variable.
    Adds code shamelessly cribbed from an example by Bill Stoddart for
    model-checking which uses a choice-while construct to add elements to a new
    set, terminating when the set is no longer empty. Empty resultant set for ∀,
    adding only false values, or true resultant set adding true values after ∃
    represents success.
)
( " ∀x • x ∈ iset ⇒ x < 0" )
nowspace DUP SWAP CLONE-STRING SWAP " ∀" OVER prefix? OVER " ∃" SWAP prefix? OR  
IF
    bullet-seq rsplit 0=
    IF
        ." ∀ or ∃ without • error" ABORT
    THEN
    and-implies rsplit
    DUP
    IF
        DUP  " ∧" string-eq
        IF
            PUSH PUSH PUSH " ∃" OVER prefix? NOT
                IF 
                    ." ∧ and ∃ must accompany each other. Text = " DROP .AZ ABORT
                THEN
            POP POP POP DROP
        ELSE
            " ⇒" string-eq PUSH ROT " ∀" OVER prefix?
                PUSH ROT ROT POP NOT POP AND
            IF
                ." ⇒ and ∀ must accompany each other. Text = " 2DROP DROP .AZ ABORT
            THEN
        THEN
    ELSE
        ." ∀ or ∃ without ⇒ or ∧ error. Text = " 2DROP 2DROP .AZ ABORT
    THEN
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀x" "x ∈ iset" "x < 0" )
    PUSH eqmem rsplit
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀x" "x" "iset" "∈" US="x < 0" )
    DUP 0= ( test for nullity or you get a seg fault )
    IF
        ." Left half of expression after ∀∃ must be in the form x ∈ S"
        CR ." Text = " 2DROP 2DROP .AZ ABORT
    THEN
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀x" "x ∈ iset" "x" "iset" "∈" US="x < 0" )
    " ∈" string-eq NOT
    IF
        ." Left half of expression after ∀∃ must be in the form x ∈ S: text = "
        2DROP 2DROP .AZ ABORT
    THEN
    PUSH 2DUP nowspace SWAP nowspace suffix? NOT 
    ROT nowspace ROT nowspace OVER OVER truncate nowspace
    myazlength " ∀" myazlength <>
    ( " ∀" and " ∃" same length ) PUSH ROT POP OR
    IF
        ." Bound variable before and after • different. Text = " 2DROP .AZ ABORT
    THEN
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀" "x" US="x < 0" "iset" )
    ( Check "x" not already used as local variable. )
    nowspace DUP locals DOM IN
    IF
        ." Bound variable " .AZ ."  already declared as local variable." CR
        ." Text = " DROP .AZ ABORT
    THEN
    ( stack = "∀ x • x ∈ i ⇒ x < 0" "∀" "x" US= "x < 0" "iset" )
    POP nowspace types OVER APPLY DUP "  POW" SWAP suffix? NOT
    IF
        ." The type " DROP .AZ
        ."  in the expression " 2DROP .AZ ."  is not a set." ABORT
    THEN
    CLONE-STRING "  POW" truncate
    ( stack = "∀ x • x ∈ iset ⇒ x < 0" "∀" "x" "iset" "INT" US="x < 0" )
    SWAP PUSH OVER SWAP STRING STRING PROD { ↦ , } locals ∪ to locals POP POP
    ( stack = "∀ x • x ∈ iset ⇒ x < 0" "∀" "x" "iset" "x < 0" US=empty )
    Pboolean quantified_
ELSE
    DROP Pequiv
THEN
;

: PquantifiedBoolean ( s -- s1 boolean )
(
    Where s is an expression starting with ∀ or ∃ and containing • later on.
    It must be in the form "∀x • x ∈ S ⇒ Px" or "∃x • x ∈ S ∧ Px" where S is a
    set and Px is a predicate on x. An expression starting with ∀ or ∃ must
    contain • otherwise an error will be thrown.
    Uses rsplit, and parses x as a new local variable, which is added to the
    locals relation, obtaining its type from the set S. The variable x must be
    the correct form for an identifier and not yet exist as a local variable.
    Adds code shamelessly cribbed from an example by Bill Stoddart for
    model-checking which uses a choice-while construct to add elements to a new
    set, terminating when the set is no longer empty. Empty resultant set for ∀,
    adding only false values, or true resultant set adding true values after ∃
    represents success.
    Differs from Pquantfied only in that it can only be reached from Pboolean,
    so must be a Boolean, and calls PequivBoolean from its last line rather than
    Pboolean.
)
( " ∀x • x ∈ iset ⇒ x < 0" )
nowspace DUP SWAP CLONE-STRING SWAP " ∀" OVER prefix? OVER " ∃" SWAP prefix? OR  
IF
    bullet-seq rsplit 0=
    IF
        ." ∀ or ∃ without • error" ABORT
    THEN
    and-implies rsplit
    DUP
    IF
        DUP  " ∧" string-eq
        IF
            PUSH PUSH PUSH " ∃" OVER prefix? NOT
                IF 
                    ." ∧ and ∃ must accompany each other. Text = " DROP .AZ ABORT
                THEN
            POP POP POP DROP
        ELSE
            " ⇒" string-eq PUSH ROT " ∀" OVER prefix?
                PUSH ROT ROT POP NOT POP AND
            IF
                ." ⇒ and ∀ must accompany each other. Text = " 2DROP DROP .AZ ABORT
            THEN
        THEN
    ELSE
        ." ∀ or ∃ without ⇒ or ∧ error. Text = " 2DROP 2DROP .AZ ABORT
    THEN
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀x" "x ∈ iset" "x < 0" )
    PUSH eqmem rsplit
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀x" "x" "iset" "∈" US="x < 0" )
    DUP 0= ( test for nullity or you get a seg fault )
    IF
        ." Left half of expression after ∀∃ must be in the form x ∈ S"
        CR ." Text = " 2DROP 2DROP .AZ ABORT
    THEN
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀x" "x ∈ iset" "x" "iset" "∈" US="x < 0" )
    " ∈" string-eq NOT
    IF
        ." Left half of expression after ∀∃ must be in the form x ∈ S: text = "
        2DROP 2DROP .AZ ABORT
    THEN
    PUSH 2DUP nowspace SWAP nowspace suffix? NOT 
    ROT nowspace ROT nowspace OVER OVER truncate nowspace
    myazlength " ∀" myazlength <>
    ( " ∀" and " ∃" same length ) PUSH ROT POP OR
    IF
        ." Bound variable before and after • different. Text = " 2DROP .AZ ABORT
    THEN
    ( stack = " ∀x • x ∈ iset ⇒ x < 0" "∀" "x" US="x < 0" "iset" )
    ( Check "x" not already used as local variable. )
    nowspace DUP locals DOM IN
    IF
        ." Bound variable " .AZ ."  already declared as local variable." CR
        ." Text = " DROP .AZ ABORT
    THEN
    ( stack = "∀ x • x ∈ i ⇒ x < 0" "∀" "x" US= "x < 0" "iset" )
    POP nowspace types OVER APPLY DUP "  POW" SWAP suffix? NOT
    IF
        ." The type " DROP .AZ
        ."  in the expression " 2DROP .AZ ."  is not a set." ABORT
    THEN
    CLONE-STRING "  POW" truncate
    ( stack = "∀ x • x ∈ iset ⇒ x < 0" "∀" "x" "iset" "INT" US="x < 0" )
    SWAP PUSH OVER SWAP STRING STRING PROD { ↦ , } locals ∪ to locals POP POP
    ( stack = "∀ x • x ∈ iset ⇒ x < 0" "∀" "x" "iset" "x < 0" US=empty )
    Pboolean quantified_
ELSE
    DROP PequivBoolean
THEN
;

(
    The following two operations to be used when the whole expression gives a
    boolean result, eg after IF.
)
: P PquantifiedBoolean  ;
' P to Pboolean
: P PequivBoolean2 ;
' P to Pboolean2

: P ( : Pdiamond ) ( s -- s1 s2 )
(
    Where s is in the format "i := 1 ⊓ i := 2 ♢ i + 1" and the output is the
    postfix form "INT {  <RUN <CHOICE 1 to i [] 2 to i CHOICE> i 1 + RUN> }" and
    the type "INT POW". Uses the ♢_ operation, which returns the type of the
    expression plus POW as its type, and the S and E parts of the input string
    with type, {}, and RUN tags added.
    Splits a string on the ♢ operator, into an expression parsed with Pequiv on
    the right, and a substitution/son the left.
    Note the ♢ operator is not associative and can only be used once in an
    expression, so it can be split on with the rsplit operation. It has a lower
    precedence than the := to its left and returns a bunch, but RVM_FORTH does
    not support bunches, so it must be converted to a set by being enclosed in
    {} braces in the original code. This whole expression therefore returns a
    set, which can be assigned, etc. The equivalent for preferential choice uses
    the ∇ operator and must be enclosed in square brackets [] in the code, to
    denote it returns a sequence rather than a bunch. Both these versions are
    handled by the ♢_ operation.
    This operation should only be called from inside Patom or similar.
)
diamond rsplit DUP 
IF  
    PUSH PUSH Pmultipleinstruction POP Pequiv POP ♢_ 
ELSE
    2DROP Pquantified
THEN ; ' P to Pdiamond

( : Pexpression )
: P ( s -- s1 s2 )
( Where s is an expression string, and this calls the other parsers and )
( operator functions to return s1 which is the string in postfix for FORTH and )
( s2 which is the type string. )
Pquantified
;

' P to Pexpression

: P ( : Plist s -- s1 s2 )
(
  Splits a string "s" representing a list into the string "s1" which is its
  postfix form, and s2 which is its type, eg " Middlesbrough, Sunderland" would
  be split into " Middlesbrough , Sunderland ," and " team" or " team LIST",
  assuming the two tokens are of type "team".
  Uses the ordinary lsplit operation to divide the string, on the assumption
  that the comma operator, which is really non-associative, associates to the
  left. The left substring is parsed again recursively by this parser, the
  left substring being passed on to Pexpression.
  Uses the ,_ operation to reassemble the text into postfix; note that ,_
  requires more values on the stack beforehand, eg "{" "{" 0. The open bracket
  operation must be invoked before this, and the close bracket operation
  afterwards. Example:
  {_ "Middlesbrough, Sunderland, Leeds" Plist }_ --->
  "team { Sunderland , Middlesbrough , Leeds , }" "team POW",
  or {_ " 1, 2, 3" Plist }_ ---> "INT { 1 , 2 , 3 , }" "INT POW",
  or [_" 1, 2, 3" Plist ]_ ---> "INT [ 1 , 2 , 3 , ]" "INT INT PROD POW".
  Failure to invoke an open bracket operation first will lead to undefined
  output or more probably a segmentation error.
)
comma lsplit
DUP 0= ( Reached 1st name in list, or one-element list: no operator )
       ( Operator string can be discarded because it is always the same, comma )
       ( Refactor to take out the excess DROPs. )
IF
    2DROP Pexpression
ELSE
    DROP PUSH RECURSE     ( Left substring parsed recursively )
    ,_                    ( Left substring and type to be followed by comma. )
    POP Pexpression       ( Parsing of right substring as an expression )
    ( Only one possible operator string = comma, can be deleted at beginning. )
THEN
;

' P to Plist

: P ( s -- s1 : to become Plist2 )
(
    Splits a string s representing a list and reconstructs it with calls to the
    ,_ operation and the members and types in quotes. For example i, j, k where
    the members are all INTs comes out as "i" "INT" ,_ "j" "INT" ,_ "k" "INT"
    The output has newlines after the _s and additional spacing to fit the FORTH
    syntax. The output should be preceded by putting {_ or similar on the stack,
    and followed by }_, and catenated with AZ^ twice.
    Example "{_" "i, j, k" Plist2 "}_" AZ^ AZ^
    This function splits the String using the comma as delimiter and the lsplit
    operation, assuming that , associates to the left. A list on the left is
    parsed recursively; the right element is stored on the user stack to be
    parsed later. Any single elements found are parsed as expressions.
)
comma lsplit
IF ( top value not 0, ie there is actually an operator found )
    PUSH RECURSE comma-bar AZ^ ( Recurse on left value and add ,_ )
    ( Right value retrieved, parsed as expression, "" added and catenated )
    POP Pexpression2 AZ^
ELSE ( top value = 0, ie there is no operator found )
    ( Single value: parsed and "" added to form 1 string )
    DROP Pexpression2 
THEN
;

' P to Plist2

: P ( s -- s1 To become : Pexpression2 )
(
    Where s the input string is an "expression" and s1 the output is that
    expression converted to postfix, with or without a tagged operation. For
    example, 123 --> " 123" " INT" and
    123 + 456 -->" 123" " INT" " 456" " INT" +_ Note the quote marks. These
    strings can be fed to the FORTH RVM to be executed, and produce a FORTH
    expression, with type.
)
CR ( Gives nicer printout, starting on new line. )
Pequiv2
;

' P to Pexpression2

: Passignment2 ( s -- s1 )
(
    Similar to Passignment below, but returns pointers to the intermediate
    representations, catenated into a single String. So "i := 1 + 2 * 3" returns
    " i" " INT"  " 1" " INT" " 2" " INT" " 3" " INT" *_
    +_
    :=_
    including the quotes and new lines. This can be directly executed by a FORTH
    VM to obtain the postfix output "1 2 3 * + to i". The :=_ operation tests
    correctness of the types assigned.
)  ( Needs to be enhanced to allow for multiple assignment etc )  
assignment rsplit  
0=  ( No operator found )
IF  
    DROP Pexpression2   ( Only use left argument )
ELSE  
    PUSH                ( Left argument is identifier )
    Pid addQuotes2 sspace AZ^
    POP Pexpression2 AZ^ " :=" AZ^ bar-line AZ^ ( Right argument is expression )
THEN
;

: Pleftvalue ( s -- s1 s2=type )
(
    Where s is in the form "x" or "x, y" and s1 in the form "x" or "y to x" for
    a multiple assignment. The form of s2 is the type[s] catenated together, eg
    "INT" or "INT INT". The "to " will be prepended by the :=_ operation
)
comma rsplit
IF
    PUSH Pid POP RECURSE
    ROT sspace AZ^ SWAP AZ^
    ROT ROT to_ AZ^ SWAP AZ^ SWAP
ELSE
    DROP Pid
THEN
;

: Pexpressionlist
(
    Splits a lits of expressions, eg "1 + 2 * 3, 4 - 5 / 6, 7 * 8 / 9" on the
    first comma, as if it associated to the right, and passes the left string to
    Pexpression. Recursively parses the right substring similarly, catenating
    the expressions and their types to "1 2 3 * + 4 5 6 / - 7 8 * 9 /"
    "INT INT INT". Uses rsplit and Pexpression for the dividing and parsing.
)
( "i, j" )
comma rsplit    ( "i" "j" "," )
IF
    PUSH Pexpression ( "i" " INT" ) POP RECURSE ( "i" "INT" "j" "INT" )
    ROT sspace AZ^ SWAP AZ^ ( "i" "j" "INT INT" )
    ROT sspace AZ^ ROT ( "INT INT" "i " "j " ) AZ^ SWAP ( "i j" "INT INT" )
ELSE ( "i" )
    DROP Pexpression ( "i" "INT" )
THEN
;

NULL OP Pguard NULL OP Pguard2

: Passignment ( s -- s1 )
(
    Where s is in the format "i := 1 + 2 * 3" or similar and s1 its postfix
    representation, ie "1 2 3 * + to i". Splits the string input on the :=
    to form three parts. Calls Pid on the left operand and Pexpression on the
    right, then uses :=_ to test that the types are correct, and convert the two
    parts into a single expression.
)
assignment rsplit
0=
IF ( No operator found: must be expression; change to Pfunction later )
    DROP Pexpression whitespace stringconsists? NOT
    IF  ( If "return type" not empty, will incorrectly leave value on stack. )
        ." Passed expression/function returning a value to an instruction:" CR
        ." Only null return permitted here." ABORT
    THEN
ELSE
    PUSH Pleftvalue ( Left operand is an identifier/identifiers )
    POP Pexpressionlist ( Right operand is an expression/expressions )
    :=_
THEN ;

: Ploop ( s -- s1 )
(
    Where s is an instruction in the form WHILE ... DO ... END
)
nowspace while decapitate  
endstring OVER suffix? NOT
OVER endaz endstring myazlength - alphanumeric IN NOT OR NOT 
IF ." WHILE without END error." ABORT THEN 
endstring truncate STRING [ " DO" , ] start-keywords end-keywords rsplit-for-blocks 
IF  ( DO found )
    PUSH Pboolean POP Pmultipleinstruction WHILE_
ELSE
    ." WHILE without DO error." ABORT
THEN ;

: Pthen ( s -- s1 )
(
    Where the input is the infix contents of the "THEN" part of an if-then
    statement. It is divided on "ELSE"; if ELSE is found, it is regarded as
    consisting of two blocks, each to be parsed with Pmultipleinstruction, and
    joined with the ELSE_ opration. Otherwise there is only one block, to be
    parsed with Pmultipleinstruction.
)
( Split allowing for nested IF and WHILE, etc )
else-ops start-keywords end-keywords rsplit-for-blocks
IF ( There is an ELSE found )
    PUSH Pmultipleinstruction POP Pmultipleinstruction ELSE_
ELSE
    DROP Pmultipleinstruction
THEN
;

: Pselection ( s-input -- s-output )
(
    Where the input is a string in the form "IF i < 3 THEN i := i + 1 END", and
    the output is a postfix representation "i 3 < IF i 1 + to i THEN".
    Checks that END and THEN are in their right locations (IF has already been
    tested for) and parses the first part as a Boolean and the second part as a
    multiple instruction, split if the keyword ELSE is used into two halves.
)
nowspace " IF" decapitate
endstring OVER suffix?
OVER endaz endstring myazlength - C@ alphanumeric IN NOT AND
IF
    endstring truncate
    then-ops start-keywords end-keywords rsplit-for-blocks
    IF
        PUSH Pboolean POP Pthen IF-THEN_
    ELSE
        ." IF without THEN error." ABORT
    THEN
ELSE
    ." IF without END error." ABORT
THEN
;

: Pchoice ( s -- s1 )
(
    Takes a String and splits it on the ⊓ choice operator ([] not used: may be
    needed for arrays), which is right-associative, with rsplit-for-blocks. If
    the operator is found, the left string is parsed as a guard and the parser
    recursively parses the right string. If no operator is found, the right
    substring is nonsense amnd discarded and the whole string is regarded as a
    guard.
    If it is necessary to reassemble the postfix string, calls the []_ word.
    Example: "i := i + 1 ⊓ i := i + 2" gives this postfix:
    "<CHOICE i 1 + to i [] i 2 + to i CHOICE>"
)
choice start-keywords end-keywords rsplit-for-blocks
IF ( ⊓ operator found )
    PUSH Pguard ( Left = guard )
    POP RECURSE []_ ( Right parsed and added with []_ operation )
ELSE
    DROP Pguard ( No operator: right = nonsense [deleted], left = guard )
THEN ;

: Pchoice2 ( s -- s1 )
(
    As above, but uses the []_ operation. Splits string on ⊓ choice operator,
    parsing left as if guard and recursing on right (if found). For example,
    "i := i + 1 ⊓  i := i + 2" becomes "i 1 + to i" "i 2 + to i" []_ with quotes
    (and new lines). The []_ operation can be called, which converts it to the 
    full FORTH postfix.
)
choice start-keywords end-keywords rsplit-for-blocks
DUP IF  ( L = guard, R = ?choice to parse recursively )
    PUSH PUSH Pguard2 newline AZ^
    POP RECURSE newline AZ^ AZ^
    POP bar-line AZ^ AZ^
ELSE ( L = guard, R = nonsense, to lose )
    DROP Pguard2
THEN
;

: Ploop2 ( s -- s1 )
(
    As Ploop, but in two stages "WHILE i < 3 DO i := i + 1 END" returns
    " i 3 <" " boolean" i " 1 + to i" WHILE_ with quotes and additional new
    lines. WHILE_ can be called, and does type test
)
nowspace while decapitate endstring OVER suffix? NOT
OVER endaz endstring myazlength - alphanumeric IN NOT OR NOT
IF ." WHILE without END error." ABORT THEN
endstring truncate STRING [ " DO" , ] start-keywords end-keywords rsplit-for-blocks
IF ( found DO )
    PUSH Pboolean2 POP Pmultipleinstruction2 AZ^ while bar-line AZ^ AZ^
ELSE ( not found DO )
    ." WHILE without DO error." ABORT
THEN ;

( Placeholders for operations still to be written. )
: Pselection2 ." Pselection2 not implemented completely." ABORT ; (
nowspace " IF" decapitate
endstring OVER suffix? OVER endaz endstring myazlength - C@ alphanumeric IN NOT AND
IF
    endstring truncate
    then-ops start-keywords end-keywords rsplit-for-blocks
    IF
        PUSH Pboolean2 POP Pthen2 AZ^ " IF-THEN" bar-line AZ^ AZ^
    ELSE
        ." IF without THEN error." ABORT
    THEN
ELSE ." IF without END error." ABORT
THEN ; )

: Pprint ( s -- s1 )
(
    Takes an instruction starting in PRINT and uses the PRINT_ word to convert
    it to postfix, depending on its type
)
" PRINT " decapitate Pexpression PRINT_ ;

: Pprint2 ( s -- s1 )
(
    Takes an instruction starting in PRINT and returns the postfix version with
    tags, and the tag PRINT_. To be called in two stages, the PRINT_ operation
    returning the postfix version of the expression.
)
" PRINT " decapitate Pexpression2 newline " PRINT_" newline AZ^ AZ^ AZ^ ;

: Pskip ( s="SKIP"/"" -- s=blank string )
(
    If an empty string is passed, or the keyword SKIP, leaves empty string on
    the stack.
)
nowspace DUP skip string-eq SWAP myazlength 0= OR NOT
IF
    ." Incorrect identification of skip instruction" ABORT
THEN
blank-string
;

: Pskip2 Pskip ( Leaves empty string on stack ) ;

: Pbracketedinstruction ( s -- s1 )
(
    Takes an instruction or multiple instructions in round brackets (), strips
    the () with bracketRemover2 (throws error if brackets unbalanced) and
    passes the resultant text to Pmultipleinstruction on the assumption it is
    multiple instructions grouped with () for precedence's sake.
)
[CHAR] ( [CHAR] ) bracketRemover2 Pmultipleinstruction
;

: Pbracketedinstruction2 ( As above, but in two stages )
[CHAR] ( [CHAR] )
bracketRemover2 Pmultipleinstruction2 ;

: Pinstruction2 ( s -- s1 )
( As below, but in two stages ) nowspace
DUP " PRINT " 2DUP SWAP prefix? ROT ROT whitespace followed-by? AND
IF Pprint2
ELSE
    DUP while 2DUP SWAP prefix? ROT ROT whitespace followed-by? AND
    IF Ploop2
    ELSE
        DUP " IF" 2DUP SWAP prefix? ROT ROT whitespace followed-by? AND
        IF Pselection2            
        ELSE
            DUP C@ [CHAR] ( =
            IF Pbracketedinstruction2
            ELSE
                DUP DUP myazlength 0= SWAP skip string-eq OR
                IF Pskip2
                ELSE
                    Passignment2
                THEN
            THEN
        THEN
    THEN
THEN
;

: Pinstruction ( s -- s1 )
(
   Instructions starting with PRINT, IF, WHILE and SKIP are passed to their
   respective parsers, otherwise assumed to be an assignment.
   Instructions in round brackets () to have their brackets stripped; they may
   be multiple instructions.
)
nowspace DUP
" PRINT" 2DUP SWAP prefix? ROT ROT whitespace followed-by? AND
IF
    Pprint
ELSE
    DUP while 2DUP SWAP prefix? ROT ROT  whitespace followed-by? AND
    IF
        Ploop
    ELSE
        DUP " IF" 2DUP SWAP prefix? ROT ROT whitespace followed-by? AND
        IF
            Pselection
        ELSE
            DUP C@ [CHAR] ( =
            IF
                Pbracketedinstruction
            ELSE
                DUP DUP myazlength 0= SWAP skip string-eq OR
                IF
                    Pskip
                ELSE
                    Passignment
                THEN
            THEN
        THEN
    THEN
THEN ;

: P ( to become : Pguard ) ( s -- s1 )
(
    Takes a Boolean expression before a guard, passes it for parsing to Pboolean
    and calls the --> operation which appends the guard operator.
    No need for type-checking because passing a non-Boolean to Pboolean will
    result in an error from Patom or similar.
)
guard start-keywords end-keywords rsplit-for-blocks
IF
    PUSH Pboolean POP RECURSE -->_
ELSE
    DROP Pinstruction
THEN
;

' P to Pguard

: P ( to become : Pguard2 ) ( s -- s1 )
(
    Takes a Boolean expression before a guard, passes it for parsing to Pboolean
    and calls the --> operation which appends the guard operator.
    No need for type-checking because passing a non-Boolean to Pboolean will
    result in an error from Patom or similar.
)
guard start-keywords end-keywords rsplit-for-blocks
DUP IF
    PUSH PUSH Pboolean2
    newline POP RECURSE AZ^ AZ^
    newline POP bar-line AZ^ AZ^ AZ^
ELSE
    DROP Pinstruction2
THEN
;

' P to Pguard2

: P ( : Pmultipleinstruction ) ( s -- s1 )
(
    Where s is an instruction in the format "i := i + 1; PRINT i", which is
    split on the first ; allowing for keywords like WHILE and IF or (). The text
    is separated into left, right and the operator; if there is no operator the
    left string is an instruction and the right string nonsense (discarded). If,
    however, there is an operator, the right string is regarded as another
    multiple intruction, which is parsed recursively and catenated to the result
    of parsing the left string with the ;_ operation.
    Typical usage:
    " WHILE i < 3 DO i := i + 1; PRINT i END; j := j * 2; PRINT j"
    Pmultipleinstruction. Splits first on the ; after END, giving this result:
    "BEGIN i 3 < WHILE i 1 + to i i . REPEAT j 2 * to j j ." with appropriate
    newlines
)
sequence start-keywords end-keywords rsplit-for-blocks
IF       
    PUSH ( Left substring is a choice instruction )
    Pchoice
    POP  ( Recursively parse "right" substring )
    RECURSE
    ;_   ( Use ;_ operation to catenate operations )
ELSE     ( No operator found: left string is a choice, right nonsense )
    DROP Pchoice
THEN ;

' P to Pmultipleinstruction

: P ( : Pmultipleinstruction2 ) ( s -- s1 )
(
    Similar to above. Takes an instruction in the format "i := i + 1; PRINT i",
    handled similarly, but returns "i 1 + to i" "i ." ;_ with the quotes (and
    new lines). As before, splits on ; operator, but not in "IF ... END" or
    similar. The ;_ operation can be called from the output, which catenates
    the instructions into one.
)
sequence start-keywords end-keywords rsplit-for-blocks
DUP IF
    PUSH PUSH ( Keep left as choice ) Pchoice2 POP RECURSE
    newline POP bar-line AZ^ AZ^ AZ^ AZ^
ELSE
    2DROP Pchoice2 ( Null operator, right = nonsense: lose 2. Left = choice )
THEN ;
' P to Pmultipleinstruction2

NULL OP Pprod NULL OP Pprodforarguments

: Ppowforarguments ( s1 -- s2 )
(
    Very similar to Ppow below, but when a single token is found, rather than
    adding it to user-types, checks whether it is in declared-user-types. If not
    error message sent. (User-defined types not yet implemented.)
)
nowspace pow-seq rsplit-for-uminus
IF
    NIP nowspace DUP head [CHAR] ( = NOT
    IF
        ." The ℙ operator must be followed by (. ℙ" .AZ ."  passed." ABORT
    THEN
    [CHAR] ( [CHAR] ) bracketRemover2
    Pprodforarguments ℙ_
ELSE
    DROP
    DUP builtin-types IN NOT OVER declared-user-types IN NOT AND
    IF
        ." The type " .AZ ."  has not yet been defined." ABORT
    THEN
THEN
;

: Ppow ( s1 -- s2 )
(
    Splits on the ℙ operator: a type which is a member of ℙ(foo) is a set of foo
    Uses the rsplit-for-uminus operation; like the sign-change operator, this is
    a right-associative unary operator, which must be followed by its type in ()
    The () mean ℙ has a higher precedence than ×, which must be put in the ()
    Anything in () is passed back to the Pprod operation
)
nowspace pow-seq rsplit-for-uminus
IF
    NIP nowspace DUP head [CHAR] ( = NOT
    IF
        ." The ℙ operator must be followed by (. ℙ" .AZ ."  passed." ABORT
    THEN
    [CHAR] ( [CHAR] ) bracketRemover2
    Pprod ℙ_
ELSE
    DROP
    DUP builtin-types IN NOT
    IF  (
            Add a new type to the user-types set:
            not used until user-defined types become available.
        )
        DUP STRING { , } user-types ∪ to user-types
    THEN    ( No operator: now should be single token )
THEN ;

: P ( s1 -- s2 to become : Pprodforarguments )
(
    Very similar to Pprod but the version of Ppow tests the type has already
    been declared
)
nowspace times-sq rsplit
IF
    SWAP Ppowforarguments SWAP RECURSE ×_
ELSE
    DROP Ppowforarguments
THEN ;
' P to Pprodforarguments

: P ( s1 -- s2 to become : Pprod )
(
    Where s1 is a type string in a format like "foo × bar" and s2 its postfix
    representation eg "foo bar PROD".
)
nowspace times-sq rsplit
IF
    SWAP Ppow SWAP RECURSE ×_
ELSE
    DROP Ppow
THEN ;
' P to Pprod

: Pargumenttype ( s -- s1 )
(
    Very similar to Pvariabletype except that the version of Ppow used checks the
    type has been declared (except INT FLOAT STRING), rather than adding to the
    list to be declared.
)
Pprodforarguments
check-single-tree ;

: Pvariabletype ( s -- s1 )
(
    Takes a variable type eg INT or ℙ(INT × STRING) and returns its postfix
    types, ie INT or INT STRING PROD POW. Passes the String to Pprod (and Ppow)
    for handling the ℙ and × operators.
    The bit about "check-single-tree" may be redundant.
)
Pprod
check-single-tree ;

: sq-brackets-abort ( s1 s2 -- error )
(
    for use when a type is "foo []" with something follows the []
)
    ." Type with something after []: not permitted. " SWAP .AZ ." []" .AZ
    ."  passed." ABORT
;

: Parraytypeforvariables ( s -- s1, and side-effect )
(
    INT[3] → 3 VALUE-ARRAY to type-value, and INT ARRAY to s1.
    Similar to below, but uses Ppow which declares type and adds it to types,
    whereas the arguments version checks the type has already been declared.
    If no value is given in the [], accepts it and assumes 0 length: type-value
    is "0 VALUE-ARRAY"
)
nowspace " ]" OVER suffix?
IF
    array-seq lsplit 0=
    IF
        ." ] without [ error in " SWAP .AZ ABORT
    THEN
    " ]" truncate nowspace DUP myazlength
    IF
        Parith " Array Index" SWAP check-type-int
    ELSE
        DROP " 0"
    THEN
    value-array AZ^ to type-value ( write 123 VALUE-ARRAY foo NB: 0 acceptable )
    "  ARRAY" AZ^
ELSE    ( No []: remaining top value on stack is nonsense value )
    0value to type-value ( Write 0 VALUE foo )
    Pvariabletype
THEN
;

: Parraytypeforarguments ( s -- s1 )
(
    If s is a type ending in [] recurses and appends " ARRAY", otherwise
    unchanged from Pargumenttype. Type must already have been declared.
    Needs to be of the type INT[] not INT[3]
)
array-seq lsplit
IF
    nowspace " ]" truncate DUP myazlength
    IF  ( Right string ought now to be 0 length )
        sq-brackets-abort
    THEN
    DROP nowspace RECURSE array AZ^
ELSE
    DROP Pargumenttype
THEN
;

: Pargument ( s -- s1 )
(
    Very similar to Pvariable, but intended for return values and parameters
    when declaring a function. i INT ← foo ( s STRING, f FLOAT ) ... is an
    example; for foo(i, j, k) you use PargumentList.
    Rather than adding any unknown types to the user-types relation, it checks
    that any types required have already been declared, otherwise returning an
    error
)
wspace-split nowspace SWAP nowspace SWAP
OVER test-form-for-identifier
OVER locals DOM IN
IF
    ." Parameter " OVER .AZ ."  already declared as local variable." ABORT
THEN
Parraytypeforarguments
OVER SWAP nowspace STRING STRING PROD { ↦ , } locals ∪ to locals
type-value SWAP newline AZ^ AZ^
;

: Pvariable ( s -- s1 )
(
    Where s is a single variable eg "i INT" and the initialisation "0 VALUE i"
    is returned; simultaneously the type "i ↦ INT" is added to the "types"
    relation.
)
wspace-split ( "i" "INT" )
nowspace SWAP nowspace SWAP
OVER test-form-for-identifier
types DOM IN
IF
    ." Variable " OVER .AZ ."  already declared as variable or constant." ABORT
THEN
Parraytypeforvariables
OVER SWAP nowspace STRING STRING PROD { ↦ , } types ∪ to types
type-value SWAP newline AZ^ AZ^
;

: Pvariableslist ( s -- s1 )
(
    Where s is a comma-separated list of variables, to be split on commas from
    left to right as if comma associated to the right. Each separate part is
    passed to the Pvariable parser, and the results are catenated.
)
comma rsplit
IF  ( Found , so L = single variable, R = shorter list )
    PUSH Pvariable POP RECURSE AZ^
ELSE    ( No , so L = single variable, R = discarded as nonsense value )
    DROP Pvariable
THEN
;

NULL OP Poperations

: Pvariables ( s -- s1 )
(
    Where s is a string of code possibly starting with the VARIABLES keyword, a
    comma-separated list, END, and the remainder of the code. If VARIABLES is
    found, splits on END, and passes the list to Pvariableslist, otherwise the
    whole code is passed to the parser for instructions (changing to operations);
    the code fragments are joined into one with newlines added as appropriate.
    Example "VARIABLES i INT, s STRING, seq INT STRING PROD POW END . . . " will
    return "0 VALUE i 0 VALUE s 0 VALUE seq" with appropriate newlines, and the
    three types "i ↦ INT, s ↦ STRING, seq ↦ INT STRING PROD POW" are added to
    the "types" relation.
) ( Pmultipleinstruction must be replaced by Pmultipleoperation or similar )
-wspace variables OVER prefix?
IF
    DUP variables whitespace followed-by?
    IF
        variables decapitate
        endstring rsplit-for-keywords 0= ( END missing = error )
        IF
            ." VARIABLES without END error" ABORT
        ELSE
            PUSH Pvariableslist POP Pmultipleinstruction AZ^
        THEN
    ELSE
        Poperations
    THEN
ELSE
    Poperations
THEN
;

(
    If the following constant is an array, its type will end in " ARRAY". Use
    OVER CLONE-STRING to copy value, wspace-split NIP and wspace-split DROP to
    get the number, then value-array AZ^ to catenate to "123 VALUE-ARRAY "
    Get the "HERE ..." string, catenate " to " and the identifier, and catenate
    the identifier to value-array. Catenate the whole lot and leave on the top
    of the stack.
)
: Pconstant ( s -- s1 )
(
    Where s is a single constant eg "i 123", split on the space into i and 123,
    the former passed to Pid and checks it hasn't been used before, nor is a
    keyword nor of incorrect format, and the latter passed to Patom to get its
    type.
    Returns 123 VALUE i or similar. Also adds i to the constants set and i↦INT
    to the types relation.
)
wspace-split ( "i" "123" )
nowspace SWAP nowspace SWAP ( Refactor )
OVER constants IN ( already been declared )
IF
    ." Constant " OVER .AZ ."  declared twice" ABORT
THEN
STRING { OVER , } constants ∪ to constants 
Patom ( "i" "123" "INT" ) SWAP PUSH OVER SWAP
STRING STRING PROD { |->$,$ , } types ∪ to types
Pid  array SWAP suffix?
IF  ( "iArr" US = "HERE 3 , 1 , 2 , 3 ," )
    POP DUP CLONE-STRING PUSH wspace-split NIP wspace-split DROP value-array AZ^
    ( "iArr" "3 VALUE-ARRAY" ) OVER AZ^ newline AZ^
    ( "iArr" "3 VALUE-ARRAY iArr" ) POP to_ AZ^ sspace AZ^ ROT AZ^ newline AZ^
    AZ^
ELSE
    newline AZ^ POP value-string AZ^ SWAP AZ^
THEN
;

: Pconstantlist ( s -- s1 )
(
    Where s is a list of constants, eg i 123, j 345, s "Campbell", which splits
    on commas, going from left to right as if comma associated to the right. If
    no comma is found, parses the result as a single constant declaration,
    otherwise parses the left part as a single constant declaration and recurses
    on the right.
)
comma rsplit
IF   ( found , operator L=single constant, R=constant list )
    PUSH Pconstant POP RECURSE AZ^
ELSE ( no comma found: right string discarded as nonsense )
    DROP Pconstant
THEN ;

: Pconstants ( s^"END ..." -- s1 )
(
    Where s is a string of code which may start with the CONSTANTS keyword,
    followed by a comma-separated list of constant values, then END then the
    remainder of the program. If CONSTANTS is found, splits on END, parsing the
    left part as a constant list and the right part is passed to the variables
    parser. Example;
    "CONSTANTS i 123, j 234, s “Campbell” END foo bar" is parsed with
    "i 123, j 234, s “Campbell”" being a constants list and "foo bar" the rest
    of the program.
)
-wspace
constants-string OVER prefix?
IF
    DUP constants-string whitespace followed-by?
    IF
        constants-string decapitate
        endstring rsplit-for-keywords 0= ( no "END" found = error )
        IF
            ." CONSTANTS without END error." ABORT
        ELSE
            PUSH 
            Pconstantlist
            POP Pvariables AZ^
        THEN
    ELSE ( The following two instructions are for no constants found )
        Pvariables
    THEN
ELSE
    Pvariables
THEN
;

: P Pmultipleinstruction ; ' P to Poperations

