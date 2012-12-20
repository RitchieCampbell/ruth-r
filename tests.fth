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

( The tests follow: some require the types relation be extant. )
1 " Leeds" Pid " Leeds" " team"               checkOutputAndType
2 " Leeds" Patom " Leeds" " team"             checkOutputAndType
3 " Leeds" Pexpression " Leeds" " team"         checkOutputAndType
4 " Middlesbrough" Pid " Middlesbrough" " team" checkOutputAndType
5 " Middlesbrough" Patom " Middlesbrough" " team" checkOutputAndType
6 " Middlesbrough" Pexpression " Middlesbrough" " team" checkOutputAndType
7 " 123" Pint " 123" int                        checkOutputAndType
8 " 123" Pnumber " 123" int                     checkOutputAndType
9 " 123" Parith " 123" int                      checkOutputAndType
10 " 123" ParithAtom " 123" int                 checkOutputAndType
11 " 123" Pexpression " 123" int                checkOutputAndType
12 " 123.45" Pfloat " 123.45" float             checkOutputAndType
13 " 123.45" Pnumber " 123.45" float            checkOutputAndType
14 " 123.45" Parith " 123.45" float             checkOutputAndType
15 " 123.45" ParithAtom " 123.45" float         checkOutputAndType
16 " 123.45" Pexpression " 123.45" float        checkOutputAndType
17 " -123" Parith " 123 -1 *" int               checkOutputAndType
18 " -123" Pexpression " 123 -1 *" int          checkOutputAndType
19 " -123.45" Parith " 123.45 -1.0 F*" float    checkOutputAndType
20 " -123.45" Pexpression " 123.45 -1.0 F*" float checkOutputAndType 
21 " 1 + 2 * 3" Parith " 1 2 3 * +" int         checkOutputAndType
22 " 1 + 2 * 3" Pexpression " 1 2 3 * +" int    checkOutputAndType
23 " (1 + 2) * 3" Parith " 1 2 + 3 *" int       checkOutputAndType
24 " (1 + 2) * 3" Pexpression " 1 2 + 3 *" int  checkOutputAndType
25 " 1 - 2 / 3" Parith " 1 2 3 / -" int         checkOutputAndType
26 " 1 - 2 / 3" Pexpression " 1 2 3 / -" int    checkOutputAndType
27 " (1 - 2) / 3" Parith " 1 2 - 3 /" int       checkOutputAndType
28 " (1 - 2) / 3" Pexpression " 1 2 - 3 /" int  checkOutputAndType
29 " 1 + 0.23 " Parith " 1 S>F 0.23 F+" float   checkOutputAndType
29 " 1 + 0.23 " Parith " 1 S>F 0.23 F+" float   checkOutputAndType
30 " 1 - 0.23 " Parith " 1 S>F 0.23 F-" float   checkOutputAndType
31 " 1 * 0.23 " Parith " 1 S>F 0.23 F*" float   checkOutputAndType
32 " 1 / 0.23 " Parith " 1 S>F 0.23 F/" float   checkOutputAndType
29 " 1 + 0.23 " Parith " 1 S>F 0.23 F+" float   checkOutputAndType
33 " 0.23 + 1 " Parith " 0.23 1 S>F F+" float   checkOutputAndType
34 " 0.23 - 1 " Parith " 0.23 1 S>F F-" float   checkOutputAndType
35 " 0.23 * 1 " Parith " 0.23 1 S>F F*" float   checkOutputAndType
36 " 0.23 / 1 " Parith " 0.23 1 S>F F/" float   checkOutputAndType
37 " 1.0 + 0.23 " Parith " 1.0 0.23 F+" float   checkOutputAndType
38 " 1.0 - 0.23 " Parith " 1.0 0.23 F-" float   checkOutputAndType
39 " 1.0 * 0.23 " Parith " 1.0 0.23 F*" float   checkOutputAndType
40 " 1.0 / 0.23 " Parith " 1.0 0.23 F/" float   checkOutputAndType
41 " 0.23 + 1.0 " Parith " 0.23 1.0 F+" float   checkOutputAndType
42 " 0.23 - 1.0 " Parith " 0.23 1.0 F-" float   checkOutputAndType
43 " 0.23 * 1.0 " Parith " 0.23 1.0 F*" float   checkOutputAndType
44 " 0.23 / 1.0 " Parith " 0.23 1.0 F/" float   checkOutputAndType
45 " i"           ParithAtom " i" int           checkOutputAndType
46 " i"           Patom " i" int                checkOutputAndType
47 " i"           Parith " i" int               checkOutputAndType
48 " i"           Pexpression " i" int          checkOutputAndType
STRING STRING PROD { " i123" int |->$,$ , " f1" float |->$,$ , } types ∪ to types
49 " i123"        ParithAtom " i123" int        checkOutputAndType
50 " i123"        Patom " i123" int             checkOutputAndType
51 " i123"        Parith " i123" int            checkOutputAndType
52 " i123"        Pexpression " i123" int       checkOutputAndType
53 " f1  "        ParithAtom " f1" float        checkOutputAndType
54 " f1  "        Patom " f1" float             checkOutputAndType
55 " f1  "        Pexpression " f1" float       checkOutputAndType
56 " 123.45e-67"  Pfloat " 123.45e-67" float    checkOutputAndType
57 " -123.45e-67" Parith " 123.45e-67 -1.0 F*" float checkOutputAndType
58 " 123.45e-67"  Patom " 123.45e-67" float     checkOutputAndType
59 " -123.45e-67" Pexpression " 123.45e-67 -1.0 F*" float checkOutputAndType
60 " i123"        ParithAtom " i123" int        checkOutputAndType
61 " i123"        Pexpression " i123" int       checkOutputAndType
62 " abc1"        Patom " abc1" " foo"          checkOutputAndType
63 " abc1"        Pid " abc1" " foo"            checkOutputAndType
64 " abc1"        Pexpression " abc1" " foo"    checkOutputAndType
65 " iseq"        Pexpression " iseq" " INT INT PROD POW" checkOutputAndType
66 " iseq"        Patom " iseq" " INT INT PROD POW" checkOutputAndType
67 " iseq"        Pid " iseq" " INT INT PROD POW" checkOutputAndType
68 " foo2"  Patom " foo2" " INT1 INT2 INT3 # foofoo baa" checkOutputAndType
69 " foo2"  Pid " foo2" " INT1 INT2 INT3 # foofoo baa" checkOutputAndType
70 " foo2"  Pexpression " foo2" " INT1 INT2 INT3 # foofoo baa" checkOutputAndType
71 " i123"        Patom " i123" int              checkOutputAndType
72 " iArr[2]"    Patom SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
73 " iArr[1 + 2 * 3]"    Patom SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
74 " iArr[2]"    Parray SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
75 " iArr[1 + 2 * 3]"    Parray SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
76 " iArr[2]"    Parith SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
77 " iArr[1 + 2 * 3]"    Parith SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
78 " iArr[2]"    ParithExp SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
79 " iArr[1 + 2 * 3]"    ParithExp SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
80 " iArr[2]"    Pexpression SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
81 " iArr[1 + 2 * 3]"    Pexpression SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
82 " iArr"    Pid " iArr" " INT ARRAY"          checkOutputAndType
83 " iArr"    Patom " iArr" " INT ARRAY"        checkOutputAndType
84 " iArr"    Parith " iArr" " INT ARRAY"       checkOutputAndType
85 " iArr"    ParithExp " iArr" " INT ARRAY"    checkOutputAndType
86 " iArr"    Pexpression  " iArr" " INT ARRAY" checkOutputAndType
87 " ARRAY[1, 2, 3]" ParrayLiteral " HERE 3 , 1 , 2 , 3 , " " INT ARRAY" checkOutputAndType
88 " ARRAY[1, 2, 3]" Patom " HERE 3 , 1 , 2 , 3 , " " INT ARRAY" checkOutputAndType
89 " ARRAY[1, 2, 3]" Pexpression " HERE 3 , 1 , 2 , 3 , " " INT ARRAY" checkOutputAndType
90 " {1, 2, 3}" Patom " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
91 " {1, 2, 3}" Pset  " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
92 " {1, 2, 3}" Pexpression " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
93 " [1, 2, 3]" Patom " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 94 " [1, 2, 3]" Pset  " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 95 " [1, 2, 3]" Psequence " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 96 " [1, 2, 3]" Pexpression " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 97 {_ " 1, 2, 3" Plist 97 ROT ROT " 3" int checkOutputAndType " { 1 , 2 ," int checkOutputAndType DROP " }
DROP 98 [_ " 1, 2, 3" Plist 98 ROT ROT " 3" int checkOutputAndType " [ 1 , 2 ," int checkOutputAndType DROP " ]
DROP 99 (_ " 1, 2, 3" Plist 99 ROT ROT " 3" int checkOutputAndType " 1 2" " INT INT"  checkOutputAndType DROP
100 {_ " 1, 2, 3" Plist }_ " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
101 [_ " 1, 2, 3" Plist ]_ " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 102 (_ " 1, 2, 3" Plist " foo" )_ " 1 2 3 foo" " foo" checkOutputAndType
103 " foo(1, 2, 3)" Patom " 1 2 3 foo" " foo"   checkOutputAndType
104 " foo(1, 2, 3)" Pfunction " 1 2 3 foo" " foo" checkOutputAndType
105 " foo(1, 2, 3)" Pexpression " 1 2 3 foo" " foo" checkOutputAndType
106 " ARRAY[]" ParrayLiteral " HERE 0 , " " ARRAY" checkOutputAndType
107 " ARRAY[]" Patom " HERE 0 , " " ARRAY"      checkOutputAndType
108 " ARRAY[]" Pexpression " HERE 0 , " " ARRAY" checkOutputAndType
109 " (" " " 0 " 1, 2, 3" PargumentList " foo" )_ " 1 2 3 foo" " foo" checkOutputAndType ( foo is in types )
110 " “Campbell”" Pstring " Campbell" addQuotes1 string checkOutputAndType
111 " “Campbell(((”" Pstring " Campbell(((" addQuotes1 string checkOutputAndType
112 " “Campbell “Campbell “Campbell “Campbell””””" Pstring " Campbell “Campbell “Campbell “Campbell”””" addQuotes1 string checkOutputAndType
113 " “Campbell”" Patom " Campbell" addQuotes1 string checkOutputAndType
114 " “Campbell(((”" Patom " Campbell(((" addQuotes1 string checkOutputAndType
115 " “Campbell “Campbell “Campbell “Campbell””””" Patom " Campbell “Campbell “Campbell “Campbell”””" addQuotes1 string checkOutputAndType
116 " “Campbell”" Pexpression " Campbell" addQuotes1 string checkOutputAndType
117 " “Campbell(((”" Pexpression " Campbell(((" addQuotes1 string checkOutputAndType
118 " “Campbell “Campbell “Campbell “Campbell””””" Pexpression " Campbell “Campbell “Campbell “Campbell”””" addQuotes1 string checkOutputAndType
( Here follow 100 lines copied pasted and renumbered, with () added )
119 " (-123.45)" Parith " 123.45 -1.0 F*" float    checkOutputAndType
120 " (  -123.45)" Pexpression " 123.45 -1.0 F*" float checkOutputAndType 
121 " ( 1 + 2 * 3 )" Parith " 1 2 3 * +" int         checkOutputAndType
122 "   ( 1 + 2 * 3)" Pexpression " 1 2 3 * +" int    checkOutputAndType
123 " ((1 + 2) * 3 )" Parith " 1 2 + 3 *" int       checkOutputAndType
124 "   ( (1 + 2) * 3)" Pexpression " 1 2 + 3 *" int  checkOutputAndType
125 " ( 1 - 2 / 3)" Parith " 1 2 3 / -" int         checkOutputAndType
126 " ((((1 - 2 / 3))))" Pexpression " 1 2 3 / -" int    checkOutputAndType
127 " ((((1 - 2) / 3)))" Parith " 1 2 - 3 /" int       checkOutputAndType
128 " ((((1 - 2) / 3)))" Pexpression " 1 2 - 3 /" int  checkOutputAndType
129 " (1) + 0.23 " Parith " 1 S>F 0.23 F+" float   checkOutputAndType
130 " (1) - 0.23 " Parith " 1 S>F 0.23 F-" float   checkOutputAndType
131 " (1) * 0.23 " Parith " 1 S>F 0.23 F*" float   checkOutputAndType
132 " (1) / 0.23 " Parith " 1 S>F 0.23 F/" float   checkOutputAndType
133 " (0.23) + 1 " Parith " 0.23 1 S>F F+" float   checkOutputAndType
134 " (0.23) - 1 " Parith " 0.23 1 S>F F-" float   checkOutputAndType
135 " (0.23) * 1 " Parith " 0.23 1 S>F F*" float   checkOutputAndType
136 " (0.23) / 1 " Parith " 0.23 1 S>F F/" float   checkOutputAndType
137 " (1.0) + 0.23 " Parith " 1.0 0.23 F+" float   checkOutputAndType
138 " (1.0) - 0.23 " Parith " 1.0 0.23 F-" float   checkOutputAndType
139 " (1.0) * 0.23 " Parith " 1.0 0.23 F*" float   checkOutputAndType
140 " (1.0) / 0.23 " Parith " 1.0 0.23 F/" float   checkOutputAndType
141 " (0.23) + 1.0 " Parith " 0.23 1.0 F+" float   checkOutputAndType
142 " (0.23) - 1.0 " Parith " 0.23 1.0 F-" float   checkOutputAndType
143 " (0.23) * 1.0 " Parith " 0.23 1.0 F*" float   checkOutputAndType
144 " (0.23) / 1.0 " Parith " 0.23 1.0 F/" float   checkOutputAndType
145 " (i   )"           ParithAtom " i" int           checkOutputAndType
146 " (i   )"           Patom " i" int                checkOutputAndType
147 " (i   )"           Parith " i" int               checkOutputAndType
148 " (i   )"           Pexpression " i" int          checkOutputAndType
149 " (    i123)"        ParithAtom " i123" int        checkOutputAndType
150 " (    i123)"        Patom " i123" int             checkOutputAndType
151 " (    i123)"        Parith " i123" int            checkOutputAndType
152 " (    i123)"        Pexpression " i123" int       checkOutputAndType
153 " (f1)  "        ParithAtom " f1" float        checkOutputAndType
154 " (f1)  "        Patom " f1" float             checkOutputAndType
155 " (f1)  "        Pexpression " f1" float       checkOutputAndType
156 " (-123.45e-67)" Parith " 123.45e-67 -1.0 F*" float checkOutputAndType
157 " (123.45e-67)"  Patom " 123.45e-67" float     checkOutputAndType
158 " (-123.45e-67)" Pexpression " 123.45e-67 -1.0 F*" float checkOutputAndType
159 " (i123)"        ParithAtom " i123" int        checkOutputAndType
160 " (i123)"        Pexpression " i123" int       checkOutputAndType
161 " (abc1)"        Patom " abc1" " foo"          checkOutputAndType
162 " (abc1)"        Pexpression " abc1" " foo"    checkOutputAndType
163 " (iseq)"        Pexpression " iseq" " INT INT PROD POW" checkOutputAndType
164 " (iseq)"        Patom " iseq" " INT INT PROD POW" checkOutputAndType
165 " (foo2)"  Patom " foo2" " INT1 INT2 INT3 # foofoo baa" checkOutputAndType
166 " (foo2)"  Pexpression " foo2" " INT1 INT2 INT3 # foofoo baa" checkOutputAndType
167 " (i123)"        Patom " i123" int              checkOutputAndType
168 " (iArr[2])"    Patom SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
169 " (iArr[1 + 2 * 3])"    Patom SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
170 " (iArr[2])"    Parith SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
171 " (iArr[1 + 2 * 3])"    Parith SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
172 " (iArr[2])"    ParithExp SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
173 " (iArr[1 + 2 * 3])"    ParithExp SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
174 " (iArr[2])"    Pexpression SWAP nowspace SWAP " << 2 >> of iArr" int checkOutputAndType
175 " iArr[1 + 2 * 3]"    Pexpression SWAP nowspace SWAP " << 1 2 3 * + >> of iArr" int checkOutputAndType
176 " (iArr)"    Patom " iArr" " INT ARRAY"        checkOutputAndType
177 " (iArr)"    Parith " iArr" " INT ARRAY"       checkOutputAndType
178 " (iArr)"    ParithExp " iArr" " INT ARRAY"    checkOutputAndType
179 " (iArr)"    Pexpression  " iArr" " INT ARRAY" checkOutputAndType
180 " (ARRAY[1, 2, 3])" Patom " HERE 3 , 1 , 2 , 3 , " " INT ARRAY" checkOutputAndType
181 " (ARRAY[1, 2, 3])" Pexpression " HERE 3 , 1 , 2 , 3 , " " INT ARRAY" checkOutputAndType
182 " ( {1, 2, 3})" Patom " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
183 " ( {1, 2, 3})" Pset  " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
184 " ( {1, 2, 3})" Pexpression " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
185 " ([1, 2, 3] )" Patom " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 186 " ([1, 2, 3] )" Pset  " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 187 " ([1, 2, 3] )" Pexpression " INT [ 1 , 2 , 3 , ]" " INT INT PROD POW" checkOutputAndType " ]
DROP 188 " ( foo(1, 2, 3))" Patom " 1 2 3 foo" " foo"   checkOutputAndType
189 " ( foo(1, 2, 3))" Pexpression " 1 2 3 foo" " foo" checkOutputAndType
190 " (ARRAY[])" Patom " HERE 0 , " " ARRAY"      checkOutputAndType
191 " (ARRAY[])" Pexpression " HERE 0 , " " ARRAY" checkOutputAndType
192 " (" " " 0 " 1, 2, 3" PargumentList " foo" )_ " 1 2 3 foo" " foo" checkOutputAndType ( foo is in types )
193 " ( “Campbell”)" Patom " Campbell" addQuotes1 string checkOutputAndType
194 " (“Campbell(((”)" Patom " Campbell(((" addQuotes1 string checkOutputAndType
195 " (“Campbell “Campbell “Campbell “Campbell””””)" Patom " Campbell “Campbell “Campbell “Campbell”””" addQuotes1 string checkOutputAndType
196 " (“Campbell”)" Pexpression " Campbell" addQuotes1 string checkOutputAndType
197 " (“Campbell(((”)" Pexpression " Campbell(((" addQuotes1 string checkOutputAndType
198 " (“Campbell “Campbell “Campbell “Campbell””””)" Pexpression " Campbell “Campbell “Campbell “Campbell”””" addQuotes1 string checkOutputAndType
199 " -123" ParithExp " 123 -1 *" int               checkOutputAndType
200 " -123" Puminus " 123 -1 *" int          checkOutputAndType
201 " -123.45" ParithExp " 123.45 -1.0 F*" float    checkOutputAndType
202 " -123.45" Puminus " 123.45 -1.0 F*" float checkOutputAndType
STRING STRING PROD { " greater" int sspace AZ^ int AZ^ "  # " AZ^ boolean AZ^ |->$,$ , } types ∪ to types
203 " greater(  1   ,  2)" Pfunction " 1 2 greater" boolean checkOutputAndType
204 " greater(  1   ,  2)" Patom " 1 2 greater" boolean checkOutputAndType
205 " greater(  1   ,  2)" PbooleanAtom " 1 2 greater" boolean checkOutputAndType
206 " greater(  1   ,  2)" Pboolean " 1 2 greater" boolean checkOutputAndType
207 " greater(  1   ,  2)" Pexpression " 1 2 greater" boolean checkOutputAndType
208 " TRUE" PbooleanAtom " TRUE" boolean checkOutputAndType
209 " TRUE" Patom " TRUE" boolean checkOutputAndType
210 " TRUE" Pboolean " TRUE" boolean checkOutputAndType
211 " TRUE" Pexpression " TRUE" boolean checkOutputAndType
212 " true" PbooleanAtom " TRUE" boolean checkOutputAndType
213 " true" Patom " TRUE" boolean checkOutputAndType
214 " true" Pboolean " TRUE" boolean checkOutputAndType
215 " true" Pexpression " TRUE" boolean checkOutputAndType
216 " FALSE" PbooleanAtom " FALSE" boolean checkOutputAndType
217 " FALSE" Patom " FALSE" boolean checkOutputAndType
218 " FALSE" Pboolean " FALSE" boolean checkOutputAndType
219 " FALSE" Pexpression " FALSE" boolean checkOutputAndType
220 " false" PbooleanAtom " FALSE" boolean checkOutputAndType
221 " false" Patom " FALSE" boolean checkOutputAndType
222 " false" Pboolean " FALSE" boolean checkOutputAndType
223 " false" Pexpression " FALSE" boolean checkOutputAndType
224 " {false} ⊂ {false, true}" Psubset boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
225 " {false} ⊂ {false, true}" PsubsetBoolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
226 " {false} ⊂ {false, true}" Pboolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
227 " {false} ⊂ {false, true}" Pexpression boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
228 " {true} ⊂ {false, true}" Psubset boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
229 " {true} ⊂ {false, true}" PsubsetBoolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
230 " {true} ⊂ {false, true}" Pboolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
231 " {true} ⊂ {false, true}" Pexpression boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊂" AZ^ boolean checkOutputAndType
232 " {1, 2, 3} ⊂ {4, 5, 6}" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂" AZ^ boolean checkOutputAndType
233 " {1, 2, 3} ⊂ {4, 5, 6}" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂" AZ^ boolean checkOutputAndType
234 " {1, 2, 3} ⊂ {4, 5, 6}" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂" AZ^ boolean checkOutputAndType
235 " {1, 2, 3} ⊂ {4, 5, 6}" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊂" AZ^ boolean checkOutputAndType
236 " {1, 2, 3} ⊂ 1 .. 6" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂" AZ^ boolean checkOutputAndType
237 " {1, 2, 3} ⊂ 1 .. 6" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂" AZ^ boolean checkOutputAndType
238 " {1, 2, 3} ⊂ 1 .. 6" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂" AZ^ boolean checkOutputAndType
239 " {1, 2, 3} ⊂ 1 .. 6" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊂" AZ^ boolean checkOutputAndType
240 " {false} ⊆ {false, true}" Psubset boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
241 " {false} ⊆ {false, true}" PsubsetBoolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
242 " {false} ⊆ {false, true}" Pboolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
243 " {false} ⊆ {false, true}" Pexpression boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
244 " {true} ⊆ {false, true}" Psubset boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
245 " {true} ⊆ {false, true}" PsubsetBoolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
246 " {true} ⊆ {false, true}" Pboolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
247 " {true} ⊆ {false, true}" Pexpression boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊆" AZ^ boolean checkOutputAndType
248 " {1, 2, 3} ⊆ {4, 5, 6}" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆" AZ^ boolean checkOutputAndType
249 " {1, 2, 3} ⊆ {4, 5, 6}" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆" AZ^ boolean checkOutputAndType
250 " {1, 2, 3} ⊆ {4, 5, 6}" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆" AZ^ boolean checkOutputAndType
251 " {1, 2, 3} ⊆ {4, 5, 6}" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆" AZ^ boolean checkOutputAndType
252 " {1, 2, 3} ⊆ 1 .. 6" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
253 " {1, 2, 3} ⊆ 1 .. 6" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
254 " {1, 2, 3} ⊆ 1 .. 6" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
255 " {1, 2, 3} ⊆ 1 .. 6" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
256 " {false} ⊄ {false, true}" Psubset boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
257 " {false} ⊄ {false, true}" PsubsetBoolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
258 " {false} ⊄ {false, true}" Pboolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
259 " {false} ⊄ {false, true}" Pexpression boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
260 " {true} ⊄ {false, true}" Psubset boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
261 " {true} ⊄ {false, true}" PsubsetBoolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
262 " {true} ⊄ {false, true}" Pboolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
263 " {true} ⊄ {false, true}" Pexpression boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
264 " {1, 2, 3} ⊄ {4, 5, 6}" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
265 " {1, 2, 3} ⊄ {4, 5, 6}" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
266 " {1, 2, 3} ⊄ {4, 5, 6}" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
267 " {1, 2, 3} ⊄ {4, 5, 6}" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
268 " {1, 2, 3} ⊄ 1 .. 6" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
269 " {1, 2, 3} ⊄ 1 .. 6" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
270 " {1, 2, 3} ⊄ 1 .. 6" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
271 " {1, 2, 3} ⊄ 1 .. 6" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
272 " {false} ⊈ {false, true}" Psubset boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
273 " {false} ⊈ {false, true}" PsubsetBoolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
274 " {false} ⊈ {false, true}" Pboolean boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
275 " {false} ⊈ {false, true}" Pexpression boolean sspace AZ^ " { FALSE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
276 " {true} ⊈ {false, true}" Psubset boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
277 " {true} ⊈ {false, true}" PsubsetBoolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
278 " {true} ⊈ {false, true}" Pboolean boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
279 " {true} ⊈ {false, true}" Pexpression boolean sspace AZ^ " { TRUE , }" AZ^ sspace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
280 " {1, 2, 3} ⊈ {4, 5, 6}" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
281 " {1, 2, 3} ⊈ {4, 5, 6}" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
282 " {1, 2, 3} ⊈ {4, 5, 6}" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
283 " {1, 2, 3} ⊈ {4, 5, 6}" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ sspace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
284 " {1, 2, 3} ⊈ 1 .. 6" Psubset int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
285 " {1, 2, 3} ⊈ 1 .. 6" PsubsetBoolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
286 " {1, 2, 3} ⊈ 1 .. 6" Pboolean int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
287 " {1, 2, 3} ⊈ 1 .. 6" Pexpression int sspace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
288 " 1 ↦ “Campbell”" Ppair " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
289 " 1 ↦ “Campbell”" Pexpression " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
290 " (1 ↦ “Campbell”)" Ppair " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
291 " (1 ↦ “Campbell”)" Pexpression " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
292 " 1 ↦ 99" Ppair " 1 99 |->I,I" " INT INT PROD" checkOutputAndType
293 " 1 ↦ 99" Pexpression " 1 99 |->I,I" " INT INT PROD" checkOutputAndType
294 " (1 ↦ 99)" Ppair " 1 99 |->I,I" " INT INT PROD" checkOutputAndType
295 " (1 ↦ 99)" Pexpression " 1 99 |->I,I" " INT INT PROD" checkOutputAndType
296 " “Campbell”↦1" Ppair quotespace " Campbell" quotespace "  1" "  |->$,I" AZ^ AZ^ AZ^ AZ^ " STRING INT PROD" checkOutputAndType
297 " “Campbell”↦1" Pexpression quotespace " Campbell" quotespace "  1" "  |->$,I" AZ^ AZ^ AZ^ AZ^ " STRING INT PROD" checkOutputAndType
298 " ( “Campbell”↦1)" Ppair quotespace " Campbell" quotespace "  1" "  |->$,I" AZ^ AZ^ AZ^ AZ^ " STRING INT PROD" checkOutputAndType
299 " ( “Campbell”↦1)" Pexpression quotespace " Campbell" quotespace "  1" "  |->$,I" AZ^ AZ^ AZ^ AZ^ " STRING INT PROD" checkOutputAndType
300 " 1↦“Campbell”" Ppair " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
301 " 1↦“Campbell”" Pexpression " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
302 " (1↦“Campbell”)" Ppair " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
303 " (1↦“Campbell”)" Pexpression " 1 " quotespace " Campbell" quotespace "  |->I,$" AZ^ AZ^ AZ^ AZ^ " INT STRING PROD" checkOutputAndType
304 " {1, 2, 3} ↦ {4, 5, 6}" Ppair " INT { 1 , 2 , 3 , } INT { 4 , 5 , 6 , } |->S,S" " INT POW INT POW PROD" checkOutputAndType
305 " {1, 2, 3} ↦ {4, 5, 6}" Pexpression " INT { 1 , 2 , 3 , } INT { 4 , 5 , 6 , } |->S,S" " INT POW INT POW PROD" checkOutputAndType
306 " 123 ↦ 234 ↦ 456" Ppair " 123 234 |->I,I 456 |->P,I" " INT INT PROD INT PROD" checkOutputAndType
307 " 123 ↦ 234 ↦ 456" Pexpression " 123 234 |->I,I 456 |->P,I" " INT INT PROD INT PROD" checkOutputAndType
308 " 123 ↦ (234 ↦ 456)" Ppair " 123 234 456 |->I,I |->I,P" " INT INT INT PROD PROD" checkOutputAndType
309 " 123 ↦ (234 ↦ 456)" Pexpression " 123 234 456 |->I,I |->I,P" " INT INT INT PROD PROD" checkOutputAndType
310 " {1, 2, 3}" PjoinedSet " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
311 " ({1, (2), 3})" PjoinedSet " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
312 " {1, 2, 3}" Pexpression " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
313 " ({1, (2), 3})" Pexpression " INT { 1 , 2 , 3 , }" " INT POW" checkOutputAndType
314 " {“Campbell”, “Bill”, “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
315 " ({“Campbell”, (“Bill”), “Steve”})" PjoinedSet  SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
316 " {“Campbell”, “Bill”, “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
317 " ({“Campbell”, (“Bill”), “Steve”})" Pexpression  SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
318 " {“Campbell”, “Bill”} ∪ {“Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
319 " ({“Campbell”, (“Bill”)} ∪ {“Steve”})" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
320 " {“Campbell”, “Bill”} ∪ {“Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
321 " ({“Campbell”, (“Bill”)} ∪ {“Steve”})" Pexpression  SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
322  " {“Campbell”, “Bill”} ∩ {“Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP  " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
323 " ({“Campbell”, (“Bill”)} ∩ {“Steve”})" PjoinedSet  SWAP doubleSpaceRemover SWAP  " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
324 " {“Campbell”, “Bill”} ∩ {“Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP  " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
325 " ({“Campbell”, (“Bill”)} ∩ {“Steve”})" Pexpression  SWAP doubleSpaceRemover SWAP  " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
322 " {“Campbell”, “Bill”} \  {“Steve”}" PjoinedSet SWAP doubleSpaceRemover nowspace SWAP  " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ nowspace " STRING POW" checkOutputAndType
323 " ({“Campbell”, (“Bill”)} \  {“Steve”})" PjoinedSet  SWAP doubleSpaceRemover nowspace SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ nowspace " STRING POW" checkOutputAndType
324 " {“Campbell”, “Bill”} \  {“Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP nowspace " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ nowspace " STRING POW" checkOutputAndType
325 " ({“Campbell”, (“Bill”)} \  {“Steve”})" Pexpression  SWAP doubleSpaceRemover nowspace SWAP  " STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { " AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ nowspace " STRING POW" checkOutputAndType
326 " {1, 2, 3, 4, 5, 6} \ {1, 5, 7}" PjoinedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " nowspace " INT POW" checkOutputAndType
327 " ({1, (2), 3,(( 4)), 5, 6} \ {1, 5, 7})" PjoinedSet  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " nowspace " INT POW" checkOutputAndType
328 " {1, 2, 3, 4, 5, 6} \ {1, 5, 7}" Pexpression  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " nowspace " INT POW" checkOutputAndType
329 " ({1, (2), 3,(( 4)), 5, 6} \ {1, 5, 7})" Pexpression  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " nowspace " INT POW" checkOutputAndType
330 " {1, 2, 3, 4, 5, 6} ∪ {1, 5, 7}" PjoinedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
331 " ({1, (2), 3,(( 4)), 5, 6} ∪ {1, 5, 7})" PjoinedSet  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
332 " {1, 2, 3, 4, 5, 6} ∪ {1, 5, 7}" Pexpression  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
333 " ({1, (2), 3,(( 4)), 5, 6} ∪ {1, 5, 7})" Pexpression  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
334 " {1, 2, 3, 4, 5, 6} ∩ {1, 5, 7}" PjoinedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
335 " ({1, (2), 3,(( 4)), 5, 6} ∩ {1, 5, 7})" PjoinedSet  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
336 " {1, 2, 3, 4, 5, 6} ∩ {1, 5, 7}" Pexpression  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
337 " ({1, (2), 3,(( 4)), 5, 6} ∩ {1, 5, 7})" Pexpression  SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
338 " {1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
339 " {1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
340 " {(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
341 " {(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
342 " {1 ↦ 1, 1 ↦ 2, 2 ↦ 3, 99 ↦ 4, 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" PjoinedSet " INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
343 " {1 ↦ 1, 1 ↦ 2, 2 ↦ 3, 99 ↦ 4, 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" Pexpression " INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
344 " ({1 ↦ 1, 1 ↦ (2), 2 ↦ 3,((99 ↦ 4)), 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet " INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
345 " ({1 ↦ 1, 1 ↦ (2), 2 ↦ 3,((99 ↦ 4)), 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet " INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
346 " ({1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" PjoinedSet SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
347 " ({1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" Pexpression SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
348 " ({(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" Pexpression  SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
349 " ({(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" PjoinedSet SWAP doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
350 " [“Campbell”, “Bill”] ⊕ {97 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 351 " [“Campbell”, “Bill”] ⊕ {97 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 352 " [“Campbell”, “Bill”] ⊕ {2 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 353 " [“Campbell”, “Bill”] ⊕ {2 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 354 " ([(“Campbell”), “Bill”] ⊕ {(2 ↦ “Steve”), 3  ↦ “Colin”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , 3 " AZ^ " Colin" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 355 " ([(“Campbell”), “Bill”] ⊕ {(2 ↦ “Steve”), 3  ↦ “Colin”})" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , 3 " AZ^ " Colin" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 356 " [1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" PjoinedSet " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
357 " [1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" Pexpression " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
358 " ([1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
359 " ([1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
360 " {97, 98, 99} ◁  {1 ↦ “Campbell”, 97 ↦ “Bill”} " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
361  " {97, 98, 99} ◁  {1 ↦ “Campbell”, 97 ↦ “Bill”} " Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
362  " ({97, (98), 99} ◁  ({1 ↦ “Campbell”, (97) ↦ “Bill”})) "  Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
363  " ({97, (98), 99} ◁  ({1 ↦ “Campbell”, (97) ↦ “Bill”})) " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
364 " {97, 98, 99} ◁- {1 ↦ “Campbell”, 97 ↦ “Bill”} " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
365 " {97, 98, 99} ◁- {1 ↦ “Campbell”, 97 ↦ “Bill”} " Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
366  " ({97, (98), 99} ◁- ({1 ↦ “Campbell”, (97) ↦ “Bill”})) "  Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
367  " ({97, (98), 99} ◁- ({1 ↦ “Campbell”, (97) ↦ “Bill”})) " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
368 " {97, 98, 99} ◁ [“Campbell”, “Bill”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
369 " {97, 98, 99} ◁ [“Campbell”, “Bill”] " Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
370 " (({97, 98, 99}) ◁ [(“Campbell”), “Bill”] )" Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
371 " (({97, 98, 99}) ◁ [(“Campbell”), “Bill”] )" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
372 " {97, 98, 99} ◁- [“Campbell”, “Bill”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
373 " {97, 98, 99} ◁- [“Campbell”, “Bill”] " Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
374 " (({97, 98, 99}) ◁- [(“Campbell”), “Bill”] )" Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
375 " (({97, 98, 99}) ◁- [(“Campbell”), “Bill”] )" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
376 " {1, 2, 3} ◁  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
377 " {1, 2, 3} ◁  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
378 " (({(1), 2, 3}) ◁  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
379 " (({(1), 2, 3}) ◁  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
380 " {1, 2, 3} ◁-  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
381 " (({(1), 2, 3}) ◁-  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
382 " {1, 2, 3} ◁-  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
383 " (({(1), 2, 3}) ◁-  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
384 " {1, 2, 69, 4} ◁ [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
385 " {1, 2, 69, 4} ◁- [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
386 " {1, 2, 69, 4} ◁ [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
387 " {1, 2, 69, 4} ◁- [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
388 " (({1, 2, 69, 4}) ◁ ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
389 " (({1, 2, 69, 4}) ◁- ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
390 " (({1, 2, 69, 4}) ◁ ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
391 " (({1, 2, 69, 4}) ◁- ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
392 " ({“Campbell”} ∪ {“Andy”}) ◁ {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
393 " ({“Campbell”} ∪ {“Andy”}) ◁ {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" Pexpression SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
394 " ({“Campbell”} ∪ {“Andy”}) ◁ ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
395 " ({“Campbell”} ∪ {“Andy”}) ◁ ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
396 " ({“Campbell”} ∪ {“Andy”}) ◁- {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
397 " ({“Campbell”} ∪ {“Andy”}) ◁- {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" Pexpression SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
398 " ({“Campbell”} ∪ {“Andy”}) ◁- ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
399 " ({“Campbell”} ∪ {“Andy”}) ◁- ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
400 " ({“Campbell”} ∪ {“Andy”}) ◁ {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
401 " ({“Campbell”} ∪ {“Andy”}) ◁ ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
402 " ({“Campbell”} ∪ {“Andy”}) ◁- {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
403 " ({“Campbell”} ∪ {“Andy”}) ◁- ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedExp SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
404 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ({“Sarah”} ∪ {“Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
405 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
406 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ({“Sarah”} ∪ {“Eleanor”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
407 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
408 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ({“Sarah”} ∪ {“Eleanor”})" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
409 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
410 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}▷ ({“Sarah”} ∪ {“Eleanor”})" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
411 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷ ((({“Sarah”})) ∪ {“Eleanor”})" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
412 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
413 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
414 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
415 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
416 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
417 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
418 " {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ({“Sarah”} ∪ {“Eleanor”})" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
419 " {((“Campbell”) ↦ “Ruth”), “John” ↦ (((“Laura”))),    “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”} ▷- ((({“Sarah”})) ∪ {“Eleanor”})" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING STRING PROD { " " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
420 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
421 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
422 " [“Ruth”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
423 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
424 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedExp SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
425 " ([(“Ruth”), ((“Laura”)), “Sarah”, “Eleanor”, “Eleanor”])  ▷ ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth" addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
426 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" PrangeRestrictedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
427 " [“Ruth,,”, “Laura”, “Sarah”, “Eleanor”, “Eleanor”]  ▷ ({“Sarah”} ∪  {“Eleanor”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING [ " " Ruth,," addQuotes1 AZ^ " , " AZ^ " Laura" addQuotes1 AZ^ " , " AZ^ " Sarah" addQuotes1 AZ^ "  , " AZ^ " Eleanor" addQuotes1 AZ^ " , " AZ^ " Eleanor" addQuotes1 AZ^ "  , ] STRING { " AZ^ " Sarah" addQuotes1 AZ^ " , } STRING { " AZ^ " Eleanor" addQuotes1 AZ^ " , } ∪ ▷" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType

CR " HereEndethTheTestFile" .AZ CR
