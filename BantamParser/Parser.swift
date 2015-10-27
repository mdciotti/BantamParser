class Parser {
    let tokens: Lexer
    var read = [Token]()
    var prefixParselets = [TokenType:PrefixParselet]()
    var infixParselets = [TokenType:InfixParselet]()

    init(_ tokens: Lexer) {
        self.tokens = tokens
    }

    func register(token: TokenType, _ parselet: PrefixParselet) {
        prefixParselets[token] = parselet
    }

    func register(token: TokenType, _ parselet: InfixParselet) {
        infixParselets[token] = parselet
    }

    func parseExpression(precedence: Int = 0) throws -> Expression {
        var token: Token = consume()
        if let prefix: PrefixParselet = prefixParselets[token.type] {
            var left: Expression = try prefix.parse(self, token)
            var infix: InfixParselet

            while (precedence < getPrecedence()) {
                token = consume()
                infix = infixParselets[token.type]!
                try left = infix.parse(self, left, token)
            }

            return left
        } else { throw ParseException.ParseError(token.text) }
    }

    func match(expected: TokenType) -> Bool {
        let token: Token = lookAhead(0)
        if (token.type != expected) { return false }
        consume()
        return true
    }

    func consume(expected: TokenType) throws -> Token {
        let token: Token = lookAhead(0)
        if (token.type != expected) {
            throw ParseException.ExpectedToken(expected, token.type)
        }
        return consume()
    }

    func consume() -> Token {
        // Make sure we've read the token.
        lookAhead(0)
        return read.removeAtIndex(0)
    }

    private func lookAhead(distance: Int) -> Token {
        // Read in as many as needed.
        while (distance >= read.count) {
            read.append(tokens.next())
        }

        // Get the queued token.
        return read[distance]
    }

    private func getPrecedence() -> Int {
        if let parser: InfixParselet = infixParselets[lookAhead(0).type] {
            return parser.getPrecedence()
        }
        return 0
    }
}
