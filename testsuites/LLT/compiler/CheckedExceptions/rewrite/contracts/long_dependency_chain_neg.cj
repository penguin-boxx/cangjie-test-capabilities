// Rewrite acceptance: §5.3.3.
// Forty inferred-result edges must not hit the old 32-round completion cutoff.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-AE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex long_dependency_chain_neg\.cj:13:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}
main(): Int64 {
    f0()() // ERROR: the final reference still requires AE
    return 0
}
func f0() { f1() }
func f1() { f2() }
func f2() { f3() }
func f3() { f4() }
func f4() { f5() }
func f5() { f6() }
func f6() { f7() }
func f7() { f8() }
func f8() { f9() }
func f9() { f10() }
func f10() { f11() }
func f11() { f12() }
func f12() { f13() }
func f13() { f14() }
func f14() { f15() }
func f15() { f16() }
func f16() { f17() }
func f17() { f18() }
func f18() { f19() }
func f19() { f20() }
func f20() { f21() }
func f21() { f22() }
func f22() { f23() }
func f23() { f24() }
func f24() { f25() }
func f25() { f26() }
func f26() { f27() }
func f27() { f28() }
func f28() { f29() }
func f29() { f30() }
func f30() { f31() }
func f31() { f32() }
func f32() { f33() }
func f33() { f34() }
func f34() { f35() }
func f35() { f36() }
func f36() { f37() }
func f37() { f38() }
func f38() { f39() }
func f39() { f40() }
func f40() { risky }
func risky(): Unit { throw AE() }
