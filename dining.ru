CONSTANTS thinking 0, waiting 1, eating 2, down 0, up 1, count 3 END
VARIABLES philosophers INT[count], forks INT[count] END

result INT ← power(argument INT, index INT) ≙
        IF
            index = 0
        THEN
            result := 1
        ELSE IF
            index % 2 = 0
        THEN
            result := power(argument, index / 2) * power(argument, index / 2)
        ELSE
            result := argument * power(argument, index - 1)
        END END END ;

initialise ≙ VARIABLES i INT END
        i := 0;
        WHILE
            i < ¢forks
        DO
            i := i + 1;
            forks[i] := down
        END ;
        i := 0;
        WHILE
            i < ¢philosophers
        DO
            i := i + 1;
            philosophers[i] := thinking
        END END ;

i INT ← forkToLeft(p INT) ≙ i := p END ;
i INT ← forkToRight(p INT) ≙ i := (p - 1) % count;
        IF i = 0 THEN i := count END END ;
i INT ← philosopherToLeftOfFork(f INT) ≙ i := (f + 1) % count;
        IF i = 0 THEN i := count END END ;
i INT ← philosopherToRightOfFork(f INT) ≙ i := f END ;
i INT ← philosopherToLeft(p INT) ≙ i := (p + 1) % count;
        IF i = 0 THEN i := count END END ;
i INT ← philosopherToRight(p INT) ≙ i := (p - 1) % count;
        IF i = 0 THEN i := count END END ;

b BOO ← eatingInvariant(i INT) ≙
        b := 
          philosophers[i] = eating   ⇒
          forks[forkToLeft(i)] = up & forks[forkToRight(i)] = up END ;
          
b BOO ← waitingInvariant(i INT) ≙
        b := 
          philosophers[i] = waiting   ⇒   forks[forkToRight(i)] = up END ;
          
b BOO ← leftThinkingInvariant(i INT) ≙ b := philosophers[i] = eating ⇒
        philosophers[philosopherToLeft(i)] = thinking END ;
        
b BOO ← rightNotEatingInvariant(i INT) ≙ b := philosophers[i] = eating ⇒
        philosophers[philosopherToRight(i)] ≠ eating END ;
        
b BOO ← thinkingLeftUpInvariant(i INT) ≙ b :=
        philosophers[i] = thinking & forks[forkToLeft(i)] = up ⇒
        philosophers[philosopherToLeft(i)] ≠ thinking  END ;
        
b BOO ← leftThinkingLeftUpInvariant(i INT) ≙ b :=
        philosophers[philosopherToLeft(i)] = thinking &
        forks[forkToLeft(i)] = up ⇒ philosophers[i] = eating END ;
        
b BOO ← twoUpEatingAssertion(i INT) ≙ b :=
        count > 2 & forks[forkToLeft(i)] = up &
        forks[forkToLeft(i)] = up ⇒ philosophers[i] = eating END ;

b BOO ← allInvariants(i INT) ≙ b := eatingInvariant(i) & waitingInvariant(i) &
        leftThinkingInvariant(i) & rightNotEatingInvariant(i) &
        thinkingLeftUpInvariant(i) & leftThinkingLeftUpInvariant(i) END ;

b BOO ← all7Invariants(i INT) ≙ b := eatingInvariant(i) & waitingInvariant(i) &
        leftThinkingInvariant(i) & rightNotEatingInvariant(i) &
        thinkingLeftUpInvariant(i) & leftThinkingLeftUpInvariant(i) &
        twoUpEatingAssertion(i) END ;

b BOO ← allEatingInvariant ≙ b := ∀ i • i ∈ 1..¢philosophers ⇒ eatingInvariant(i)
        END ;
b BOO ← allWaitingInvariant ≙ b := ∀ i • i ∈ 1..¢philosophers ⇒ waitingInvariant(i)
        END ;
b BOO ← allLeftThinkingInvariant ≙ b := ∀ i • i ∈ 1..¢philosophers ⇒
        leftThinkingInvariant(i) END ;
b BOO ← allRightNotEatingInvariant ≙ b := ∀ i • i ∈ 1..¢philosophers ⇒
        rightNotEatingInvariant(i)  END ;
b BOO ← allThinkingLeftUpInvariant ≙ b := ∀ i • i ∈ 1..¢philosophers ⇒
        thinkingLeftUpInvariant(i) END ;
b BOO ← allLeftThinkingLeftUpInvariant ≙ b := ∀ i • i ∈ 1..¢philosophers ⇒
        leftThinkingLeftUpInvariant(i) END ;
b BOO ← allTwoUpEatingAssertion ≙ b := ∀ i • i ∈ 1..¢philosophers ⇒
        twoUpEatingAssertion(i) END ;

b BOO ← allInvariantsForAll ≙
        b := ∀ i • i ∈ 1..count ⇒ allInvariants(i) END ;

b BOO ← all7InvariantsForAll ≙
        b := ∀ i • i ∈ 1..count ⇒ all7Invariants(i) END ;

i INT ← encodeStatus ≙ VARIABLES index INT, next INT END
        i := 0;
        index := 0;
        next := 1;
        WHILE
            index < ¢forks
        DO
            index := index + 1;
            i := i + forks[index] * next;
            next := next * 2
        END ;
        index := 0;
        WHILE
            index < ¢philosophers
        DO
            index := index + 1;
            i := i + philosophers[index] * next;
            next := next * 3
        END END ;

