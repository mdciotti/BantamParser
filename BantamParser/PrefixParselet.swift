///
/// One of the two protocols used by the Pratt parser.
///
/// A `PrefixParselet` is associated with a token that appears at the beginning
/// of an expression. Its `parse()` method will be called with the consumed
/// leading token, and the parselet is responsible for parsing anything that
/// comes after that token. This protocol is also used for single-token
/// expressions like variables, in which case `parse()` simply doesn't consume
/// any more tokens.
///
protocol PrefixParselet {
    func parse(parser: Parser, _ token: Token) throws -> Expression
}

///
/// Generic prefix parselet for a unary arithmetic operator.
///
/// Parses prefix unary `-`, `+`, `~`, and `!` expressions.
///
class PrefixOperatorParselet: PrefixParselet {
    let precedence: Int

    init(_ precedence: Int) {
        self.precedence = precedence
    }

    func parse(parser: Parser, _ token: Token) throws -> Expression {
        // To handle right-associative operators like "^", we allow a slightly
        // lower precedence when parsing the right-hand side. This will let a
        // parselet with the same precedence appear on the right, which will then
        // take *this* parselet's result as its left-hand argument.
        let right: Expression = try parser.parseExpression(precedence)

        return PrefixExpression(token.type, right)
    }

    func getPrecedence() -> Int { return precedence }
}

/**
 * Parses parentheses used to group an expression, like "a * (b + c)".
 */
class GroupParselet: PrefixParselet {
    func parse(parser: Parser, _ token: Token) throws -> Expression {
        let expression: Expression = try parser.parseExpression()
        try parser.consume(TokenType.RIGHT_PAREN)
        return expression
    }
}

/**
 * Simple parselet for a named variable like "abc".
 */
class NameParselet: PrefixParselet {
    func parse(parser: Parser, _ token: Token) -> Expression {
        return NameExpression(token.text)
    }
}
