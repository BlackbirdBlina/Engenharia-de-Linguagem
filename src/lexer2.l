%{
#include <stdio.h>
#include <stdlib.h>

int column_counter = 1;

extern FILE *yyin;

void print_token(const char* token, const char* lexema) {
    printf(
        "[TOKEN] %-15s | LEXEMA: %-12s | LINHA: %-3d | COLUNA: %-3d\n",
        token,
        lexema,
        yylineno,
        column_counter
    );
}

void update_column() {
    column_counter += yyleng;
}
%}

%option noyywrap
%option yylineno

DIGIT          [0-9]
LETTER         [a-zA-Z_]

ID             {LETTER}({LETTER}|{DIGIT})*

INT            {DIGIT}+
FLOAT          {DIGIT}+"."{DIGIT}+

WHITESPACE     [ \t]+
NEWLINE        \n

STRING         \"([^\\\"]|\\.)*\"
CHAR           \'.\'

%%

\/\/.*

\/\*([^*]|\*+[^*/])*\*+\/

{WHITESPACE} {
    update_column();
}

{NEWLINE} {
    column_counter = 1;
}

"function" {
    print_token("FUNCTION", yytext);
    update_column();
}

"return" {
    print_token("RETURN", yytext);
    update_column();
}

"if" {
    print_token("IF", yytext);
    update_column();
}

"else" {
    print_token("ELSE", yytext);
    update_column();
}

"while" {
    print_token("WHILE", yytext);
    update_column();
}

"for" {
    print_token("FOR", yytext);
    update_column();
}

"break" {
    print_token("BREAK", yytext);
    update_column();
}

"continue" {
    print_token("CONTINUE", yytext);
    update_column();
}

"int" {
    print_token("TIPO_INT", yytext);
    update_column();
}

"float" {
    print_token("TIPO_FLOAT", yytext);
    update_column();
}

"bool" {
    print_token("TIPO_BOOL", yytext);
    update_column();
}

"char" {
    print_token("TIPO_CHAR", yytext);
    update_column();
}

"string" {
    print_token("TIPO_STRING", yytext);
    update_column();
}

"true" {
    print_token("BOOL_TRUE", yytext);
    update_column();
}

"false" {
    print_token("BOOL_FALSE", yytext);
    update_column();
}

"==" {
    print_token("EQUAL", yytext);
    update_column();
}

"!=" {
    print_token("NOT_EQUAL", yytext);
    update_column();
}

">=" {
    print_token("GREATER_EQUAL", yytext);
    update_column();
}

"<=" {
    print_token("LESS_EQUAL", yytext);
    update_column();
}

"&&" {
    print_token("AND", yytext);
    update_column();
}

"||" {
    print_token("OR", yytext);
    update_column();
}

"->" {
    print_token("ARROW", yytext);
    update_column();
}

".." {
    print_token("INTERVAL", yytext);
    update_column();
}

"+" {
    print_token("PLUS", yytext);
    update_column();
}

"-" {
    print_token("MINUS", yytext);
    update_column();
}

"*" {
    print_token("MULTIPLY", yytext);
    update_column();
}

"/" {
    print_token("DIVIDE", yytext);
    update_column();
}

"%" {
    print_token("MOD", yytext);
    update_column();
}

"=" {
    print_token("ATTR", yytext);
    update_column();
}

">" {
    print_token("GREATER", yytext);
    update_column();
}

"<" {
    print_token("LESS", yytext);
    update_column();
}

"!" {
    print_token("NOT", yytext);
    update_column();
}


"(" {
    print_token("LPAREN", yytext);
    update_column();
}

")" {
    print_token("RPAREN", yytext);
    update_column();
}

"{" {
    print_token("LBRACE", yytext);
    update_column();
}

"}" {
    print_token("RBRACE", yytext);
    update_column();
}

"[" {
    print_token("LBRACKET", yytext);
    update_column();
}

"]" {
    print_token("RBRACKET", yytext);
    update_column();
}

"," {
    print_token("COMMA", yytext);
    update_column();
}

";" {
    print_token("SEMICOLON", yytext);
    update_column();
}

":" {
    print_token("COLON", yytext);
    update_column();
}

"." {
    print_token("DOT", yytext);
    update_column();
}

{FLOAT} {
    print_token("FLOAT", yytext);
    update_column();
}

{INT} {
    print_token("INT", yytext);
    update_column();
}

{STRING} {
    print_token("STRING", yytext);
    update_column();
}

{CHAR} {
    print_token("CHAR", yytext);
    update_column();
}

{ID} {
    print_token("ID", yytext);
    update_column();
}

. {
    fprintf(
        stderr,
        "Erro lexico linha %d coluna %d: %s\n",
        yylineno,
        column_counter,
        yytext
    );
    exit(1);
}

%%

int main(int argc, char **argv) {

    if(argc < 2) {
        printf("Uso: ./lexer arquivo.txt\n");
        return 1;
    }

    FILE *file = fopen(argv[1], "r");

    if(!file) {
        printf("Erro ao abrir arquivo\n");
        return 1;
    }

    yyin = file;

    yylex();

    fclose(file);

    return 0;
}