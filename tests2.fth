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

( The tests follow: some require the types relation be extant. )
251 " {1, 2, 3} ⊆ {4, 5, 6}" Pexpression int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊆" AZ^ boolean checkOutputAndType
252 " {1, 2, 3} ⊆ 1 .. 6" Psubset int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
253 " {1, 2, 3} ⊆ 1 .. 6" PsubsetBoolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
254 " {1, 2, 3} ⊆ 1 .. 6" Pboolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
255 " {1, 2, 3} ⊆ 1 .. 6" Pexpression int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊆" AZ^ boolean checkOutputAndType
256 " {false} ⊄ {false, true}" Psubset boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
257 " {false} ⊄ {false, true}" PsubsetBoolean boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
258 " {false} ⊄ {false, true}" Pboolean boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
259 " {false} ⊄ {false, true}" Pexpression boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
260 " {true} ⊄ {false, true}" Psubset boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
261 " {true} ⊄ {false, true}" PsubsetBoolean boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
262 " {true} ⊄ {false, true}" Pboolean boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
263 " {true} ⊄ {false, true}" Pexpression boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊄" AZ^ boolean checkOutputAndType
264 " {1, 2, 3} ⊄ {4, 5, 6}" Psubset int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
265 " {1, 2, 3} ⊄ {4, 5, 6}" PsubsetBoolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
266 " {1, 2, 3} ⊄ {4, 5, 6}" Pboolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
267 " {1, 2, 3} ⊄ {4, 5, 6}" Pexpression int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊄" AZ^ boolean checkOutputAndType
268 " {1, 2, 3} ⊄ 1 .. 6" Psubset int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
269 " {1, 2, 3} ⊄ 1 .. 6" PsubsetBoolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
270 " {1, 2, 3} ⊄ 1 .. 6" Pboolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
271 " {1, 2, 3} ⊄ 1 .. 6" Pexpression int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊄" AZ^ boolean checkOutputAndType
272 " {false} ⊈ {false, true}" Psubset boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
273 " {false} ⊈ {false, true}" PsubsetBoolean boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
274 " {false} ⊈ {false, true}" Pboolean boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
275 " {false} ⊈ {false, true}" Pexpression boolean sSpace AZ^ " { FALSE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
276 " {true} ⊈ {false, true}" Psubset boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
277 " {true} ⊈ {false, true}" PsubsetBoolean boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
278 " {true} ⊈ {false, true}" Pboolean boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
279 " {true} ⊈ {false, true}" Pexpression boolean sSpace AZ^ " { TRUE , }" AZ^ sSpace AZ^ boolean AZ^ "  { FALSE , TRUE , } ⊈" AZ^ boolean checkOutputAndType
280 " {1, 2, 3} ⊈ {4, 5, 6}" Psubset int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
281 " {1, 2, 3} ⊈ {4, 5, 6}" PsubsetBoolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
282 " {1, 2, 3} ⊈ {4, 5, 6}" Pboolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
283 " {1, 2, 3} ⊈ {4, 5, 6}" Pexpression int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ sSpace AZ^ int AZ^ "  { 4 , 5 , 6 , } ⊈" AZ^ boolean checkOutputAndType
284 " {1, 2, 3} ⊈ 1 .. 6" Psubset int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
285 " {1, 2, 3} ⊈ 1 .. 6" PsubsetBoolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
286 " {1, 2, 3} ⊈ 1 .. 6" Pboolean int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
287 " {1, 2, 3} ⊈ 1 .. 6" Pexpression int sSpace AZ^ " { 1 , 2 , 3 , }" AZ^ "  1 6 .. ⊈" AZ^ boolean checkOutputAndType
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
314 " {“Campbell”, “Bill”, “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^
" Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
315 " ({“Campbell”, (“Bill”), “Steve”})" PjoinedSet  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^
" Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
316 " {“Campbell”, “Bill”, “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^
" Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
317 " ({“Campbell”, (“Bill”), “Steve”})" Pexpression  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^
" Steve" addQuotes1 AZ^ " , }" AZ^ " STRING POW" checkOutputAndType
318 " {“Campbell”, “Bill”} ∪ {“Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
319 " ({“Campbell”, (“Bill”)} ∪ {“Steve”})" PjoinedSet SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
320 " {“Campbell”, “Bill”} ∪ {“Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
321 " ({“Campbell”, (“Bill”)} ∪ {“Steve”})" Pexpression  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∪" AZ^ " STRING POW" checkOutputAndType
322  " {“Campbell”, “Bill”} ∩ {“Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
323 " ({“Campbell”, (“Bill”)} ∩ {“Steve”})" PjoinedSet  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
324 " {“Campbell”, “Bill”} ∩ {“Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
325 " ({“Campbell”, (“Bill”)} ∩ {“Steve”})" Pexpression  SWAP doubleSpaceRemover SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } ∩" AZ^ " STRING POW" checkOutputAndType
326 " {“Campbell”, “Bill”} \  {“Steve”}" PjoinedSet SWAP doubleSpaceRemover noWSpace SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ noWSpace " STRING POW" checkOutputAndType
327 " ({“Campbell”, (“Bill”)} \  {“Steve”})" PjoinedSet  SWAP doubleSpaceRemover noWSpace SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ noWSpace " STRING POW" checkOutputAndType
328 " {“Campbell”, “Bill”} \  {“Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP noWSpace
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ noWSpace " STRING POW" checkOutputAndType
329 " ({“Campbell”, (“Bill”)} \  {“Steve”})" Pexpression  SWAP doubleSpaceRemover noWSpace SWAP
" STRING { " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , } STRING { "
AZ^ " Steve" addQuotes1 AZ^ " , } \ " AZ^ noWSpace " STRING POW" checkOutputAndType
330 " {1, 2, 3, 4, 5, 6} \ {1, 5, 7}" PjoinedSet SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " noWSpace " INT POW" checkOutputAndType
331 " ({1, (2), 3,(( 4)), 5, 6} \ {1, 5, 7})" PjoinedSet  SWAP doubleSpaceRemover
SWAP " INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " noWSpace " INT POW" checkOutputAndType
332 " {1, 2, 3, 4, 5, 6} \ {1, 5, 7}" Pexpression  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " noWSpace " INT POW" checkOutputAndType
333 " ({1, (2), 3,(( 4)), 5, 6} \ {1, 5, 7})" Pexpression  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } \ " noWSpace " INT POW" checkOutputAndType
334 " {1, 2, 3, 4, 5, 6} ∪ {1, 5, 7}" PjoinedSet SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
335 " ({1, (2), 3,(( 4)), 5, 6} ∪ {1, 5, 7})" PjoinedSet  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
336 " {1, 2, 3, 4, 5, 6} ∪ {1, 5, 7}" Pexpression  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
337 " ({1, (2), 3,(( 4)), 5, 6} ∪ {1, 5, 7})" Pexpression  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∪" " INT POW" checkOutputAndType
338 " {1, 2, 3, 4, 5, 6} ∩ {1, 5, 7}" PjoinedSet SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
339 " ({1, (2), 3,(( 4)), 5, 6} ∩ {1, 5, 7})" PjoinedSet  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
340 " {1, 2, 3, 4, 5, 6} ∩ {1, 5, 7}" Pexpression  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
341 " ({1, (2), 3,(( 4)), 5, 6} ∩ {1, 5, 7})" Pexpression  SWAP doubleSpaceRemover SWAP
" INT { 1 , 2 , 3 , 4 , 5 , 6 , } INT { 1 , 5 , 7 , } ∩" " INT POW" checkOutputAndType
342 " {1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP
" INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^
" |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
343 " {1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP
" INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^
" |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
344 " {(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover
SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1
AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
345 " {(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover
SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1
AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
346 " {1 ↦ 1, 1 ↦ 2, 2 ↦ 3, 99 ↦ 4, 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" PjoinedSet
" INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕"
" INT INT PROD POW" checkOutputAndType
347 " {1 ↦ 1, 1 ↦ 2, 2 ↦ 3, 99 ↦ 4, 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" Pexpression
" INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕"
" INT INT PROD POW" checkOutputAndType
348 " ({1 ↦ 1, 1 ↦ (2), 2 ↦ 3,((99 ↦ 4)), 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet
" INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕"
" INT INT PROD POW" checkOutputAndType
349 " ({1 ↦ 1, 1 ↦ (2), 2 ↦ 3,((99 ↦ 4)), 4 ↦ 5, 5 ↦ 6} ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet " INT INT PROD { 1 1 |->I,I , 1 2 |->I,I , 2 3 |->I,I , 99 4 |->I,I , 4 5 |->I,I , 5 6 |->I,I , } INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
350 " ({1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" PjoinedSet SWAP doubleSpaceRemover
SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1
AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
351 " ({1 ↦ “Campbell”, 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" Pexpression SWAP doubleSpaceRemover
SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1
AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
352 " ({(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" Pexpression  SWAP
doubleSpaceRemover SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 "
AZ^ " Bill" addQuotes1 AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1
AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
353 " ({(1 ↦ “Campbell”), 97 ↦ “Bill”} ⊕ {97 ↦ “Steve”})" PjoinedSet SWAP doubleSpaceRemover
SWAP " INT STRING PROD  { 1 " " Campbell" addQuotes1 AZ^ " |->I,$ , 97 " AZ^ " Bill" addQuotes1
AZ^ " |->I,$ , } INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^
doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
354 " [“Campbell”, “Bill”] ⊕ {97 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 355 " [“Campbell”, “Bill”] ⊕ {97 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 97 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 356 " [“Campbell”, “Bill”] ⊕ {2 ↦ “Steve”}" Pexpression  SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 357 " [“Campbell”, “Bill”] ⊕ {2 ↦ “Steve”}" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 358 " ([(“Campbell”), “Bill”] ⊕ {(2 ↦ “Steve”), 3  ↦ “Colin”})" Pexpression SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , 3 " AZ^ " Colin" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 359 " ([(“Campbell”), “Bill”] ⊕ {(2 ↦ “Steve”), 3  ↦ “Colin”})" PjoinedSet SWAP doubleSpaceRemover SWAP " STRING [ " " Campbell" addQuotes1 AZ^ "  , " AZ^ " Bill" addQuotes1 AZ^ "  , ] INT STRING PROD  { 2 " AZ^ " Steve" addQuotes1 AZ^ " |->I,$ , 3 " AZ^ " Colin" addQuotes1 AZ^ " |->I,$ , } ⊕" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType " [
DROP 360 " [1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" PjoinedSet " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
361 " [1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7}" Pexpression " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
362 " ([1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
363 " ([1, 2, 3, 4, 5, 6] ⊕ {1 ↦ 1, 1 ↦ 5, 2 ↦ 7})" PjoinedSet " INT [ 1 , 2 , 3 , 4 , 5 , 6 , ] INT INT PROD { 1 1 |->I,I , 1 5 |->I,I , 2 7 |->I,I , } ⊕" " INT INT PROD POW" checkOutputAndType
364 " {97, 98, 99} ◁  {1 ↦ “Campbell”, 97 ↦ “Bill”} " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
365  " {97, 98, 99} ◁  {1 ↦ “Campbell”, 97 ↦ “Bill”} " Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
366  " ({97, (98), 99} ◁  ({1 ↦ “Campbell”, (97) ↦ “Bill”})) "  Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
367  " ({97, (98), 99} ◁  ({1 ↦ “Campbell”, (97) ↦ “Bill”})) " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
368 " {97, 98, 99} ◁- {1 ↦ “Campbell”, 97 ↦ “Bill”} " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
369 " {97, 98, 99} ◁- {1 ↦ “Campbell”, 97 ↦ “Bill”} " Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
370  " ({97, (98), 99} ◁- ({1 ↦ “Campbell”, (97) ↦ “Bill”})) "  Pexpression " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
371  " ({97, (98), 99} ◁- ({1 ↦ “Campbell”, (97) ↦ “Bill”})) " PdomainRestrictedSet " INT { 97 , 98 , 99 , } INT STRING PROD { 1 " " Campbell" addQuotes1 AZ^ "  |->I,$ , 97 " AZ^ " Bill" addQuotes1 AZ^ "  |->I,$ , } ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
372 " {97, 98, 99} ◁ [“Campbell”, “Bill”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
373 " {97, 98, 99} ◁ [“Campbell”, “Bill”] " Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
374 " (({97, 98, 99}) ◁ [(“Campbell”), “Bill”] )" Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
375 " (({97, 98, 99}) ◁ [(“Campbell”), “Bill”] )" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
376 " {97, 98, 99} ◁- [“Campbell”, “Bill”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
377 " {97, 98, 99} ◁- [“Campbell”, “Bill”] " Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
378 " (({97, 98, 99}) ◁- [(“Campbell”), “Bill”] )" Pexpression SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
379 " (({97, 98, 99}) ◁- [(“Campbell”), “Bill”] )" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 97 , 98 , 99 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ "  , ] ◁-" AZ^ doubleSpaceRemover " INT STRING PROD POW" checkOutputAndType
380 " {1, 2, 3} ◁  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
381 " {1, 2, 3} ◁  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
382 " (({(1), 2, 3}) ◁  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
383 " (({(1), 2, 3}) ◁  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁" AZ^ " INT STRING PROD POW" checkOutputAndType
384 " {1, 2, 3} ◁-  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
385 " (({(1), 2, 3}) ◁-  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
386 " {1, 2, 3} ◁-  [“Campbell”, “Bill”, “Steve”, “Dave”, “Rob”, “HaiYun”] " PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
387 " (({(1), 2, 3}) ◁-  ([(“Campbell”), ((“Bill”)), “Steve”, “Dave”, “Rob”, “HaiYun”])) " Pexpression SWAP doubleSpaceRemover SWAP " INT { 1 , 2 , 3 , } STRING [ " " Campbell" addQuotes1 AZ^ " , " AZ^ " Bill" addQuotes1 AZ^ " , " AZ^ " Steve" addQuotes1 AZ^ " , " AZ^ " Dave" addQuotes1 AZ^ " , " AZ^ " Rob" addQuotes1 AZ^ " , " AZ^ " HaiYun" addQuotes1 AZ^ " , ] ◁-" AZ^ " INT STRING PROD POW" checkOutputAndType
388 " {1, 2, 69, 4} ◁ [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
389 " {1, 2, 69, 4} ◁- [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
390 " {1, 2, 69, 4} ◁ [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
391 " {1, 2, 69, 4} ◁- [1, 87243, 827, 18, 0, 99, 1, 2, 69, 4]" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
392 " (({1, 2, 69, 4}) ◁ ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
393 " (({1, 2, 69, 4}) ◁- ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" PdomainRestrictedSet " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
394 " (({1, 2, 69, 4}) ◁ ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁" " INT INT PROD POW" checkOutputAndType
395 " (({1, 2, 69, 4}) ◁- ([1, (87243),( 827), 18, 0, 99, 1, 2, 69, 4]))" Pexpression " INT { 1 , 2 , 69 , 4 , } INT [ 1 , 87243 , 827 , 18 , 0 , 99 , 1 , 2 , 69 , 4 , ] ◁-" " INT INT PROD POW" checkOutputAndType
396 " ({“Campbell”} ∪ {“Andy”}) ◁ {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
397 " ({“Campbell”} ∪ {“Andy”}) ◁ {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" Pexpression SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
398 " ({“Campbell”} ∪ {“Andy”}) ◁ ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
399 " ({“Campbell”} ∪ {“Andy”}) ◁ ({(“Campbell” ↦ “Ruth”), ((“John” ↦ “Laura”)), “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”})" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType
400 " ({“Campbell”} ∪ {“Andy”}) ◁- {“Campbell” ↦ “Ruth”, “John” ↦ “Laura”, “Andy” ↦ “Sarah”, “Paul” ↦ “Eleanor”, “Jonathan” ↦ “Eleanor”}" PdomainRestrictedSet SWAP doubleSpaceRemover SWAP " STRING { " " Campbell" addQuotes1 AZ^ " , } STRING { " AZ^ " Andy" addQuotes1 AZ^ " , } ∪ STRING STRING PROD { " AZ^ " Campbell" addQuotes1 AZ^ " Ruth" addQuotes1 AZ^ "  |->$,$ , " AZ^ " John" addQuotes1 AZ^ " Laura" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Andy" addQuotes1 AZ^ " Sarah" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Paul" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , " AZ^ " Jonathan" addQuotes1 AZ^ " Eleanor" addQuotes1 AZ^ "  |->$,$ , } ◁-" AZ^ doubleSpaceRemover " STRING STRING PROD POW" checkOutputAndType

CR " HereEndethThe2ndTestFile" .AZ CR
