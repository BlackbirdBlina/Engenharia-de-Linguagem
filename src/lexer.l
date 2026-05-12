%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int column_counter;
%}

%option noinput nounput
%option noyywrap
%option yylineno

number              [0-9]
letter              [a-zA-Z\_]
indentation         [ \t]
whitespaces         {delim}+
newline             [\n]+
identificador       {letter}({letter}|{number})*

%%

"/*"([^}]|\n)*"*/"  {/* Ignora tudo entre "{" e "}" */}
"//".*              {/* Ignora tudo após "--* até o final da linha */}

{whitespace}        {column_counter += strlen(yytext);}
{newline}           {column_counter = 0;}
"bool"              {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); printf("TIPO_BOOL")};
"int"               {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); printf("TIPO_INT")};
"float"             {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); printf("TIPO_FLOAT")};
"char"              {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); printf("TIPO_CHAR")};
"string"            {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); printf("TIPO_STRING")};

"="                 {column_counter += strlen(yytext); printf("ATTRIBUTION")};

">"                 {column_counter += strlen(yytext); printf("GREATER")};
"<"                 {column_counter += strlen(yytext); printf("LESS")};
">="                {column_counter += strlen(yytext); printf("GREATER_EQUAL")};
"<="                {column_counter += strlen(yytext); printf("LESS_EQUAL")};
"=="                {column_counter += strlen(yytext); printf("EQUAL")};
"!="                {column_counter += strlen(yytext); printf("NOT_EQUAL")};

"+"                 {column_counter += strlen(yytext); printf("PLUS")};
"-"                 {column_counter += strlen(yytext); printf("MINUS")};
"*"                 {column_counter += strlen(yytext); printf("MULTIPLY")};
"/"                 {column_counter += strlen(yytext); printf("DIVIDE")};
"%"                 {column_counter += strlen(yytext); printf("REMAINDER")};

"!"                 {column_counter += strlen(yytext); printf("NOT")};
"&&"                {column_counter += strlen(yytext); printf("AND")};
"||"                {column_counter += strlen(yytext); printf("OR")};

"("                 {column_counter += strlen(yytext); printf("LEFT_PARENTH")};
")"                 {column_counter += strlen(yytext); printf("RIGHT_PARENTH")};
"["                 {column_counter += strlen(yytext); printf("LEFT_BRACK")};
"]"                 {column_counter += strlen(yytext); printf("RIGHT_BRACK")};
"{"                 {column_counter += strlen(yytext); printf("LEFT_BRACES")};
"}"                 {column_counter += strlen(yytext); printf("RIGHT_BRACES")};

"\.\."              {column_counter += strlen(yytext); printf("INTERVAL")};
"\."                {column_counter += strlen(yytext); printf("DOT")};
":"                 {column_counter += strlen(yytext); printf("COLON")};
";"                 {column_counter += strlen(yytext); printf("SEMICOLON")};

"const"             {column_counter += strlen(yytext); printf("CONST")};
"let"               {column_counter += strlen(yytext); printf("LET")};
"&"                 {column_counter += strlen(yytext); printf("REF")};
"if"                {column_counter += strlen(yytext); printf("IF")};
"else"              {column_counter += strlen(yytext); printf("ELSE")};
"loop"              {column_counter += strlen(yytext); printf("LOOP")};
"while"             {column_counter += strlen(yytext); printf("WHILE")};
"for"               {column_counter += strlen(yytext); printf("FOR")};

"function"          {column_counter += strlen(yytext); printf("FUNCTION")};

"return"            {column_counter += strlen(yytext); printf("RETURN")};
"break"             {column_counter += strlen(yytext); printf("BREAK")};
"continue"          {column_counter += strlen(yytext); printf("CONTINUE")};
"struct"            {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); printf("STRUCT")};
"array"             {column_counter += strlen(yytext); yytext.info.name = strdup(yytext); printf("ARRAY")};

"true"|"false"          {
                            yylval.info.value.valor_bool = yytext[0] == 't' ? 1 : 0;
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            printf("VALOR_BOOL");
                        }

{number}+               {
                            yylval.info.value.valor_int = atoin(yytext);
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            printf("VALOR_INT");
                        }

{number}+\.{number}+    {
                            yylval.info.value.valor_float = strtof(yytext, NULL);
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            printf("VALOR_FLOAT");
                        }

\'.\'                   {
                            yylval.info.value.valor_char = yytext[1];
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            printf("VALOR_CHAR");
                        }

\".*\"                  {
                            yylval.info.value.valor_string = strdup(yytext + 1);
                            yylval.info.value.valor_string[yyleng - 2] = '\0';
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            printf("VALOR_STRINT");
                        }
