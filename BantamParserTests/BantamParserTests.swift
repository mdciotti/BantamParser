//
//  BantamParserTests.swift
//  BantamParserTests
//
//  Created by Maxwell Ciotti on 2015-08-18.
//  Copyright © 2015 mdciotti. All rights reserved.
//

import XCTest
@testable import BantamParser

class BantamParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFunctionCall() {
        test("a()", "a()")
        test("a(b)", "a(b)")
        test("a(b, c)", "a(b, c)")
        test("a(b)(c)", "a(b)(c)")
        test("a(b) + c(d)", "(a(b) + c(d))")
        test("a(b ? c : d, e + f)", "a((b ? c : d), (e + f))")
    }

    func testUnaryPrecedence() {
        test("~!-+a", "(~(!(-(+a))))")
        test("a!!!", "(((a!)!)!)")
    }

    func testUnaryAndBinaryPrecedence() {
        test("-a * b", "((-a) * b)")
        test("!a + b", "((!a) + b)")
        test("~a ^ b", "((~a) ^ b)")
        test("-a!",    "(-(a!))")
        test("!a!",    "(!(a!))")
    }

    func testBinaryPrecedence() {
        test("a = b + c * d ^ e - f / g", "(a = ((b + (c * (d ^ e))) - (f / g)))")
    }

    func testBinaryAssociativity() {
        test("a = b = c", "(a = (b = c))")
        test("a + b - c", "((a + b) - c)")
        test("a * b / c", "((a * b) / c)")
        test("a ^ b ^ c", "(a ^ (b ^ c))")
    }

    func testConditionalOperator() {
        test("a ? b : c ? d : e", "(a ? b : (c ? d : e))")
        test("a ? b ? c : d : e", "(a ? (b ? c : d) : e)")
        test("a + b ? c * d : e / f", "((a + b) ? (c * d) : (e / f))")
    }

    func testGrouping() {
        test("a + (b + c) + d", "((a + (b + c)) + d)")
        test("a ^ (b + c)", "(a ^ (b + c))")
        test("(!a)!",    "((!a)!)")
    }

    func testNaming() {
        test("abc", "abc")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

/**
 * Parses the given chunk of code and verifies that it matches the expected
 * pretty-printed result.
 */
func test(source: String, _ expected: String) {
    let lexer: Lexer = Lexer(source)
    let parser: Parser = BantamParser(lexer)

    do {
        let result: Expression = try parser.parseExpression()
        var actual: String = ""
        result.printTo(&actual)

        XCTAssertEqual(expected, actual)

        print(actual)

    } catch ParseException.ExpectedName {
        XCTAssert(false, "The left-hand side of an assignment must be a name.")
    } catch ParseException.ParseError(let text) {
        XCTAssert(false, "Could not parse \"\(text)\".")
    } catch ParseException.ExpectedToken(let expected, let seen) {
        XCTAssert(false, "Expected token \(expected) and found \(seen).")
    } catch {
        XCTAssert(false, "Unknown error")
    }
}
