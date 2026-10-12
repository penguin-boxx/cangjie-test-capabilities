// Rewrite audit: §3.8, §5.4.
// An override cannot add an effect requirement to a clause-free interface method.
//
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(override|not covered|capability|mismatched types)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex effect_override_neg\.cj:14:[0-9]+:

import stdx.effect.*
class Ask <: Command<Int64> {}
interface API { func run(): Int64 }
class Impl <: API {
    public func run(): Int64 performs Ask { perform Ask() } // ERROR: interface supplies no Ask
}
main(): Int64 { 0 }
