%{
#include <stdio.h>
#include "symbol_table.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

/* Custom Functions */
void p(const char string[]);
void np(const char string[]);

SymbolTable* createTable_Program = NULL;
/* OUR TODOs */
/*
    -> Figure out the syntax for structs:
        struct Thing {
            whatever : u_int8 = u_int8::default,
        }
        // Na main:
        let t : Thing = Thing { whatever = 10 };
        // Ou
        // Ou
        let t : struct = Thing { whatever : u_int8 = 10 };
    -> ENUM, match, union
            | EnumDecl { p("ENUM Detected"); }
            EnumDecl: ENUM ID '{' Variants '}'{}
	Variants: ID ',' Variants{}
	Variants: ID ',' Variants{}
			| ID ',' {}
			;
			| ID ',' {}
			;
			;
    -> Print tá funcionando, mas a gnt quer ele nativo? Ou faz um macro futuramente (igual rust).
*/

%}

%union {
	int    iValue; 	
	char   cValue; 	
	char * sValue;  
	};

%token CONST MUTABLE LET ';' OR AND NOT_EQUAL '=' '<' '>' LESS_EQUAL GREATER_EQUAL NOT '+' '^' '-' '*' '/' '%' '(' ')' '[' ']' '{' '}' '.' ',' ':' PROCEDURE FUNCTION PURE FOR LOOP CONTINUE BREAK IF IN ELSE RETURN '&'
%token EQUAL INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token PRINT
%token OK ERROR SOME NONE ID VALUE_INT VALUE_FLOAT VALUE_BOOL VALUE_CHAR VALUE_STRING 
%token TYPE_BOOL TYPE_S_INT8 TYPE_S_INT32 TYPE_S_SIZE TYPE_S_INT16 TYPE_U_INT8 TYPE_U_INT16 TYPE_U_INT32 TYPE_U_SIZE TYPE_FLOAT32 TYPE_FLOAT64 TYPE_CHAR TYPE_STRING TYPE_VEC TYPE_SET TYPE_MATRIX TYPE_RESULT TYPE_OPTION
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN

%start Program 

