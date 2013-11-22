CONSTANTS ZERO 0, ONE 1, NINE 9, THREE 3, EMPTYSET {0} \ {0} END
VARIABLES grid ℙ(INT × ℙ(INT × INT)), allPossibles ℙ(INT × ℙ(INT × ℙ(INT))) END

/* For use of 0-based indices */
index INT ← getIndex(i INT) ≙ index := i + 1 END ;

/*
 * Initialise the grid to what the newspaper printed, and allPossibles to 1..9
 * throughout.
 */
initialise ≙
        VARIABLES i INT, possibleSquare ℙ(INT), possibleRow ℙ(INT × ℙ(INT)) END
        i := 0;
        possibleSquare := ONE..NINE;
        possibleRow := [{0}] ↓ 1;
        WHILE
            i < NINE
        DO
            possibleRow := possibleRow ← possibleSquare;
            i := i + 1;
        END;
        i := 0;
        allPossibles := [[{0}]] ↓ 1;
        WHILE
            i < NINE
        DO
            allPossibles := allPossibles ← possibleRow;
            i := i + 1;
        END;
        grid :=
        [[0, 0, 0, 2, 0, 0, 0, 1, 0],
         [0, 0, 4, 0, 0, 0, 2, 0, 0],
         [0, 6, 0, 1, 0, 3, 4, 0, 0],
         [5, 0, 9, 6, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 5, 1, 0, 4],
         [0, 0, 2, 0, 8, 1, 0, 0, 9],
         [0, 8, 3, 0, 1, 0, 9, 0, 7],
         [6, 0, 0, 0, 0, 0, 0, 0, 1],
         [0, 0, 0, 0, 3, 6, 5, 2, 0]];
        END ;

/* Prints a line like this ┃ 1 2 3 ┃ 4 5 6 ┃ 7 8 9┃ */
prettyPrintLine(seq ℙ(INT × INT)) ≙
        VARIABLES i INT, vertical STRING, output STRING END
        vertical := “┃”;
        output := vertical;
        i := 1;
        WHILE
            i < ¢seq
        DO
            PRINT vertical ^ “ ” ^ seq(i) ^ “ ” ^ seq(i + 1) ^ “ ” ^ seq(i + 2) ^ “ ”;
            i := i + THREE;
        END;
        PRINT vertical;
        PRINT;
        END ;

/*
 * Uses prettyPrintLine repeatedly to print the entire grid like this
 * ┏━━━━━━━┳━━━━━━━┳━━━━━━━┓
 * ┃ 0 0 0 ┃ 2 0 0 ┃ 0 1 0 ┃
 * ┃ 0 0 4 ┃ 0 0 0 ┃ 2 0 0 ┃
 * ┃ 0 6 0 ┃ 1 0 3 ┃ 4 0 0 ┃
 * ┣━━━━━━━╋━━━━━━━╋━━━━━━━┫
 * ┃ 5 0 9 ┃ 6 0 0 ┃ 0 0 0 ┃
 * ┃ 0 0 0 ┃ 0 0 5 ┃ 1 0 4 ┃
 * ┃ 0 0 2 ┃ 0 8 1 ┃ 0 0 9 ┃
 * ┣━━━━━━━╋━━━━━━━╋━━━━━━━┫
 * ┃ 0 8 3 ┃ 0 1 0 ┃ 9 0 7 ┃
 * ┃ 6 0 0 ┃ 0 0 0 ┃ 0 0 1 ┃
 * ┃ 0 0 0 ┃ 0 3 6 ┃ 5 2 0 ┃
 * ┗━━━━━━━┻━━━━━━━┻━━━━━━━┛
 */
prettyPrint ≙
        VARIABLES i INT, j INT, horizontal STRING END
        horizontal := “┣━━━━━━━╋━━━━━━━╋━━━━━━━┫”;
        i := 0;
        PRINT;
        PRINT “┏━━━━━━━┳━━━━━━━┳━━━━━━━┓”;
        PRINT;
        WHILE
            i < ¢grid
        DO
            j := 0;
            WHILE
                j < THREE
            DO
                i := i + 1;
                j := j + 1;
                prettyPrintLine(grid(i));
            END ;
            IF
                i < NINE
            THEN
                PRINT horizontal;
                PRINT
            END
        END ;
        PRINT “┗━━━━━━━┻━━━━━━━┻━━━━━━━┛”;
        PRINT
        END ;
        
/* Gets a single row from grid as a sequence: argument 0-based */
row ℙ(INT × INT) ← getRow(index INT) ≙
        row := grid(getIndex(index))
        END ;

/* A sequence of sets representing all possible numbers for a row. index 0-based */
row ℙ(INT × ℙ(INT)) ← getPossibleRow(index INT) ≙
        row := allPossibles(getIndex(index))
        END ;
        
/* Gets a single column from grid as a sequence: argument 0-based */
column ℙ(INT × INT) ← getColumn(index INT) ≙
        VARIABLES i INT, row ℙ(INT × INT) END
        column := [0] ↓ 1;
        i := 0;
        WHILE
            i < ¢grid
        DO
            row := grid(getIndex(i));
            column := column ← row(getIndex(index));
            i := i + 1;
        END
        END ;

