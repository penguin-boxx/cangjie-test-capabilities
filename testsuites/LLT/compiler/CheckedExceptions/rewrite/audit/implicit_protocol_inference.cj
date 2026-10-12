// Rewrite audit: §3.3.2, §5.3.2; collector-only implicit dependencies.
// Inferred iterator/close requirements reach callers before final validation.
// Warn mode permits current empty std interface contracts; exact caller warnings remain required.
//
// EXEC-PIPE: %compiler %cmp_opt --experimental --enable-checked-exceptions=warn %n.cj -o %output 2>&1 | compare %f
// EXEC: %run %output
// ASSERT: scan warning: Cannot find a capability for 'Class-IE'
// ASSERT: scan warning: Cannot find a capability for 'Class-CE'
// ASSERT: scan-not error:
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex implicit_protocol_inference\.cj:25:[0-9]+:
// ASSERT: regex implicit_protocol_inference\.cj:26:[0-9]+:

class IE <: Exception {}
class CE <: Exception {}
class Items <: Iterator<Int64> {
    public func next(): ?Int64 { throw IE() }
}
class Handle <: Resource {
    public func isClosed(): Bool { false }
    public func close(): Unit { throw CE() }
}
func iterate(): Unit { for (x in Items()) { () } }
func closeResource(): Unit { try (h = Handle()) { () } }
public func missingIteration(): Unit { iterate() } // ERROR: caller needs IE
public func missingClose(): Unit { closeResource() } // ERROR: caller needs CE
main(): Int64 {
    var caught = 0
    try { iterate() } catch (e: IE) { caught++ }
    try { closeResource() } catch (e: CE) { caught++ }
    return if (caught == 2) { 0 } else { 1 }
}
