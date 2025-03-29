module interpreter;

import std.stdio;
import std.array;
import std.string;
import std.typecons;
import parser; // Import parser to use ASTNode
import std.conv;

// Dictionary to store variable values
__gshared string[string] variables;

int interpret(ASTNode node) {
    writeln("Interpreting node: ", node.type, " with value: ", node.value); // Debug print

    if (node.type == "Program") {
        foreach (child; node.children) {
            interpret(child); // Process each child node
        }
    } else if (node.type == "VariableDeclaration") {
        variables[node.value] = evaluate(node.children[0]); // Evaluate and store the variable value
    } else if (node.type == "ConsoleLog") {
        auto value = evaluate(ASTNode("Identifier", node.value)); // Evaluate the identifier value
        writeln(value);
    } else if (node.type == "Assignment") {
        variables[node.value] = evaluate(node.children[0]); // Evaluate and store the expression result
    } else if (node.type == "BinaryExpression") {
        auto left = evaluate(node.children[0]);
        auto right = evaluate(node.children[1]);
        if (node.value == "+") return to!int(left) + to!int(right);
        if (node.value == "-") return to!int(left) - to!int(right);
        if (node.value == "*") return to!int(left) * to!int(right);
        if (node.value == "/") return to!int(left) / to!int(right);
    }

    return -1;
}

string evaluate(ASTNode node) {
    writeln("Evaluating node: ", node.type, " with value: ", node.value); // Debug print

    if (node.type == "Literal") {
        return node.value;
    }
    if (node.type == "Identifier" && node.value in variables) {
        return variables[node.value]; // Retrieve stored value
    }
    if (node.type == "Addition" || node.type == "BinaryExpression") {
        auto left = evaluate(node.children[0]); // Ensure left operand is evaluated
        auto right = evaluate(node.children[1]); // Ensure right operand is evaluated

        if (node.children[0].type == "Identifier") {
            left = variables.get(node.children[0].value, "0");
        }
        if (node.children[1].type == "Identifier") {
            right = variables.get(node.children[1].value, "0");
        }

        // For Addition nodes or BinaryExpression with "+" operator
        if (node.type == "Addition" || node.value == "+") 
            return to!string(to!int(left) + to!int(right));
        if (node.value == "-") return to!string(to!int(left) - to!int(right));
        if (node.value == "*") return to!string(to!int(left) * to!int(right));
        if (node.value == "/") return to!string(to!int(left) / to!int(right));
    }
    return "0";
}