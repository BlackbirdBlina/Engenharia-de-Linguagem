%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int column_counter = 0;
int line_counter = 0;

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
identificador       {letter}({letter}|{number})*

%%


"/*"([^}]|\n)*"*/"  {/* Ignora tudo entre "{" e "}" */}
"//".*              {/* Ignora tudo após "--* até o final da linha */}

{whitespace}        {column_counter += strlen(yytext);}
{newline}           {column_counter = 0; printf("\n");}
"bool"              {printf("TIPO_BOOL ");}

"s_int8"            {printf("TIPO_S_INT8 ");}
"s_int16"           {printf("TIPO_S_INT16 ");}
"s_int32"           {printf("TIPO_S_INT32 ");}
"s_size"            {printf("TIPO_S_SIZE ");}
"u_int8"            {printf("TIPO_U_INT8 ");}
"u_int16"           {printf("TIPO_U_INT16 ");}
"u_int32"           {printf("TIPO_U_INT32 ");}
"u_size"            {printf("TIPO_U_SIZE ");}

"float32"           {printf("TIPO_FLOAT32 ");}
"float64"           {printf("TIPO_FLOAT64 ");}

"char"              {printf("TIPO_CHAR ");}
"String"            {printf("TIPO_STRING ");}

"Vec"               {printf("TIPO_VEC ");}
"Set"               {printf("TIPO_SET ");}
"Matrix"            {printf("TIPO_MATRIX ");}

"Result"            {printf("TIPO_RESULT ");}

"="                 {printf("ATTRIBUTION ");}

">"                 {printf("GREATER ");}
"<"                 {printf("LESS ");}
">="                {printf("GREATER_EQUAL ");}
"<="                {printf("LESS_EQUAL ");}
"=="                {printf("EQUAL ");}
"!="                {printf("NOT_EQUAL ");}

"+"                 {printf("PLUS ");}
"-"                 {printf("MINUS ");}
"*"                 {printf("MULTIPLY ");}
"/"                 {printf("DIVIDE ");}
"%"                 {printf("REMAINDER ");}

"!"                 {printf("NOT ");}
"&&"                {printf("AND ");}
"||"                {printf("OR ");}

"("                 {printf("LEFT_PARENTHESIS ");}
")"                 {printf("RIGHT_PARENTHESIS ");}
"["                 {printf("LEFT_BRACKET ");}
"]"                 {printf("RIGHT_BRACKET ");}
"{"                 {printf("LEFT_BRACE ");}
"}"                 {printf("RIGHT_BRACE ");}

"\.\."              {printf("INTERVAL ");}
"\."                {printf("DOT ");}
":"                 {printf("COLON ");}
";"                 {printf("SEMICOLON ");}
","                 {printf("COMMA ");}

"const"             {printf("CONST ");}
"let"               {printf("LET ");}
"&"                 {printf("REF ");}
"if"                {printf("IF ");}
"else"              {printf("ELSE ");}
"loop"              {printf("LOOP ");}
"while"             {printf("WHILE ");}
"for"               {printf("FOR ");}
"in"                {printf("IN ");}

"func"              {printf("FUNCTION ");}
"->"                {printf("ARROW ");}

"return"            {printf("RETURN ");}
"break"             {printf("BREAK ");}
"continue"          {printf("CONTINUE ");}
"struct"            {printf("STRUCT ");}

"true"|"false"          {
                            printf("VALOR_BOOL ");
                        }

{number}+               {
                            printf("VALOR_INT ");
                        }

{number}+\.{number}+    {
                            printf("VALOR_FLOAT ");
                        }

\'.\'                   {
                            printf("VALOR_CHAR ");
                        }

\".*\"                  {
                            printf("VALOR_STRING ");
                        }

[a-zA-Z][a-zA-Z0-9_]* { printf("ID(%s) ",yytext);}

.                       {printf("Error_line_text(%d,%s) ", yylineno, yytext) ;}

%%

#ifndef yywrap
   // Indicates no more input 
   int yywrap (void) {return 1;}
#endif

int main(void)
{
  yylex();  
  return 0;
}
