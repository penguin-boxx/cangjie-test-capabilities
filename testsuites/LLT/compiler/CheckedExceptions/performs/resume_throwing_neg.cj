// Effect requirements: 'resume ... throwing e' injects 'e' at the suspended 'perform' site, so it is
// a requirement site classified by the static type of 'e', exactly as 'throw e' is -- and it
// resolves in the handler body's enclosing capability scopes, a 'handle' body being outside its own
// try's scope, like a 'catch' body.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-AException'
// ASSERT: scan required by this 'resume ... throwing' expression

import stdx.effect.*

class GetNumber <: Command<Int64> {}
class AException <: Exception {}

public func handler(): Int64 {
    try {
        perform GetNumber()
    } handle (_: GetNumber) {
        resume throwing AException() // error: nothing here supplies the capability
    }
}

main() {
    return 0
}
