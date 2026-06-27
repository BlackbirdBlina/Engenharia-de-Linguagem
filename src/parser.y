%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lib/record.h"
#include "lib/linked_list.h"
#include "lib/symbol_table.h"
#include "lib/scope_stack.h"
#include "lib/parser/semantics.h"
#include "lib/parser/grammar/assignments.c"
#include "lib/parser/grammar/attribution.c"
#include "lib/parser/grammar/print.c"
#include "lib/parser/grammar/input.c"
#include "lib/parser/grammar/operator.c"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;

%}
%union {
	int    iValue; 	
	float  fValue; 	
	char   cValue; 	
	ID_t idValue;
	VALUE_STRING_t sValue;
	struct Record * rec;  
	};

%token CONST MUTABLE LET ';' OR AND NOT_EQUAL '=' '<' '>' LESS_EQUAL GREATER_EQUAL NOT '+' '^' '-' '*' '/' '%' '(' ')' '[' ']' '{' '}' '.' ',' ':' PROCEDURE FUNCTION PURE FOR LOOP CONTINUE BREAK IF IN ELSE RETURN '&'
%token EQUAL INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token PRINT TOPRINT
%token <sValue> OK ERROR SOME NONE VALUE_BOOL VALUE_CHAR VALUE_STRING VALUE_FLOAT VALUE_INT
%token <idValue> ID
%token TYPE_BOOL TYPE_S_INT64 TYPE_S_INT32 TYPE_S_SIZE TYPE_S_INT16 TYPE_U_INT64 TYPE_U_INT16 TYPE_U_INT32 TYPE_U_SIZE TYPE_FLOAT32 TYPE_FLOAT64 TYPE_CHAR TYPE_STRING TYPE_VEC TYPE_SET TYPE_MATRIX TYPE_RESULT TYPE_OPTION
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN INPUT TOINPUT

%type <rec> SubProgram Main Params VarTyped VarTypedList Scope Statements Statement Return Assignment Attribution IncrOrDecr
%type <rec> Array ArrayAccesses Expression AuxExp1 AuxExp2 AuxExp3 AuxExp4 AuxExp5 AuxExp6 AuxExp7 AuxExp8 IDs List Print Input
%type <rec> SubprogramCall MaybeParams ParamsToCall ElementSequence RepeatStructures DecisionStructures ElseIf Pattern
%type <rec> MatchStructures MaybeType StructDecl Attributes EnumDecl Variants Type Compare Literal
%type <rec> Decls ThingsToPrint ThingsToInput
%start Program 

