///
/// A very primitive lexer.
///
/// Takes a string and splits it into a series of `Token`s. Operators and
/// punctuation are mapped to unique keywords. Names, which can be any series of
/// letters, are turned into `NAME` tokens. All other characters are ignored
/// (except to separate names). Numbers and strings are not supported. This is
/// really just the bare minimum to give the parser something to work with.
///
class Lexer {
    var punctuators: [Character:TokenType] = [:]
    let text: String
    var index: Int = 0

    ///
    /// Creates a new `Lexer` to tokenize the given string (`text`).
    ///
    init(_ text: String) {
        index = 0
        self.text = text

        // Register all of the TokenTypes that are explicit punctuators.
        for type in TokenType.values {
            if let punctuator: Character = type.punctuator() {
                punctuators[punctuator] = type
            }
        }
    }

    ///
    /// Retrieves the next token by reading the source text
    ///
    func next() -> Token {
        while (index < text.characters.count) {
            let c: Character = text.characters[advance(text.startIndex, index++)]

            if (punctuators.indexForKey(c) != nil) {
                // Handle punctuation.
                return Token(punctuators[c]!, String(c))
            } else if (CharacterIsLetter(c)) {
                // Handle names.
                let start: Int = index - 1
                while (index < text.characters.count) {
                    if (!CharacterIsLetter(text.characters[advance(text.startIndex, index)])) { break }
                    index++
                }

                let begin = advance(text.startIndex, start)
                let end = advance(text.startIndex, index - 1)
                return Token(TokenType.NAME, text[begin...end])
            } else {
                // Ignore all other characters (whitespace, etc.)
            }
        }

        // Once we've reached the end of the string, just return EOF tokens. We'll
        // just keeping returning them as many times as we're asked so that the
        // parser's lookahead doesn't have to worry about running out of tokens.
        return Token(TokenType.EOF, "")
    }
}

///
/// Checks a character `c` to see if it is a letter.
///
/// Valid letters are A-Z and a-z.
///
func CharacterIsLetter(c: Character) -> Bool {
    let start: Character = "A"
    let end: Character = "z"
    return start <= c && c <= end
}
