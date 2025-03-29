module tokenizer;

import std.regex;
import std.array;
import std.string;
import std.stdio;

struct Token {
    string type;
    string value;
}

Token[] tokenize(string code) {
    Token[] tokens;

    // Split code by spaces, keeping operators
    import std.string : split, strip;
    import std.algorithm : map, filter;
    import std.array : array;

    // Replace console.log with a single token
    code = code.replace("console.log", "console_log");

    // Insert spaces around operators to help with splitting
    foreach (op; ["(", ")", "{", "}", ";", "="]) {
        code = code.replace(op, " " ~ op ~ " ");
    }

    foreach (op; ["(", ")", "{", "}", ";", "=", "+", "-", "*", "/"]) {
        code = code.replace(op, " " ~ op ~ " ");
    }

    auto words = code.split()
                      .filter!(w => w.strip.length > 0)
                      .array;

    foreach (word; words) {
        string type;
        string value = word;

        // Replace console_log back to console.log
        if (value == "console_log") value = "console.log";

        if (value == "let" || value == "console.log") {
            type = "Keyword";
        } else if (isNumeric(value)) {
            type = "Number";
        } else if (isIdentifier(value)) {
            type = "Identifier";
        } else {
            type = "Operator";
        }

        tokens ~= Token(type, value);
    }

    return tokens; // Ensure this is inside the function
}

bool isNumeric(string s) {
    import std.ascii : isDigit;
    import std.algorithm : all;
    return s.length > 0 && s.all!isDigit;
}

bool isIdentifier(string s) {
    import std.ascii : isAlpha, isAlphaNum;
    if (s.length == 0) return false;
    if (!isAlpha(s[0]) && s[0] != '_') return false;
    foreach (i, c; s) {
        if (i > 0 && !isAlphaNum(c) && c != '_') return false;
    }
    return true;
}