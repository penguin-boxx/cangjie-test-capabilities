// Checked exceptions (clauses on declarations): a macro is a callable and carries a 'throws'
// clause of its own -- every macro in stdx raises an exception while expanding and documents it.
// The clause is discharged inside the macro body; the code that invokes the macro never runs that
// body, so the expansion site demands nothing.

// DEPENDENCE: macro_throws_define.cj
// EXEC: %compiler %cmp_macro --experimental --enable-checked-exceptions macro_throws_define.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import chexc_macro_test.*

@Checked
func doubled(): Int64 { 21 }

main(): Int64 {
    if (doubled() != 21) {
        return 1
    }
    return 0
}
