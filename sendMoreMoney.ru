d INT, e INT, m INT, n INT, o INT, r INT, s INT, y INT ← sendMoreMoney ≙
    VARIABLES c0 INT, c1 INT, c2 INT, digits ℙ(INT) END
    m := 1;
    digits := 0..9 \ {m};
    d :∈ digits;
    digits := digits \ {d};
    e :∈ digits;
    digits := digits \ {e};
    y := (d + e) % 10;
    y ∈ digits → digits := digits \ {y};
    c0 := (d + e) / 10;
    n :∈ digits;
    digits := digits \ {n};
    r :∈ digits;
    digits := digits \ {r};
    e = (c0 + n + r) % 10 → c1 := (c0 + n + r) / 10;
    o :∈ digits;
    digits := digits \ {o};
    n = (c1 + e + o) % 10 → c2 := (c1 + e + o) / 10;
    s :∈ digits;
    digits := digits \ {s};
    o = (c2 + s + m) % 10 ∧ m = (c2 + m + s) / 10 → SKIP
    END ;

run ≙
    VARIABLES d INT, e INT, m INT, n INT, o INT, r INT, s INT, y INT END
    d, e, m, n, o, r, s, y := sendMoreMoney;
    PRINT;
    PRINT “ ”;
    PRINT s * 1000 + e * 100 + n * 10 + d;
    PRINT;
    PRINT “ ”;
    PRINT m * 1000 + o * 1000 + r * 10 + e;
    PRINT “ +”;
    PRINT;
    PRINT “_____”;
    PRINT;
    PRINT m * 10000 + o * 1000 + n * 100 + e * 10 + y;
    PRINT

