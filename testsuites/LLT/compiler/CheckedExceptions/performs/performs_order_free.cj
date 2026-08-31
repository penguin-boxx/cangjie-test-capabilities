// Effects (keyword scheme rule 9): on a DECLARATION the 'where', 'performs' and 'throws' blocks
// order freely, each at most once — they are keyword-led, and 'where' already sits anywhere, so a
// fixed order would buy nothing. Every permutation below is legal and means the same thing.
// Functional types are the opposite case ('performs_order_neg.cj').

// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %set_stdx_path %run_opt %output

import stdx.effect.*

class GetNumber <: Command<Int64> {}
class MyExc <: Exception {}

func performsFirst(): Int64
performs GetNumber
throws MyExc {
    return perform GetNumber()
}

func throwsFirst(): Int64
throws MyExc
performs GetNumber {
    return perform GetNumber()
}

func aroundWhere<T>(x: T): Int64
throws MyExc
where T <: ToString
performs GetNumber {
    return perform GetNumber()
}

func whereFirst<T>(x: T): Int64
where T <: ToString
performs GetNumber
throws MyExc {
    return perform GetNumber()
}

func sumAll(): Int64 {
    try {
        return performsFirst() + throwsFirst() + aroundWhere<Int64>(1) + whereFirst<Int64>(1)
    } catch (e: MyExc) {
        return -1
    } handle (_: GetNumber) {
        resume with 11
    }
}

main(): Int64 {
    if (sumAll() != 44) {
        return 1
    }
    return 0
}
