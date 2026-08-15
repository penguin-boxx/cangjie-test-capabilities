// Effects (§8.2 with §9.1): the two capability kinds never discharge one another. A 'catch'
// supplies exception capabilities only, and a 'handle' supplies effect capabilities only, because
// discharge is by subtyping and the 'Command' and 'Exception' roots are disjoint.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GetNumber'
// ASSERT: scan Cannot find a capability for 'Class-MyException'

import stdx.effect.*

class GetNumber <: Command<Int64> {}
class MyException <: Exception {}

// a catch cannot discharge a perform
public func caughtNotHandled(): Int64 {
    return try {
        perform GetNumber()
    } catch (e: Exception) {
        0
    }
}

// a handle cannot discharge a throw
public func handledNotCaught(): Int64 {
    return try {
        throw MyException()
    } handle (_: GetNumber) {
        resume with 0
    }
}

main() {
    return 0
}
