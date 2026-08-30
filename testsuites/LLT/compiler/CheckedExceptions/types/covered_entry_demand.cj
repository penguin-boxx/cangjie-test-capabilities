// Checked exceptions (semantic form): 'throws Base, Derived' with 'Derived <: Base' IS the list
// {Base} -- the covered entry introduces no requirement. A call site missing the handler reports
// Base alone, and a 'catch (e: Base)' discharges the whole call.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Class-BaseE' (of type 'CanThrow<Class-BaseE>') in the current scope
// ASSERT: scan-not Class-DerE

open class BaseE <: Exception {}
class DerE <: BaseE {}

func f(): Unit throws BaseE, DerE {}

public func caller(): Unit
throws () {
    f()
}

main(): Int64 { 0 }
