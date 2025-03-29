import tokenizer;
import parser;
import interpreter;

void main() {
    auto tokens = tokenize(`let x = 42; let y = 10; z = x - y; console.log(z); z = x * y; console.log(z); z = x / y; console.log(z);`);
    auto ast = parse(tokens);
    interpret(ast);
}
