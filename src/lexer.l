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
"bool"              {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); return TIPO_BOOL;}
"int"               {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); return TIPO_INT;}
"float"             {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); return TIPO_FLOAT;}
"char"              {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); return TIPO_CHAR;}
"string"            {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); return TIPO_STRING;}

"="                 {column_counter += strlen(yytext); return ATTRIBUTION;}

">"                 {column_counter += strlen(yytext); return GREATER;}
"<"                 {column_counter += strlen(yytext); return LESS;}
">="                {column_counter += strlen(yytext); return GREATER_EQUAL;}
"<="                {column_counter += strlen(yytext); return LESS_EQUAL;}
"=="                {column_counter += strlen(yytext); return EQUAL;}
"!="                {column_counter += strlen(yytext); return NOT_EQUAL;}

"+"                 {column_counter += strlen(yytext); return PLUS;}
"-"                 {column_counter += strlen(yytext); return MINUS;}
"*"                 {column_counter += strlen(yytext); return MULTIPLY;}
"/"                 {column_counter += strlen(yytext); return DIVIDE;}
"%"                 {column_counter += strlen(yytext); return REMAINDER;}

"!"                 {column_counter += strlen(yytext); return NOT;}
"&&"                {column_counter += strlen(yytext); return AND;}
"||"                {column_counter += strlen(yytext); return OR;}

"("                 {column_counter += strlen(yytext); return LEFT_PARENTH;}
")"                 {column_counter += strlen(yytext); return RIGHT_PARENTH;}
"["                 {column_counter += strlen(yytext); return LEFT_BRACK;}
"]"                 {column_counter += strlen(yytext); return RIGHT_BRACK;}
"{"                 {column_counter += strlen(yytext); return LEFT_BRACES;}
"}"                 {column_counter += strlen(yytext); return RIGHT_BRACES;}

"\.\."              {column_counter += strlen(yytext); return INTERVAL;}
"\."                {column_counter += strlen(yytext); return DOT;}
":"                 {column_counter += strlen(yytext); return COLON;}
";"                 {column_counter += strlen(yytext); return SEMICOLON;}

"const"             {column_counter += strlen(yytext); return CONST;}
"let"               {column_counter += strlen(yytext); return LET;}
"&"                 {column_counter += strlen(yytext); return REF;}
"if"                {column_counter += strlen(yytext); return IF;}
"else"              {column_counter += strlen(yytext); return ELSE;}
"loop"              {column_counter += strlen(yytext); return LOOP;}
"while"             {column_counter += strlen(yytext); return WHILE;}
"for"               {column_counter += strlen(yytext); return FOR;}

"function"          {column_counter += strlen(yytext); return FUNCTION;}

"return"            {column_counter += strlen(yytext); return RETURN;}
"break"             {column_counter += strlen(yytext); return BREAK;}
"continue"          {column_counter += strlen(yytext); return CONTINUE;}
"struct"            {column_counter += strlen(yytext); yylval.info.name = strdup(yytext); return STRUCT;}
"array"             {column_counter += strlen(yytext); yytext.info.name = strdup(yytext); return ARRAY;}

"true"|"false"          {
                            yylval.info.value.valor_bool = yytext[0] == 't' ? 1 : 0;
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            return VALOR_BOOL;

                        }

{number}+               {
                            yylval.info.value.valor_int = atoin(yytext);
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            return VALOR_INT;
                        }

{number}+\.{number}+    {
                            yylval.info.value.valor_float = strtof(yytext, NULL);
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            return VALOR_FLOAT;
                        }

\'.\'                   {
                            yylval.info.value.valor_char = yytext[1];
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            return VALOR_CHAR;
                        }

\".*\"                  {
                            yylval.info.value.valor_string = strdup(yytext + 1);
                            yylval.info.value.valor_string[yyleng - 2] = '\0';
                            yylval.info.name = strdup(yytext);
                            column_counter += strlen(yytext);
                            return VALOR_STRING;
                        }