%%
    Program:
        Decls  {
            fprintf(yyout,"#include<stdio.h>\n%s", $1->code);
        }
        ;
	Decls: SubProgram Decls{
							char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));
                            }
		 | Assignment Decls{char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));
                            }
		 | StructDecl Decls{char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));
                            }
		 | EnumDecl Decls{char* temp[]={$1->code,"\n",$2->code};
							$$=CreateRecord(cat(temp,3));
                            }	
		 | Main {
				$$=CreateRecord($1->code);
		 }
		 ;
	SubProgram: FUNCTION ID '(' Params ')' ARROW Type Scope {
															char* temp[]={$7->code," ",$2,"(",$4->code,")",$8->code};
															$$=CreateRecordFunc(cat(temp,7),$4->paramsTypes,$7->type);
                                                            store_func_in_funcTable($2,$4->paramsTypes,$7->type);

                                                            }
			  | PURE FUNCTION ID '(' Params ')' ARROW Type Scope {
			  													   char* temp[]={$8->code," ",$3,"(",$5->code,")",$9->code};
																   $$=CreateRecordFunc(cat(temp,7),$5->paramsTypes,$8->type);
                                                                   store_func_in_funcTable($3,$5->paramsTypes,$8->type);
                                                                   }
			  | PROCEDURE ID '(' Params ')' Scope {
			  										char* temp[]={"void"," ",$2,"(",$4->code,")",$6->code};
													$$=CreateRecordFunc(cat(temp,7),$4->paramsTypes,"");
                                                    store_func_in_funcTable($2,$4->paramsTypes,"");
                                                    }
			  ;
	Main: FUNCTION MAIN '(' Params ')' ARROW Type Scope { char* temp[]={"int main() ", $8->code};
														  $$=CreateRecord(cat(temp,2));
                                                          }
		;
	Params: VarTypedList {
        $$=CreateRecordFuncParams($1->code,$1->paramsTypes);
    }
          | {LinkedList* paramsTypes=CreateLinkedList();$$=CreateRecordFuncParams("",paramsTypes);}
        ;
	VarTypedList: VarTyped ',' VarTypedList { 
                                              char* temp[]={$1->code,",",$3->code};  
                                              PushElement($3->paramsTypes,CreateNodeInfo($1->type));
											  $$=CreateRecordFuncParams(cat(temp,3),$3->paramsTypes);
											}
				| VarTyped {
                            LinkedList* paramsTypes=CreateLinkedList();
                            PushElement(paramsTypes,CreateNodeInfo($1->type));
                            $$=CreateRecordFuncParams($1->code,paramsTypes);
                }
				;
	VarTyped: ID ':' Type {
							char* temp[]={$3->code," ",$1};
							$$=CreateRecordVarTyped(cat(temp,3),$3->type,$1); }
			;
	Scope: '{' { PushScope(scopeStack,GenerateScope()); } '}' { $$=CreateRecord("{}"); PopScope(scopeStack); }
		 | '{' { PushScope(scopeStack,GenerateScope()); } Statements '}' {
		 						char* temp[]={"{\n\t",$3->code,"\n}"};
								$$=CreateRecord(cat(temp,3));
								PopScope(scopeStack);
                                }
		 ;
	Statements: Statement Statements { char* temp[]={$1->code,"\n",$2->code};
									  $$=CreateRecord(cat(temp,3));
                                      }
			  | Statement { $$=CreateRecord($1->code); }
			  ;
	Statement: Assignment {
    $$=CreateRecord($1->code);
    }
             | Attribution {
             $$=CreateRecord($1->code);
             }
             | StructDecl {}
			 | SubprogramCall ';'{char* temp[]={$1->code,";"};
								$$=CreateRecord(cat(temp,2));
                                }
			 | Return {
             $$=CreateRecord($1->code); }
			 | Scope {
             $$=CreateRecord($1->code);
             }
			 | RepeatStructures {
             $$=CreateRecord($1->code);
             }
			 | DecisionStructures {
             $$=CreateRecord($1->code);
             }
			 | CONTINUE ';' {
             $$=CreateRecord("break");
             }
			 | BREAK ';' {
             $$=CreateRecord("continue");
             }
             | Print ';' {
             $$=CreateRecord($1->code);
             }
             |Input{
             $$=CreateRecord($1->code);
             }
			 ;
	Return: RETURN ';' { $$=CreateRecord("return;"); }
	      | RETURN Expression ';' {char* temp[]={"return ",$2->code,";"};
								  $$=CreateRecord(cat(temp,3));
                                  }
		  ;
	Assignment: LET VarTyped '=' Expression ';'                                           { let__equal(&$$, $2, $4, STAT); }
              | CONST VarTyped '=' Expression ';'                                         { let__equal(&$$, $2, $4, CONSTANT); }
              | LET MUTABLE VarTyped '=' Expression ';'                                   { let__equal(&$$, $3, $5, MUT); }
              | LET STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
              | LET MUTABLE STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
