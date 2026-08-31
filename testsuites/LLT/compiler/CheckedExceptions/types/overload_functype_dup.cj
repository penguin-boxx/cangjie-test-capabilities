// Checked exceptions (overloading): parameter function types differing only in capability
// lists are the same type for overload purposes — such overloads are duplicates.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: function 'h' has overload conflicts

class AException <: Exception {}

func h(block: () throws AException -> Unit) {
    try {
        block()
    } catch (e: AException) {
    }
}

func h(block: () -> Unit) {
    block()
}

main() {
    return 0
}
