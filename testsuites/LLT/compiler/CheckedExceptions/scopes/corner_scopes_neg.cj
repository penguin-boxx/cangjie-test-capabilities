// Checked exceptions (§3.3, scope corner cases):
// 1) a catch block is NOT inside its try's capability scope (bare rethrow of a
//    checked exception needs an enclosing capability);
// 2) a finally block is outside the scope too;
// 3) top-level variable initializers have no capability scope.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-AException'
// ASSERT: scan Cannot find a capability for 'Class-BException'
// ASSERT: scan Cannot find a capability for 'Class-CException'

class AException <: Exception {}
class BException <: Exception {}
class CException <: Exception {}

func mkOrThrow(): Int64 throws CException {
    throw CException()
}

// 3) no scope encloses a top-level initializer
var g: Int64 = mkOrThrow()

func catchNotInScope() {
    try {
        throw AException()
    } catch (e: AException) {
        throw AException() // 1) error: the try's capability is gone here
    }
}

func finallyNotInScope() {
    try {
        throw BException()
    } catch (e: BException) {
    } finally {
        if (false) {
            throw BException() // 2) error: finally is outside the scope
        }
    }
}

main() {
    catchNotInScope()
    finallyNotInScope()
    return 0
}
