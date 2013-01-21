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

( The tests follow. Some require the types relation be extant. )
STRING STRING PROD { " greater" int sspace AZ^ int AZ^ "  # " AZ^ boolean AZ^ |->$,$ , }
    types ∪ to types
804 " (¬true)" PbooleanAtom " TRUE ¬" boolean checkOutputAndType ( Moved from 812 to make number easier )
805 " (¬greater(  1   ,  2))" Patom " 1 2 greater ¬" boolean checkOutputAndType
806 " (¬greater(  1   ,  2))" PbooleanAtom " 1 2 greater ¬" boolean checkOutputAndType
807 " ¬greater(  1   ,  2)" Pboolean " 1 2 greater ¬" boolean checkOutputAndType
808 " ¬greater(  1   ,  2)" Pexpression " 1 2 greater ¬" boolean checkOutputAndType
809 " (¬TRUE)" PbooleanAtom " TRUE ¬" boolean checkOutputAndType
810 " (¬TRUE)" Patom " TRUE ¬" boolean checkOutputAndType
811 " ¬TRUE" Pboolean " TRUE ¬" boolean checkOutputAndType
812 " ¬TRUE" Pexpression " TRUE ¬" boolean checkOutputAndType
813 " (¬true)" Patom " TRUE ¬" boolean checkOutputAndType
814 " ¬true" Pboolean " TRUE ¬" boolean checkOutputAndType
815 " ¬true" Pexpression " TRUE ¬" boolean checkOutputAndType
816 " (¬FALSE)" PbooleanAtom " FALSE ¬" boolean checkOutputAndType
817 " (¬FALSE)" Patom " FALSE ¬" boolean checkOutputAndType
818 " ¬FALSE" Pboolean " FALSE ¬" boolean checkOutputAndType
819 " ¬FALSE" Pexpression " FALSE ¬" boolean checkOutputAndType
820 " (¬false)" PbooleanAtom " FALSE ¬" boolean checkOutputAndType
821 " (¬false)" Patom " FALSE ¬" boolean checkOutputAndType
822 " ¬false" Pboolean " FALSE ¬" boolean checkOutputAndType
823 " ¬false" Pexpression " FALSE ¬" boolean checkOutputAndType
824 " ¬({false} ⊂ {false, true})" Pnot boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂ ¬" AZ^ boolean checkOutputAndType
825 " ¬({false} ⊂ {false, true})" PnotBoolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂ ¬" AZ^ boolean checkOutputAndType
826 " ¬({false} ⊂ {false, true})" Pboolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂ ¬" AZ^ boolean checkOutputAndType
827 " ¬({false} ⊂ {false, true})" Pexpression boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂ ¬" AZ^ boolean checkOutputAndType
828 " ¬({true} ⊂ {false, true})" Pexpression  boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂ ¬" AZ^ boolean checkOutputAndType
829 " (¬({true} ⊂ {false, true}))" PbooleanAtom boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂ ¬" AZ^ boolean checkOutputAndType
830 " (¬({true} ⊂ {false, true}))" Patom boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂ ¬" AZ^ boolean checkOutputAndType
831 " ¬“Campbell” = “Ruth”" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq ¬" AZ^ AZ^ boolean checkOutputAndType ( Moved to ease numbering )
832 " ¬({1, 2, 3} ⊂ {4, 5, 6})" PnotBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂ ¬" AZ^ boolean checkOutputAndType
833 " ¬({1, 2, 3} ⊂ {4, 5, 6})" Pnot int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂ ¬" AZ^ boolean checkOutputAndType
834 " ¬({1, 2, 3} ⊂ {4, 5, 6})" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂ ¬" AZ^ boolean checkOutputAndType
835 " ¬({1, 2, 3} ⊂ {4, 5, 6})" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂ ¬" AZ^ boolean checkOutputAndType
836 " ¬({1, 2, 3} ⊂ 1 .. 6)" Pnot int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂ ¬" AZ^ boolean checkOutputAndType
837 " ¬({1, 2, 3} ⊂ 1 .. 6)" PnotBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂ ¬" AZ^ boolean checkOutputAndType
838 " ¬{1, 2, 3} ⊂ 1 .. 6" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂ ¬" AZ^ boolean checkOutputAndType
839 " ¬{1, 2, 3} ⊂ 1 .. 6" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂ ¬" AZ^ boolean checkOutputAndType
840 " ¬({false} ⊆ {false, true})" Pnot boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
841 " ¬({false} ⊆ {false, true})" PnotBoolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
842 " ¬{false} ⊆ {false, true}" Pboolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
843 " ¬{false} ⊆ {false, true}" Pexpression boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
844 " {¬(true} ⊆ {false, true})" Pnot boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
845 " ¬({true} ⊆ {false, true})" PnotBoolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
846 " ¬{true} ⊆ {false, true}" Pboolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
847 " ¬{true} ⊆ {false, true}" Pexpression boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆ ¬" AZ^ boolean checkOutputAndType
848 " ¬({1, 2, 3} ⊆ {4, 5, 6})" Pnot int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆ ¬" AZ^ boolean checkOutputAndType
849 " ¬({1, 2, 3} ⊆ {4, 5, 6})" PnotBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆ ¬" AZ^ boolean checkOutputAndType
850 " ¬{1, 2, 3} ⊆ {4, 5, 6}" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆ ¬" AZ^ boolean checkOutputAndType
851 " ¬greater(  1   ,  2)" PnotBoolean " 1 2 greater ¬" boolean checkOutputAndType
852 " (¬greater(  1   ,  2))" PbooleanAtom " 1 2 greater ¬" boolean checkOutputAndType
853 " ¬greater(  1   ,  2)" Pnot " 1 2 greater ¬" boolean checkOutputAndType
854 " (¬TRUE)" PnotBoolean " TRUE ¬" boolean checkOutputAndType
855 " (¬TRUE)" Pnot " TRUE ¬" boolean checkOutputAndType
856 " ¬TRUE" PnotBoolean " TRUE ¬" boolean checkOutputAndType
857 " ¬TRUE" Pnot " TRUE ¬" boolean checkOutputAndType
858 " (¬true)" Patom " TRUE ¬" boolean checkOutputAndType
859 " ¬true" Pboolean " TRUE ¬" boolean checkOutputAndType
860 " ¬true" Pexpression " TRUE ¬" boolean checkOutputAndType
861 " (¬FALSE)" PbooleanAtom " FALSE ¬" boolean checkOutputAndType
862 " (¬FALSE)" Patom " FALSE ¬" boolean checkOutputAndType
863 " ¬FALSE" Pboolean " FALSE ¬" boolean checkOutputAndType
864 " ¬FALSE" Pexpression " FALSE ¬" boolean checkOutputAndType
865 " (¬false)" PbooleanAtom " FALSE ¬" boolean checkOutputAndType
866 " (¬false)" Patom " FALSE ¬" boolean checkOutputAndType
867 " ¬false" Pboolean " FALSE ¬" boolean checkOutputAndType
868 " ¬false" Pexpression " FALSE ¬" boolean checkOutputAndType
869 " (¬b)" PbooleanAtom        " b ¬"     boolean checkOutputAndType
870 " ¬1 = 2" Pexpression       " 1 2 = ¬" boolean checkOutputAndType
871 " (¬1 = 2)" Patom           " 1 2 = ¬" boolean checkOutputAndType
872 " ¬1 = 2" Pboolean          " 1 2 = ¬" boolean checkOutputAndType
873 " ¬(1 = 2)" PnotBoolean    " 1 2 = ¬" boolean checkOutputAndType
874 " (¬1 = 2)" PbooleanAtom     " 1 2 = ¬" boolean checkOutputAndType
875 " ¬(1 = 2)" Pboolean        " 1 2 = ¬" boolean checkOutputAndType
876 " (¬“Campbell” = “Ruth”)" Patom  SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq ¬" AZ^ AZ^ boolean checkOutputAndType
877 " ¬“Campbell” ≠ “Ruth” ∈ {(true), false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT ¬ " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∈" AZ^ boolean checkOutputAndType
878 " ¬1 = 2 ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
879 " ¬(1 = 2) ∈ {true, false}" Pexpression  SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
880 " ¬1 = 2 ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
881 " (¬(1 = 2) ∈ {true, false})" PbooleanAtom SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
882 " ¬(1) = 2 ∈ {(true), false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
883 " ¬(1) = 2 ∈ {(true), false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
884 " ¬1 = 2 ∈ {true, false}" Pnot SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
885 " ¬1 = 2 ∈ {true, false}" PnotBoolean SWAP doubleSpaceRemover SWAP
" 1 2 = " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
886 " ¬1 ≠ 2 ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
887 " (¬(1 ≠ 2) ∈ {true, false})" Patom  SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
888 " ¬1 ≠ 2 ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
889 " (¬(1 ≠ 2) ∈ {true, false})" PbooleanAtom SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
880 " 1 ≠ 2 ∈ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈" AZ^ AZ^ boolean checkOutputAndType
891 " ¬1 ≠ 2 ∈ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
892 " ¬1 ≠ 2 ∈ {true, false}" Pnot SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
893 " ¬1 ≠ 2 ∈ {true, false}" PnotBoolean SWAP doubleSpaceRemover SWAP
" 1 2 = NOT " boolean "  { TRUE , FALSE , } ∈ ¬" AZ^ AZ^ boolean checkOutputAndType
894 " ¬(“Campbell” = “Ruth”) ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉ ¬" AZ^ boolean checkOutputAndType
895 " ¬“Campbell” ≠ “Ruth” ∉ {true, false}" Pexpression SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉ ¬" AZ^ boolean checkOutputAndType
896 " ¬(“Campbell” = “Ruth”) ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉ ¬" AZ^ boolean checkOutputAndType
897 " ¬“Campbell” ≠ “Ruth” ∉ {true, false}" Pboolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉ ¬" AZ^ boolean checkOutputAndType
898 " (¬“Campbell” = “Ruth”) ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq ¬ " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
899 " “¬(Campbell” ≠ “Ruth”) ∉ {true, false}" PeqMem SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq NOT ¬ " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
900 " (¬“Campbell” = “Ruth”) ∉ {true, false}" PeqMemBoolean SWAP doubleSpaceRemover SWAP
" Campbell" addQuotes1 " Ruth" addQuotes1 " stringEq ¬ " boolean AZ^ AZ^ AZ^
"  { TRUE , FALSE , } ∉" AZ^ boolean checkOutputAndType
901 " ¬1 > 2" Pexpression " 1 2 > ¬" boolean checkOutputAndType
902 " ¬1 > 2" Pboolean " 1 2 > ¬" boolean checkOutputAndType
903 " ¬1 > 2" Pnot " 1 2 > ¬" boolean checkOutputAndType
904 " ¬1 > 2" PnotBoolean " 1 2 > ¬" boolean checkOutputAndType
905 " ¬i > j" Pexpression " i j > ¬" boolean checkOutputAndType
906 " ¬i > j" Pboolean " i j > ¬" boolean checkOutputAndType
907 " ¬i > j" Pnot " i j > ¬" boolean checkOutputAndType
908 " ¬i > j" PnotBoolean " i j > ¬" boolean checkOutputAndType
909 " ¬1 < 2" Pexpression " 1 2 < ¬" boolean checkOutputAndType
910 " ¬1 < 2" Pboolean " 1 2 < ¬" boolean checkOutputAndType
911 " ¬1 < 2" Pnot " 1 2 < ¬" boolean checkOutputAndType
912 " ¬1 < 2" PnotBoolean " 1 2 < ¬" boolean checkOutputAndType
913 " ¬i < j" Pexpression " i j < ¬" boolean checkOutputAndType
914 " ¬i < j" Pboolean " i j < ¬" boolean checkOutputAndType
915 " ¬i < j" Pnot " i j < ¬" boolean checkOutputAndType
916 " ¬i < j" PnotBoolean " i j < ¬" boolean checkOutputAndType
917 " ¬1 ≥ 2" Pexpression " 1 2 ≥ ¬" boolean checkOutputAndType
918 " ¬1 ≥ 2" Pboolean " 1 2 ≥ ¬" boolean checkOutputAndType
919 " ¬1 ≥ 2" Pnot " 1 2 ≥ ¬" boolean checkOutputAndType
920 " ¬1 ≥ 2" PnotBoolean " 1 2 ≥ ¬" boolean checkOutputAndType
921 " ¬i ≥ j" Pexpression " i j ≥ ¬" boolean checkOutputAndType
922 " ¬i ≥ j" Pboolean " i j ≥ ¬" boolean checkOutputAndType
923 " ¬i ≥ j" Pnot " i j ≥ ¬" boolean checkOutputAndType
924 " ¬i ≥ j" PnotBoolean " i j ≥ ¬" boolean checkOutputAndType
925 " ¬1 ≤ 2" Pexpression " 1 2 ≤ ¬" boolean checkOutputAndType
926 " ¬1 ≤ 2" Pboolean " 1 2 ≤ ¬" boolean checkOutputAndType
927 " ¬1 ≤ 2" Pnot " 1 2 ≤ ¬" boolean checkOutputAndType
928 " ¬1 ≤ 2" PnotBoolean " 1 2 ≤ ¬" boolean checkOutputAndType
929 " ¬i ≤ j" Pexpression " i j ≤ ¬" boolean checkOutputAndType
930 " ¬i ≤ j" Pboolean " i j ≤ ¬" boolean checkOutputAndType
931 " ¬i ≤ j" Pnot " i j ≤ ¬" boolean checkOutputAndType
932 " ¬i ≤ j" PnotBoolean " i j ≤ ¬" boolean checkOutputAndType
933 " ¬1 > 1 + 2 * 3" Pexpression " 1 1 2 3 * + > ¬" boolean checkOutputAndType
934 " ¬1 > 1 + 2 * 3" Pboolean " 1 1 2 3 * + > ¬" boolean checkOutputAndType
935 " ¬1 > 1 + 2 * 3" Pnot " 1 1 2 3 * + > ¬" boolean checkOutputAndType
936 " ¬1 > 1 + 2 * 3" PnotBoolean " 1 1 2 3 * + > ¬" boolean checkOutputAndType
937 " ¬i > 1 + 2 * 3" Pexpression " i 1 2 3 * + > ¬" boolean checkOutputAndType
938 " ¬i > 1 + 2 * 3" Pboolean " i 1 2 3 * + > ¬" boolean checkOutputAndType
939 " ¬i > 1 + 2 * 3" Pnot " i 1 2 3 * + > ¬" boolean checkOutputAndType
940 " ¬i > 1 + 2 * 3" PnotBoolean " i 1 2 3 * + > ¬" boolean checkOutputAndType
941 " ¬1 < 1 + 2 * 3" Pexpression " 1 1 2 3 * + < ¬" boolean checkOutputAndType
942 " ¬7.0 = 1 + 2 * 3" Pexpression " 7.0 1 2 3 * + S>F F= ¬" boolean checkOutputAndType
943 " ¬1.23 = 1 + 2 * 3" Pexpression " 1.23 1 2 3 * + S>F F= ¬" boolean checkOutputAndType
944 " ¬7.0 = 1 + 2 * 3" Pboolean " 7.0 1 2 3 * + S>F F= ¬" boolean checkOutputAndType
945 " ¬1.23 = 1 + 2 * 3" Pboolean " 1.23 1 2 3 * + S>F F= ¬" boolean checkOutputAndType
946 " ¬7.0 = 1 + 2 * 3" Pnot " 7.0 1 2 3 * + S>F F= ¬" boolean checkOutputAndType
948 " ¬1.23 = 1 + 2 * 3" Pnot " 1.23 1 2 3 * + S>F F= ¬" boolean checkOutputAndType
949 " ¬7.0 = 1 + 2 * 3" PnotBoolean " 7.0 1 2 3 * + S>F F= ¬" boolean checkOutputAndType
947 " ¬1.23 = 1 + 2 * 3" PnotBoolean " 1.23 1 2 3 * + S>F F=" boolean checkOutputAndType
948 " ¬b" Pexpression         " b ¬"     boolean checkOutputAndType
949 " ¬b" Pboolean            " b ¬"     boolean checkOutputAndType
950 " ¬b" Patom               " b ¬"     boolean checkOutputAndType
types STRING STRING PROD { " flag" " INT INT INT # " boolean AZ^ |->$,$ , } ∪ to types
951 " ¬flag(1, 2, 3)" Pexpression " 1 2 3 flag ¬" boolean checkOutputAndType
952 " ¬flag(1, 2, 3)" Pboolean " 1 2 3 flag ¬" boolean checkOutputAndType

CR " HereEndethThe5thTestFile" .AZ CR
