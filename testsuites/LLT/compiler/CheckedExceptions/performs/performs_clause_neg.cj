// Effects (§8.2): a 'performs' entry must be a 'Command' subtype, mirroring the rule that a
// 'throws' entry must be an 'Exception' subtype.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan is not a subtype of 'Command'

import stdx.effect.*

class NotACommand {}

func bad(): Int64 performs NotACommand {
    return 0
}

main() {
    return 0
}
