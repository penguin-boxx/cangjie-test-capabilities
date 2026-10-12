// Support macro for macro_inferred*.cj; no standalone test commands.
macro package audit_macro
import std.ast.*
public macro Insert(input: Tokens): Tokens throws ASTException {
    return quote(func generated(): Unit { risky() })
}
public macro RoundTrip(input: Tokens): Tokens throws (ASTException, ParseASTException) {
    return parseDecl(input).toTokens()
}
