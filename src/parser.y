%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lib/record.h"
#include "lib/symbol_table.h"
#include "lib/scope_stack.h"
#include "lib/parser/semantics.h"
#include "lib/parser/grammar/assignments.c"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;

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
%token TYPE_BOOL TYPE_S_INT64 TYPE_S_INT32 TYPE_S_SIZE TYPE_S_INT16 TYPE_U_INT64 TYPE_U_INT16 TYPE_U_INT32 TYPE_U_SIZE TYPE_FLOAT32 TYPE_FLOAT64 TYPE_CHAR TYPE_STRING TYPE_VEC TYPE_SET TYPE_MATRIX TYPE_RESULT TYPE_OPTION
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN

%type <rec> SubProgram Main Params VarTyped VarTypedList Scope Statements Statement Return Assignment Attribution IncrOrDecr
%type <rec> Array ArrayAccesses Expression AuxExp1 AuxExp2 AuxExp3 AuxExp4 AuxExp5 AuxExp6 AuxExp7 AuxExp8 IDs List Print
%type <rec> SubprogramCall MaybeParams ParamsToCall ModuleCall ElementSequence RepeatStructures DecisionStructures ElseIf Pattern
%type <rec> MatchStructures MaybeType StructDecl Attributes EnumDecl Variants Type TypeCollection Compare Literal
%type <rec> Decls 
%start Program 

%%
    Program:
        Decls  {
            fprintf(yyout,"%s", $1->code);
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
															$$=CreateRecord(cat(temp,7));
                                                            }
			  | PURE FUNCTION ID '(' Params ')' ARROW Type Scope {
			  													   char* temp[]={$8->code," ",$3,"(",$5->code,")",$9->code};
																   $$=CreateRecord(cat(temp,7));
                                                                   }
			  | PROCEDURE ID '(' Params ')' Scope {
			  										char* temp[]={"void"," ",$2,"(",$4->code,")",$6->code};
													$$=CreateRecord(cat(temp,7));
                                                    }
			  ;
	Main: FUNCTION MAIN '(' Params ')' ARROW Type Scope { char* temp[]={"int main()", $8->code};
														  $$=CreateRecord(cat(temp,2));
                                                          }
		;
	Params: VarTypedList {
    $$=CreateRecord($1->code);
    }
		  | {
          $$=CreateRecord("");
          }
		  ;
	VarTypedList: VarTyped ',' VarTypedList { char* temp[]={$1->code,",",$3->code};
											  $$=CreateRecord(cat(temp,3));
											}
				| VarTyped {
                $$=CreateRecord($1->code);
                }
				;
	VarTyped: ID ':' Type {
							char* temp[]={$3->code," ",$1};
							$$=CreateRecordVarTyped(cat(temp,3),$3->type,$1); }
			;
	Scope: '{'{PushScope(scopeStack,GenerateScope());
    } '}' { $$=CreateRecord("{}"); PopScope(scopeStack); }
		 | '{' {PushScope(scopeStack,GenerateScope());
         } Statements '}' {
		 						char* temp[]={"{",$3->code,"}"};
								$$=CreateRecord(cat(temp,3));
								PopScope(scopeStack);
                                }
		 ;
	Statements: Statement Statements {char* temp[]={$1->code,"\n",$2->code};
									  $$=CreateRecord(cat(temp,3));
                                      }
			  | Statement {
              $$=CreateRecord($1->code);
              }
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
             | ModuleCall ';' {}
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
             | Print ';' {}
			 ;
	Return: RETURN ';' {
    $$=CreateRecord("return;");
    }
	      | RETURN Expression ';' {char* temp[]={"return",$2->code,";"};
								  $$=CreateRecord(cat(temp,3));
                                  }
		  ;
	Assignment:
        LET VarTyped '=' Expression ';' {
            char* temp[] = { "const ", $2->code, "=", $4->code, ";" };
            $$ = CreateRecord(cat(temp,5));
            check_let_equal($$,$2,$4);

            insert_symbol(varTable,$2->id,alloc_type_var($2->type,scopeStack->top->scopeName));
        }
        | CONST VarTyped '=' Expression ';' {}
        | LET MUTABLE VarTyped '=' Expression ';' {
            char* temp[]={$3->code,"=",$5->code,";"};
            $$=CreateRecord(cat(temp,4));
        }
        | LET STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
        | LET MUTABLE STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
