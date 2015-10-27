enum TokenType {
    case LEFT_PAREN
    case RIGHT_PAREN
    case COMMA
    case ASSIGN
    case PLUS
    case MINUS
    case ASTERISK
    case SLASH
    case CARET
    case TILDE
    case BANG
    case QUESTION
    case COLON
    case NAME
    case EOF

    ///
    /// If the `TokenType` represents a punctuator (i.e. a token that can split
    /// an identifier like `+`, this will get its text.
    ///
    func punctuator() -> Character? {
        switch (self) {
            case .LEFT_PAREN:  return "("
            case .RIGHT_PAREN: return ")"
            case .COMMA:       return ","
            case .ASSIGN:      return "="
            case .PLUS:        return "+"
            case .MINUS:       return "-"
            case .ASTERISK:    return "*"
            case .SLASH:       return "/"
            case .CARET:       return "^"
            case .TILDE:       return "~"
            case .BANG:        return "!"
            case .QUESTION:    return "?"
            case .COLON:       return ":"
            default:           return nil
        }
    }

    ///
    /// An array of all the `TokenType` values.
    ///
    static let values = [LEFT_PAREN, RIGHT_PAREN, COMMA, ASSIGN, PLUS, MINUS,
        ASTERISK, SLASH, CARET, TILDE, BANG, QUESTION, COLON, NAME, EOF]
}
