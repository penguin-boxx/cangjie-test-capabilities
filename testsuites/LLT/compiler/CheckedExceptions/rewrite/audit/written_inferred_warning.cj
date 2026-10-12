// Written and inferred requirements use the same committed warning-mode checks.
// EXEC-PIPE: %compiler %cmp_opt --experimental --enable-checked-exceptions=warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan warning: capability requirements of
// ASSERT: scan-not error:
// EXEC: %run %output

class AE <: Exception {}
func inferred(): Unit { throw AE() }
func written(): Unit throws AE { throw AE() }
func identity<T>(value: T): T { value }
class Box<T> {
    let value: T
    init(value: T) { this.value = value }
}
func returnsInferred(): () -> Unit throws () { inferred }
func returnsWritten(): () -> Unit throws () { written }
func invoke(f: () -> Unit): Unit { try { f() } catch (e: AE) {} }
main(): Int64 {
    var f: () -> Unit = written
    f = inferred
    invoke(f)
    invoke(identity(inferred))
    invoke(identity(written))
    let a: Box<() -> Unit> = Box<() throws AE -> Unit>(inferred)
    let b: Box<() -> Unit> = Box<() throws AE -> Unit>(written)
    invoke(a.value)
    invoke(b.value)
    invoke(returnsInferred())
    invoke(returnsWritten())
    return 0
}