;
Attribution: ID '=' Expression ';' {
char* temp[]={$1,"=",$3->code,";"};
checkVarScope($1);
char* tempVarExpTypeCmp=checkTypeCompatibility(getVarType($1),$3->type);
if(tempVarExpTypeCmp){
            if(strcmp(tempVarExpTypeCmp,getVarType($1))!=0){
                        printf("ERROR: variável %s espera receber algo do tipo %s",$1,getVarType($1));
                        exit(1);
                    }
                }
                else{
                    printf("ERROR: variável \"%s\" espera receber algo do tipo \"%s\"",$1,getVarType($1));
                    exit(1);
                }
                $$=CreateRecord(cat(temp,4));
                }
               | ID '.' ID '=' Expression ';'{ }
			   | ID PLUS_ATTRIBUTION Expression ';' { }
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
	Expression: Expression OR AuxExp1 {char* temp[]={$1->code,"||",$3->code};
										if(!checkTypeCompatibility(bool_,$1->type) || !checkTypeCompatibility(bool_,$3->type)){
											printf("Tipos incompatíveis com o operador '||' ");
											exit(0);
										}	
									   $$=CreateRecordType(cat(temp,3),checkTypeCompatibility($1->type,$3->type));
                                       }
		      | AuxExp1 {
              $$=CreateRecordType($1->code,$1->type);
              }
			  ;

	AuxExp1: AuxExp1 AND AuxExp2 {char* temp[]={$1->code,"&&",$3->code};
									if(!checkTypeCompatibility(bool_,$1->type) || !checkTypeCompatibility(bool_,$3->type)){
											printf("Tipos incompatíveis com o operador '&&' ");
											exit(0);
									}	
								  $$=CreateRecordType(cat(temp,3),checkTypeCompatibility($1->type,$3->type));
                                  }
		   | AuxExp2 {
           $$=CreateRecordType($1->code,$1->type);
           }
		   ;
	
	AuxExp2: AuxExp2 NOT_EQUAL AuxExp3{char* temp[]={$1->code,"!=",$3->code};
		   								if(!checkTypeCompatibility(bool_,$1->type) || !checkTypeCompatibility(bool_,$3->type)){
											printf("Tipos incompatíveis com o operador '!=' ");
											exit(0);
										}
									   $$=CreateRecordType(cat(temp,3),checkTypeCompatibility($1->type,$3->type));
                                       }
	       | AuxExp3{
           $$=CreateRecordType($1->code,$1->type);
           }
		   ;
	
	AuxExp3: AuxExp3 Compare AuxExp4{char* temp[]={$1->code,$2->code,$3->code};
										if(!checkTypeCompatibility(bool_,$1->type) || !checkTypeCompatibility(bool_,$3->type)){
											printf("Tipos incompatíveis com o operador '%s' ",$2->code);
											exit(0);
										}
									   $$=CreateRecordType(cat(temp,3),checkTypeCompatibility($1->type,$3->type));
                                       }
		   | AuxExp4{
           $$=CreateRecordType($1->code,$1->type);
           }
		   ;
	
	AuxExp4: AuxExp4 '+' AuxExp5 {
        char* temp[]={$1->code,"+",$3->code};

        if (!checkTypeCompatibility(literal_int,$1->type) || !checkTypeCompatibility(literal_int,$3->type)) {
            printf("Tipos incompatíveis com o operador '+' ");
            exit(0);
        }

        char * temp2 = checkTypeCompatibility($1->type,$3->type);
        if (temp2) {
            $$=CreateRecordType(cat(temp,3),temp2);
        }
        else {
            printf("ERROR: %s and %s are not interchangeable types\n", $1->type, $3->type);
            exit(1);
        }

        $$ = CreateRecordType(cat(temp, 3), checkTypeCompatibility($1->type, $3->type));

        }
	       | AuxExp4 '-' AuxExp5{char* temp[]={$1->code,"-",$3->code};
		   								if(!checkTypeCompatibility(literal_int,$1->type) || !checkTypeCompatibility(literal_int,$3->type)){
											printf("Tipos incompatíveis com o operador '-' ");
											exit(0);
										}
        char * temp2 = checkTypeCompatibility($1->type,$3->type);
        if (temp2) {
            $$=CreateRecordType(cat(temp,3),temp2);
        }
        else {
            printf("ERROR: %s and %s are not interchangeable types\n", $1->type, $3->type);
            exit(1);
        }
           }
		   | AuxExp5{
           $$=CreateRecordType($1->code,$1->type);
           }
		   ;
	
	AuxExp5: AuxExp5 '*' AuxExp6{char* temp[]={$1->code,"*",$3->code};
										if(!checkTypeCompatibility(literal_int,$1->type) || !checkTypeCompatibility(literal_int,$3->type)){
											printf("Tipos incompatíveis com o operador '*' ");
											exit(0);
										}
                                                char * temp2 = checkTypeCompatibility($1->type,$3->type);
        if (temp2) {
            $$=CreateRecordType(cat(temp,3),temp2);
        }
        else {
            printf("ERROR: %s and %s are not interchangeable types\n", $1->type, $3->type);
            exit(1);
        }

                                       }
		   | AuxExp5 '/' AuxExp6{char* temp[]={$1->code,"/",$3->code};
		   								if(!checkTypeCompatibility(literal_int,$1->type) || !checkTypeCompatibility(literal_int,$3->type)){
											printf("Tipos incompatíveis com o operador '/' ");
											exit(0);
										}
                                                char * temp2 = checkTypeCompatibility($1->type,$3->type);
        if (temp2) {
            $$=CreateRecordType(cat(temp,3),temp2);
        }
        else {
            printf("ERROR: %s and %s are not interchangeable types\n", $1->type, $3->type);
            exit(1);
        }

                                       }
		   | AuxExp5 '%' AuxExp6{char* temp[]={$1->code,"\%",$3->code};
		   								if(!checkTypeCompatibility(literal_int,$1->type) || !checkTypeCompatibility(literal_int,$3->type)){
                                            // TODO: -V
											printf("Tipos incompatíveis com o operador  ");
											exit(0);
										}
                                        char * temp2 = checkTypeCompatibility($1->type,$3->type);
        if (temp2) {
            $$=CreateRecordType(cat(temp,3),temp2);
        }
        else {
            printf("ERROR: %s and %s are not interchangeable types\n", $1->type, $3->type);
            exit(1);
        }
        }
		   | AuxExp6{
           $$=CreateRecordType($1->code,$1->type);
           }
		   ;
	
	AuxExp6: AuxExp7 '^' AuxExp6{char* temp[]={$1->code,"^",$3->code};
								if(!checkTypeCompatibility(literal_int,$1->type) || !checkTypeCompatibility(literal_int,$3->type)){
									printf("Tipos incompatíveis com o operador '^' ");
									exit(0);
								}
                                        char * temp2 = checkTypeCompatibility($1->type,$3->type);
        if (temp2) {
            $$=CreateRecordType(cat(temp,3),temp2);
        }
        else {
            printf("ERROR: %s and %s are not interchangeable types\n", $1->type, $3->type);
            exit(1);
        }

                                }
		   | AuxExp7{
           $$=CreateRecordType($1->code,$1->type);
           }
		   ;
	
	AuxExp7: NOT AuxExp7{char* temp[]={"!",$2->code};
						 $$=CreateRecordType(cat(temp,2),$2->type);
                         }
		   | AuxExp8{
           $$=CreateRecordType($1->code,$1->type);
           }
		   ;
	
	AuxExp8: IDs {
    $$=CreateRecordType($1->code,$1->type);
    }
		   | Literal {
           $$=CreateRecordType($1->code,$1->type);
           }
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
           | ModuleCall {}
		   | SubprogramCall {
           $$=CreateRecord($1->code);
           }
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

    Print: PRINT '(' VALUE_STRING ',' Expression ')' {  }
         | PRINT '(' VALUE_STRING ')' {  }
         ;

	SubprogramCall: ID MaybeParams '.' SubprogramCall {}
                  | ID '.' SubprogramCall {} // foo.poo()
				  | ID MaybeParams {char* temp[]={$1,$2->code};
									$$=CreateRecord(cat(temp,2));
                                    }
				  ;

    MaybeParams: '(' ')' {
    $$=CreateRecord("()");
    }
               | '(' ParamsToCall ')' {char* temp[]={"(",$2->code,")"};
									   $$=CreateRecord(cat(temp,3));
                                       }
               ;

	ParamsToCall: Expression ',' ParamsToCall{char* temp[]={$1->code,",",$3->code};
									   		  $$=CreateRecord(cat(temp,3));
                                              }
				| Expression {
                $$=CreateRecord($1->code);
                }
				;
    
    ModuleCall: ID ':' ':' SubprogramCall  {}
              | TypeCollection ':' ':' SubprogramCall {}
              ;

	ElementSequence: Expression ',' ElementSequence{}
				   | Expression {}
				   ;
	
	RepeatStructures:
        WHILE '(' Expression ')' Scope {
														char* tempw[]={"WHILE_",whileCount()};
														char* whileLabel=cat(tempw,2);
														char* temp[]={"{",whileLabel,":if(",$3->code,"){",$5->code,"goto ",whileLabel,"}}"};
														$$=CreateRecord(cat(temp,9));
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
					
	DecisionStructures: IF '(' Expression ')' Scope {char* temp[]={"if(",$3->code,")",$5->code};
									   		  		$$=CreateRecord(cat(temp,4));
                                                    }
					  | IF '(' Expression ')' Scope ELSE Scope {char* temp[]={"if(",$3->code,")",$5->code,"else",$7->code};
									   		  					$$=CreateRecord(cat(temp,6));
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

    TypeCollection: TYPE_S_INT64 {}
				  | TYPE_S_INT32 {}
				  | TYPE_S_SIZE {}
				  | TYPE_S_INT16 {}
				  | TYPE_U_INT64 {}
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
				  | TYPE_RESULT {}
				  | TYPE_OPTION {}
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
	scopeStack=CreateStack();
	varTable=create_table();
	funcTable=create_table();
	InitializeTypeTable();
	PushScope(scopeStack,CreateScope("GLOBAL"));
    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");
    codigo = yyparse();

    fclose(yyin);
    fclose(yyout);

    
	return codigo;
}
