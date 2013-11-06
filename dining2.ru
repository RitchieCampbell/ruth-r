CONSTANTS thinking 0, waiting 1, eating 2, count 3 END
VARIABLES philosophers INT[count] END

result INT ← power(argument INT, index INT) ≙
        VARIABLES root INT END
        IF
            index = 0
        THEN
            result := 1
        ELSE IF
            index % 2 = 0
        THEN
            root := power(argument, index / 2);
            result := root * root
        ELSE
            result := argument * power(argument, index - 1)
        END END END ;

initialise ≙ VARIABLES i INT END
        i := 0;
        WHILE
            i < ¢philosophers
        DO
            i := i + 1;
            philosophers[i] := thinking
        END END ;

i INT ← philosopherToRight(number INT) ≙
        i := number - 1;
        IF
            i = 0
        THEN
            i := ¢philosophers
        END END ;

i INT ← philosopherToLeft(number INT) ≙
        i := (number + 1);
        IF
            i > ¢philosophers
        THEN
            i := i % ¢philosophers
        END END ;

i INT ← encodeStatus ≙
        VARIABLES index INT, multiplier INT END
        i := 0;
        multiplier := 1;
        WHILE
            index < ¢philosophers
        DO
            index := index + 1;
            i := i + philosophers[index] * multiplier;
            multiplier := multiplier * 3
        END END ;

decodeStatus(state INT) ≙ VARIABLES i INT END
        i := 0;
        WHILE
            i < ¢philosophers
        DO
            i := i + 1;
            philosophers[i] := state % 3;
            state := state / 3
        END END ;

moveToWait(i INT)  ≙ philosophers[i] :=  waiting END ;
moveToEat(i INT)   ≙ philosophers[i] :=   eating END ;
moveToThink(i INT) ≙ philosophers[i] := thinking END ;

b BOO ← thinkingInvariant(i INT) ≙ b := true END ;

b BOO ← eatingInvariant(i INT) ≙
        b := philosophers[i] = eating ⇒
             philosophers[philosopherToLeft(i)]  = thinking ∧
             philosophers[philosopherToRight(i)] ≠ eating
        END ;

b BOO ← waitingInvariant(i INT) ≙
        b := philosophers[i] = waiting ⇒
            philosophers[philosopherToRight(i)] ≠ eating END ;

b BOO ← allInvariants(i INT) ≙
        b := thinkingInvariant(i) ∧ waitingInvariant(i) ∧ eatingInvariant(i) END;

b BOO ← allInvariantsForAll ≙
        b := ∀ i • i ∈ 1..¢philosophers ⇒ allInvariants(i) END ;

b BOO ← canThink(i INT) ≙ b := philosophers[i] = eating END ;

b BOO ← canEat  (i INT) ≙ b := philosophers[i] = waiting ∧ 
        philosophers[philosopherToLeft(i)] = thinking END ;

b BOO ← canWait (i INT) ≙ b := philosophers[i] = thinking ∧ 
        philosophers[philosopherToRight(i)] ≠ eating END ;

b BOO ← canMove (i INT) ≙ b :=  canThink(i) ∨ canWait(i) ∨ canEat(i) END ;

b BOO ← anyMovePossible ≙ b := ∃ i • i ∈ 1..¢philosophers ∧ canMove(i) END ;

s STRING ← statusToString(status INT) ≙ VARIABLES i INT, j INT END
        i := 0;
        s := “”;
        WHILE
            i < ¢philosophers
        DO
            i := i + 1;
            j := status % 3;
            status := status / 3;
            IF
                j = thinking
            THEN
                s := s ^ “T”;
            ELSE
                IF
                    j = waiting
                THEN
                    s := s ^ “W”;
                ELSE
                    s := s ^ “E”;
                END
            END
        END END ;
 
s STRING ← blockingToString(status INT) ≙
        VARIABLES oldState INT END
        oldState := encodeStatus;
        decodeStatus(status);
        IF
            anyMovePossible
        THEN
            s := “False”;
        ELSE
            s := “True ”;
        END ;
        decodeStatus(oldState) END ;

iSet ℙ(INT) ← getStates ≙
        VARIABLES state INT END
        iSet := {state :∈ 0..power(3, count) - 1;
        decodeStatus(state);
        allInvariantsForAll → SKIP ♢ state} END ;
        
printStatus(status INT) ≙
        PRINT “State: ” ^ status ^ “ = ” ^ statusToString(status) ^
            “. Blocking: ” ^ blockingToString(status);
        PRINT END ;

moveNext(i INT) ≙
        canEat(i)    →   moveToEat(i) ▯
        canWait(i)   →  moveToWait(i) ▯
        canThink(i)  → moveToThink(i) END ;

iSet ℙ(INT) ← getMoves ≙
        VARIABLES i INT, j INT, state INT, newStates ℙ(INT) END
        iSet := {0};
        newStates := {0};
        WHILE
            ¢newStates > 0
        DO
            j := 0;
            newStates := newStates \ newStates;
            WHILE
                j < count
            DO
                j := j + 1; 
                newStates :=
                {
                    i :∈ iSet;
                    decodeStatus(i);
                    moveNext(j);
                    state := encodeStatus;
                    state ∉ iSet → SKIP
                    ♢ state
                } ∪ newStates;
                iSet := iSet ∪ newStates;
            END
        END END ;

displaySet(title STRING, sSet ℙ(INT)) ≙ VARIABLES i INT END
        PRINT title;
        PRINT sSet;
        PRINT;
        PRINT “For ” ^ count ^ “ around the table there are ” ^ ¢sSet ^ “ results.”;
        PRINT;
        i := 0;
        WHILE
            i < power(3, count)
        DO
            IF
                i ∈ sSet
            THEN
                printStatus(i);
            END ;
            i := i + 1;
        END END ;

run ≙ VARIABLES sSet ℙ(INT), mSet ℙ(INT) END
        initialise;
        sSet := getStates;
        displaySet(“By Invariants: ”, sSet);
        mSet := getMoves;
        displaySet(“By Moving:     ”, mSet);
        PRINT “The Two Results are the Same: ”;
        PRINT mSet = sSet

