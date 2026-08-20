// Checked exceptions (overloading): signatures that coincide after removing capability
// lists are duplicate declarations.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: function 'f' has overload conflicts

class AException <: Exception {}
class BException <: Exception {}

func f(x: Int64) throws AException {
    throw AException()
}

func f(x: Int64) throws BException {
    throw BException()
}

main() {
    return 0
}
