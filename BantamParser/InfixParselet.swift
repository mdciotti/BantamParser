///
/// One of the two parselet protocols used by the Pratt parser.
/// 
/// An `InfixParselet` is associated with a token that appears in the middle of
/// the expression it parses. Its `parse()` method will be called after the
/// left-hand side has been parsed, and it in turn is responsible for parsing
/// everything that comes after the token. This is also used for postfix
/// expressions, in which case it simply doesn't consume any more tokens in its
/// `parse()` call.
///
protocol InfixParselet {
    func parse(parser: Parser, _ left: Expression, _ token: Token) throws -> Expression
    func getPrecedence() -> Int
}

///
/// Parselet for the condition or ternary operator, like `a ? b : c`.
///
class ConditionalParselet: InfixParselet {
    func parse(parser: Parser, _ left: Expression, _ token: Token) throws -> Expression {
        let thenArm: Expression = try parser.parseExpression()
        try parser.consume(TokenType.COLON)
        let elseArm: Expression = try parser.parseExpression(Precedence.CONDITIONAL - 1)

        return ConditionalExpression(left, thenArm, elseArm)
    }

    func getPrecedence() -> Int { return Precedence.CONDITIONAL }
}

///
/// Parselet to parse a function call like `a(b, c, d)`.
///
class CallParselet: InfixParselet {
    func parse(parser: Parser, _ left: Expression, _ token: Token) throws -> Expression {
        // Parse the comma-separated arguments until we hit, ")".
        var args = [Expression]()

        // There may be no arguments at all.
        if (!parser.match(TokenType.RIGHT_PAREN)) {
            repeat {
                try args.append(parser.parseExpression())
            } while (parser.match(TokenType.COMMA))
            try parser.consume(TokenType.RIGHT_PAREN)
        }

        return CallExpression(left, args)
    }

    func getPrecedence() -> Int { return Precedence.CALL }
}

///
/// Generic infix parselet for a binary arithmetic operator.
///
/// The only difference when parsing, `+`, `-`, `*`, `/`, and `^` is precedence
/// and associativity, so we can use a single parselet class for all of those.
///
class BinaryOperatorParselet: InfixParselet {
    let precedence: Int
    let isRight: Bool

    init(_ precedence: Int, _ isRight: Bool) {
        self.precedence = precedence
        self.isRight = isRight
    }

    func parse(parser: Parser, _ left: Expression, _ token: Token) throws -> Expression {
        // To handle right-associative operators like "^", we allow a slightly
        // lower precedence when parsing the right-hand side. This will let a
        // parselet with the same precedence appear on the right, which will then
        // take *this* parselet's result as its left-hand argument.
        let right: Expression = try parser.parseExpression(precedence - (isRight ? 1 : 0))

        return OperatorExpression(left, token.type, right)
    }

    func getPrecedence() -> Int { return precedence }
}

///
/// Parses assignment expressions like `a = b`.
///
/// The left side of an assignment expression must be a simple name like `a`,
/// and expressions are right-associative. (In other words, `a = b = c` is
/// parsed as `a = (b = c)`).
///
class AssignParselet: InfixParselet {
    func parse(parser: Parser, _ left: Expression, _ token: Token) throws -> Expression {
        let right: Expression = try parser.parseExpression(Precedence.ASSIGNMENT - 1)

        if (!(left is NameExpression)) {
            throw ParseException.ExpectedName
        }

        let name: String = (left as! NameExpression).name
        return AssignExpression(name, right)
    }

    func getPrecedence() -> Int { return Precedence.ASSIGNMENT }
}

///
/// Generic infix parselet for an unary arithmetic operator.
/// 
/// Parses postfix unary `!` expressions.
///
class PostfixOperatorParselet: InfixParselet {
    let precedence: Int

    init(_ precedence: Int) {
        self.precedence = precedence
    }

    func parse(parser: Parser, _ left: Expression, _ token: Token) -> Expression {
        return PostfixExpression(left, token.type)
    }

    func getPrecedence() -> Int { return precedence }
}
