// Checked exceptions ("Overriding and redefinition", multiplatform matching): a specific function
// matches its common one when their capability lists are equal up to normalization -- as sets, up
// to coverage. Spelling never affects matching: a reordered list matches, and so does one with a
// covered entry. The program then runs on the specific bodies, and the common callers' handlers
// catch what they throw.

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental --enable-checked-exceptions c/c.cj --output-type=chir --output-dir ./c
package cmp

public open class AException <: Exception {}
public class BException <: Exception {}
public class DerivedA <: AException {}

public common func reordered(): Unit throws AException, BException
public common func covered(): Unit throws AException

public func callBoth(): Int64 {
    var n = 0
    try {
        reordered()
    } catch (e: AException) {
        n += 1
    } catch (e: BException) {
        n += 10
    }
    try {
        covered()
    } catch (e: AException) {
        n += 100
    }
    n
}

// SEPARATE-FILE: p/p.cj
// EXEC: %compiler %noColor --experimental --enable-checked-exceptions p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=./c/cmp.cjo --output-type=dylib
package cmp

public specific func reordered(): Unit throws BException, AException {
    throw BException()
}

public specific func covered(): Unit throws AException, DerivedA {
    throw DerivedA()
}

// SEPARATE-FILE: main.cj
// EXEC: %compiler %noColor --experimental --enable-checked-exceptions main.cj -lcmp -L. -o %output
// EXEC: %run %output 2>&1 | compare %f
// ASSERT: scan matched: 110
import cmp.*

main(): Int64 {
    println("matched: ${callBoth()}")
    return 0
}
