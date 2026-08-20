// Checked exceptions (functional types): functional-type subtyping — capability lists compare
// as sets: permutations, adding requirements, and pointwise widening are all legal.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

open class BaseException <: Exception {}
class AException <: BaseException {}
class BException <: Exception {}
class CException <: Exception {}

func f() throws AException, BException {
    throw AException()
}

main() {
    // permutation: capability lists are sets
    let f1: () throws (BException, AException) -> Unit = f
    // adding requirements is ok — call sites just provide more
    let f2: () throws (AException, BException, CException) -> Unit = f
    // pointwise widening: CanThrow<BaseException> is suitable for CanThrow<AException>
    let f3: () throws (BaseException, BException) -> Unit = f
    try {
        f1()
    } catch (e: Exception) {
    }
    try {
        f2()
    } catch (e: Exception) {
    }
    try {
        f3()
    } catch (e: Exception) {
    }
    return 0
}
