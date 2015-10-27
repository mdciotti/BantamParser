//
//  ParseException.swift
//  BantamParser
//
//  Created by Maxwell Ciotti on 2015-08-18.
//  Copyright © 2015 mdciotti. All rights reserved.
//

enum ParseException: ErrorType {
    case ExpectedName
    case ExpectedToken(TokenType, TokenType)
    case ParseError(String)

//    static func getMessage() -> String {
//        switch(self) {
//        case .ExpectedName(let message): return message
//        }
//    }
}