;
Attribution: ID '=' Expression ';'                                                        { attribute_id_expression(&$$, $1, $3); }
           | ID '.' ID '=' Expression ';'                                                 { /* TODO: Aqui n pode ser id.id.id.id não? */ }
           | ID PLUS_ATTRIBUTION Expression ';'                                           {  }
           | ID MINUS_ATTRIBUTION Expression ';' {  }
           | ID MULTIPLY_ATTRIBUTION Expression ';' {  }
           | ID DIVIDE_ATTRIBUTION Expression ';' {  }
           | Array '=' Expression ';' { }
           | IncrOrDecr ';' {}
           ;
    IncrOrDecr: ID INCREMENT {}
			  | ID DECREMENT {}
			  | INCREMENT ID {}
			  | DECREMENT ID {}
              ;
	Array: ID ArrayAccesses{}
		 ;
	ArrayAccesses: '[' Expression ']' ArrayAccesses{}
		         | '[' Expression ']' {}
		         ;
	Expression: Expression OR AuxExp1 {handle_operands_types(&$$,$1,$3,"||",bool_);}
                | AuxExp1 {$$=CreateRecordType($1->code,$1->type);}
                ;

	AuxExp1: AuxExp1 AND AuxExp2 {handle_operands_types(&$$,$1,$3,"&&",bool_);}
		   | AuxExp2 {$$=CreateRecordType($1->code,$1->type);}
		   ;
	
	AuxExp2: AuxExp2 NOT_EQUAL AuxExp3{handle_operands_types(&$$,$1,$3,"!=",literal_int);}
	       | AuxExp3{$$=CreateRecordType($1->code,$1->type);}
		   ;
	
	AuxExp3: AuxExp3 Compare AuxExp4{handle_operands_types(&$$,$1,$3,$2->code,literal_int);}
		   | AuxExp4{$$=CreateRecordType($1->code,$1->type);}
		   ;
	
	AuxExp4: AuxExp4 '+' AuxExp5 {handle_operands_types(&$$,$1,$3,"+",literal_int);}
    | AuxExp4 '-' AuxExp5{handle_operands_types(&$$,$1,$3,"-",literal_int);}
    | AuxExp5{$$=CreateRecordType($1->code,$1->type);}
    ;
	
	AuxExp5: AuxExp5 '*' AuxExp6{handle_operands_types(&$$,$1,$3,"*",literal_int);}
	| AuxExp5 '/' AuxExp6{handle_operands_types(&$$,$1,$3,"/",literal_int);}
	| AuxExp5 '%' AuxExp6{handle_operands_types(&$$,$1,$3,"\%",literal_int);}
    | AuxExp6{$$=CreateRecordType($1->code,$1->type);}
    ;

	AuxExp6: AuxExp7 '^' AuxExp6{handle_operands_types(&$$,$1,$3,"^",literal_int);}
    | AuxExp7{$$=CreateRecordType($1->code,$1->type);}
    ;

	AuxExp7: NOT AuxExp7{
        char* temp[]={"!",$2->code};
        $$=CreateRecordType(cat(temp,2),$2->type);
    }
    | AuxExp8{$$=CreateRecordType($1->code,$1->type);}
    ;

	AuxExp8: IDs {$$=CreateRecordType($1->code,$1->type);}
		   | Literal {$$=CreateRecordType($1->code,$1->type);}
		   | '(' Expression ')' {char* temp[]={"(",$2->code,")"};
								$$=CreateRecordType(cat(temp,3),$2->type);
                                }
		   | Array {}
		   | '&' ID {} // TALVEZ IDs?
           | '&' ID '[' INTERVAL ID ']' {} // TALVEZ IDs?
           | '&' ID '[' ID INTERVAL ']' {}// TALVEZ IDs?
           | '&' ID '[' INTERVAL VALUE_INT ']' {}
           | '&' ID '[' VALUE_INT INTERVAL ']' {}
           | Print {}
		   | SubprogramCall {$$=CreateRecordType($1->code,$1->type);}
           | List {}
		   ;

    IDs:
        ID '.' IDs {
            char* temp[] = {$1, ".", $3->code};
            $$ = CreateRecord(cat(temp, 3));
        }
        | ID {
            SymbolNode* id = lookup_symbol(varTable, $1);
	   		checkVarScope($1);
			$$=CreateRecordType($1,getVarType($1));
        }
        ;
		   
    List: '[' ']' {}
        | '[' ElementSequence ']' {}
        ;

    Print: PRINT TOPRINT ThingsToPrint                                  { PRINT_toPrint(&$$, $3); };
    ThingsToPrint: ID TOPRINT ThingsToPrint                             { ID_toPrint(&$$, $1, $3); }
                 | VALUE_STRING TOPRINT ThingsToPrint                   { VALUE_STRING_toPrint(&$$, $1, $3); }
                 | ID                                                   { print_ID(&$$, $1); }
                 | VALUE_STRING                                         { print_VALUE_STRING(&$$, $1); }
                 ;

    Input: INPUT TOINPUT ThingsToInput ';'{INPUT_toInput(&$$,$3);}
    ThingsToInput: ID TOINPUT ThingsToInput{ID_toInput(&$$,$1,$3);}
                |  ID {input_ID(&$$,$1);}
                ;

	SubprogramCall: ID MaybeParams                                      { char* temp[]={$1,$2->code};
                                                                          $$=CreateRecordType(cat(temp,2),check_params_types_on_subprogram_call($1,$2->paramsTypes)); }
				  ;

    MaybeParams: '(' ')'                                                {
                                                                         LinkedList* paramsTypes=CreateLinkedList(); 
                                                                         $$=CreateRecordFuncParams("()",paramsTypes); }
               | '(' ParamsToCall ')'                                   { char* temp[]={"(",$2->code,")"};
                                                                          $$=CreateRecordFuncParams(cat(temp,3),$2->paramsTypes); }
               ;

	ParamsToCall: Expression ',' ParamsToCall                           { char* temp[]={$1->code,",",$3->code};
                                                                          PushElement($3->paramsTypes,CreateNodeInfo($1->type));
                                                                          $$=CreateRecordFuncParams(cat(temp,3),$3->paramsTypes); }
				| Expression                                            { 
                                                                         LinkedList* paramsTypes=CreateLinkedList();
                                                                         PushElement(paramsTypes,CreateNodeInfo($1->type));
                                                                         $$=CreateRecordFuncParams($1->code,paramsTypes); }
				;
    
	ElementSequence: Expression ',' ElementSequence{}
				   | Expression {}
				   ;
	
	RepeatStructures:
        WHILE '(' Expression ')' Scope {
						char* counter = whileCount();
						char* tempw[] = {"WHILE_", counter}; // Guarda em tempw a string WHILE_ e um número que é um contador para facilitar os saltos do goto
						char* tempendw[] = {"ENDWHILE_", counter};
						char* tempWhileScop[] = {"WHILESCOPE_", counter};
						char* whileLabel = cat(tempw, 2); // Coloca na var whileLabel a concatenação entre a label "WHILE_" e o seu valor correspondente para diferenciar os "whiles" do programa
						char* endWhile = cat(tempendw, 2);
						char* whileScope = cat(tempWhileScop, 2);
						char* temp[] = {
							"\n", whileLabel, ":\nif(", $3->code, ")", " goto ", whileScope, ";\n", 
							"goto ", endWhile, ";\n", 
							whileScope, ":\n", $5->code, " ",
							"\ngoto ", whileLabel,";\n",
							endWhile, ":"
						}; // Guarda em temp as informações da estrutura do while em C simplificado
						$$ = CreateRecord(cat(temp, 20)); // Realiza o registro da estrutura que deve ser apresentada em C
                    }
					|  FOR '(' ID IN Expression INTERVAL Expression ')' Scope{
																			char* tempf[]={"FOR_",forCount()};
																			char* forLabel=cat(tempf,2);
																			char* temp[]={"{ int",$3,"=",$5->code,";",forLabel,":if(",$3,"!=",$7->code,"){",$9->code,"if(",$3,"<",$7->code,"){",$3,"++;}","else{",$3,"--;} goto ",forLabel,"}}"};
																			$$=CreateRecord(cat(temp,24));
                                                                            }
					|  FOR '(' ID IN Expression ')' Scope{}
					|  LOOP Scope {}
					;
					
	DecisionStructures: IF '(' Expression ')' Scope {
						char* counter = ifCount();
						char* tempif[] = {"IF_SCOPE", counter};
						char* tempend[] = {"ENDIF_", counter};
						char* ifScope = cat(tempif, 2);
						char* endIf = cat(tempend, 2);
						char* temp[] = {
							"\nif", "(", $3->code, ")", " goto ", ifScope, ";\n", 
							"\ngoto ", endIf, ";\n", 
							ifScope, ":\n", $5->code
						};
						$$ = CreateRecord(cat(temp, 13));
                        }
					  | IF '(' Expression ')' Scope ELSE Scope {
						char* counter = ifCount();
						char* tempif[] = {"IF_", counter};
						char* tempend[] = {"ENDIF_", counter};
						char* tempelse[] = {"ELSE_", elseCount()};
						char* ifScope = cat(tempif, 2);
						char* endIf = cat(tempend, 2);
						char* elseScope = cat(tempelse, 2);
						char* temp[] = {
							"\nif", "(", $3->code, ")", " goto ", ifScope, ";\n", 
							"goto ", elseScope, ";\n", 
							ifScope, ":\n", $5->code, " ",
							"\ngoto ", endIf, ";\n\n",
							elseScope, ":\n", $7->code, "\n",
							endIf, ": "
						};
						$$ = CreateRecord(cat(temp, 23));
                        }
					  | IF '(' Expression ')' Scope ElseIf {char* temp[]={"if(",$3->code,")",$5->code,$6->code};
									   		  				$$=CreateRecord(cat(temp,5));
                                                            }
					  | MATCH '(' Pattern ')' '{' MatchStructures '}' {}
					  ;

	ElseIf: ELSE IF '(' Expression ')' Scope ElseIf {char* temp[]={"else{ if(",$4->code,")",$6->code,$7->code,"}"};
									   		  $$=CreateRecord(cat(temp,6));
                                              }
		  | ELSE IF '(' Expression ')' Scope ELSE Scope{char* temp[]={"else{ if(",$4->code,")",$6->code,"else",$8->code,"}"};
		  												$$=CreateRecord(cat(temp,7));
                                                        }
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


	Type: TYPE_BOOL { $$=CreateRecordType("bool",bool_);
    }
        | TYPE_S_INT16  {
        $$=CreateRecordType("short int",s_int16);
        }
        | TYPE_S_INT32  {
        $$=CreateRecordType("int",s_int32);
        }
        | TYPE_S_INT64 {
        $$=CreateRecordType("long long int",s_int64);
        }
        | TYPE_S_SIZE  {}
        | TYPE_U_INT16  {
        $$=CreateRecordType("unsigned short int",u_int16);
        }
        | TYPE_U_INT32  {
        $$=CreateRecordType("unsigned int",u_int32);
        }
        | TYPE_U_INT64  {
        $$=CreateRecordType("unsigned long long int",u_int64);
        }
        | TYPE_U_SIZE  {}
        | TYPE_FLOAT32 {
        $$=CreateRecordType("float",float32);
        }
        | TYPE_FLOAT64  {
        $$=CreateRecordType("double",float64);
        }
        | TYPE_CHAR  {
        $$=CreateRecordType("char",char_);
        }
        | TYPE_STRING  {
        $$=CreateRecordType("char*","string");
        }
        | TYPE_VEC '<' Type '>' {}
        | TYPE_SET '<' Type '>' {}
        | TYPE_MATRIX '<' Type ';' VALUE_INT ';' VALUE_INT '>' {}
        | TYPE_RESULT '<' Type ',' Type '>' {}
        | TYPE_OPTION '<' Type ',' Type '>' {}
        | '[' Type ';' VALUE_INT ']' {}
        | '&' '[' Type ']' {}
        | '&' Type {}
        | '('')' {}
		| ID {}
        ;

	Compare: '<' {
    $$=CreateRecord("<");
    }
		   | '>' {
           $$=CreateRecord(">");
           }
		   | LESS_EQUAL {
           $$=CreateRecord("<=");
           }
		   | GREATER_EQUAL {
           $$=CreateRecord(">=");
           }
		   | EQUAL {
           $$=CreateRecord("==");
           }
		   ;

	Literal: VALUE_INT {
    $$=CreateRecordType($1,literal_int);
    }
           | VALUE_FLOAT {
           $$=CreateRecordType($1,literal_float);
           }
           | VALUE_BOOL {
           $$=CreateRecordType($1,bool_);
           }
           | VALUE_CHAR {
           $$=CreateRecordType($1,char_);
           }
           | VALUE_STRING {
           $$=CreateRecord($1);
           }
           | OK '(' Expression ')' {}
           | ERROR '(' Expression ')' {}
           | SOME '(' Expression ')' {}
           | '(' ')' {}
           | NONE {}
           ;

%%

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}

int main (int argc, char ** argv) {
 	int codigo;
    if (argc != 3) {
       printf("Usage: $./compiler input.txt output.txt\nClosing application...\n");
       exit(0);
    }
	InitializeScopeStack();
	InitializeFuncTable();
	InitializeTypeTable();
    InitializeVarTable();
    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");
    codigo = yyparse();

    fclose(yyin);
    fclose(yyout);

    
	return codigo;
}