decodeStatus(i INT) ≙ VARIABLES index INT END
        index := 0;
        WHILE
            index < ¢forks
        DO
            index := index + 1;
            forks[index] := i % 2;
            i := i / 2
        END ;
        index := 0;
        WHILE
            index < ¢philosophers
        DO
            index := index + 1;
            philosophers[index] := i % 3;
            i := i / 3
        END END ;

initialise ≙ VARIABLES index INT END
        index := 0;
        WHILE
            index < ¢forks
        DO
            index := index + 1;
            forks[index] := down;
        END ;
        index := 0;
        WHILE
            index < ¢philosophers
        DO
            index := index + 1;
            philosophers[index] := thinking;
        END END ;

b BOO ← canEat(philosopher INT) ≙
        b := philosophers[philosopher] = waiting &
                forks[forkToLeft(philosopher)] = down END ;

b BOO ← canThink(philosopher INT) ≙
        b := philosophers[philosopher] = eating END ;

b BOO ← canWait(philosopher INT) ≙
        b := philosophers[philosopher] = thinking &
                forks[forkToRight(philosopher)] = down END ;

eat(philosopher INT) ≙ canEat(philosopher) →
        (
            philosophers[philosopher] := eating;
            forks[forkToLeft(philosopher)] := up
        ) END ;

think(philosopher INT) ≙ canThink(philosopher) →
        (
            philosophers[philosopher] := thinking;
            forks[forkToRight(philosopher)] := down;
            forks[forkToLeft(philosopher)] := down
        ) END ;

wait(philosopher INT) ≙ canWait(philosopher) →
        (
            philosophers[philosopher] := waiting;
            forks[forkToRight(philosopher)] := up;
        ) END ;

b BOO ← canMoveNext(philosopher INT) ≙
        IF
            philosophers[philosopher] = thinking
        THEN
            b := canWait(philosopher)
        ELSE IF
            philosophers[philosopher] = waiting
        THEN
            b := canEat(philosopher)
        ELSE IF
            philosophers[philosopher] = eating
        THEN
            b := canThink(philosopher)
        END END END END ;

b BOO ← nextMoveAvailable ≙
        b := ∃ i • i ∈ 1..count ∧ canMoveNext(i) END ;

moveNext(philosopher INT) ≙
        IF
            philosophers[philosopher] = thinking
        THEN
            wait(philosopher)
        ELSE IF
            philosophers[philosopher] = waiting
        THEN
            eat(philosopher)
        ELSE IF
            philosophers[philosopher] = eating
        THEN
            think(philosopher)
        END END END END ;

set ℙ(INT) ← getStates ≙ VARIABLES i INT END
        set :=
        {
            i :∈ 0 .. power(6, count) - 1;
            decodeStatus(i);
            allInvariantsForAll → SKIP ♢ i
        } END ;
        
set ℙ(INT) ← getMoves ≙
        VARIABLES
            i INT, j INT, state INT, oldState INT, newCard INT,
            states ℙ(INT × INT)
        END
        set := {0};
        states := [0];
        i := 0;
        newCard := 1;
        WHILE
            i < newCard
        DO
            i := i + 1;
            j := 0;
            oldState := states(i);
            WHILE
                j < count
            DO
                j := j + 1;
                decodeStatus(oldState);
                IF
                    canMoveNext(j)
                THEN
                    moveNext(j);
                    state := encodeStatus;
                    IF
                        ¬(state ∈ set)
                    THEN
                        newCard := newCard + 1;
                        set := set ∪ {state};
                        states := states ← state
                    END
                END
            END
        END END ;

printState(state INT) ≙
        VARIABLES i INT, oldState INT, outputF STRING, outputP STRING END
        oldState := encodeStatus;
        decodeStatus(state);
        i := 0;
        outputF := “”;
        outputP := “”;
        WHILE
            i < count
        DO
            i := i + 1;
            IF
                forks[i] = up
            THEN
                outputF := outputF ^ “↑”
            ELSE
                outputF := outputF ^ “↓”
            END ;
            IF
                philosophers[i] = waiting
            THEN
                outputP := outputP ^ “W”
            ELSE
                IF
                    philosophers[i] = thinking
                THEN
                    outputP := outputP ^ “T”
                ELSE
                    outputP := outputP ^ “E”
                END
            END
        END ;
        PRINT “State ” ^ state ^ “ = ” ^ outputF ^ outputP ^ “ Blocking: ”;
        PRINT ¬nextMoveAvailable;
        PRINT;
        decodeStatus(oldState) END ;

run ≙ VARIABLES state INT, sSet ℙ(INT), mSet ℙ(INT) END
        initialise;
        sSet := getStates;
        PRINT sSet;
        PRINT;
        mSet := getMoves;
        PRINT mSet;
        PRINT;
        PRINT “The two results are equal: ”;
        PRINT sSet = mSet;
        PRINT;
        PRINT “For ” ^ count ^ “ around the table there are ” ^ ¢sSet ^ “ results.”;
        PRINT;
        WHILE
            ¢sSet > 0
        DO
            state :∈ sSet;
            printState(state);
            sSet := sSet \ {state};
        END
