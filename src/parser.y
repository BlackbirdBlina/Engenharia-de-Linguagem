%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lib/parser/parser.h"
#include "lib/record.h"
#include "lib/linked_list.h"
#include "lib/symbol_table.h"
#include "lib/scope_stack.h"
#include "lib/parser/semantics.h"
#include "lib/parser/grammar/IO.c"
#include "lib/parser/grammar/array.c"
#include "lib/parser/grammar/operator.c"
#include "lib/parser/grammar/vartyped.c"
#include "lib/parser/grammar/subprogram.c"
#include "lib/parser/grammar/assignments.c"
#include "lib/parser/grammar/attribution.c"

int yylex(void);
int yyerror(char *s);
extern char * yytext;
extern FILE * yyin, * yyout;

%}
%union {
	long long iValue; 	
	float  fValue; 	
	char   cValue; 	
	ID_t   idValue;
	VALUE_STRING_t sValue;
	struct Record* rec;  
	struct TypeRec* typeRec;  
	struct ArrayType* arrayType;  
	};

%token CONST MUTABLE LET ';' OR AND NOT_EQUAL '=' '<' '>' LESS_EQUAL GREATER_EQUAL NOT '+' '^' '-' '*' '/' '%' '(' ')' '[' ']' '{' '}' '.' ',' ':' PROCEDURE FUNCTION PURE FOR LOOP CONTINUE BREAK IF IN ELSE RETURN '&'
%token EQUAL INCREMENT DECREMENT PLUS_ATTRIBUTION MINUS_ATTRIBUTION MULTIPLY_ATTRIBUTION DIVIDE_ATTRIBUTION 
%token PRINT TOPRINT
%token <sValue> OK ERROR SOME NONE VALUE_BOOL VALUE_CHAR VALUE_STRING VALUE_FLOAT
%token <iValue> VALUE_INT
%token <idValue> ID
%token <typeRec> TYPE_BOOL TYPE_S_INT64 TYPE_S_INT32 TYPE_S_SIZE TYPE_S_INT16 TYPE_U_INT64 TYPE_U_INT32 TYPE_U_SIZE TYPE_FLOAT32 TYPE_FLOAT64 TYPE_CHAR TYPE_STRING TYPE_VEC TYPE_SET TYPE_MATRIX TYPE_RESULT TYPE_OPTION
%token <typeRec> TYPE_U_INT16
%token INTERVAL MATCH WHILE STRUCT ENUM ARROW MAIN INPUT TOINPUT
%token RESERVE

%type <rec> SubProgram Main Params VarTyped VarTypedList Scope Statements Statement Return Assignment Attribution IncrOrDecr
%type <rec> Array ArrayAccesses Expression AuxExp1 AuxExp2 AuxExp3 AuxExp4 AuxExp5 AuxExp6 AuxExp7 AuxExp8 StructAcess List Print Input
%type <rec> SubprogramCall MaybeParams ParamsToCall ElementSequence RepeatStructures DecisionStructures ElseIf 
%type <rec> StructDecl Attributes EnumDecl Variants Compare Literal
%type <rec> ReserveMem
%type <typeRec> Type
// EXAMPLE:
//     ArrayDecl '{' ArrayDeclForm '}'
//     ArrayDecl = { 0, 1}
//     ArrayDeclForm = 0, 1
%type <arrayType> ArrayDecl ArrayDeclForm
%type <rec> Decls ThingsToPrint ThingsToInput
%start Program 

