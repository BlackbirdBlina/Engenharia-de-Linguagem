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

%token CONST MUTABLE LET SEMICOLON OR AND NOT_EQUAL EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL NOT PLUS EXPONENTIAL MINUS MULTIPLY DIVIDE REMAINDER LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET RIGHT_BRACKET LEFT_BRACE RIGHT_BRACE DOT END COMMA COLON PROCEDURE FUNCTION PURE FOR TO LOOP CONTINUE BREAK IF IN THEN ELSE RETURN REF PRINT
%token ATTRIBUTION INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token ID VALOR_INT VALOR_FLOAT VALOR_BOOL VALOR_CHAR VALOR_STRING 
%token TIPO_BOOL TIPO_S_INT8 TIPO_S_INT32 TIPO_S_SIZE TIPO_S_INT16 TIPO_U_INT8 TIPO_U_INT16 TIPO_U_INT32 TIPO_U_SIZE TIPO_FLOAT32 TIPO_FLOAT64 TIPO_CHAR TIPO_STRING TIPO_VEC TIPO_SET TIPO_MATRIX TIPO_RESULT
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN

%start Program 

%%
    Program: SubProgram Program{}
		| Assigment Program{}
		| Main {printf("Programa detectado\n");}
        ;

	SubProgram: FUNCTION ID LEFT_PARENTHESIS Params RIGHT_PARENTHESIS ARROW Type Scope {}
			  | PURE FUNCTION ID LEFT_PARENTHESIS Params RIGHT_PARENTHESIS ARROW Type Scope {}
			  | PROCEDURE ID LEFT_PARENTHESIS Params RIGHT_PARENTHESIS Scope {}
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
			 | FunctionCall SEMICOLON{}
			 ;

	Assigment: LET VarTyped ATTRIBUTION Expression SEMICOLON {printf("Declaração com atribuição\n");}
			 | CONST VarTyped ATTRIBUTION Expression SEMICOLON {printf("Declaração constante com atribuição\n");}
			 | MUTABLE VarTyped ATTRIBUTION Expression SEMICOLON {printf("Declaração mutável com atribuição\n");}
			 | ID ATTRIBUTION Expression SEMICOLON {printf("Atribuição\n");}
			 | ID INCREMENT SEMICOLON {printf("Incremento\n");}
			 | ID DECREMENT SEMICOLON {printf("Decremento\n");}
			 | ID PLUS_ATTRIBUTION Expression SEMICOLON {printf("Atribuição de soma\n");}
			 | ID MINUS_ATTRIBUTION Expression SEMICOLON {printf("Atribuição de subtração\n");}
			 | ID MULTIPLY_ATTRIBUTION Expression SEMICOLON {printf("Atribuição de multiplicação\n");}
			 | ID DIVIDE_ATTRIBUTION Expression SEMICOLON {printf("Atribuição de divisão\n");}
			 ;

	Expression: Expression OR AuxExp1 {}
		      | AuxExp1 {}
			  ;

	AuxExp1: AuxExp1 AND AuxExp2 {}
		   | AuxExp2 {}
		   ;
	
	AuxExp2: AuxExp2 EQUAL AuxExp3 {}
           | AuxExp2 NOT_EQUAL AuxExp3{}
	       | AuxExp3{}
		   ;
	
	AuxExp3: AuxExp3 Compare AuxExp4{}
		   | AuxExp4{}
		   ;
	
	AuxExp4: AuxExp4 PLUS AuxExp5{}
	       | AuxExp4 MINUS AuxExp5{}
		   | AuxExp5{}
		   ;
	
	AuxExp5: AuxExp5 MULTIPLY AuxExp6{}
		   | AuxExp5 DIVIDE AuxExp6{}
		   | AuxExp5 REMAINDER AuxExp6{}
		   | AuxExp6{}
		   ;
	
	AuxExp6: AuxExp7 EXPONENTIAL AuxExp6{}
		   | AuxExp7{}
		   ;
	
	AuxExp7: NOT AuxExp7{}
		   | AuxExp8{}
		   ;
	
	AuxExp8: ID{}
		   | Literal {}
		   | LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS {}
		   | FunctionCall {}
		   ;

	FunctionCall: ID FunctionCall {}
				| ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS FunctionCall {}
				| DOT ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS FunctionCall {}
				| DOT ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS {}
				| ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS{}
				;

	ParamsToCall: Expression COMMA ParamsToCall{}
				| Expression {}
				;
	
	Type: TIPO_BOOL | TIPO_S_INT8 | TIPO_S_INT32 | TIPO_S_SIZE | TIPO_S_INT16 | TIPO_U_INT8 | TIPO_U_INT16 | TIPO_U_INT32 | TIPO_U_SIZE | TIPO_FLOAT32 | TIPO_FLOAT64 | TIPO_CHAR | TIPO_STRING | TIPO_VEC | TIPO_SET | TIPO_MATRIX | TIPO_RESULT| LEFT_BRACKET Type RIGHT_BRACKET;

	Compare: LESS | GREATER | LESS_EQUAL | GREATER_EQUAL;

	Literal: VALOR_INT |VALOR_FLOAT |VALOR_BOOL |VALOR_CHAR |VALOR_STRING ;

%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}