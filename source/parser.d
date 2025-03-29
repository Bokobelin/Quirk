import std.stdio;
import std.array;
import std.string;
import tokenizer; // Import tokenizer to use Token

struct ASTNode {
    string type;
    string value;
    ASTNode[] children;
}

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
        } else {
            i++;
        }
    }

    return root;
}