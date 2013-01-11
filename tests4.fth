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

( The tests follow. some require the types relation be extant. )
489 " b" Pexpression         " b"     boolean checkOutputAndType
490 " b" Pboolean            " b"     boolean checkOutputAndType
491 " b" Patom               " b"     boolean checkOutputAndType
types STRING STRING PROD { " flag" " INT INT INT # " boolean AZ^ |->$,$ , } ∪ to types
492 " flag(1, 2, 3)" Pexpression " 1 2 3 flag" boolean checkOutputAndType
493 " flag(1, 2, 3)" Pboolean " 1 2 3 flag" boolean checkOutputAndType
494 " flag(1, 2, 3)" Patom    " 1 2 3 flag" boolean checkOutputAndType
( Unbracketed versions of the following in 1st tests file, about line 200 )
495 " (true)" Pexpression     " TRUE"  boolean checkOutputAndType
496 " (TRUE)" Pexpression     " TRUE"  boolean checkOutputAndType
497 " (true)" Patom           " TRUE"  boolean checkOutputAndType
498 " (TRUE)" Patom           " TRUE"  boolean checkOutputAndType
499 " (true)" Pboolean        " TRUE"  boolean checkOutputAndType
500 " (TRUE)" Pboolean        " TRUE"  boolean checkOutputAndType
501 " (false)" Pexpression    " FALSE" boolean checkOutputAndType
502 " (FALSE)" Pexpression    " FALSE" boolean checkOutputAndType
503 " (false)" Patom          " FALSE" boolean checkOutputAndType
504 " (FALSE)" Patom          " FALSE" boolean checkOutputAndType
505 " (false)" Pboolean       " FALSE" boolean checkOutputAndType
506 " (FALSE)" Pboolean       " FALSE" boolean checkOutputAndType
507 " (b)" Pexpression        " b"     boolean checkOutputAndType
508 " (b)" Pexpression        " b"     boolean checkOutputAndType
509 " (b)" Patom              " b"     boolean checkOutputAndType
510 " (flag(1, ((2)), 3))" Pexpression " 1 2 3 flag" boolean checkOutputAndType
511 " (flag(1, ((2)), 3))" Pboolean " 1 2 3 flag" boolean checkOutputAndType
512 " (flag(1, ((2)), 3))" PbooleanAtom " 1 2 3 flag" boolean checkOutputAndType
513 " (flag(1, ((2)), 3))" Patom " 1 2 3 flag" boolean checkOutputAndType
514 " true" PbooleanAtom       " TRUE"  boolean checkOutputAndType
515 " TRUE" PbooleanAtom       " TRUE"  boolean checkOutputAndType
516 " false" PbooleanAtom      " FALSE" boolean checkOutputAndType
517 " FALSE" PbooleanAtom      " FALSE" boolean checkOutputAndType
518 " b" PbooleanAtom          " b"     boolean checkOutputAndType
519 " flag(1, 2, 3)" PbooleanAtom " 1 2 3 flag" boolean checkOutputAndType
520 " (true)" PbooleanAtom     " TRUE"  boolean checkOutputAndType
521 " (TRUE)" PbooleanAtom     " TRUE"  boolean checkOutputAndType
522 " (false)" PbooleanAtom    " FALSE" boolean checkOutputAndType
523 " (FALSE)" PbooleanAtom    " FALSE" boolean checkOutputAndType
524 " (b)" PbooleanAtom        " b"     boolean checkOutputAndType
525 " 1 = 2" Pexpression       " 1 2 =" boolean checkOutputAndType
526 " (1 = 2)" Patom           " 1 2 =" boolean checkOutputAndType
527 " 1 = 2" Pboolean          " 1 2 =" boolean checkOutputAndType
528 " (1 = 2)" PbooleanAtom    " 1 2 =" boolean checkOutputAndType
529 " (1 = 2)" Pexpression     " 1 2 =" boolean checkOutputAndType
530 " (1 = 2)" Pboolean        " 1 2 =" boolean checkOutputAndType
531 " “Campbell” = “Ruth”" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType
532 " (“Campbell” = “Ruth”)" Patom  SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType
533 " “Campbell” = “Ruth”" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType
534 " (“Campbell” = “Ruth”)" PbooleanAtom SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType
535 " (“Campbell” = “Ruth”)" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType
536 " (“Campbell” = “Ruth”)" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType
537 " (“Campbell” = “Ruth”)" Peqmem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType
538 " (“Campbell” = “Ruth”)" Peqmemboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " string-eq" AZ^ AZ^ boolean checkOutputAndType

CR " HereEndethThe4thTestFile" .AZ CR
