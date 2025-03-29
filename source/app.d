import tokenizer;
import parser;
import interpreter;

void main() {
    auto tokens = tokenize(`let x = 42; console.log(x);`);
    auto ast = parse(tokens);
    interpret(ast);
}
