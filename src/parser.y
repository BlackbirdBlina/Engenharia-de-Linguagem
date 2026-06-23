%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;

/* Custom Functions */
void p(const char string[]);
void np(const char string[]);
char * cat(char **, int);
char * whileCount();
char * forCount();

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
	struct Record * rec;  
	};

%token CONST MUTABLE LET ';' OR AND NOT_EQUAL '=' '<' '>' LESS_EQUAL GREATER_EQUAL NOT '+' '^' '-' '*' '/' '%' '(' ')' '[' ']' '{' '}' '.' ',' ':' PROCEDURE FUNCTION PURE FOR LOOP CONTINUE BREAK IF IN ELSE RETURN '&'
%token EQUAL INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token PRINT
%token <sValue> OK ERROR SOME NONE ID VALUE_INT VALUE_FLOAT VALUE_BOOL VALUE_CHAR VALUE_STRING 
%token TYPE_BOOL TYPE_S_INT8 TYPE_S_INT32 TYPE_S_SIZE TYPE_S_INT16 TYPE_U_INT8 TYPE_U_INT16 TYPE_U_INT32 TYPE_U_SIZE TYPE_FLOAT32 TYPE_FLOAT64 TYPE_CHAR TYPE_STRING TYPE_VEC TYPE_SET TYPE_MATRIX TYPE_RESULT TYPE_OPTION
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN

%type <rec> SubProgram Main Params VarTyped VarTypedList Scope Statements Statement Return Assignment Attribution IncrOrDecr
%type <rec> Array ArrayAccesses Expression AuxExp1 AuxExp2 AuxExp3 AuxExp4 AuxExp5 AuxExp6 AuxExp7 AuxExp8 IDs List Print
%type <rec> SubprogramCall MaybeParams ParamsToCall ModuleCall ElementSequence RepeatStructures DecisionStructures ElseIf Pattern
%type <rec> MatchStructures MaybeType StructDecl Attributes EnumDecl Variants Type TypeCollection Compare Literal
%type <rec> Decls 
%start Program 

