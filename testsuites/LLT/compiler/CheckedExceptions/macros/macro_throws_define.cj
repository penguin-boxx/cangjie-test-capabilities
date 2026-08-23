// The macro package for 'macro_throws.cj': a macro declares what it may throw while it expands.
// A macro package exports macros only, so the exception is std.ast's own -- which is what the
// macros in stdx raise as well.

macro package chexc_macro_test

import std.ast.*

// The clause supplies the capability inside the body, which is where expansion-time failures are
// raised. A macro's requirement is discharged by its own clause; the code that invokes the macro
// never runs this body, so nothing is demanded at the expansion site.
public macro Checked(input: Tokens): Tokens
throws ASTException {
    if (input.size == 0) {
        throw ASTException("Checked expects a declaration")
    }
    return input
}
