///
/// Interface for all expression AST node classes.
///
protocol Expression {
    ///
    /// Pretty-print the expression to a string.
    ///
    func printTo(inout out: String)
}

///
/// A ternary conditional expression like `a ? b : c`.
///
class ConditionalExpression: Expression {
    let condition: Expression
    let thenArm: Expression
    let elseArm: Expression

    init(_ condition: Expression, _ thenArm: Expression, _ elseArm: Expression) {
        self.condition = condition
        self.thenArm   = thenArm
        self.elseArm   = elseArm
    }

    func printTo(inout out: String) {
        out += "("
        condition.printTo(&out)
        out += " ? "
        thenArm.printTo(&out)
        out += " : "
        elseArm.printTo(&out)
        out += ")"
    }
}

///
/// A function call like `a(b, c, d)`.
///
class CallExpression: Expression {
    let function: Expression
    let args: [Expression]

    init(_ function: Expression, _ args: [Expression]) {
        self.function = function
        self.args = args
    }

    func printTo(inout out: String) {
        function.printTo(&out)
        out += "("
        var i = 0
        for a in args {
            a.printTo(&out)
            if (i < args.endIndex - 1) { out += ", " }
            ++i
        }
        out += ")"
    }

}

///
/// A simple variable name expression like `abc`.
///
class NameExpression: Expression {
    let name: String

    init(_ name: String) {
        self.name = name
    }

    func printTo(inout out: String) {
        out += name
    }
}

///
/// A binary arithmetic expression like `a + b` or `c ^ d`.
///
class OperatorExpression: Expression {
    let leftExp: Expression
    let op: TokenType
    let rightExp: Expression

    init(_ leftExp: Expression, _ op: TokenType, _ rightExp: Expression) {
        self.leftExp = leftExp
        self.op = op
        self.rightExp = rightExp
    }

    func printTo(inout out: String) {
        out += "("
        leftExp.printTo(&out)
        out += " "
        out.append(op.punctuator()!)
        out += " "
        rightExp.printTo(&out)
        out += ")"
    }
}

///
/// A postfix unary arithmetic expression like `a!`.
///
class PostfixExpression: Expression {
    let leftExp: Expression
    let op: TokenType

    init(_ leftExp: Expression, _ op: TokenType) {
        self.leftExp = leftExp
        self.op = op
    }

    func printTo(inout out: String) {
        out += "("
        leftExp.printTo(&out)
        out.append(op.punctuator()!)
        out += ")"
    }
}

///
/// A prefix unary arithmetic expression like `!a` or `-b`.
///
class PrefixExpression: Expression {
    let op: TokenType
    let rightExp: Expression

    init(_ op: TokenType, _ rightExp: Expression) {
        self.op = op
        self.rightExp = rightExp
    }

    func printTo(inout out: String) {
        out += "("
        out.append(op.punctuator()!)
        rightExp.printTo(&out)
        out += ")"
    }
}

///
/// An assignment expression like `a = b`.
///
class AssignExpression: Expression {
    let name: String
    let right: Expression
    
    init(_ name: String, _ right: Expression) {
        self.name = name
        self.right = right
    }
    
    func printTo(inout out: String) {
        out += "("
        out += "\(name) = "
        right.printTo(&out)
        out += ")"
    }
}