%%
    Program:
        Decls  {
            fprintf(yyout,"#include<stdio.h>\n#include<stdbool.h>\n#include<stdlib.h>\n%s", $1->code);
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
    
	SubProgram: FUNCTION ID '(' {PushScope(scopeStack,GenerateScope());} Params ')' ARROW Type{SUBPROGRAM_PREDecl($2,$5,$8);}Scope{ FUNCTION_Decl(&$$, $2, $5, $8, $10);PopScope(scopeStack); }
			  | PURE FUNCTION ID '(' {PushScope(scopeStack,GenerateScope());} Params ')' ARROW Type {SUBPROGRAM_PREDecl($3,$6,$9);}Scope{ PURE_FUNCTION_Decl(&$$, $3, $6, $9, $11);PopScope(scopeStack); }
			  | PROCEDURE ID '(' {PushScope(scopeStack,GenerateScope());} Params ')' {PROCEDURE_PREDecl($2,$5);}Scope{ PROCEDURE_Decl(&$$, $2, $5, $8);PopScope(scopeStack); }
			  ;
	Main: FUNCTION MAIN '(' Params ')' ARROW Type Scope {
            char* temp[]={"int main() ", $8->code};
            $$=CreateRecord(cat(temp,2));
        }
		;
    Params: VarTypedList                                            { $$ = CreateRecordFuncParams($1->code, $1->paramsTypes); }
        |                                                           { LinkedList* paramsTypes = CreateLinkedList();
                                                                      $$ = CreateRecordFuncParams("", paramsTypes); }
        ;
	VarTypedList: VarTyped ',' VarTypedList                         { VarTypedList_Chain(&$$, $1, $3); }
				| VarTyped                                          { VarTypedList_Single(&$$, $1); }
				;
	VarTyped: ID ':' Type                                           { VarTyped_ID_Type(&$$, $1, $3); }
			;
	Scope: '{' { PushScope(scopeStack,GenerateScope()); } '}' { $$=CreateRecord("{}"); PopScope(scopeStack); }
		 | '{' { PushScope(scopeStack,GenerateScope()); } Statements '}' {
		 						char* temp[]={"{\n\t",$3->code,"\n}"};
								$$=CreateRecord(cat(temp,3));
                                $$->returnType=$3->returnType;
								PopScope(scopeStack);
                                }
		 ;
	Statements: Statement Statements { char* temp[]={$1->code,"\n",$2->code};
									   $$ = CreateRecord(cat(temp, 3));
                                       if($1->returnType && $2->returnType){
                                          char* temp = checkTypeCompat($1->returnType, $2->returnType, BOTH);
                                          if(temp){
                                              $$->returnType = temp; 
                                          }
                                          else{
                                              printf("ERROR Line %d: Returns with incompatible types;",
                                                  yylineno);
                                              exit(1);
                                          }
                                       }
                                       else if($1->returnType){ $$->returnType=$1->returnType; }
                                       else if($2->returnType){ $$->returnType=$2->returnType; }
                                     }
			  | Statement { $$=CreateRecord($1->code); $$->returnType=$1->returnType;}
			  ;
	Statement: Assignment { $$=CreateRecord($1->code); }
             | Attribution { $$=CreateRecord($1->code); }
             | StructDecl {}
			 | SubprogramCall ';'{char* temp[]={$1->code,";"};
								$$=CreateRecord(cat(temp,2));
                                }
			 | Return { $$=CreateRecord($1->code); $$->returnType=$1->returnType;}
			 | Scope { $$=CreateRecord($1->code); $$->returnType=$1->returnType; }
			 | RepeatStructures { $$=CreateRecord($1->code); }
			 | DecisionStructures { $$=CreateRecord($1->code); $$->returnType=$1->returnType; }
			 | CONTINUE ';' { $$=CreateRecord("break"); }
			 | BREAK ';' { $$=CreateRecord("continue"); }
             | Print ';' { $$=CreateRecord($1->code); }
             | Input{ $$=CreateRecord($1->code); }
			 ;
	Return: RETURN ';' { $$=CreateRecord("return;"); $$->returnType=void_; }
	      | RETURN Expression ';' {char* temp[]={"return ",$2->code,";"};
								  $$=CreateRecord(cat(temp,3));
                                  $$->returnType=$2->type;
                                  }
		  ;
	Assignment: LET VarTyped '=' Expression ';'                                           { let__equal(&$$, $2, $4, STAT); }
              | LET MUTABLE VarTyped '=' Expression ';'                                   { let__equal(&$$, $3, $5, MUT); }
			  |	LET VarTyped '=' ArrayDecl';'                                             { let__equal_array(&$$, $2, $4, STAT); }
              | LET MUTABLE VarTyped '=' ArrayDecl ';'                                    { let__equal_array(&$$, $3, $5, MUT); }
              | LET MUTABLE VarTyped';'                                   				  { let__equal_without_exp(&$$, $3, MUT); }
              | CONST VarTyped '=' Expression ';'                                         { let__equal(&$$, $2, $4, CONSTANT); }
              | LET STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
              | LET MUTABLE STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
              ;
Attribution: ID '=' Expression ';'                                                        { attribute_id_expression(&$$, $1, $3); }
           | StructAcess'=' Expression ';'                                                { attribute_struct_expression(&$$,$1,$3); }
           | ID PLUS_ATTRIBUTION Expression ';'                                           { }
           | ID MINUS_ATTRIBUTION Expression ';' {  }
           | ID MULTIPLY_ATTRIBUTION Expression ';' {  }
           | ID DIVIDE_ATTRIBUTION Expression ';' {  }
           // arr[0] = ... ;
           | Array '=' Expression ';' { attribute_array_expression(&$$, $1, $3); }
           | IncrOrDecr ';' {}
           ;
    IncrOrDecr: ID INCREMENT {}
			  | ID DECREMENT {}
			  | INCREMENT ID {}
			  | DECREMENT ID {}
              ;



	Expression: Expression OR AuxExp1 {handleOperandTypes(&$$,$1,$3,"||",bool_);}
                | AuxExp1 {$$=CreateRecordType($1->code,$1->type);}
                ;

	AuxExp1: AuxExp1 AND AuxExp2 {handleOperandTypes(&$$,$1,$3,"&&",bool_);}
		   | AuxExp2 {$$=CreateRecordType($1->code,$1->type);}
		   ;
	
	AuxExp2: AuxExp2 NOT_EQUAL AuxExp3{handleOperandTypes(&$$,$1,$3,"!=",literal_int);}
	       | AuxExp3{$$=CreateRecordType($1->code,$1->type);}
		   ;
	
	AuxExp3: AuxExp3 Compare AuxExp4{handleOperandTypes(&$$,$1,$3,$2->code,literal_int);$$->type=bool_;}
		   | AuxExp4{$$=CreateRecordType($1->code,$1->type);}
		   ;
	
	AuxExp4: AuxExp4 '+' AuxExp5 {handleOperandTypes(&$$,$1,$3,"+",literal_int);}
    | AuxExp4 '-' AuxExp5{handleOperandTypes(&$$,$1,$3,"-",literal_int);}
    | AuxExp5{$$=CreateRecordType($1->code,$1->type);}
    ;
	
	AuxExp5: AuxExp5 '*' AuxExp6{handleOperandTypes(&$$,$1,$3,"*",literal_int);}
	| AuxExp5 '/' AuxExp6{handleOperandTypes(&$$,$1,$3,"/",literal_int);}
	| AuxExp5 '%' AuxExp6{handleOperandTypes(&$$,$1,$3,"\%",literal_int);}
    | AuxExp6{$$=CreateRecordType($1->code,$1->type);}
    ;

	AuxExp6: AuxExp7 '^' AuxExp6{handleOperandTypes(&$$,$1,$3,"^",literal_int);}
    | AuxExp7{$$=CreateRecordType($1->code,$1->type);}
    ;

	AuxExp7: NOT AuxExp7{
        char* temp[]={"!",$2->code};
        $$=CreateRecordType(cat(temp,2),$2->type);
    }
    | AuxExp8{$$=CreateRecordType($1->code,$1->type);}
    ;

	AuxExp8: ID {
	   			checkVarScope($1);
				$$=CreateRecordType($1,getVarType($1));}
		   | Literal {$$=CreateRecordType($1->code,$1->type);}
		   | '(' Expression ')' {char* temp[]={"(",$2->code,")"};
								$$=CreateRecordType(cat(temp,3),$2->type);
                                }
		   | Array {$$=CreateRecordType($1->code,$1->type);}
		   | '&' ID {
                checkVarScope($2);

                char* c_tmp[] = {"&", $2};
                c_code c_code = cat(c_tmp, 2);

                char* t_tmp[] = {"&", getVarType($2)};
                type t = cat(t_tmp, 2);

                if (lookup_symbol(typeTable, t) == NULL) {
                    insert_symbol(typeTable, t, allocTypeRef(t, getVarType($2)));
                }

                $$ = CreateRecordType(c_code, t);
           }
		   | StructAcess {}
		   | SubprogramCall {$$=CreateRecordType($1->code,$1->type);}
           | List {}
           // let mut var : &u_int16 = reserve(sizeof(u_int16), 2);
           | ReserveMem { 
            $$ = CreateRecordType($1->code, $1->type); }
		   ;

    ReserveMem: RESERVE '(' Type ',' Expression ')' {
        // TODO: Deixa isso Expression mesmo? Faz verificação?
        char* c_code[] = {
            "malloc(",
                "sizeof(", $3->c_code, ")",
                        " * ",
                            "(", $5->code, ")",
                   ")" };
        char* temp[] = {"&", $3->type};
        char* typeID = cat(temp, 2);
        
        if (lookup_symbol(typeTable, typeID) == NULL) {
            insert_symbol(typeTable, typeID, allocTypeRef(typeID, $3->type));
        }

        $$ = CreateRecordType(cat(c_code, 9), typeID);
    }

	Array: ID ArrayAccesses {
			type typeMemAccess = getVarType($1);
            checkVarScope($1);

			for(int i = 0; i < $2->sizeOfArrayAcess; i++) {
                // TODO: Check if ID exists first:
				type arrayStore = lookup_symbol(typeTable,typeMemAccess)->info->isArrayOf;
				type refStore = lookup_symbol(typeTable,typeMemAccess)->info->isRefOf;

				if(arrayStore != NULL){
					typeMemAccess = arrayStore;
				} else if (refStore != NULL) {
                    typeMemAccess = refStore;
                }
                // Caso de erro:
                // - let arr : [u_int32; 1] = {0};
                // - ... arr[0][0];
                else {
                    printf("ERROR Line %d: Improper Access of memory \"%s\"\n",
                        yylineno, $1);
                    exit(1);
                }
			}
			char* temp[] = {$1, $2->code};
			$$ = CreateRecordVarTyped(cat(temp,2), typeMemAccess, $1);
	}
         ;

	ArrayAccesses: '[' Expression ']' ArrayAccesses {
                                                    char* temp[]={"[",$2->code,"]",$4->code};
													$$ = CreateRecordArrayAcess(cat(temp,4),$4->sizeOfArrayAcess+1);
                                                    }
		         | '[' Expression ']' {
										char* temp[]={"[",$2->code,"]"};
										$$ = CreateRecordArrayAcess(cat(temp,3),1);}
		         ;

	ArrayDecl: '{' ArrayDeclForm '}' { arrayDeclaration(&$$, $2); }
             ;
	ArrayDeclForm: Expression ',' ArrayDeclForm         { arrayDeclForm_Expression(&$$, $1, $3); }
			     | ArrayDecl ',' ArrayDeclForm          { arrayDeclForm_ArrayDecl(&$$, $1, $3); }
                 | Expression                           { $$ = newArrayType($1->code, $1->type, 1); }
                 | ArrayDecl                            { $$ = newArrayType($1->content, $1->type, 1); }
                 ;

    StructAcess:
        ID '.' ID {
            checkVarScope($1);
			char* varType=getVarType($1);
			SymbolInfo* typeInfo= lookup_symbol(typeTable,varType)->info;
			if(typeInfo->structFields!=NULL){
				if(lookup_symbol(typeInfo->structFields,$3)!=NULL){
					char* temp[]={$1,".",$3};
					$$=CreateRecordVarTyped(cat(temp,3),lookup_symbol(typeInfo->structFields,$3)->info->type,$1);
				}
				else{
					printf("ERROR line%d:The variable \"%s\" has tipe \"%s\" and \"%s\"dont have the field\"%s\"",yylineno,$1,varType,varType,$3);
					exit(1);
				}
			}
			else{
				printf("ERROR line%d:The variable \"%s\" has tipe \"%s\" and \"%s\" dont have fields",yylineno,$1,varType,varType);
				exit(1);
			}
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
                                                                          $$=CreateRecordType(cat(temp,2), checkParamType($1,$2->paramsTypes)); }
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
					|  FOR '(' ID  IN Expression INTERVAL Expression ')' {PushScope(scopeStack,GenerateScope()); store_var_in_varTable($3, literal_int, MUT); } Scope {
					     char* counter = forCount();
					     char* tempPrepar[] = {"FOR_PREP_", counter};
					     char* tempFor[] = {"FOR_", counter};
					     char* tempEndFor[] = {"END_FOR_", counter};
					     char* tempForScope[] = {"FOR_SCOPE_", counter};
					     char* prepFor = cat(tempPrepar, 2);
					     char* forLabel = cat(tempFor, 2); 
					     char* endFor = cat(tempEndFor, 2);
					     char* forScope = cat(tempForScope, 2);
					     char* temp[] = {
					     	"{const int inicio_", forLabel, " = ", $5->code, ";\n",
					     	"const int fim_", forLabel, " = ", $7->code, ";\n",
					     	"int ", $3, " = ", "inicio_", forLabel, ";\n",
					     	forLabel, ":\n",
					     	"if (", $3, " < fim_", forLabel, ")", " goto ", forScope, ";\n", 
					     	"goto ", endFor, ";\n",
					     	forScope, ":\n",
					     	$10->code, "\n",
					     	$3, " = ", $3, " + 1;\n",
					     	"goto ", forLabel, ";\n",
					     	endFor, ":\n}"
					     };
						PopScope(scopeStack);
						$$ = CreateRecord(cat(temp, 42)); 
                        }
					|  FOR '(' ID IN Expression ')' Scope{}
					|  LOOP Scope {}
					;
					
	DecisionStructures: IF '(' Expression ')' Scope {
						if(checkTypeCompat($3->type,bool_,LEFT_RIGHT)==NULL){
							printf("ERROR Line %d: The If expected a boolean expression",
               				yylineno);
							exit(1);
						}
						char* counter = ifCount();
						char* tempif[] = {"IF_SCOPE", counter};
						char* tempend[] = {"ENDIF_", counter};
						char* ifScope = cat(tempif, 2);
						char* endIf = cat(tempend, 2);
						char* temp[] = {
							"\nif", "(", $3->code, ")", " goto ", ifScope, ";\n", 
							"\ngoto ", endIf, ";\n", 
							ifScope, ":\n", $5->code, "\n",
							endIf, ": "
						};
						$$ = CreateRecord(cat(temp, 16));
                        }
					  | IF '(' Expression ')' Scope ELSE Scope {
						if(checkTypeCompat($3->type,bool_,LEFT_RIGHT)==NULL){
							printf("ERROR Line %d: The If expected a boolean expression",
               				yylineno);
							exit(1);
						}
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
					  ;

	ElseIf: ELSE IF '(' Expression ')' Scope ElseIf {char* temp[]={"else{ if(",$4->code,")",$6->code,$7->code,"}"};
									   		  $$=CreateRecord(cat(temp,6));
                                              }
		  | ELSE IF '(' Expression ')' Scope ELSE Scope{char* temp[]={"else{ if(",$4->code,")",$6->code,"else",$8->code,"}"};
		  												$$=CreateRecord(cat(temp,7));
                                                        }
		  ;


	StructDecl: STRUCT ID '{' Attributes '}'{char* temp[]={" typedef struct {",$4->code,"}",$2,";"};
											$$=CreateRecord(cat(temp,5));
											if (lookup_symbol(typeTable, $2) == NULL) {
                								insert_symbol(typeTable, $2,alloc_type_typeStruct($2,$4->structFields));
        									}
											else{
												printf("ERROR: the type \" %s\" already exist",$2);	
												exit(1);
											}}
	          ;

	Attributes: VarTyped ',' Attributes {char* temp[] = {$1->code, ";", $3->code};
										insert_symbol($3->structFields,$1->id,alloc_type_typeStructField($1->type));
										$$ = CreateRecordAttributes(cat(temp, 3), $3->structFields);}
		      | VarTyped ',' {
								SymbolTable* attributesTypes = create_table();
    							insert_symbol(attributesTypes, $1->id,alloc_type_typeStructField($1->type));
								char* temp[] = {$1->code, ";"};
    							$$ = CreateRecordAttributes(cat(temp,2), attributesTypes);
			  			     }
		      ;

	EnumDecl: ENUM ID '{' Variants '}' {}
			;
	
	Variants: ID ',' Variants {}
			| ID ',' {}
			;

	Type: TYPE_BOOL     { $$=newTypeRec("bool",bool_,1); }
        | TYPE_S_INT16  { $$=newTypeRec("short int",s_int16,1); }
        | TYPE_S_INT32  { $$=newTypeRec("int",s_int32, 1); }
        | TYPE_S_INT64  { $$=newTypeRec("long long int",s_int64,1); }
        | TYPE_U_INT16  { $$ = newTypeRec("unsigned short int", u_int16, 1); }
        | TYPE_U_INT32  { $$ = newTypeRec("unsigned int", u_int32, 1); }
        | TYPE_U_INT64  { $$=newTypeRec("unsigned long long int",u_int64,1); }
        | TYPE_FLOAT32  { $$=newTypeRec("float",float32,1); }
        | TYPE_FLOAT64  { $$=newTypeRec("double",float64,1); }
        | TYPE_CHAR     { $$=newTypeRec("char",char_,1); }
        | TYPE_STRING   { $$=newTypeRec("char*","string",1); }
        | '[' Type ';' VALUE_INT ']' {
                                        // Max algorismos for long long
                                        char value_int[20];
                                        sprintf(value_int, "%lld", $4);

                                        type temp[] = {"[", $2->type, ";", value_int, "]"};
                                        type type = cat(temp, 5);
                                        
                                        if (lookup_symbol(typeTable, type) == NULL) {
                                            insert_symbol(typeTable, type, allocTypeArray(type, $2->type, $4));
                                        }


                                        $$ = newTypeRec($2->c_code, type, $4);
        }
        // let arr : [u_int16; 2] = {0, 1};
        // let ref : &[u_int16] = &arr;
        // ref[2]
        // let int : u_int16 = 0;
        // let ref : &u_int16 = &int;
        // | '&' '[' Type ']' {}
        | '&' Type {
            char* c_type[] = {$2->c_code, "*"};
            char* temp[] = {"&", $2->type};
            char* our_type = cat(temp, 2);

            if (lookup_symbol(typeTable, our_type) == NULL) {
                insert_symbol(typeTable, our_type, allocTypeRef(our_type, $2->type));
            }

            $$ = newTypeRec(cat(c_type, 2), our_type, 1);
        }
        | ID {
            SymbolNode* findIDType = lookup_symbol(typeTable, $1);
            if (findIDType == NULL) {
                printf("ERROR Line %d: type '%s' not found\n",
                    yylineno, $1);
                exit(1);
            } else {
                $$ = newTypeRec($1, $1, findIDType->info->size);
            }
        }
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
        long long size = 20;

        char VALUE_INT_STRING[size];
        snprintf(VALUE_INT_STRING, sizeof(VALUE_INT_STRING), "%lld", $1);

        // TODO: Maybe filter this to their respective types instead of just literal_int conversions.
        $$ = CreateRecordType(VALUE_INT_STRING, literal_int);
    }
           | VALUE_FLOAT { $$=CreateRecordType($1,literal_float); }
           | VALUE_BOOL { $$=CreateRecordType($1,bool_); }
           | VALUE_CHAR { $$=CreateRecordType($1,char_); }
           | VALUE_STRING { $$=CreateRecord($1); }
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
    printf("\033[1;31m");
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
    printf("\033[0m");

    
	return codigo;
}
