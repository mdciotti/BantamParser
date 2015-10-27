///
/// Defines the different precendence levels used by the infix parsers.
///
/// These determine how a series of infix expressions will be grouped. For
/// example, `a + b * c - d` will be parsed as `(a + (b * c)) - d` because `*`
/// has higher precedence than `+` and `-`. Here, bigger numbers mean higher
/// precedence.
///
struct Precedence {
    // Ordered in increasing precedence.
    static let ASSIGNMENT: Int  = 1
    static let CONDITIONAL: Int = 2
    static let SUM: Int         = 3
    static let PRODUCT: Int     = 4
    static let EXPONENT: Int    = 5
    static let PREFIX: Int      = 6
    static let POSTFIX: Int     = 7
    static let CALL: Int        = 8
}
