%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

/* Custom Functions */
void p(const char string[]);

/* OUR TODOs */
/*
    -> Add support for these things:
        OK(Type)
        ERROR(Type)
        SOME(Type)
    
    -> Add support for things like: Vec::foo()
    ModuleFunction: ID ':' ':' ModuleFunction {}
                  | ID '(' ElementSequence ')' ModuleFunction {}
                  | '.' ID '(' ElementSequence ')' ModuleFunction {}
	              | '.' ID '(' ElementSequence ')' {}
	          	  | '.' ID '('  ')' ModuleFunction {}
	          	  | '.' ID '('  ')' {}
	          	  | ID ':' ':' '('  ')'{}

    -> Add Incrementing and Decrementing
        ID INCREMENT {}
        ID DECREMENT {}
        INCREMENT ID {}
        DECREMENT ID {}
*/

%}

%union {
	int    iValue; 	
	char   cValue; 	
	char * sValue;  
	};

%token CONST MUTABLE LET ';' OR AND NOT_EQUAL '=' '<' '>' LESS_EQUAL GREATER_EQUAL NOT '+' '^' '-' '*' '/' '%' '(' ')' '[' ']' '{' '}' '.' ',' ':' PROCEDURE FUNCTION PURE FOR LOOP CONTINUE BREAK IF IN ELSE RETURN '&'
%token EQUAL INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token OK ERROR SOME NONE ID VALUE_INT VALUE_FLOAT VALUE_BOOL VALUE_CHAR VALUE_STRING 
%token TYPE_BOOL TYPE_S_INT8 TYPE_S_INT32 TYPE_S_SIZE TYPE_S_INT16 TYPE_U_INT8 TYPE_U_INT16 TYPE_U_INT32 TYPE_U_SIZE TYPE_FLOAT32 TYPE_FLOAT64 TYPE_CHAR TYPE_STRING TYPE_VEC TYPE_SET TYPE_MATRIX TYPE_RESULT TYPE_OPTION
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN

%start Program 

