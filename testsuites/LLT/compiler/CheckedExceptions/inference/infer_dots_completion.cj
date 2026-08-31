// Checked exceptions (interaction with an explicit 'throws'): the completed declaration type is
// the semantic form of the union. Here the explicit entry is 'DerE' and inference adds 'BaseE',
// which covers it -- one entry before, one entry after, and a different list. Completion that
// compared cardinality left the declaration on its stale type, so the caller below was checked
// against 'DerE' while the body could raise 'BaseE'.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Class-BaseE'

open class BaseE <: Exception {}
class DerE <: BaseE {}

func h(): Unit
throws DerE, ... {
    throw BaseE()
}

public func caller(): Unit
throws DerE {          // covers the explicit entry only; the completed list is {BaseE}
    h()
}

main(): Int64 { 0 }
