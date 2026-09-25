// Checked exceptions ("Overriding and redefinition", multiplatform matching): matching requires the
// capability lists to be EQUAL up to normalization -- not the narrowing an override may do. Common
// callers pay the common list whatever the platform does, so a narrower or a wider specific list
// would let the platform surfaces diverge silently; both are rejected.
//
// Before, matching was blind to capability lists altogether: pairing a specific declaration with
// its common one deliberately ignores them (a list takes no part in overload resolution), and
// nothing compared them afterwards, so both specific functions below were accepted.

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental --enable-checked-exceptions c/c.cj --output-type=chir --output-dir ./c
package cmp

public class AException <: Exception {}
public class BException <: Exception {}

public common func narrower(): Unit throws AException, BException
public common func wider(): Unit throws AException

// SEPARATE-FILE: p/p.cj
// EXEC-PIPE-1: %compiler %noColor --experimental --enable-checked-exceptions p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=./c/cmp.cjo --output-type=dylib 2>&1 | compare %f
// ASSERT: scan the capability lists differ: 'specific' requires 'Class-AException', 'common' requires 'Class-AException', 'Class-BException'
// ASSERT: scan the capability lists differ: 'specific' requires 'Class-AException', 'Class-BException', 'common' requires 'Class-AException'
// ASSERT: scan 'specific' function type is not equal to 'common' type
package cmp

public specific func narrower(): Unit throws AException {}

public specific func wider(): Unit throws AException, BException {}
