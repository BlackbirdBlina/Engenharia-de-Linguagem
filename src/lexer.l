%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int column_counter = 0;
char char_at_end[] = "\n";

extern int yyerror (char *msg); 
%}

%option noinput nounput
%option noyywrap
%option yylineno

number              [0-9]
letter              [a-zA-Z\_]
indentation         [ \t]
whitespace          {indentation}+
newline             [\n]+
id                  {letter}({letter}|{number})*

%%


"/*"(.|\n)*"*/"     {/* Ignora tudo entre "/ *" e "* /" */}
"//".*              {/* Ignora tudo após "//" até o final da linha */}

{whitespace}        {column_counter += strlen(yytext);}
{newline}           {column_counter = 0; printf("\n");}
"bool"              { printf("TIPO_BOOL%s", char_at_end);}

"s_int8"            { printf("TIPO_S_INT8%s", char_at_end);}
"s_int16"           { printf("TIPO_S_INT16%s", char_at_end);}
"s_int32"           { printf("TIPO_S_INT32%s", char_at_end);}
"s_size"            { printf("TIPO_S_SIZE%s", char_at_end);}
"u_int8"            { printf("TIPO_U_INT8%s", char_at_end);}
"u_int16"           { printf("TIPO_U_INT16%s", char_at_end);}
"u_int32"           { printf("TIPO_U_INT32%s", char_at_end);}
"u_size"            { printf("TIPO_U_SIZE%s", char_at_end);}

"float32"           { printf("TIPO_FLOAT32%s", char_at_end);}
"float64"           { printf("TIPO_FLOAT64%s", char_at_end);}

"char"              { printf("TIPO_CHAR%s", char_at_end);}
"String"            { printf("TIPO_STRING%s", char_at_end);}

"Vec"               { printf("TIPO_VEC%s", char_at_end);}
"Set"               { printf("TIPO_SET%s", char_at_end);}
"Matrix"            { printf("TIPO_MATRIX%s", char_at_end);}

"Result"            { printf("TIPO_RESULT%s", char_at_end);}

"="                 { printf("ATTRIBUTION%s", char_at_end);}

">"                 { printf("GREATER%s", char_at_end);}
"<"                 { printf("LESS%s", char_at_end);}
">="                { printf("GREATER_EQUAL%s", char_at_end);}
"<="                { printf("LESS_EQUAL%s", char_at_end);}
"=="                { printf("EQUAL%s", char_at_end);}
"!="                { printf("NOT_EQUAL%s", char_at_end);}

"++"                { printf("INCREMENT%s", char_at_end);}
"--"                { printf("DECREMENT%s", char_at_end);}
"+="                { printf("PLUS_ATTRIBUTION%s", char_at_end);}
"-="                { printf("MINUS_ATTRIBUTION%s", char_at_end);}
"*="                { printf("MULTIPLY_ATTRIBUTION%s", char_at_end);}
"/="                { printf("DIVIDE_ATTRIBUTION%s", char_at_end);}

"+"                 { printf("PLUS%s", char_at_end);}
"-"                 { printf("MINUS%s", char_at_end);}
"*"                 { printf("MULTIPLY%s", char_at_end);}
"/"                 { printf("DIVIDE%s", char_at_end);}
"%"                 { printf("REMAINDER%s", char_at_end);}

"!"                 { printf("NOT%s", char_at_end);}
"&&"                { printf("AND%s", char_at_end);}
"||"                { printf("OR%s", char_at_end);}

"("                 { printf("LEFT_PARENTHESIS%s", char_at_end);}
")"                 { printf("RIGHT_PARENTHESIS%s", char_at_end);}
"["                 { printf("LEFT_BRACKET%s", char_at_end);}
"]"                 { printf("RIGHT_BRACKET%s", char_at_end);}
"{"                 { printf("LEFT_BRACE%s", char_at_end);}
"}"                 { printf("RIGHT_BRACE%s", char_at_end);}

"\.\."              { printf("INTERVAL%s", char_at_end);}
"\."                { printf("DOT%s", char_at_end);}
":"                 { printf("COLON%s", char_at_end);}
";"                 { printf("SEMICOLON%s", char_at_end);}
","                 { printf("COMMA%s", char_at_end);}
"\{"                { printf("LEFT_BRACE%s", char_at_end);}

"const"             { printf("CONST%s", char_at_end);}
"let"               { printf("LET%s", char_at_end);}
"mute"              { printf("MUTABLE%s", char_at_end);}
"&"                 { printf("REF%s", char_at_end);}
"if"                { printf("IF%s", char_at_end);}
"else"              { printf("ELSE%s", char_at_end);}
"match"             { printf("MATCH%s", char_at_end);}
"loop"              { printf("LOOP%s", char_at_end);}
"while"             { printf("WHILE%s", char_at_end);}
"for"               { printf("FOR%s", char_at_end);}
"in"                { printf("IN%s", char_at_end)}

"func"              { printf("FUNCTION%s", char_at_end);}
"->"                { printf("ARROW%s", char_at_end);}
"proced"            { printf("PROCEDURE%s", char_at_end);}
"pure"              { printf("PURE%s", char_at_end);}

"return"            { printf("RETURN%s", char_at_end);}
"break"             { printf("BREAK%s", char_at_end);}
"continue"          { printf("CONTINUE%s", char_at_end);}
"struct"            { printf("STRUCT%s", char_at_end);}
"enum"              { printf("ENUM%s", char_at_end);}

"true"|"false"                              {
                                                printf("VALOR_BOOL%s", char_at_end);
                                            }

{number}+(E[+-]?{number}+)?                 {
                                                printf("VALOR_INT%s", char_at_end);
                                            }

{number}+\.{number}+(E[+-]?{number}+)?      {
                                                printf("VALOR_FLOAT%s", char_at_end);
                                            }

\'.\'                                       {
                                                printf("VALOR_CHAR%s", char_at_end);
                                            }

\".*\"                                      {
                                                printf("VALOR_STRING%s", char_at_end);
                                            }

{id}                    { printf("ID(%s)%s", yytext, char_at_end);}

.                       { printf("Error_line_text(%d,%s)%s", yylineno, yytext, char_at_end) ;}

%%

#ifndef yywrap
   // Indicates no more input 
   int yywrap (void) {return 1;}
#endif

int main(int argc, char **argv)
{
    if (argc > 1)
    {
        yyin = fopen(argv[1], "r");

        if (!yyin)
        {
            perror("Erro ao abrir arquivo");
            return 1;
        }
    }

    yylex();

    if (yyin)
        fclose(yyin);

    return 0;
}