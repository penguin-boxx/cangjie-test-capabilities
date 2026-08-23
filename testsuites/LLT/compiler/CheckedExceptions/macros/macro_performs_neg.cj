// Checked exceptions / effects: a macro body runs inside the compiler, where no handler for a user
// effect can be installed, so a 'performs' clause on a macro is rejected. Conservative reading --
// the text says a macro may declare what it throws and is silent on effects (question Q13).

// EXEC-PIPE-1: %compiler %cmp_macro --diagnostic-format=noColor --experimental --enable-checked-exceptions %n.cj 2>&1 | compare %f
// ASSERT: scan error: a macro cannot carry a 'performs' clause

macro package chexc_macro_performs

import std.ast.*

public macro Bad(input: Tokens): Tokens
performs Command<Unit> {
    return input
}
