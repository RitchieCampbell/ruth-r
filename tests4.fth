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
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
532 " (“Campbell” = “Ruth”)" Patom  SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
533 " “Campbell” = “Ruth”" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
534 " (“Campbell” = “Ruth”)" PbooleanAtom SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
535 " (“Campbell” = “Ruth”)" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
536 " (“Campbell” = “Ruth”)" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
537 " (“Campbell” = “Ruth”)" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
538 " (“Campbell” = “Ruth”)" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq" AZ^ AZ^ boolean checkOutputAndType
539 " “Campbell” ≠ “Ruth”" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
540 " (“Campbell” ≠ “Ruth”)" Patom  SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
541 " “Campbell” ≠ “Ruth”" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
542 " (“Campbell” ≠ “Ruth”)" PbooleanAtom SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
543 " (“Campbell” ≠ “Ruth”)" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
544 " (“Campbell” ≠ “Ruth”)" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
545 " (“Campbell” ≠ “Ruth”)" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
546 " (“Campbell” ≠ “Ruth”)" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT" AZ^ AZ^ boolean checkOutputAndType
547 " 1 ≠ 2" Pexpression       " 1 2 = NOT" boolean checkOutputAndType
548 " (1 ≠ 2)" Patom           " 1 2 = NOT" boolean checkOutputAndType
549 " 1 ≠ 2" Pboolean          " 1 2 = NOT" boolean checkOutputAndType
550 " (1 ≠ 2)" PbooleanAtom    " 1 2 = NOT" boolean checkOutputAndType
551 " (1 ≠ 2)" Pexpression     " 1 2 = NOT" boolean checkOutputAndType
552 " (1 ≠ 2)" Pboolean        " 1 2 = NOT" boolean checkOutputAndType
553 " “Campbell” = “Ruth” ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
554 " (“Campbell” ≠ “Ruth”) ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
555 " (“Campbell” = “Ruth”) ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
556 " “Campbell” ≠ “Ruth” ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
557 " (“Campbell” = “Ruth”) ∈ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
558 " “Campbell” ≠ “Ruth” ∈ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
559 " (“Campbell” = “Ruth”) ∈ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
560 " “Campbell” ≠ “Ruth” ∈ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
561 " (“Campbell” = “Ruth”) ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
562 " “Campbell” ≠ “Ruth” ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
563 " (“Campbell” = “Ruth”) ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
564 " “Campbell” ≠ “Ruth” ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
565 " (“Campbell” = “Ruth”) ∈ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
566 " “Campbell” ≠ “Ruth” ∈ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
567 " (“Campbell” = “Ruth”) ∈ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
568 " “Campbell” ≠ “Ruth” ∈ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
569 " “Campbell” ≠ “Ruth” ∈ {(true), false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
570 " “Campbell” = “Ruth” ∈ {(true), false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
571 " “Campbell” ≠ “Ruth” ∈ {(true), false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
572 " “Campbell” = “Ruth” ∈ {(true), false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
573 " “Campbell” ≠ “Ruth” ∈ {(true), false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
574 " “Campbell” = “Ruth” ∈ {(true), false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
575 " “Campbell” ≠ “Ruth” ∈ {(true), false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
576 " “Campbell” = “Ruth” ∈ {(true), false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
577 " “Campbell” ≠ “Ruth” ∈ {(true), false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
578 " 1 = 2 ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
579 " ((1 = 2) ∈ {true, false})" Patom  SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
580 " 1 = 2 ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
581 " ((1 = 2) ∈ {true, false})" PbooleanAtom SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
582 " (1) = 2 ∈ {(true), false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
583 " (1) = 2 ∈ {(true), false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
584 " 1 = 2 ∈ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
585 " 1 = 2 ∈ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
586 " 1 ≠ 2 ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
587 " ((1 ≠ 2) ∈ {true, false})" Patom  SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
588 " 1 ≠ 2 ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
589 " ((1 ≠ 2) ∈ {true, false})" PbooleanAtom SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
580 " 1 ≠ 2 ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
591 " 1 ≠ 2 ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
592 " 1 ≠ 2 ∈ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
593 " 1 ≠ 2 ∈ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
594 " (“Campbell” = “Ruth”) ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
595 " “Campbell” ≠ “Ruth” ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
596 " (“Campbell” = “Ruth”) ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
597 " “Campbell” ≠ “Ruth” ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
598 " (“Campbell” = “Ruth”) ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
599 " “Campbell” ≠ “Ruth” ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
600 " (“Campbell” = “Ruth”) ∉ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
601 " “Campbell” ≠ “Ruth” ∉ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
602 " (“Campbell” = “Ruth”) ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
603 " “Campbell” ≠ “Ruth” ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
604 " (“Campbell” = “Ruth”) ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
605 " “Campbell” ≠ “Ruth” ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
606 " (“Campbell” = “Ruth”) ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
607 " “Campbell” ≠ “Ruth” ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
608 " (“Campbell” = “Ruth”) ∉ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
609 " “Campbell” ≠ “Ruth” ∉ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
610 " “Campbell” ≠ “Ruth” ∉ {(true), false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
611 " “Campbell” = “Ruth” ∉ {(true), false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
612 " “Campbell” ≠ “Ruth” ∉ {(true), false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
613 " “Campbell” = “Ruth” ∉ {(true), false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
614 " “Campbell” ≠ “Ruth” ∉ {(true), false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
615 " “Campbell” = “Ruth” ∉ {(true), false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
616 " “Campbell” ≠ “Ruth” ∉ {(true), false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
617 " “Campbell” = “Ruth” ∉ {(true), false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
618 " “Campbell” ≠ “Ruth” ∉ {(true), false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
619 " 1 = 2 ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
620 " ((1 = 2) ∉ {true, false})" Patom  SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
621 " 1 = 2 ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
622 " ((1 = 2) ∉ {true, false})" PbooleanAtom SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
623 " (1) = 2 ∉ {(true), false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
624 " (1) = 2 ∉ {(true), false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
625 " 1 = 2 ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
626 " 1 = 2 ∉ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
627 " 1 ≠ 2 ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
628 " ((1 ≠ 2) ∉ {true, false})" Patom  SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
629 " 1 ≠ 2 ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
630 " ((1 ≠ 2) ∉ {true, false})" PbooleanAtom SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
631 " 1 ≠ 2 ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
632 " 1 ≠ 2 ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
633 " 1 ≠ 2 ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
634 " 1 ≠ 2 ∉ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∉" AZ^ AZ^ boolean checkOutputAndType
635 " 1 > 2" Pexpression " 1 2 >" boolean checkOutputAndType
636 " 1 > 2" Pboolean " 1 2 >" boolean checkOutputAndType
637 " 1 > 2" Pineq " 1 2 >" boolean checkOutputAndType
638 " 1 > 2" PineqBoolean " 1 2 >" boolean checkOutputAndType
639 " i > j" Pexpression " i j >" boolean checkOutputAndType
640 " i > j" Pboolean " i j >" boolean checkOutputAndType
641 " i > j" Pineq " i j >" boolean checkOutputAndType
642 " i > j" PineqBoolean " i j >" boolean checkOutputAndType
643 " 1 < 2" Pexpression " 1 2 <" boolean checkOutputAndType
644 " 1 < 2" Pboolean " 1 2 <" boolean checkOutputAndType
645 " 1 < 2" Pineq " 1 2 <" boolean checkOutputAndType
646 " 1 < 2" PineqBoolean " 1 2 <" boolean checkOutputAndType
647 " i < j" Pexpression " i j <" boolean checkOutputAndType
648 " i < j" Pboolean " i j <" boolean checkOutputAndType
649 " i < j" Pineq " i j <" boolean checkOutputAndType
650 " i < j" PineqBoolean " i j <" boolean checkOutputAndType
651 " 1 ≥ 2" Pexpression " 1 2 ≥" boolean checkOutputAndType
652 " 1 ≥ 2" Pboolean " 1 2 ≥" boolean checkOutputAndType
653 " 1 ≥ 2" Pineq " 1 2 ≥" boolean checkOutputAndType
654 " 1 ≥ 2" PineqBoolean " 1 2 ≥" boolean checkOutputAndType
655 " i ≥ j" Pexpression " i j ≥" boolean checkOutputAndType
656 " i ≥ j" Pboolean " i j ≥" boolean checkOutputAndType
657 " i ≥ j" Pineq " i j ≥" boolean checkOutputAndType
658 " i ≥ j" PineqBoolean " i j ≥" boolean checkOutputAndType
659 " 1 ≤ 2" Pexpression " 1 2 ≤" boolean checkOutputAndType
660 " 1 ≤ 2" Pboolean " 1 2 ≤" boolean checkOutputAndType
661 " 1 ≤ 2" Pineq " 1 2 ≤" boolean checkOutputAndType
662 " 1 ≤ 2" PineqBoolean " 1 2 ≤" boolean checkOutputAndType
663 " i ≤ j" Pexpression " i j ≤" boolean checkOutputAndType
664 " i ≤ j" Pboolean " i j ≤" boolean checkOutputAndType
665 " i ≤ j" Pineq " i j ≤" boolean checkOutputAndType
666 " i ≤ j" PineqBoolean " i j ≤" boolean checkOutputAndType
667 " 1 > 1 + 2 * 3" Pexpression " 1 1 2 3 * + >" boolean checkOutputAndType
668 " 1 > 1 + 2 * 3" Pboolean " 1 1 2 3 * + >" boolean checkOutputAndType
669 " 1 > 1 + 2 * 3" Pineq " 1 1 2 3 * + >" boolean checkOutputAndType
670 " 1 > 1 + 2 * 3" PineqBoolean " 1 1 2 3 * + >" boolean checkOutputAndType
671 " i > 1 + 2 * 3" Pexpression " i 1 2 3 * + >" boolean checkOutputAndType
672 " i > 1 + 2 * 3" Pboolean " i 1 2 3 * + >" boolean checkOutputAndType
673 " i > 1 + 2 * 3" Pineq " i 1 2 3 * + >" boolean checkOutputAndType
674 " i > 1 + 2 * 3" PineqBoolean " i 1 2 3 * + >" boolean checkOutputAndType
675 " 1 < 1 + 2 * 3" Pexpression " 1 1 2 3 * + <" boolean checkOutputAndType
676 " 1 < 1 + 2 * 3" Pboolean " 1 1 2 3 * + <" boolean checkOutputAndType
677 " 1 < 1 + 2 * 3" Pineq " 1 1 2 3 * + <" boolean checkOutputAndType
678 " 1 < 1 + 2 * 3" PineqBoolean " 1 1 2 3 * + <" boolean checkOutputAndType
679 " i < 1 + 2 * 3" Pexpression " i 1 2 3 * + <" boolean checkOutputAndType
680 " i < 1 + 2 * 3" Pboolean " i 1 2 3 * + <" boolean checkOutputAndType
681 " i < 1 + 2 * 3" Pineq " i 1 2 3 * + <" boolean checkOutputAndType
682 " i < 1 + 2 * 3" PineqBoolean " i 1 2 3 * + <" boolean checkOutputAndType
683 " 1 ≥ 1 + 2 * 3" Pexpression " 1 1 2 3 * + ≥" boolean checkOutputAndType
684 " 1 ≥ 1 + 2 * 3" Pboolean " 1 1 2 3 * + ≥" boolean checkOutputAndType
685 " 1 ≥ 1 + 2 * 3" Pineq " 1 1 2 3 * + ≥" boolean checkOutputAndType
686 " 1 ≥ 1 + 2 * 3" PineqBoolean " 1 1 2 3 * + ≥" boolean checkOutputAndType
687 " i ≥ 1 + 2 * 3" Pexpression " i 1 2 3 * + ≥" boolean checkOutputAndType
688 " i ≥ 1 + 2 * 3" Pboolean " i 1 2 3 * + ≥" boolean checkOutputAndType
689 " i ≥ 1 + 2 * 3" Pineq " i 1 2 3 * + ≥" boolean checkOutputAndType
690 " i ≥ 1 + 2 * 3" PineqBoolean " i 1 2 3 * + ≥" boolean checkOutputAndType
691 " 1 ≤ 1 + 2 * 3" Pexpression " 1 1 2 3 * + ≤" boolean checkOutputAndType
692 " 1 ≤ 1 + 2 * 3" Pboolean " 1 1 2 3 * + ≤" boolean checkOutputAndType
693 " 1 ≤ 1 + 2 * 3" Pineq " 1 1 2 3 * + ≤" boolean checkOutputAndType
694 " 1 ≤ 1 + 2 * 3" PineqBoolean " 1 1 2 3 * + ≤" boolean checkOutputAndType
695 " i ≤ 1 + 2 * 3" Pexpression " i 1 2 3 * + ≤" boolean checkOutputAndType
696 " i ≤ 1 + 2 * 3" Pboolean " i 1 2 3 * + ≤" boolean checkOutputAndType
697 " i ≤ 1 + 2 * 3" Pineq " i 1 2 3 * + ≤" boolean checkOutputAndType
698 " i ≤ 1 + 2 * 3" PineqBoolean " i 1 2 3 * + ≤" boolean checkOutputAndType

( Subsets already in the 1st tests file. )

CR " HereEndethThe4thTestFile" .AZ CR
