CONSTANTS set 10..20 END

fSet ℙ(INT × INT) ← factors(k INT, set ℙ(INT)) ≙
       VARIABLES i INT, j INT END
       fSet :=
       {
            i :∈ set;
            j :∈ set;
            i * j = k → SKIP ♢ j ↦ i
       }
       END ;

printFactors ≙
        PRINT factors(480, set);
        PRINT;
        PRINT factors(480, set ∪ {24});
        PRINT;
        PRINT factors(240, set);
        PRINT;
        PRINT factors(256, set);
        PRINT;
        PRINT factors(521, set);
        PRINT;
        PRINT factors(521, 1..23);
        PRINT;
        PRINT factors(521, {1, 521})