/* A sequence of sets representing all possible numbers for a column. index 0-based */
column ℙ(INT × ℙ(INT)) ← getPossibleColumn(index INT) ≙
        VARIABLES i INT, row ℙ(INT × ℙ(INT)) END
        column := [{0}] ↓ 1;
        i := 0;
        WHILE
            i < ¢allPossibles
        DO
            row := allPossibles(getIndex(i));
            column := column ← row(getIndex(index));
            i := i + 1
        END
        END ;

/* Puts all the [non-zero] numbers in a particular sequence into a set */
set ℙ(INT) ← sequenceToSet(seq ℙ(INT × INT)) ≙
        VARIABLES i INT END
        set := {0};
        i := 0;
        WHILE
            i < ¢seq
        DO
            set := set ∪ {seq(getIndex(i))};
            i := i + 1;
        END;
        set := set \ {0}
        END ;

/* Puts all the [non-zero] numbers in a particular row into a set with 0-based index */
rowSet ℙ(INT) ← getRowAsSet(index INT) ≙
        rowSet := sequenceToSet(getRow(index))
        END ;

/* Puts all the [non-zero] numbers in a particular column into a set with 0-based index */
columnSet ℙ(INT) ← getColumnAsSet(index INT) ≙
        columnSet := sequenceToSet(getColumn(index))
        END ;

/*
 * Puts all the values in a sector (3×3 box) into a sequence. The parameters are
 * 0-based, so row=5 column=6 will find the middle right sector whose top left
 * square is (3, 6)
 * For example, this sector will give the result
 * ┏━━━━━━━┓
 * ┃ 2 1 0 ┃
 * ┃ 4 6 3 ┃
 * ┃ 9 7 0 ┃
 * ┗━━━━━━━┛ give this result: [2, 1, 0, 4, 6, 3, 9, 7, 0]
 */
sector ℙ(INT × INT) ← getSector(row INT, column INT) ≙
        VARIABLES i INT, j INT, seq ℙ(INT × INT) END
        sector := [0] ↓ 1;
        i := 0;
        row := row / THREE * THREE;
        column := column / THREE * THREE;
        WHILE
            i < THREE
        DO
            j := 0;
            seq := getRow(row + i);
            i := i + 1;
            WHILE
                j < THREE
            DO
                sector := sector ← seq(getIndex(column + j));
                j := j + 1
            END
        END END ;

/*
 * Collects all the non-zero values from a 3×3 sector as a set.
 * Result from sector shown for getSector will be {1, 2, 3, 4, 6, 7, 9}.
 * Arguments are 0-based
 */
sectorSet ℙ(INT) ← getSectorAsSet(row INT, column INT) ≙ 
        sectorSet := sequenceToSet(getSector(row, column))
        END ;

/* The value already set in a square: arguments 0-based. Empty square = 0 */
i INT ← getValueForSquare(row INT, column INT) ≙
        VARIABLES seq ℙ(INT × INT) END
        seq := getRow(row);
        i := seq(getIndex(column));
        END ;

/*
 * Collects all the [non-zero] values for (0-based) square in sector row and
 * column, and subtracts them from 1..9 and returns a set of possible numbers.
 * For example, in the grid shown for prettyPrint above, the 0, 8 square has
 * {1, 2, 4, 7, 9} already used, and possible would be {3, 5, 6, 8}
 */
possible ℙ(INT) ← getPossible(row INT, column INT) ≙
        VARIABLES rowSet ℙ(INT), columnSet ℙ(INT), sectorSet ℙ(INT) END
        IF
            getValueForSquare(row, column) = 0
        THEN
            possible := ONE..NINE;
            rowSet    := getRowAsSet(row);
            possible := possible \ rowSet;
            columnSet := getColumnAsSet(column);
            possible := possible \ columnSet;
            sectorSet := getSectorAsSet(row, column);
            possible := possible \ sectorSet
        ELSE
            possible := EMPTYSET
        END END ;

/*
 * Use the already extant allPossibles seq to find possible solutions for a
 * row: index 0-based
 */
possibles ℙ(INT × ℙ(INT)) ← getPossiblesForRow(row INT) ≙
        possibles := allPossibles(getIndex(row))
        END ;

/*
 * Use the already extant allPossibles seq to find possible solutions for a
 * square: indices 0-based
 */
possibles ℙ(INT) ← getPossiblesForSquare(row INT, column INT) ≙
        VARIABLES seq ℙ(INT × ℙ(INT)) END
        seq := getPossiblesForRow(row);
        possibles := seq(getIndex(column))
        END ;

/*
 * Set a particular set for a square in allPossibles: row and column 0-based.
 * Guard removed. Use gridCorrectlyFilled → setPossiblesForAllSquares instead
 */
