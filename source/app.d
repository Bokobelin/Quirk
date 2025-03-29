import tokenizer;
import parser;
import interpreter;

void main() {
    auto tokens = tokenize(`let x = 42; console.log(x); let y = 10; console.log(y); z = x + y; console.log(z);`);
    auto ast = parse(tokens);
    interpret(ast);
}
