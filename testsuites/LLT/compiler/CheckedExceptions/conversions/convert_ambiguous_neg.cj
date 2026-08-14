// Checked exceptions (§6.2.1 rule 3): when several Convertible implementations
// apply at a call site, the conversion is ambiguous and must be rejected — the
// user disambiguates by writing the try-catch by hand.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error
// ASSERT: scan ambiguous

class FromException <: Exception {}
class ToOneException <: Exception {}
class ToTwoException <: Exception {}

extend ToOneException <: Convertible<FromException, ToOneException> {
    public static func convertFrom(x: FromException): ToOneException {
        ToOneException()
    }
}

extend ToTwoException <: Convertible<FromException, ToTwoException> {
    public static func convertFrom(x: FromException): ToTwoException {
        ToTwoException()
    }
}

func g() throws FromException {
    throw FromException()
}

// both targets' capabilities are in scope, so both conversions apply
func f() throws ToOneException, ToTwoException {
    g()
}

main() {
    return 0
}