%%
    Program:  Decls  { p("PROGRAM Detected");
					   fprintf(yyout,"%s", $1->code);} 
           ;
	Decls: SubProgram Decls{
							char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));}
		 | Assignment Decls{char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));}
		 | StructDecl Decls{char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));}
		 | EnumDecl Decls{char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));}	
		 | Main {
				$$=CreateRecord($1->code);
		 }
		 ;
	
	SubProgram: FUNCTION ID '(' Params ')' ARROW Type Scope { p("REGULAR FUNCTION");
															char* temp[]={$7->code," ",$2,"(",$4->code,")",$8->code};
															$$=CreateRecord(cat(temp,7));}
			  | PURE FUNCTION ID '(' Params ')' ARROW Type Scope { p("PURE FUNCTION");
			  													   char* temp[]={$8->code," ",$3,"(",$5->code,")",$9->code};
																   $$=CreateRecord(cat(temp,7));}
			  | PROCEDURE ID '(' Params ')' Scope { p("PROCEDURE");
			  										char* temp[]={"void"," ",$2,"(",$4->code,")",$6->code};
													$$=CreateRecord(cat(temp,7));}
			  ;

	Main: FUNCTION MAIN '(' Params ')' ARROW Type Scope { char* temp[]={"int main()", $8->code};
														  $$=CreateRecord(cat(temp,2));}
		;

	Params: VarTypedList {$$=CreateRecord($1->code);}
		  | { np("No PARAMS"); $$=CreateRecord("");}
		  ;

	VarTypedList: VarTyped ',' VarTypedList { char* temp[]={$1->code,",",$3->code};
											  $$=CreateRecord(cat(temp,3));
											}
				| VarTyped {$$=CreateRecord($1->code);}
				;

	VarTyped: ID ':' Type { np("PARAMS");
							char* temp[]={$3->code," ",$1};
							$$=CreateRecord(cat(temp,3)); }
			;

	Scope: '{' '}' { $$=CreateRecord("{}"); }
		 | '{' Statements '}' { np("SCOPE");
		 						char* temp[]={"{",$2->code,"}"};
								$$=CreateRecord(cat(temp,3)); }
		 ;

	Statements: Statement Statements {char* temp[]={$1->code,"\n",$2->code};
									  $$=CreateRecord(cat(temp,3));}
			  | Statement {$$=CreateRecord($1->code);}
			  ;
	
	Statement: Assignment {$$=CreateRecord($1->code);}
             | Attribution {$$=CreateRecord($1->code);}
             | StructDecl { p("STRUCT Detected"); }
			 | SubprogramCall ';'{char* temp[]={$1->code,";"};
								  $$=CreateRecord(cat(temp,2));}
             | ModuleCall ';' {}
			 | Return { np("RETURN");$$=CreateRecord($1->code); }
			 | Scope {$$=CreateRecord($1->code);}
			 | RepeatStructures {$$=CreateRecord($1->code);}
			 | DecisionStructures {$$=CreateRecord($1->code);}
			 | CONTINUE ';' {$$=CreateRecord("break");}
			 | BREAK ';' {$$=CreateRecord("continue");}
             | Print ';' {}
			 ;

	Return: RETURN ';' {$$=CreateRecord("return;");}
	      | RETURN Expression ';' {char* temp[]={"return",$2->code,";"};
								  $$=CreateRecord(cat(temp,3));}
		  ;

	Assignment: LET VarTyped '=' Expression ';' { p("NON-MUTABLE ASSIGNMENT");
												  char* temp[]={"const ",$2->code,"=",$4->code,";"};
												  $$=CreateRecord(cat(temp,5));}
			  | CONST VarTyped '=' Expression ';' { p("CONSTANT ASSIGNMENT"); }
			  | LET MUTABLE VarTyped '=' Expression ';' { p("MUTABLE ASSIGNMENT"); 
			  											  char* temp[]={$3->code,"=",$5->code,";"};
														  $$=CreateRecord(cat(temp,4));}
              | LET STRUCT ID '=' ID '{' ElementSequence '}' ';' {} // Rever: ElementSequence Mesmo?
              | LET MUTABLE STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
			  ;

    Attribution: ID '=' Expression ';' { p("ATTRIBUTION");
										 char* temp[]={$1,"=",$3->code,";"};
										 $$=CreateRecord(cat(temp,4)); }
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

	Expression: Expression OR AuxExp1 {char* temp[]={$1->code,"||",$3->code};
									   $$=CreateRecord(cat(temp,3));}
		      | AuxExp1 {$$=CreateRecord($1->code);}
			  ;

	AuxExp1: AuxExp1 AND AuxExp2 {char* temp[]={$1->code,"&&",$3->code};
								  $$=CreateRecord(cat(temp,3));}
		   | AuxExp2 {$$=CreateRecord($1->code);}
		   ;
	
	AuxExp2: AuxExp2 '=' AuxExp3 {char* temp[]={$1->code,"==",$3->code};
								  $$=CreateRecord(cat(temp,3));}
           | AuxExp2 NOT_EQUAL AuxExp3{char* temp[]={$1->code,"!=",$3->code};
									   $$=CreateRecord(cat(temp,3));}
	       | AuxExp3{$$=CreateRecord($1->code);}
		   ;
	
	AuxExp3: AuxExp3 Compare AuxExp4{char* temp[]={$1->code,$2->code,$3->code};
									   $$=CreateRecord(cat(temp,3));}
		   | AuxExp4{$$=CreateRecord($1->code);}
		   ;
	
	AuxExp4: AuxExp4 '+' AuxExp5{char* temp[]={$1->code,"+",$3->code};
									   $$=CreateRecord(cat(temp,3));}
	       | AuxExp4 '-' AuxExp5{char* temp[]={$1->code,"-",$3->code};
									   $$=CreateRecord(cat(temp,3));}
		   | AuxExp5{$$=CreateRecord($1->code);}
		   ;
	
	AuxExp5: AuxExp5 '*' AuxExp6{char* temp[]={$1->code,"*",$3->code};
									   $$=CreateRecord(cat(temp,3));}
		   | AuxExp5 '/' AuxExp6{char* temp[]={$1->code,"/",$3->code};
									   $$=CreateRecord(cat(temp,3));}
		   | AuxExp5 '%' AuxExp6{char* temp[]={$1->code,"\%",$3->code};
									   $$=CreateRecord(cat(temp,3));}
		   | AuxExp6{$$=CreateRecord($1->code);}
		   ;
	
	AuxExp6: AuxExp7 '^' AuxExp6{char* temp[]={$1->code,"^",$3->code};
									   $$=CreateRecord(cat(temp,3));}
		   | AuxExp7{$$=CreateRecord($1->code);}
		   ;
	
	AuxExp7: NOT AuxExp7{char* temp[]={"!",$2->code};
									   $$=CreateRecord(cat(temp,2));}
		   | AuxExp8{$$=CreateRecord($1->code);}
		   ;
	
	AuxExp8: IDs {$$=CreateRecord($1->code);}
		   | Literal {$$=CreateRecord($1->code);}
		   | '(' Expression ')' {$$=CreateRecord($2->code);}
		   | Array {}
		   | '&' ID {} // TALVEZ IDs?
           | '&' ID '[' INTERVAL ID ']' {} // TALVEZ IDs?
           | '&' ID '[' ID INTERVAL ']' {}// TALVEZ IDs?
           | '&' ID '[' INTERVAL VALUE_INT ']' {}
           | '&' ID '[' VALUE_INT INTERVAL ']' {}
           | Print {}
           | ModuleCall {}
		   | SubprogramCall {$$=CreateRecord($1->code);}
           | List {}
		   ;

    IDs: ID '.' IDs {char* temp[]={$1,".",$3->code};
					 $$=CreateRecord(cat(temp,3));}
       | ID {$$=CreateRecord($1);}
       ;
		   
    List: '[' ']' {}
        | '[' ElementSequence ']' {}
        ;

    Print: PRINT '(' VALUE_STRING ',' Expression ')' {}
         | PRINT '(' VALUE_STRING ')' {}
         ;

	SubprogramCall: ID MaybeParams '.' SubprogramCall {}
                  | ID '.' SubprogramCall {} // foo.poo()
				  | ID MaybeParams {char* temp[]={$1,$2->code};
									$$=CreateRecord(cat(temp,2));}
				  ;

    MaybeParams: '(' ')' {$$=CreateRecord("()");}
               | '(' ParamsToCall ')' {char* temp[]={"(",$2->code,")"};
									   $$=CreateRecord(cat(temp,3));}
               ;

	ParamsToCall: Expression ',' ParamsToCall{char* temp[]={$1->code,",",$3->code};
									   		  $$=CreateRecord(cat(temp,3));}
				| Expression {$$=CreateRecord($1->code);}
				;
    
    ModuleCall: ID ':' ':' SubprogramCall  {}
              | TypeCollection ':' ':' SubprogramCall {}
              ;

	ElementSequence: Expression ',' ElementSequence{}
				   | Expression {}
				   ;
	
	RepeatStructures:  WHILE '(' Expression ')' Scope{
														char* tempw[]={"WHILE_",whileCount()};
														char* whileLabel=cat(tempw,2);
														char* temp[]={"{",whileLabel,":if(",$3->code,"){",$5->code,"goto ",whileLabel,"}}"};
														$$=CreateRecord(cat(temp,9));}
					|  FOR '(' ID IN Expression INTERVAL Expression ')' Scope{
																			char* tempf[]={"FOR_",forCount()};
																			char* forLabel=cat(tempf,2);
																			char* temp[]={"{ int",$3,"=",$5->code,";",forLabel,":if(",$3,"!=",$7->code,"){",$9->code,"if(",$3,"<",$7->code,"){",$3,"++;}","else{",$3,"--;} goto ",forLabel,"}}"};
																			$$=CreateRecord(cat(temp,24));}
					|  FOR '(' ID IN Expression ')' Scope{}
					|  LOOP Scope {}
					;
					
	DecisionStructures: IF '(' Expression ')' Scope {char* temp[]={"if(",$3->code,")",$5->code};
									   		  		$$=CreateRecord(cat(temp,4));}
					  | IF '(' Expression ')' Scope ELSE Scope {char* temp[]={"if(",$3->code,")",$5->code,"else",$7->code};
									   		  					$$=CreateRecord(cat(temp,6));}
					  | IF '(' Expression ')' Scope ElseIf {char* temp[]={"if(",$3->code,")",$5->code,$6->code};
									   		  				$$=CreateRecord(cat(temp,5));}
					  | MATCH '(' Pattern ')' '{' MatchStructures '}' {}
					  ;

	ElseIf: ELSE IF '(' Expression ')' Scope ElseIf {char* temp[]={"else{ if(",$4->code,")",$6->code,$7->code,"}"};
									   		  $$=CreateRecord(cat(temp,6));}
		  | ELSE IF '(' Expression ')' Scope ELSE Scope{char* temp[]={"else{ if(",$4->code,")",$6->code,"else",$8->code,"}"};
		  												$$=CreateRecord(cat(temp,7));}
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


    TypeCollection: TYPE_S_INT8 {}
				  | TYPE_S_INT32 {}
				  | TYPE_S_SIZE {}
				  | TYPE_S_INT16 {}
				  | TYPE_U_INT8 {}
				  | TYPE_U_INT16 {}
				  | TYPE_U_INT32 {}
				  | TYPE_U_SIZE {}
				  | TYPE_FLOAT32 {}
				  | TYPE_FLOAT64 {}
				  | TYPE_CHAR {}
				  | TYPE_STRING {}
				  | TYPE_VEC {}
				  | TYPE_SET {}
				  | TYPE_MATRIX {}
				  | TYPE_RESULT {np("RESULT");}
				  | TYPE_OPTION {}
				  ;

	Type: TYPE_BOOL {np("BOOL"); $$=CreateRecord("bool");}
        | TYPE_S_INT8 {np("S_INT8");}
        | TYPE_S_INT32  {np("S_INT32");$$=CreateRecord("int");}
        | TYPE_S_SIZE  {np("S_SIZE");}
        | TYPE_S_INT16  {np("S_INT16");$$=CreateRecord("short int");}
        | TYPE_U_INT8  {np("U_INT8");}
        | TYPE_U_INT16  {np("U_INT16");$$=CreateRecord("unsigned short int");}
        | TYPE_U_INT32  {np("U_INT32");$$=CreateRecord("unsigned int");}
        | TYPE_U_SIZE  {np("U_SIZE");}
        | TYPE_FLOAT32 {np("FLOAT32");$$=CreateRecord("float");}
        | TYPE_FLOAT64  {np("FLOAT64");$$=CreateRecord("double");}
        | TYPE_CHAR  {np("CHAR");$$=CreateRecord("char");}
        | TYPE_STRING  {np("STRING");$$=CreateRecord("char*");}
        | TYPE_VEC '<' Type '>' {np("VEC");}
        | TYPE_SET '<' Type '>' {np("SET");}
        | TYPE_MATRIX '<' Type ';' VALUE_INT ';' VALUE_INT '>' { np("MATRIX"); }
        | TYPE_RESULT '<' Type ',' Type '>' { np("RESULT W/ Types"); }
        | TYPE_OPTION '<' Type ',' Type '>' { np("OPTION"); }
        | '[' Type ';' VALUE_INT ']' { np("ARRAY"); }
        | '&' '[' Type ']' { np("REFERENCE ARRAY"); }
        | '&' Type { np("REFERENCE"); }
        | '('')' { np("UNIT TYPE"); }
		| ID {}
        ;

	Compare: '<' {$$=CreateRecord("<");}
		   | '>' {$$=CreateRecord(">");}
		   | LESS_EQUAL {$$=CreateRecord("<=");}
		   | GREATER_EQUAL {$$=CreateRecord(">=");}
		   | EQUAL {$$=CreateRecord("==");}
		   ;

	Literal: VALUE_INT {$$=CreateRecord($1);}
           | VALUE_FLOAT {$$=CreateRecord($1);}
           | VALUE_BOOL {$$=CreateRecord($1);}
           | VALUE_CHAR {$$=CreateRecord($1);}
           | VALUE_STRING {$$=CreateRecord($1);}
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


int main (int argc, char ** argv) {
 	int codigo;

    if (argc != 3) {
       printf("Usage: $./compiler input.txt output.txt\nClosing application...\n");
       exit(0);
    }
    
    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");

    codigo = yyparse();

    fclose(yyin);
    fclose(yyout);

	return codigo;
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
char* cat(char** strings, int qnt){
	int tam=0;
	for(int i=0;i<qnt;i++){
		if(strings[i]!=NULL){
			tam+=strlen(strings[i]);
		}
	}
	tam++;
	char * output= malloc(tam*sizeof(char));
	if (!output){
		exit(0);
  	}
	output[0]='\0';
	for(int i=0;i<qnt;i++){
		strcat(output,strings[i]);
	}
	return output;
}
char* forCount(){
	static int forCounts=0;
	char* text=malloc(sizeof(char)*12);
	snprintf(text,sizeof(text),"%d",forCounts++);
	return text;
}
char* whileCount(){
	static int whileCounts=0;
	char* text=malloc(sizeof(char)*12);
	snprintf(text,sizeof(text),"%d",whileCounts++);
	return text;
}