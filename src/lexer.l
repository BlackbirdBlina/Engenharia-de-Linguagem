%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lib/parser/semantics.h"
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

"/*"([^*]|\*+[^*/])*\*+"/" {/* Ignora tudo entre "/ *" e "* /" */}
"//".*              {/* Ignora tudo após "//" até o final da linha */}

{whitespace}        {column_counter += strlen(yytext);}
{newline}           {column_counter = 0; }
"bool"              { return TYPE_BOOL;}

"s_int16"           { return TYPE_S_INT16;}
"s_int32"           { return TYPE_S_INT32;}
"s_int64"           { return TYPE_S_INT64;}
"s_size"            { return TYPE_S_SIZE;}
"u_int16"           { return TYPE_U_INT16;}
"u_int32"           { return TYPE_U_INT32;}
"u_int64"            { return TYPE_U_INT64;}
"u_size"            { return TYPE_U_SIZE;}

"float32"           { return TYPE_FLOAT32;}
"float64"           { return TYPE_FLOAT64;}

"char"              { return TYPE_CHAR;}
"String"            { return TYPE_STRING;}

"Vec"               { return TYPE_VEC;}
"Set"               { return TYPE_SET;}
"Matrix"            { return TYPE_MATRIX;}

"Result"            { return TYPE_RESULT;}
"Ok"                { return OK;}
"Error"             { return ERROR;}

"Option"            { return TYPE_OPTION;}
"Some"              { return SOME;}
"None"              { return NONE;}

"="                 { return '=';}

">"                 { return '>';}
"<"                 { return '<';}
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

"+"                 { return '+';}
"-"                 { return '-';}
"*"                 { return '*';}
"/"                 { return '/';}
"%"                 { return '%';}
"^"                 { return '^';}

"!"                 { return NOT;}
"&&"                { return AND;}
"||"                { return OR;}

"("                 { return '(';}
")"                 { return ')';}
"["                 { return '[';}
"]"                 { return ']';}
"{"                 { return '{';}
"}"                 { return '}';}

"\.\."              { return INTERVAL;}
"\."                { return '.';}
":"                 { return ':';}
";"                 { return ';';}
","                 { return ',';}

"const"             { return CONST;}
"let"               { return LET;}
"mut"               { return MUTABLE;}
"&"                 { return '&';}
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
"print"             { return PRINT;}

"true"|"false"                              {
                                                yylval.sValue = strdup(yytext);
                                                return VALUE_BOOL;
                                            }

{number}+(E[+-]?{number}+)?                 {
                                                yylval.sValue = strdup(yytext);
                                                return VALUE_INT;
                                            }

{number}+\.{number}+(E[+-]?{number}+)?      {
                                                yylval.sValue = strdup(yytext);
                                                return VALUE_FLOAT;
                                            }

\'.\'                                       {
                                                yylval.sValue = strdup(yytext);
                                                return VALUE_CHAR;
                                            }

\".*\"                                      {
                                                yylval.sValue = strdup(yytext);
                                                return VALUE_STRING;
                                            }

{id}                    { yylval.sValue = strdup(yytext); 
                          return ID; }

.                       { printf("Error_line_text(%d,%s)%s", yylineno, yytext, char_at_end) ;}

%%

#ifndef yywrap
   // Indicates no more input 
   int yywrap (void) {return 1;}
#endif

