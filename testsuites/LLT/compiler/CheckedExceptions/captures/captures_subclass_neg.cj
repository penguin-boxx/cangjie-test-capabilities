// Checked exceptions (capability capturing rule 4): every subclass of a capturing class is itself a
// capturing class, and its `captures` list must cover the superclass's -- each superclass entry
// covered by an own entry, possibly a more general one. A subclass with no clause, or with one that
// misses an entry, is an error; the covering case is in captures_subclass.cj.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: 'NoClause' must capture 'Class-FileException'
// ASSERT: scan error: 'Narrow' must capture 'Class-FileException'

class FileException <: Exception {}
class LogException <: Exception {}

open class Base
captures FileException {
    init() {}

    public open func write(s: String): Unit {
        throw FileException()
    }
}

class NoClause <: Base {
    init() { super() }
}

class Narrow <: Base
captures LogException {
    init() { super() }
}

main() {
    return 0
}
