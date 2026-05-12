%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int column_counter;

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
{newline}           {column_counter = 0;}
"bool"              {printf("TIPO_BOOL\n");}

"s_int8"            {printf("TIPO_S_INT8\n");}
"s_int16"           {printf("TIPO_S_INT16\n");}
"s_int32"           {printf("TIPO_S_INT32\n");}
"s_size"            {printf("TIPO_S_SIZE\n");}
"u_int8"            {printf("TIPO_U_INT8\n");}
"u_int16"           {printf("TIPO_U_INT16\n");}
"u_int32"           {printf("TIPO_U_INT32\n");}
"u_size"            {printf("TIPO_U_SIZE\n");}

"float32"           {printf("TIPO_FLOAT32\n");}
"float64"           {printf("TIPO_FLOAT64\n");}

"char"              {printf("TIPO_CHAR\n");}
"string"            {printf("TIPO_STRING\n");}

"="                 {printf("ATTRIBUTION\n");}

">"                 {printf("GREATER\n");}
"<"                 {printf("LESS\n");}
">="                {printf("GREATER_EQUAL\n");}
"<="                {printf("LESS_EQUAL\n");}
"=="                {printf("EQUAL\n");}
"!="                {printf("NOT_EQUAL\n");}

"+"                 {printf("PLUS\n");}
"-"                 {printf("MINUS\n");}
"*"                 {printf("MULTIPLY\n");}
"/"                 {printf("DIVIDE\n");}
"%"                 {printf("REMAINDER\n");}

"!"                 {printf("NOT\n");}
"&&"                {printf("AND\n");}
"||"                {printf("OR\n");}

"("                 {printf("LEFT_PARENTH\n");}
")"                 {printf("RIGHT_PARENTH\n");}
"["                 {printf("LEFT_BRACK\n");}
"]"                 {printf("RIGHT_BRACK\n");}
"{"                 {printf("LEFT_BRACES\n");}
";}"                 {printf("RIGHT_BRACES\n");}

"\.\."              {printf("INTERVAL\n");}
"\."                {printf("DOT\n");}
":"                 {printf("COLON\n");}
";"                 {printf("SEMICOLON\n");}

"const"             {printf("CONST\n");}
"let"               {printf("LET\n");}
"&"                 {printf("REF\n");}
"if"                {printf("IF\n");}
"else"              {printf("ELSE\n");}
"loop"              {printf("LOOP\n");}
"while"             {printf("WHILE\n");}
"for"               {printf("FOR\n");}

"func"              {printf("FUNCTION\n");}

"return"            {printf("RETURN\n");}
"break"             {printf("BREAK\n");}
"continue"          {printf("CONTINUE\n");}
"struct"            {printf("STRUCT\n");}
"array"             {printf("ARRAY\n");}
[a-zA-Z][a-zA-Z0-9]* {printf("ID(%s)\n",yytext);}

"true"|"false"          {
                            printf("VALOR_BOOL\n");
                        }

{number}+               {
                            printf("VALOR_INT\n");
                        }

{number}+\.{number}+    {
                            printf("VALOR_FLOAT\n");
                        }

\'.\'                   {
                            printf("VALOR_CHAR\n");
                        }

\".*\"                  {
                            printf("VALOR_STRING\n");
                        }

.                      {printf("Caracter Inválido\n");}

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