%%
    Program: SubProgram Program{}
		| Assignment Program{}
		| StructDecl Program{ p("STRUCT Detected"); }
		| EnumDecl Program{ p("ENUM Detected"); }
		| Main { p("PROGRAM Detected"); }
        ;

	SubProgram: FUNCTION ID '(' Params ')' ARROW Type Scope { p("FUNCTION"); }
			  | PURE FUNCTION ID '(' Params ')' ARROW Type Scope { p("PURE FUNCTION"); }
			  | PROCEDURE ID '(' Params ')' Scope { p("PROCEDURE"); }
			  ;

	Main: FUNCTION MAIN '(' Params ')' ARROW Type Scope { p("MAIN");}
		;

	Params: VarTypedList {}
		  | {}
		  ;

	VarTypedList: VarTyped ',' VarTypedList {}
				| VarTyped {}
				;

	VarTyped: ID ':' Type {}
			;

	Scope: '{' '}' { p("SCOPE Inactive"); }
		 | '{' Statements '}' { p("SCOPE Active"); }
		 ;

	Statements: Statement Statements {}
			  | Statement {}
			  ;
	
	Statement: Assignment {}
			 | SubprogramCall ';'{}
			 | Return {}
			 | Scope {}
			 | RepeatStructures {}
			 | DecisionStructures {}
			 | CONTINUE ';' {}
			 | BREAK ';' {}
			 ;

	Return: RETURN ';' {}
	      | RETURN Expression ';' {}
		  ;

	Assignment: LET VarTyped '=' Expression ';' { p("NON-MUTABLE ASSIGNMENT"); }
			 | CONST VarTyped '=' Expression ';' { p("CONSTANT ASSIGNMENT"); }
			 | MUTABLE VarTyped '=' Expression ';' { p("MUTABLE ASSIGNMENT"); }
			 | ID '=' Expression ';' { p("ATTRIBUTION"); }
			 | ID INCREMENT ';' { p("INCREMENT"); }
			 | ID DECREMENT ';' { p("DECREMENT"); }
			 | ID PLUS_ATTRIBUTION Expression ';' { p("ADDING_ATTRIBUTION"); }
			 | ID MINUS_ATTRIBUTION Expression ';' { p("SUBTRACTING_ATTRIBUTION"); }
			 | ID MULTIPLY_ATTRIBUTION Expression ';' { p("MULTIPLICATION_ATTRIBUTION"); }
			 | ID DIVIDE_ATTRIBUTION Expression ';' { p("DIVIDING_ATTRIBUTION"); }
			 | Array '=' Expression ';' { p("ARRAY_ATTRIBUTION"); }
			 ;
	Array: ID AtomArray{}
		 ;

	AtomArray: '[' Expression ']' AtomArray{}
		| '[' Expression ']' {}
		;
	Expression: Expression OR AuxExp1 {}
		      | AuxExp1 {}
			  ;

	AuxExp1: AuxExp1 AND AuxExp2 {}
		   | AuxExp2 {}
		   ;
	
	AuxExp2: AuxExp2 '=' AuxExp3 {}
           | AuxExp2 NOT_EQUAL AuxExp3{}
	       | AuxExp3{}
		   ;
	
	AuxExp3: AuxExp3 Compare AuxExp4{}
		   | AuxExp4{}
		   ;
	
	AuxExp4: AuxExp4 '+' AuxExp5{}
	       | AuxExp4 '-' AuxExp5{}
		   | AuxExp5{}
		   ;
	
	AuxExp5: AuxExp5 '*' AuxExp6{}
		   | AuxExp5 '/' AuxExp6{}
		   | AuxExp5 '%' AuxExp6{}
		   | AuxExp6{}
		   ;
	
	AuxExp6: AuxExp7 '^' AuxExp6{}
		   | AuxExp7{}
		   ;
	
	AuxExp7: NOT AuxExp7{}
		   | AuxExp8{}
		   ;
	
	AuxExp8: ID {}
		   | Literal {}
		   | '(' Expression ')'{}
		   | Array {}
		   | '&' ID {}
		   | SubprogramCall {}
           | List {}
		   ;
		   
    List: '[' ']' {}
        | '[' ElementSequence ']' {}
        ;

	SubprogramCall: ID MaybeParams '.' SubprogramCall {}
                | ID '.' SubprogramCall {}
				| ID MaybeParams {}
				;

    MaybeParams: '(' ')' {}
                | '(' ParamsToCall ')' {}
                ;

	ParamsToCall: Expression ',' ParamsToCall{}
				| Expression {}
    
	ElementSequence: Expression ',' ElementSequence{}
				| Expression {}
				;
	
	RepeatStructures:  WHILE '(' Expression ')' Scope{}
					|  FOR '(' ID IN Expression INTERVAL Expression ')' Scope{}
					|  FOR '(' ID IN Expression ')' Scope{}
					|  LOOP Scope{}
					;
	DecisionStructures: IF '(' Expression ')' Scope{}
					  | IF '(' Expression ')' Scope ELSE Scope{}
					  | IF '(' Expression ')' Scope ElseIf{}
					  | MATCH '(' Pattern ')' '{' MatchStructures '}'{}
					  ;

	Pattern: Expression{}
		   ;

	MatchStructures: MatchStructure ',' MatchStructures{}
				   |{}
				   ;

	MatchStructure: MaybeType ARROW Scope{}
			  	  ;
	MaybeType: Type '[' ID ']'{}
		     | Type{}
		     ;

	StructDecl: STRUCT ID '{' Atributes '}'{}
	          ;

	Atributes: VarTyped ',' Atributes{}
		     | VarTyped ',' {}
		     ;

	EnumDecl: ENUM ID '{' Variants '}'{}
			;

	Variants: ID ',' Variants{}
			| ID ',' {}
			;

	ElseIf: ELSE IF '(' Expression ')' Scope ElseIf{}
		  | ELSE IF '(' Expression ')' Scope ELSE Scope{}
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
        | TYPE_VEC '<' Type '>'
        | TYPE_SET '<' Type '>'
        | TYPE_MATRIX '<' Type ';' VALUE_INT ';' VALUE_INT '>'
        | TYPE_RESULT '<' Type ',' Type '>'
        | TYPE_OPTION '<' Type ',' Type '>'
        | '[' Type ';' VALUE_INT ']'
        | '&' '[' Type ']'
        | '&' Type
        ;

	Compare: '<' | '>' | LESS_EQUAL | GREATER_EQUAL;

	Literal: NONE | VALUE_INT | VALUE_FLOAT | VALUE_BOOL | VALUE_CHAR | VALUE_STRING ;
%%

/* Custom Functions */
void p(const char c[]) {
    printf("%s\n", c);
}

int main (void) {

	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
