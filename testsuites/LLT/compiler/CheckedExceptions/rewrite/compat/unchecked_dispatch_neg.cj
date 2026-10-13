// Section 6 acceptance: §6.3.1: unchecked implementation does not erase the selected interface contract.
// DEPENDENCE: r6api.cj r6impl.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions=error r6api.cj -o r6api.%middle
// EXEC: %compiler %cmp_opt %compile_lib_opt r6api.%middle r6impl.cj -o r6impl.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6api.%middle r6impl.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex unchecked_dispatch_neg\.cj:17:[0-9]+:

import r6api.*
import r6impl.*
public func caller(): Unit {
    let impl = Impl()
    impl.run() // unchecked declaration has no requirement
    let service: Service = impl
    service.run() // ERROR: selected checked interface still requires AE
}
main(): Int64 { 0 }
