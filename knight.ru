CONSTANTS
    moves ARRAY[-17, -15, -10, -6, 6, 10, 15, 17], eight 8, sixtyfour eight * eight
END
VARIABLES priorities INT[64], moveSet ℙ(INT), sqSet ℙ(INT) END

/* Convert indices from 0-based to 1-based */
i INT ← getIndex(index INT) ≙ i := index + 1 END ;

/*
 * Set up priorities as per Alwan and Waters' second example.
 * Also moveSet to {}, sqSet to 0..63. sqSet may prove to be surplus to requirements
 */
initialise ≙
    VARIABLES index INT END
    priorities := ARRAY[
        8, 7, 6, 5, 5, 6, 7, 8, 7, 6, 4, 3, 3, 4, 6, 7,
        6, 4, 2, 2, 2, 2, 4, 6, 5, 3, 2, 1, 1, 2, 3, 5,
        5, 3, 2, 1, 1, 2, 3, 5, 6, 4, 2, 2, 2, 2, 4, 6,
        7, 6, 4, 3, 3, 4, 6, 7, 8, 7, 6, 5, 5, 6, 7, 8];
    moveSet := {1} \ {1};
    sqSet := 0 .. sixtyfour - 1;
    index := 0;
    WHILE
        index < ¢moves
    DO
        moveSet := moveSet ∪ {moves[getIndex(index)]};
        index := index + 1;
    END
    END ;

/* Find whether a move falls off the board: true = OK, false = invalid move
 * sq = starting square 0-based, move = how many squares.
 */
b BOO ← stillInBoard(sq INT, move INT) ≙
    VARIABLES newSq INT END
    newSq := sq + move;
    b := newSq < sixtyfour;
    b := b ∧ newSq ≥ 0;
    IF
        b ∧ sq % eight < 2
    THEN
        b := newSq % eight < 5
    END ;
    IF
        b ∧ sq % eight ≥ 5
    THEN
        b := newSq % eight > 2
    END
    END ;

/* True if square is still available, otherwise false: sq 0-based */
i INT ← squarePriority(sq INT) ≙ i := priorities[getIndex(sq)] END ;

/* True if square is still available, otherwise false: sq 0-based */
b BOO ← squareAvailable(sq INT) ≙ b := priorities[getIndex(sq)] > 0 END ;

/* Visits a square and sets it not available (0) in priorities: sq 0-based */
visitSquare(sq INT) ≙ priorities[getIndex(sq)] := 0;
    sqSet := sqSet \ {sq}
    END ;

/* Find whether there are any square available from the 8 moves: if actually
 * on board, test whether any available: sort of existential quantification.
 * sq is 0-based.
 */
b BOO ← anyAvailable(sq INT) ≙
    VARIABLES index INT END
    index := 0;
    b := false;
    WHILE
        ¬b ∧ index < ¢moves
    DO
        IF
            stillInBoard(sq, moves[getIndex(index)])
        THEN
            b := squareAvailable(sq + moves[getIndex(index)]);
        END;
        index := index + 1
    END 
    END ;

/* Find whether there are all squares available from the 8 moves: sq is 0-based.
 */
b BOO ← all8Available(sq INT) ≙
    VARIABLES index INT END
    index := 0;
    b := true;
    WHILE
        b ∧ index < ¢moves
    DO
        b := b ∧ stillInBoard(sq, moves[getIndex(index)]);
        IF
            b
        THEN
            b := squareAvailable(sq + moves[getIndex(index)]);
        END;
        index := index + 1
    END
    END ;

/* Finds a sequence of squares still available from a certain starting square, along
 * with their priorities. sq=starting square, 0-based. Result=[sq × priority]
 */
seq ℙ(INT × INT × INT) ← availableSquaresWithPrecedence(sq INT) ≙
    VARIABLES index INT, move INT END
    index := 0;
    seq := [0 ↦ 0] ↓ 1;
    WHILE
        index < ¢moves
    DO
        move := moves[getIndex(index)];
        IF
            stillInBoard(sq, move)
        THEN
            IF
                squareAvailable(sq + move)
            THEN
                seq := seq ← (sq + move ↦ squarePriority(sq + move))
            END
        END;
        index := index + 1
    END
    END ;

/* Finds a set of squares still available from a certain starting square,
 * without their priorities. sq=starting square, 0-based. Result={sq}
 */
set ℙ(INT) ← availableSquares(sq INT) ≙
    VARIABLES index INT, move INT END
    index := 0;
    set := {0} \ {0};
    WHILE
        index < ¢moves
    DO
        move := moves[getIndex(index)];
        IF
            stillInBoard(sq, move)
        THEN
            IF
                squareAvailable(sq + move)
            THEN
                set := set ∪ {sq + move}
            END
        END;
        index := index + 1
    END
    END ;

/* Confirms that all squares have been visited: true=all used false=some available */
b BOO ← allSquaresDone ≙
     b := ∀x • x ∈ 0..(¢priorities - 1) ⇒ priorities[getIndex(x)] = 0;
     END ;

/* 
 * Returns a sequence of squares to visit, in order of precedence, so the higher
 * precedences are at the beginning. If two have the same precedence, the first
 * found appears first. Padded at the end with -1 so as to have cardinality 8.
 * sq = number 0-based of square to start from
 */
seq ℙ(INT × INT) ← squaresInOrder (sq INT) ≙
    VARIABLES index INT, prec INT, sqPrecs ℙ(INT × INT × INT) END
    seq := [0] ↓ 1;
    sqPrecs := availableSquaresWithPrecedence(sq);
    index := 0;
    prec := eight;
    WHILE
        prec > 0
    DO
        WHILE
            index < ¢sqPrecs
        DO
            IF
                ®(sqPrecs(getIndex(index))) = prec
            THEN
                seq := seq ← ł(sqPrecs(getIndex(index)));
            END;
            index := index + 1
        END;
        index := 0;
        prec := prec - 1
    END;
    WHILE
        ¢seq < eight
    DO
        seq := seq ← -1
    END END ;
/*
 * For testing only: demonstrates how many squares are accessible
 * using stillInBoard
 */
testMove ≙
    VARIABLES square INT, index INT, results ℙ(INT × INT) END
    square := 0;
    WHILE
        square < ¢priorities
    DO
        results := [123] ↑ 0;
        index := 0;
        WHILE
            index < ¢moves
        DO
            IF
                stillInBoard(square, moves[getIndex(index)])
            THEN
                results := results ← (square + moves[getIndex(index)])
            END;
            index := index + 1
        END;
        PRINT “From ” ^ square ^ “ there are ” ^ ¢results ^ “ moves: ”;
        index := 0;
        WHILE
            index < ¢results
        DO
            PRINT results(getIndex(index));
            index := index + 1;
            PRINT “ ”;
        END;
        PRINT;
        square := square + 1;
    END
    END ;

/*
 * Starts from a particular square (0-based) and tries all the squares in
 * squaresInOrder with preferential choice. If any of the squares is greater than
 * 0 or equal, try that, and if it is available, visitSquare.
 */
next INT ← trySquare(sq INT) ≙ VARIABLES possibles ℙ(INT × INT) END
    possibles := squaresInOrder(sq);
        next := possibles(1) ▯ next := possibles(2) ▯ next := possibles(3) ▯
        next := possibles(4) ▯ next := possibles(5) ▯ next := possibles(6) ▯
        next := possibles(7) ▯ next := possibles(8) ;
    next ≥ 0 → (squareAvailable(next) → visitSquare(next))
    END ;

/* Start the app */
run ≙ initialise ;
