%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

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
"bool"              { printf("TYPE_BOOL%s", char_at_end);}

"s_int8"            { printf("TYPE_S_INT8%s", char_at_end);}
"s_int16"           { printf("TYPE_S_INT16%s", char_at_end);}
"s_int32"           { printf("TYPE_S_INT32%s", char_at_end);}
"s_size"            { printf("TYPE_S_SIZE%s", char_at_end);}
"u_int8"            { printf("TYPE_U_INT8%s", char_at_end);}
"u_int16"           { printf("TYPE_U_INT16%s", char_at_end);}
"u_int32"           { printf("TYPE_U_INT32%s", char_at_end);}
"u_size"            { printf("TYPE_U_SIZE%s", char_at_end);}

"float32"           { printf("TYPE_FLOAT32%s", char_at_end);}
"float64"           { printf("TYPE_FLOAT64%s", char_at_end);}

"char"              { printf("TYPE_CHAR%s", char_at_end);}
"String"            { printf("TYPE_STRING%s", char_at_end);}

"Vec"               { printf("TYPE_VEC%s", char_at_end);}
"Set"               { printf("TYPE_SET%s", char_at_end);}
"Matrix"            { printf("TYPE_MATRIX%s", char_at_end);}

"Result"            { printf("TYPE_RESULT%s", char_at_end);}

"/*"(.|\n)*"*/" {/* Ignora tudo entre */}
"//".*              {/* Ignora tudo após "//* até o final da linha */}

{whitespace}        {column_counter += strlen(yytext);}
{newline}           {column_counter = 0; printf("\n");}
"bool"              { return TIPO_BOOL;}

"s_int8"            { return TIPO_S_INT8;}
"s_int16"           { return TIPO_S_INT16;}
"s_int32"           { return TIPO_S_INT32;}
"s_size"            { return TIPO_S_SIZE;}
"u_int8"            { return TIPO_U_INT8;}
"u_int16"           { return TIPO_U_INT16;}
"u_int32"           { return TIPO_U_INT32;}
"u_size"            { return TIPO_U_SIZE;}

"float32"           { return TIPO_FLOAT32;}
"float64"           { return TIPO_FLOAT64;}

"char"              { return TIPO_CHAR;}
"String"            { return TIPO_STRING;}

"Vec"               { return TIPO_VEC;}
"Set"               { return TIPO_SET;}
"Matrix"            { return TIPO_MATRIX;}

"Result"            { return TIPO_RESULT;}

"="                 { return ATTRIBUTION;}

">"                 { return GREATER;}
"<"                 { return LESS;}
">="                { return GREATER_EQUAL;}
"<="                { return LESS_EQUAL;}
"=="                { return EQUAL;}
"!="                { return NOT_EQUAL;}

"++"                { return INCREMENT;}
"--"                { return DECREMENT;}
"+="                { return PLUS_ATTRIBUTION;}
"-="                { return MINUS_ATTRIBUTION;}
"*="                { return MULTIPLY_ATTRIBUTION;}
"/="                { return DIVIDE_ATTRIBUTION;}

"+"                 { return PLUS;}
"-"                 { return MINUS;}
"*"                 { return MULTIPLY;}
"/"                 { return DIVIDE;}
"%"                 { return REMAINDER;}
"^"                 { return EXPONENTIAL;}

"!"                 { return NOT;}
"&&"                { return AND;}
"||"                { return OR;}

"("                 { return LEFT_PARENTHESIS;}
")"                 { return RIGHT_PARENTHESIS;}
"["                 { return LEFT_BRACKET;}
"]"                 { return RIGHT_BRACKET;}
"{"                 { return LEFT_BRACE;}
"}"                 { return RIGHT_BRACE;}

"\.\."              { return INTERVAL;}
"\."                { return DOT;}
":"                 { return COLON;}
";"                 { return SEMICOLON;}
","                 { return COMMA;}

"const"             { return CONST;}
"let"               { return LET;}
"mute"              { return MUTABLE;}
"&"                 { return REF;}
"if"                { return IF;}
"else"              { return ELSE;}
"match"             { return MATCH;}
"loop"              { return LOOP;}
"while"             { return WHILE;}
"for"               { return FOR;}
"in"                { return IN;}

"func"              { return FUNCTION;}
"->"                { return ARROW;}
"proced"            { return PROCEDURE;}
"pure"              { return PURE;}

"return"            { return RETURN;}
"break"             { return BREAK;}
"continue"          { return CONTINUE;}
"struct"            { return STRUCT;}
"enum"              { return ENUM;}
"main"              { return MAIN;}

"true"|"false"                              {
                                                return VALOR_BOOL;
                                            }

{number}+(E[+-]?{number}+)?                 {
                                                return VALOR_INT;
                                            }

{number}+\.{number}+(E[+-]?{number}+)?      {
                                                return VALOR_FLOAT;
                                            }

\'.\'                                       {
                                                return VALOR_CHAR;
                                            }

\".*\"                                      {
                                                return VALOR_STRING;
                                            }

{id}                    { return ID;}

.                       { printf("Error_line_text(%d,%s)%s", yylineno, yytext, char_at_end) ;}

%%

#ifndef yywrap
   // Indicates no more input 
   int yywrap (void) {return 1;}
#endif