setPossiblesForSquare(row INT, column INT, possibles ℙ(INT)) ≙
        VARIABLES seq ℙ(INT × ℙ(INT)) END
        seq := getPossibleRow(row);
        seq := seq ⊕ {getIndex(column) ↦ possibles};
        allPossibles := allPossibles ⊕ {getIndex(row) ↦ seq};
        END ;

/* Set a particular value in square row and column 0-based */
b BOO ← setValueForSquare(row INT, column INT, value INT) ≙
        VARIABLES seq ℙ(INT × INT) END
        b := getValueForSquare(row, column) = 0;
        seq := getRow(row);
        seq := seq ⊕ {getIndex(column) ↦ value};
        setPossiblesForSquare(row, column, EMPTYSET);
        grid := grid ⊕ {getIndex(row) ↦ seq}
        END ;

/* Set all elements of allPossibles for all eighty-one squares */
setPossiblesForAllSquares ≙
        VARIABLES row INT, column INT END
        row := 0;
        WHILE
            row < ¢allPossibles
        DO
            column := 0;
            WHILE
                column < ¢allPossibles
            DO
                setPossiblesForSquare(row, column, getPossible(row, column));
                column := column + 1
            END;
            row := row + 1
        END
        END ;

/*
 * Set all elements of allPossibles for all eighty other squares. Uses a
 * different technique from preceding procedure. Indices 0-based.
 */
setPossiblesFromSquare(row INT, column INT, value INT) ≙
        VARIABLES toRemove ℙ(INT), found ℙ(INT), i INT, j INT END
        toRemove := {value};
        i := 0;
        WHILE
            i < NINE
        DO
            found := getPossiblesForSquare(row, i);
            setPossiblesForSquare(row, i, found \ toRemove);
            found := getPossiblesForSquare(i, column);
            setPossiblesForSquare(i, column, found \toRemove);
            i := i + 1
        END;
        i := row / THREE * THREE;
        WHILE
            i < row / THREE * THREE + THREE
        DO
            j := column / THREE * THREE;
            WHILE
                j < column / THREE * THREE + THREE
            DO
                found := getPossiblesForSquare(i, j);
                setPossiblesForSquare(i, j, found \ toRemove);
                j := j + 1
            END;
            i := i + 1
        END
        END ;

/*
 * Find the cell with the fewest possible solutions, starting top left going to
 * bottom right. If two cells found with same cardinality, the first found is
 * reported. Indices in results 0-based.
 * Returns set of possibles and row and column indices.
 */
rowFound INT, columnFound INT, possibles ℙ(INT) ← lowestCardinality ≙
        VARIABLES
            index INT, cardinality INT, seq ℙ(INT × ℙ(INT)), cell ℙ(INT)
        END
        index := ZERO;
        possibles := EMPTYSET;
        cardinality, rowFound, columnFound := NINE, NINE, NINE;
        WHILE
            index < NINE * NINE
        DO
            cell := getPossiblesForSquare(index / NINE, index % NINE);
            IF
                ¢cell < cardinality ∧ ¢cell > ZERO
            THEN
                cardinality := ¢cell;
                rowFound, columnFound := index / NINE, index % NINE;
                possibles := cell
            END;
            index := index + 1
        END END ;

/* Whether the grid needs completion, i.e. there are still cells valued 0 */
b BOO ← needsCompletion ≙
        b := ∃ i • i ∈ 0..(NINE * NINE - 1) ∧
               (getValueForSquare(i / NINE, i % NINE) = 0)
        END ;

/*
 * Tests for incorrect completion of the grid: if a cell contains 0, its
 * corresponding possibles set must have cardinality > 0 and vice versa.
 */
b BOO ← gridCorrectlyFilled ≙
        b := ∀ i • i ∈ 0..(NINE * NINE - 1) ⇒
        ((getValueForSquare(i / NINE, i % NINE) = 0 ⇔
               ¢getPossiblesForSquare(i / NINE, i % NINE) > 0))
        END ; 

/* Runs the app
 * In theory: initialise the grid, remove all values already set from allPossibles,
 * then: start loop while needsCompletion: find lowest cardinality, set value
 * with :∈ operator, continue until gridCorrectlyFilled returns false, then
 * backtrack.
 * In practice: runs 11 times then seg fault
 */
run ≙   VARIABLES row INT, column INT, value INT, possible ℙ(INT), output STRING, stage INT END
        initialise;
        prettyPrint;
        setPossiblesForAllSquares;
        stage := 0;
        WHILE
            needsCompletion
        DO
            row, column, possible := lowestCardinality;
            value :∈ possible;
            setValueForSquare(row, column, value) →
                    setPossiblesFromSquare(row, column, value);
            gridCorrectlyFilled → stage := stage + 1;
            IF
                stage < 10
            THEN
                output := “Stage:  ”;
            ELSE
                output := “Stage: ”;
            END;
            PRINT output ^ stage ^ “ Row: ” ^ (row + 1) ^ “ Column: ”
                    ^ (column + 1) ^ “ Value: ” ^ value;
            PRINT
        END;
        prettyPrint

