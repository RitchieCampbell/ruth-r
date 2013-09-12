CONSTANTS set 10..20,
        primes {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59,
        61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137,
        139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211,
        223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283,
        293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379,
        383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461,
        463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563,
        569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643,
        647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739,
        743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829,
        839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937,
        941, 947, 953, 967, 971, 977, 983, 991, 997} END

fSet ℙ(INT × INT) ← factors(k INT, set ℙ(INT)) ≙
       VARIABLES i INT, j INT END
       fSet :=
       {
            i :∈ set;
            j :∈ set;
            i * j = k → SKIP ♢ j ↦ i
       }
       END ;

primeSet ℙ(INT × INT) ← primeFactors(i INT) ≙
         VARIABLES j INT, k INT, numbers ℙ(INT) END
         primeSet := {j :∈ primes ♢ j ↦ 0};
         numbers := primes;
         WHILE
            ¢numbers > 0
         DO
            j :∈ numbers;
            numbers := numbers \ {j};
            WHILE
                i % j = 0
            DO
                i := i / j;
                k := primeSet(j) + 1;
                primeSet := primeSet ⊕ {j ↦ k};
            END
         END
         END ;

printPrimes(set ℙ(INT × INT)) ≙
        VARIABLES i INT, s STRING, numbers ℙ(INT) END
        s := “”;
        numbers := primes;
        WHILE
            ¢numbers > 0
        DO
            i :∈ numbers;
            numbers := numbers \ {i};
            IF
                set(i) > 0
            THEN
                s := “” ^ i ^ “^” ^ set(i) ^ “ ” ^ s;
            END
        END ;
        PRINT s;
        PRINT
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
        PRINT factors(521, {1, 521});
        PRINT;
        PRINT 480;
        printPrimes(primeFactors(480));
        PRINT 240;
        printPrimes(primeFactors(240));
        PRINT 256;
        printPrimes(primeFactors(256));
        PRINT 521;
        printPrimes(primeFactors(521));

