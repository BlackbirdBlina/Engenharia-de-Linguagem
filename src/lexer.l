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

"/*"([^}]|\n)*"*/"    {/* Ignora tudo entre "{" e "}" */}
"//".*              {/* Ignora tudo após "--* até o final da linha */}

{whitespace}                {column_counter += strlen(yytext);}
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

