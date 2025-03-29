module interpreter;

import std.stdio;
import std.array;
import std.string;
import std.typecons;
import parser; // Import parser to use ASTNode

// Dictionary to store variable values
__gshared string[string] variables;

void interpret(ASTNode node) {
    if (node.type == "Program") {
        foreach (child; node.children) {
            interpret(child);
        }
    } else if (node.type == "VariableDeclaration") {
        variables[node.value] = node.children[0].value; // Store the variable value
        //writeln("Variable assigned: ", node.value, " = ", variables[node.value]);
    } else if (node.type == "ConsoleLog") {
        if (node.value in variables) { // Use `in` to check if the key exists
            writeln(variables[node.value]); // Log the variable value
        } else {
            writeln("Undefined variable: ", node.value);
        }
    }
}