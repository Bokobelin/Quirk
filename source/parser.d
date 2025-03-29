    import std.stdio;
    import std.array;
    import std.string;
    import tokenizer; // Import tokenizer to use Token
    import std.algorithm;

    struct ASTNode {
        string type;
        string value;
        ASTNode[] children;
    }

// In the parser, update the assignment parsing logic
// In the interpreter or parser logic, we need to handle the addition expression
ASTNode parse(Token[] tokens) {
    ASTNode root = ASTNode("Program", "");

    size_t i = 0;
    while (i < tokens.length) {
        if (tokens[i].value == "let") {
            ASTNode varNode = ASTNode("VariableDeclaration", tokens[i + 1].value);
            varNode.children ~= ASTNode("Literal", tokens[i + 3].value); // Add the variable value as a child
            root.children ~= varNode;
            i += 4;  // Skip `let x = 42;`
        } else if (tokens[i].value == "console.log") {
            ASTNode logNode = ASTNode("ConsoleLog", tokens[i + 2].value); // Use the variable name, not the literal value
            root.children ~= logNode;
            i += 4;  // Skip `console.log(x);`
       } else if (tokens[i].type == "Identifier" && tokens[i + 1].value == "=") {
    ASTNode assignNode = ASTNode("Assignment", tokens[i].value);

    if (i + 3 < tokens.length && ["+", "-", "*", "/"].canFind(tokens[i + 3].value)) {
        // Handle binary expressions
        ASTNode binaryNode = ASTNode("BinaryExpression", tokens[i + 3].value);
        binaryNode.children ~= ASTNode("Identifier", tokens[i + 2].value); // Left operand
        binaryNode.children ~= ASTNode("Identifier", tokens[i + 4].value); // Right operand
        assignNode.children ~= binaryNode;
        i += 6; // Skip `z = x + y;`
    } else {
        assignNode.children ~= ASTNode("Identifier", tokens[i + 2].value); // Direct assignment
        i += 4; // Skip `z = x;`
    }

    root.children ~= assignNode;
        } else {
            i++;
        }
    }

    //writeln("Generated AST: ", root); // Debug print
    return root;
}


ASTNode parseExpression(Token[] tokens) {
    // Check for binary expressions (like x + y)
    if (tokens.length == 3 && tokens[1].type == "Operator") {
        return ASTNode("BinaryExpression", tokens[1].value, [
            ASTNode("Identifier", tokens[0].value),
            ASTNode("Identifier", tokens[2].value)
        ]);
    }
    return ASTNode("Literal", tokens[0].value); // Fallback to literal if not a binary expression
}