%%
    Program: SubProgram Program {}
		   | Assignment Program {}
           | StructDecl Program {}
		   | Main { p("PROGRAM Detected"); }
           ;

	SubProgram: FUNCTION ID '(' Params ')' ARROW Type Scope { p("REGULAR FUNCTION"); }
			  | PURE FUNCTION ID '(' Params ')' ARROW Type Scope { p("PURE FUNCTION"); }
			  | PROCEDURE ID '(' Params ')' Scope { p("PROCEDURE"); }
			  ;

	Main: FUNCTION MAIN '(' Params ')' ARROW Type Scope { p("MAIN");}
		;

	Params: VarTypedList {}
		  | { np("No PARAMS"); }
		  ;

	VarTypedList: VarTyped ',' VarTypedList {}
				| VarTyped {}
				;

	VarTyped: ID ':' Type { np("PARAMS"); }
			;

	Scope: '{' '}' { np("NoSCOPE"); }
		 | '{' Statements '}' { np("SCOPE"); }
		 ;

	Statements: Statement Statements {}
			  | Statement {}
			  ;
	
	Statement: Assignment {}
             | Attribution {}
             | StructDecl { p("STRUCT Detected"); }
			 | SubprogramCall ';'{}
             | ModuleCall ';' {}
			 | Return { np("RETURN"); }
			 | Scope {}
			 | RepeatStructures {}
			 | DecisionStructures {}
			 | CONTINUE ';' {}
			 | BREAK ';' {}
             | Print ';' {}
			 ;

	Return: RETURN ';' {}
	      | RETURN Expression ';' {}
		  ;

	Assignment: LET VarTyped '=' Expression ';' { p("NON-MUTABLE ASSIGNMENT"); }
			  | CONST VarTyped '=' Expression ';' { p("CONSTANT ASSIGNMENT"); }
			  | LET MUTABLE VarTyped '=' Expression ';' { p("MUTABLE ASSIGNMENT"); }
              | LET STRUCT ID '=' ID '{' ElementSequence '}' ';' {} // Rever: ElementSequence Mesmo?
              | LET MUTABLE STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
			  ;

    Attribution: ID '=' Expression ';' { p("ATTRIBUTION"); }
               | ID '.' ID '=' Expression ';'{ p("STRUCT ATTRIBUTION"); }
			   | ID PLUS_ATTRIBUTION Expression ';' { p("ADDING_ATTRIBUTION"); }
			   | ID MINUS_ATTRIBUTION Expression ';' { p("SUBTRACTING_ATTRIBUTION"); }
			   | ID MULTIPLY_ATTRIBUTION Expression ';' { p("MULTIPLICATION_ATTRIBUTION"); }
			   | ID DIVIDE_ATTRIBUTION Expression ';' { p("DIVIDING_ATTRIBUTION"); }
			   | Array '=' Expression ';' { p("ARRAY_ATTRIBUTION"); }
               | IncrOrDecr ';' {}
               ;

    IncrOrDecr: ID INCREMENT { p("EVAL->INCREMENT"); }
			  | ID DECREMENT { p("EVAL->DECREMENT"); }
			  | INCREMENT ID { p("INCREMENT->EVAL"); }
			  | DECREMENT ID { p("DECREMENT->EVAL"); }
              ;

	Array: ID ArrayAccesses{}
		 ;

	ArrayAccesses: '[' Expression ']' ArrayAccesses{}
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
	
	AuxExp8: IDs {}
		   | Literal {}
		   | '(' Expression ')' {}
		   | Array {}
		   | '&' ID {} // TALVEZ IDs?
           | '&' ID '[' INTERVAL ID ']' {} // TALVEZ IDs?
           | '&' ID '[' ID INTERVAL ']' {}// TALVEZ IDs?
           | '&' ID '[' INTERVAL VALUE_INT ']' {}
           | '&' ID '[' VALUE_INT INTERVAL ']' {}
           | Print {}
           | ModuleCall {}
		   | SubprogramCall {}
           | List {}
		   ;

    IDs: ID '.' IDs {}
       | ID {}
       ;
		   
    List: '[' ']' {}
        | '[' ElementSequence ']' {}
        ;

    Print: PRINT '(' VALUE_STRING ',' Expression ')' {}
         | PRINT '(' VALUE_STRING ')' {}
         ;

	SubprogramCall: ID MaybeParams '.' SubprogramCall {}
                  | ID '.' SubprogramCall {} // foo.poo()
				  | ID MaybeParams {}
				  ;

    MaybeParams: '(' ')' {}
               | '(' ParamsToCall ')' {}
               ;

	ParamsToCall: Expression ',' ParamsToCall{}
				| Expression {}
				;
    
    ModuleCall: ID ':' ':' SubprogramCall  {}
              | TypeCollection ':' ':' SubprogramCall {}
              ;

	ElementSequence: Expression ',' ElementSequence{}
				   | Expression {}
				   ;
	
	RepeatStructures:  WHILE '(' Expression ')' Scope{}
					|  FOR '(' ID IN Expression INTERVAL Expression ')' Scope{}
					|  FOR '(' ID IN Expression ')' Scope{}
					|  LOOP Scope {}
					;
					
	DecisionStructures: IF '(' Expression ')' Scope {}
					  | IF '(' Expression ')' Scope ELSE Scope {}
					  | IF '(' Expression ')' Scope ElseIf {}
					  | MATCH '(' Pattern ')' '{' MatchStructures '}' {}
					  ;

	ElseIf: ELSE IF '(' Expression ')' Scope ElseIf {}
		  | ELSE IF '(' Expression ')' Scope ELSE Scope{}
		  ;
	
	Pattern: Expression{}
		   ;

	MatchStructures: MatchStructure ',' MatchStructures{}
				   | {}
				   ;

	MatchStructure: MaybeType ARROW Scope{}
			  	  ;
				  
	MaybeType: Type '[' ID ']'{}
		     | Type{}
		     ;

	StructDecl: STRUCT ID '{' Attributes '}'{}
	          ;

	Attributes: VarTyped ',' Attributes {}
		      | VarTyped ',' {}
		      ;

	EnumDecl: ENUM ID '{' Variants '}' {}
			;
	
	Variants: ID ',' Variants {}
			| ID ',' {}
			;


    TypeCollection: TYPE_S_INT8
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
				  | TYPE_VEC
				  | TYPE_SET
				  | TYPE_MATRIX
				  | TYPE_RESULT {np("RESULT");}
				  | TYPE_OPTION
				  ;

	Type: TYPE_BOOL {np("BOOL");}
        | TYPE_S_INT8 {np("S_INT8");}
        | TYPE_S_INT32  {np("S_INT32");}
        | TYPE_S_SIZE  {np("S_SIZE");}
        | TYPE_S_INT16  {np("S_INT16");}
        | TYPE_U_INT8  {np("U_INT8");}
        | TYPE_U_INT16  {np("U_INT16");}
        | TYPE_U_INT32  {np("U_INT32");}
        | TYPE_U_SIZE  {np("U_SIZE");}
        | TYPE_FLOAT32 {np("FLOAT32");}
        | TYPE_FLOAT64  {np("FLOAT64");}
        | TYPE_CHAR  {np("CHAR");}
        | TYPE_STRING  {np("STRING");}
        | TYPE_VEC '<' Type '>' {np("VEC");}
        | TYPE_SET '<' Type '>' {np("SET");}
        | TYPE_MATRIX '<' Type ';' VALUE_INT ';' VALUE_INT '>' { np("MATRIX"); }
        | TYPE_RESULT '<' Type ',' Type '>' { np("RESULT W/ Types"); }
        | TYPE_OPTION '<' Type ',' Type '>' { np("OPTION"); }
        | '[' Type ';' VALUE_INT ']' { np("ARRAY"); }
        | '&' '[' Type ']' { np("REFERENCE ARRAY"); }
        | '&' Type { np("REFERENCE"); }
        | '('')' { np("UNIT TYPE"); }
		| ID
        ;

	Compare: '<' | '>' | LESS_EQUAL | GREATER_EQUAL | EQUAL;

	Literal: VALUE_INT
           | VALUE_FLOAT 
           | VALUE_BOOL 
           | VALUE_CHAR 
           | VALUE_STRING
           | OK '(' Expression ')' { np("OK"); }
           | ERROR '(' Expression ')' { np("ERROR"); }
           | SOME '(' Expression ')' { np("SOME"); }
           | '(' ')' { np("UNIT"); }
           | NONE {}
           ;
%%

/* Custom Functions */
void p(const char c[]) {
    printf("%s\n", c);
}
void np(const char c[]) {
    printf("%s -> ", c);
}

int main (void) {
	createTable_Program = create_table();
	insert_symbol(createTable_Program, "x", "global",create_primitive_type(KIND_BOOL));
	
	yyparse ( );
	
	printf("Tabela de símbolos criada no endereço: %p\n", createTable_Program);

    unsigned int slot = hash("x#global#0");
	SymbolNode* node = createTable_Program->buckets[slot];
	printf("node: %p\n", node);
	printf("name: %s\n", node->name);
	printf("key: %s\n", node->key);
	return 0;
	
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
