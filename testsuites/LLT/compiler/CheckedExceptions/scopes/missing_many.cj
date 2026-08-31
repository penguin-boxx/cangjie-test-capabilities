// Checked exceptions (diagnostics): a requirement site that misses several capabilities reports
// all of them, in one diagnostic. The compiler's diagnostic set deduplicates by position and
// severity alone, so one diagnostic per missing entry would collapse to the first and the next
// would appear only after that one is fixed -- which is precisely the loop migration cannot
// afford. Sites that miss exactly one keep the singular message.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find capabilities for 'Class-AException', 'Class-BException' (of types 'CanThrow<Class-AException>', 'CanThrow<Class-BException>') in the current scope
// ASSERT: scan error: Cannot find a capability for 'Class-AException' (of type 'CanThrow<Class-AException>') in the current scope

class AException <: Exception {}
class BException <: Exception {}

func needsBoth(): Unit
throws AException, BException {}

func needsOne(): Unit
throws AException {}

public func caller(): Unit
throws () {
    needsBoth()
    needsOne()
}

main(): Int64 { 0 }
