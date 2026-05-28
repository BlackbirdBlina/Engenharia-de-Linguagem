%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; 	
	char   cValue; 	
	char * sValue;  
	};

%token CONST MUTABLE LET SEMICOLON OR AND NOT_EQUAL EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL NOT PLUS MINUS MULTIPLY DIVIDE REMAINDER LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET RIGHT_BRACKET LEFT_BRACE RIGHT_BRACE DOT END COMMA COLON PROCEDURE FUNCTION PURE FOR TO LOOP CONTINUE BREAK IF IN THEN ELSE RETURN REF PRINT
%token ATTRIBUTION INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token ID VALOR_INT VALOR_FLOAT VALOR_BOOL VALOR_CHAR VALOR_STRING 
%token TIPO_BOOL TIPO_S_INT8 TIPO_S_INT32 TIPO_S_SIZE TIPO_S_INT16 TIPO_U_INT8 TIPO_U_INT16 TIPO_U_INT32 TIPO_U_SIZE TIPO_FLOAT32 TIPO_FLOAT64 TIPO_CHAR TIPO_STRING TIPO_VEC TIPO_SET TIPO_MATRIX TIPO_RESULT
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN

%start Program 

%%
    Program: SubProgram Program{}
		| Main {printf("Programa detectado\n");}
        ;

	SubProgram: FUNCTION ID LEFT_PARENTHESIS Params RIGHT_PARENTHESIS ARROW Type Scope {}
			  ;

	Main: FUNCTION MAIN LEFT_PARENTHESIS Params RIGHT_PARENTHESIS ARROW Type Scope {printf("função main detectada\n");}
		;

	Params: VarTypedList {}
		  | {}
		  ;

	VarTypedList: VarTyped COMMA VarTypedList {}
				| VarTyped {}
				;

	VarTyped: ID COLON Type {}
			;

	Scope: LEFT_BRACE RIGHT_BRACE {printf("escopo vazio\n");}
		 | LEFT_BRACE Statements RIGHT_BRACE {printf("escopo com algo dentro achado\n");}
		 ;

	Statements: Statement Statements {}
			  | Statement {}
			  | Scope {}
			  ;
	
	Statement: Assigment {}
			;

	Assigment:LET VarTyped ATTRIBUTION Literal SEMICOLON {printf("Atribuição\n");}
			 ;
	
	Type:TIPO_BOOL | TIPO_S_INT8 | TIPO_S_INT32 | TIPO_S_SIZE | TIPO_S_INT16 | TIPO_U_INT8 | TIPO_U_INT16 | TIPO_U_INT32 | TIPO_U_SIZE | TIPO_FLOAT32 | TIPO_FLOAT64 | TIPO_CHAR | TIPO_STRING | TIPO_VEC | TIPO_SET | TIPO_MATRIX | TIPO_RESULT| LEFT_BRACKET Type RIGHT_BRACKET;

	Literal: VALOR_INT |VALOR_FLOAT |VALOR_BOOL |VALOR_CHAR |VALOR_STRING ;

%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}