// Section 6 acceptance: §6.2: inferred internal lists are serialized for subpackage consumers.
// DEPENDENCE: r6parent.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions=error r6parent.cj -o r6parent.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6parent.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex internal_subpackage_neg\.cj:13:[0-9]+:

package r6parent.child
import r6parent.*
public func caller(): Unit {
    inferred() // ERROR: internal parent contract retains inferred AE
}
main(): Int64 { 0 }
