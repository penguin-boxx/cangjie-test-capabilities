// Checked exceptions ("Generics"): the positive half of 'generics_clause_only_neg.cj'. Writing the
// type argument is what the rule asks for, and then the call is ordinary: the callee's clause
// instantiates to the written type and the caller pays exactly it. A parameter that ALSO occurs
// outside the clause is inferred as usual -- the rule is about parameters nothing else constrains.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}

func f(): Unit
throws AException {
    throw AException()
}

func h<E>(block: () throws E -> Unit): Unit
where E <: Exception
throws E {
    block()
}

// 'E' appears in an ordinary parameter position too, so inference has information about it.
func withValue<E>(e: E, block: () throws E -> Unit): Unit
where E <: Exception
throws E {
    block()
}

main(): Int64 {
    try {
        h<AException>(f)        // explicit: legal
    } catch (e: AException) {
        try {
            withValue(AException(), f)   // inferred from the ordinary argument: legal
        } catch (e2: AException) {
            return 0
        }
    }
    return 1
}
