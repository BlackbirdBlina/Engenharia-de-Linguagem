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

%token CONST MUTABLE LET SEMICOLON OR AND NOT_EQUAL EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL NOT PLUS EXPONENTIAL MINUS MULTIPLY DIVIDE REMAINDER LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET RIGHT_BRACKET LEFT_BRACE RIGHT_BRACE DOT COMMA COLON PROCEDURE FUNCTION PURE FOR LOOP CONTINUE BREAK IF IN ELSE RETURN REF
%token ATTRIBUTION INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token OK ERROR SOME NONE ID VALUE_INT VALUE_FLOAT VALUE_BOOL VALUE_CHAR VALUE_STRING 
%token TYPE_BOOL TYPE_S_INT8 TYPE_S_INT32 TYPE_S_SIZE TYPE_S_INT16 TYPE_U_INT8 TYPE_U_INT16 TYPE_U_INT32 TYPE_U_SIZE TYPE_FLOAT32 TYPE_FLOAT64 TYPE_CHAR TYPE_STRING TYPE_VEC TYPE_SET TYPE_MATRIX TYPE_RESULT TYPE_OPTION
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN

%start Program 

%%
    Program: SubProgram Program{}
		| Assigment Program{}
		| StructDecl Program{printf("Struct detectada\n");}
		| EnumDecl Program{printf("Enum detectada\n");}
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
			  ;
	
	Statement: Assigment {}
			 | SubprogramCall SEMICOLON{}
			 | Return {}
			 | Scope {}
			 | RepeatStructures {}
			 | DecisionStructures {}
			 | CONTINUE SEMICOLON {}
			 | BREAK SEMICOLON {}
			 ;

	Return: RETURN SEMICOLON {}
	      | RETURN Expression SEMICOLON {}
		  ;

	Assigment: LET VarTyped ATTRIBUTION Expression SEMICOLON { printf("Declaração com atribuição\n"); }
			 | CONST VarTyped ATTRIBUTION Expression SEMICOLON { printf("Declaração constante com atribuição\n"); }
			 | MUTABLE VarTyped ATTRIBUTION Expression SEMICOLON { printf("Declaração mutável com atribuição\n"); }
			 | ID ATTRIBUTION Expression SEMICOLON { printf("Atribuição\n"); }
			 | ID INCREMENT SEMICOLON { printf("Incremento\n"); }
			 | ID DECREMENT SEMICOLON { printf("Decremento\n"); }
			 | ID PLUS_ATTRIBUTION Expression SEMICOLON { printf("Atribuição de soma\n"); }
			 | ID MINUS_ATTRIBUTION Expression SEMICOLON { printf("Atribuição de subtração\n"); }
			 | ID MULTIPLY_ATTRIBUTION Expression SEMICOLON { printf("Atribuição de multiplicação\n"); }
			 | ID DIVIDE_ATTRIBUTION Expression SEMICOLON { printf("Atribuição de divisão\n"); }
			 | Array ATTRIBUTION Expression SEMICOLON {}
			 ;
	Array: ID AtomArray{}
		 ;

	AtomArray: LEFT_BRACKET Expression RIGHT_BRACKET AtomArray{}
		| LEFT_BRACKET Expression RIGHT_BRACKET {}
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
	
	AuxExp8: ID {}
		   | Literal {}
		   | LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS{}
		   | Array {}
		   | REF ID {}
		   | SubprogramCall {}
           | List {}
		   ;
		   
    List: LEFT_BRACKET RIGHT_BRACKET {}
        | LEFT_BRACKET ElementSequence RIGHT_BRACKET {}
        ;

	SubprogramCall: ID SubprogramCall {}
				| ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS SubprogramCall{}
				| DOT ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS SubprogramCall{}
				| DOT ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS{}
				| ID LEFT_PARENTHESIS ParamsToCall RIGHT_PARENTHESIS{}
				| ID LEFT_PARENTHESIS  RIGHT_PARENTHESIS SubprogramCall{}
				| DOT ID LEFT_PARENTHESIS  RIGHT_PARENTHESIS SubprogramCall{}
				| DOT ID LEFT_PARENTHESIS  RIGHT_PARENTHESIS{}
				| ID LEFT_PARENTHESIS  RIGHT_PARENTHESIS{}
				;

	ParamsToCall: Expression COMMA ParamsToCall{}
				| Expression{}
    
	ElementSequence: Expression COMMA ElementSequence{}
				| Expression {}
				;
	
	RepeatStructures:  WHILE LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS Scope{}
					|  FOR LEFT_PARENTHESIS ID IN Expression INTERVAL Expression RIGHT_PARENTHESIS Scope{}
					|  FOR LEFT_PARENTHESIS ID IN Expression RIGHT_PARENTHESIS Scope{}
					|  LOOP Scope{}
					;
	DecisionStructures: IF LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS Scope{}
					  | IF LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS Scope ELSE Scope{}
					  | IF LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS Scope ElseIf{}
					  | MATCH LEFT_PARENTHESIS Pattern RIGHT_PARENTHESIS LEFT_BRACE MatchStructures RIGHT_BRACE{}
					  ;

	Pattern: Expression{}
		   ;

	MatchStructures: MatchStructure COMMA MatchStructures{}
				   |{}
				   ;

	MatchStructure: MaybeType ARROW Scope{}
			  	  ;
	MaybeType: Type LEFT_BRACKET ID RIGHT_BRACKET{}
		     | Type{}
		     ;

	StructDecl: STRUCT ID LEFT_BRACE Atributes RIGHT_BRACE{}
	          ;

	Atributes: VarTyped COMMA Atributes{}
		     | VarTyped COMMA{}
		     ;

	EnumDecl: ENUM ID LEFT_BRACE Variants RIGHT_BRACE{}
			;

	Variants: ID COMMA Variants{}
			| ID COMMA{}
			;

	ElseIf: ELSE IF LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS Scope ElseIf{}
		  | ELSE IF LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS Scope ELSE Scope{}
		  ;
	
	Type: TYPE_BOOL
        | TYPE_S_INT8
        | TYPE_S_INT32 
        | TYPE_S_SIZE 
        | TYPE_S_INT16 
        | TYPE_U_INT8 
        | TYPE_U_INT16 
        | TYPE_U_INT32 
        | TYPE_U_SIZE 
        | TYPE_FLOAT32
        | TYPE_FLOAT64 
        | TYPE_CHAR 
        | TYPE_STRING 
        | TYPE_VEC LESS Type GREATER
        | TYPE_SET LESS Type GREATER
        | TYPE_MATRIX  LESS Type SEMICOLON VALUE_INT SEMICOLON VALUE_INT GREATER
        | TYPE_RESULT LESS Type COMMA Type GREATER
        | TYPE_OPTION LESS Type COMMA Type GREATER
        | LEFT_BRACKET Type SEMICOLON VALUE_INT RIGHT_BRACKET
        | REF LEFT_BRACKET Type RIGHT_BRACKET
        | REF Type
        ;

	Compare: LESS | GREATER | LESS_EQUAL | GREATER_EQUAL;

	Literal: NONE | VALUE_INT | VALUE_FLOAT | VALUE_BOOL | VALUE_CHAR | VALUE_STRING ;
%%

int main (void) {
    // TODO:
        // OK(Type)
        // ERROR(Type)
        // SOME(Type)
    // TODO:
    // ModuleFunction: ID COLON COLON ModuleFunction {}
				//             | ID LEFT_PARENTHESIS ElementSequence RIGHT_PARENTHESIS ModuleFunction {}
				// | DOT ID LEFT_PARENTHESIS ElementSequence RIGHT_PARENTHESIS ModuleFunction {}
				// | DOT ID LEFT_PARENTHESIS ElementSequence RIGHT_PARENTHESIS {}
				// | DOT ID LEFT_PARENTHESIS  RIGHT_PARENTHESIS ModuleFunction {}
				// | DOT ID LEFT_PARENTHESIS  RIGHT_PARENTHESIS {}
				// | ID COLON COLON LEFT_PARENTHESIS  RIGHT_PARENTHESIS{}
    // TODO:
       // ID INCREMENT {}
       // ID DECREMENT {}
       // INCREMENT ID {}
       // DECREMENT ID {}

	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
