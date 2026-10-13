// Structured AST transport preserves assumption type lists and the bare exception form.
// EXEC: %compiler %cmp_opt %n.cj -o %output
// EXEC: %run %output

import std.ast.*
main(): Int64 {
    let exception = Annotation(quote(@AssumeThrows[(AE, BE)]))
    let effect = Annotation(quote(@AssumePerforms[(Ask, Tell)]))
    let bare = Annotation(quote(@AssumeThrows))
    if (exception.capabilityTypes.size == 0 || effect.capabilityTypes.size == 0) { return 1 }
    if (Annotation(exception.toTokens()).capabilityTypes.size != exception.capabilityTypes.size) { return 2 }
    if (Annotation(effect.toTokens()).capabilityTypes.size != effect.capabilityTypes.size) { return 3 }
    if (Annotation(bare.toTokens()).capabilityTypes.size != 0) { return 4 }
    return 0
}
