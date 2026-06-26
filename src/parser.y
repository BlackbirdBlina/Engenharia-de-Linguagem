%{
#include <stdio.h>
#include "symbol_table.h"
#include <stdlib.h>
#include <string.h>
#include "record.h"

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

SymbolTable* createTable_Program = NULL;
char* scope = NULL;
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
    Program:  {scope = "global"; /* Indica o escopo global*/ } Decls {
				fprintf(yyout,"%s", $2->code);
		   } 
           ;
	Decls: SubProgram Decls {
			char* temp[] = {$1->code, "\n", $2->code}; // Salva num array de char (temp) as strings a serem concatenadas
			$$ = CreateRecord(cat(temp,3)); // Concatena as strings, cria o registro da declaração do subprograma e o atribui à regra de Decls (declarações)
		 }
		 | Assignment Decls {
			char* temp[] = {$1->code,"\n",$2->code};
			$$ = CreateRecord(cat(temp,3));
		 }
		 | StructDecl Decls {
			char* temp[] = {$1->code,"\n",$2->code};
			$$ = CreateRecord(cat(temp,3));}
		 | EnumDecl Decls {
			char* temp[] = {$1->code,"\n",$2->code};
			$$ = CreateRecord(cat(temp,3));
		 }	
		 | Main {
			$$ = CreateRecord($1->code); // Não é necessário criar um array de char, pois é só uma "coisa" (main)
		 }
		 ;
	
	SubProgram: FUNCTION ID '(' Params ')' ARROW Type {
					char global_counter_str[20]; // Define um array de char (global_counter_str) que comporta o tamanho máximo de caracteres que pode receber
					snprintf(global_counter_str, sizeof(global_counter_str), "%d", global_counter++); // Converte o número da var global_counter em string e armazena em global_counter_str
					char* temp[] = {$2, "#", global_counter_str}; // Salva num array de char as strings a serem concatenadas
					scope = cat(temp, 3); // Concatena as strings
			  } Scope {
					char* temp[] = {$7->code, " ", $2, "(", $4->code, ")", "\n", $9->code}; // Salva num array de char (temp) as strings a serem concatenadas
					$$ = CreateRecord(cat(temp,8)); // Concatena as strings, cria o registro do escopo e o atribui à regra do subProgram
			  }
			  | PURE FUNCTION ID '(' Params ')' ARROW Type {
					char global_counter_str[20]; // Define um array de char (global_counter_str) que comporta o tamanho máximo de caracteres que pode receber
					snprintf(global_counter_str, sizeof(global_counter_str), "%d", global_counter++); // Converte o número da var global_counter em string e armazena em global_counter_str
					char* temp[] = {$3, "#", global_counter_str}; // Salva num array de char as strings a serem concatenadas
					scope = cat(temp, 3); // Concatena as strings
			  } Scope {
			  		char* temp[] = {$8->code, " ", $3, "(", $5->code, ")", $10->code};
					$$ = CreateRecord(cat(temp,7));}
			  | PROCEDURE ID '(' Params ')' {
					char global_counter_str[20]; // Define um array de char (global_counter_str) que comporta o tamanho máximo de caracteres que pode receber
					snprintf(global_counter_str, sizeof(global_counter_str), "%d", global_counter++); // converte o número da var global_counter em string e armazena em global_counter_str
					char* temp[] = {$2, "#", global_counter_str}; // Salva num array de char as strings a serem concatenadas
					scope = cat(temp, 3); // Concatena as strings
			  } Scope {
			  		char* temp[] = {"void", " ", $2, "(", $4->code, ")", $7->code};
					$$ = CreateRecord(cat(temp,7));}
			  ;

	Main: FUNCTION MAIN '(' Params ')' ARROW Type {
			char global_counter_str[20]; 
			snprintf(global_counter_str, sizeof(global_counter_str), "%d", global_counter++);
			char* temp[] = {"main", "#", global_counter_str};
			scope = cat(temp, 3);
			// printf("scope: %s\n", scope);
		} Scope { 
			// No array de char abaixo, inclui os imports de bibliotecas necessárias e, em seguida, cria o registro da main para traduzir para C
			char* temp[] = {"#include <stdio.h>\n#include <math.h>\n#include <sys/types.h>\n#include <stdbool.h>\n#include <stdint.h>\n", "\nint main()", $9->code};
			$$ = CreateRecord(cat(temp,3));
		}
		;

	Params: VarTypedList {$$=CreateRecord($1->code);}
		  | { np("No PARAMS"); $$=CreateRecord("");}
		  ;

	VarTypedList: VarTyped ',' VarTypedList { 
					char* temp[] = {$1->code, ",", $3->code};
					$$ = CreateRecord(cat(temp,3));
				}
				| VarTyped {
					$$ = CreateRecord($1->code);
				}
				;

	VarTyped: ID ':' Type { 
				char* temp[] = {$3->code, " ", $1};
				Record* record = CreateTypedRecord(cat(temp,3), $3->kind); 
				record->id = strdup($1);
				$$ = record;
			}
			;

	Scope: '{' '}' { $$=CreateRecord("{}"); }
		 | '{' Statements '}' { np("SCOPE");
		 						char* temp[]={"{\n",$2->code,"}"};
								$$=CreateRecord(cat(temp,3)); }
		 ;

	Statements: Statement Statements {
				char* temp[]={$1->code,"\n",$2->code};
				$$=CreateRecord(cat(temp,3));}
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
             | StructDecl { 
				p("STRUCT Detected"); 
			 }
			 | SubprogramCall ';'{
				char* temp[]={$1->code,";\n"};
				$$=CreateRecord(cat(temp,2));
			 }
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
	      | RETURN Expression ';' {char* temp[]={"return ",$2->code,";\n"};
								  $$=CreateRecord(cat(temp,3));}
		  ;

	Assignment: LET VarTyped '=' Expression ';' { 
				p("NON-MUTABLE ASSIGNMENT");
				char* temp[] = {"const ", $2->code, " ", "=", " ", $4->code, ";\n"};
				$$ = CreateTypedRecord(cat(temp,7), $2->kind);

				// printf("%s#%s\n", $2->id, scope);
				insert_symbol(createTable_Program, $2->id, scope, alloc_type_info($2->kind));
			  }
			  | CONST VarTyped '=' Expression ';' { p("CONSTANT ASSIGNMENT"); }
			  | LET MUTABLE VarTyped '=' Expression ';' { p("MUTABLE ASSIGNMENT"); 
			  											  char* temp[]={$3->code,"=",$5->code,";\n"};
														  $$=CreateRecord(cat(temp,4));}
              | LET STRUCT ID '=' ID '{' ElementSequence '}' ';' {} // Rever: ElementSequence Mesmo?
              | LET MUTABLE STRUCT ID '=' ID '{' ElementSequence '}' ';' {}
			  ;

    Attribution: ID '=' Expression ';' { p("ATTRIBUTION");
										 char* temp[]={$1,"=",$3->code,";\n"};
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

	Expression: Expression OR AuxExp1 {
				char* temp[] = {$1->code, " ", "||", " ", $3->code};
				$$ = CreateTypedRecord(cat(temp,5), KIND_BOOL);}
		      | AuxExp1 {$$ = $1;}
			  ;

	AuxExp1: AuxExp1 AND AuxExp2 {
				char* temp[] = {$1->code, " ","&&", " ",$3->code};
				$$ = CreateTypedRecord(cat(temp,5), KIND_BOOL);}
		   | AuxExp2 {$$ = $1;}
		   ;
	
	AuxExp2: AuxExp3{$$ = $1;}
		   ;
	
	AuxExp3: AuxExp3 Compare AuxExp4{
				char* temp[] = {$1->code, " ", $2->code, " ", $3->code};
				$$ = CreateTypedRecord(cat(temp,5), KIND_BOOL);}
		   | AuxExp4{$$ = $1;}
		   ;
	
	AuxExp4: AuxExp4 '+' AuxExp5{
				char* temp[]={$1->code,"+",$3->code};
				$$ = CreateTypedRecord(cat(temp,3), $1->kind);
			}
	       | AuxExp4 '-' AuxExp5{
				char* temp[]={$1->code,"-",$3->code};
				$$ = CreateTypedRecord(cat(temp,3), $1->kind);
			}
		   | AuxExp5{$$ = $1;}
		   ;
	
	AuxExp5: AuxExp5 '*' AuxExp6{
				char* temp[]={$1->code,"*",$3->code};
				$$ = CreateTypedRecord(cat(temp,3), $1->kind);
			}
		   | AuxExp5 '/' AuxExp6{
				char* temp[]={$1->code,"/",$3->code};
				$$ = CreateTypedRecord(cat(temp,3), $1->kind);
			}
		   | AuxExp5 '%' AuxExp6{
				char* temp[]={$1->code,"\%",$3->code};
				$$ = CreateTypedRecord(cat(temp,3), $1->kind); 
			}
		   | AuxExp6{$$ = $1;}
		   ;
	
	AuxExp6: AuxExp7 '^' AuxExp6{
				char* temp[]={"pow(",$1->code,",",$3->code,")"};
				$$ = CreateTypedRecord(cat(temp,5), $1->kind);
			}
		   | AuxExp7{$$ = $1;}
		   ;
	
	AuxExp7: NOT AuxExp7{
				char* temp[]={"!",$2->code};
				$$ = CreateTypedRecord(cat(temp,2), $2->kind);}
		   | AuxExp8{$$ = $1;}
		   ;
	
	AuxExp8: IDs {$$ = $1;}
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
       | ID {
			char* temp[] = {$1, "#", scope};
			char* key = cat(temp, 3);
			// printf("%s\n", key);
			SymbolNode* node = lookup_symbol(createTable_Program, key);
			$$ = CreateTypedRecord($1, node->type->kind);
		}
       ;
		   
    List: '[' ']' {}
        | '[' ElementSequence ']' {}
        ;

    Print: PRINT '(' VALUE_STRING ',' Expression ')' {
			TypeKind kind = $5->kind; // A variável Kind recebe uma expressão
			char formatter[4]; // O array de char (formatter) define o tamanho máximo para guardar a informação do que representa o tipo da nossa linguagem em C
			switch (kind) {
				case KIND_BOOL:
					strcpy(formatter, "%d");
					break;
				case KIND_S_INT8:
					strcpy(formatter, "%d");
					break;
				case KIND_S_INT16:
					strcpy(formatter, "%d");
					break;
				case KIND_S_INT32:
					strcpy(formatter, "%d");
					break;
				case KIND_S_SIZE:
					strcpy(formatter, "%d");
					break;
				case KIND_U_INT8:
					strcpy(formatter, "%d");
					break;
				case KIND_U_INT16:
					strcpy(formatter, "%d");
					break;
				case KIND_U_INT32:
					strcpy(formatter, "%d");
					break;
				case KIND_U_SIZE:
					strcpy(formatter, "%d");
					break;
				case KIND_FLOAT32:
					strcpy(formatter, "%f");
					break;
				case KIND_FLOAT64:
					strcpy(formatter, "%lf");
					break;
				case KIND_CHAR:
					strcpy(formatter, "%c");
					break;
				case KIND_STRING:
					strcpy(formatter, "%s");
					break;
				// Falta incluir os tipos estruturados
				default:
					printf("Tipo não encontrado.\n");
					break;
			}

			char* temp[] = {"printf(\"", formatter, "\", ", $5->code, ");\n"};
			$$ = CreateRecord(cat(temp,5));
	     }
         | PRINT '(' VALUE_STRING ')' {
			char* temp[] = {"printf(", $3, ");\n"};
			$$ = CreateRecord(cat(temp,3));
		 }
         ;

	SubprogramCall: ID MaybeParams '.' SubprogramCall {}
                  | ID '.' SubprogramCall {} // foo.poo()
				  | ID MaybeParams {
					char* temp[] = {$1, $2->code};
					$$ = CreateRecord(cat(temp,2));}
				  ;

    MaybeParams: '(' ')' {$$=CreateRecord("()");}
               | '(' ParamsToCall ')' {
				 char* temp[]={"(",$2->code,")"};
				 $$=CreateRecord(cat(temp,3));
			   }
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

	Type: TYPE_BOOL {
			$$ = CreateTypedRecord("bool", KIND_BOOL);
		}
        | TYPE_S_INT8 {
			$$ = CreateTypedRecord("int8_t", KIND_S_INT8);
		}
		| TYPE_S_INT16  {
			$$ = CreateTypedRecord("int16_t", KIND_S_INT16);
		}
        | TYPE_S_INT32  {
			$$ = CreateTypedRecord("int32_t", KIND_S_INT32);
		}
        | TYPE_S_SIZE  {
			$$ = CreateTypedRecord("ssize_t", KIND_S_SIZE);
		}
        | TYPE_U_INT8  {
			$$ = CreateTypedRecord("uint8_t", KIND_U_INT8);
		}
        | TYPE_U_INT16  {
			$$ = CreateTypedRecord("uint16_t", KIND_U_INT16);
		}
        | TYPE_U_INT32  {
			$$ = CreateTypedRecord("uint32_t", KIND_U_INT32);
		}
        | TYPE_U_SIZE  {
			$$ = CreateTypedRecord("size_t", KIND_U_SIZE);
		}
        | TYPE_FLOAT32 {
			$$ = CreateTypedRecord("float", KIND_FLOAT32);
		}
        | TYPE_FLOAT64  {
			$$ = CreateTypedRecord("double", KIND_FLOAT64);
		}
        | TYPE_CHAR  {
			$$ = CreateTypedRecord("char", KIND_CHAR);}
        | TYPE_STRING  {
			$$ = CreateTypedRecord("char*", KIND_STRING);}
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
		   | NOT_EQUAL {$$=CreateRecord("!=");}
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

	createTable_Program = create_table();

	codigo = yyparse();

	/* insert_symbol(createTable_Program, "x", "global", alloc_type_info(KIND_BOOL));
	insert_symbol(createTable_Program, "f", "global", alloc_type_info(KIND_FLOAT32));
	
	printf("Tabela de símbolos criada no endereço: %p\n", createTable_Program);

	SymbolNode* node = lookup_symbol(createTable_Program, "x#global#0");
	printf("name: %s\n", node->name);
	printf("node: %p\n", node);
	printf("key: %s\n", node->key);
	printf("kind: %d\n", node->type->kind);

	node = lookup_symbol(createTable_Program, "f#global#1");
	printf("name: %s\n", node->name);
	printf("node: %p\n", node);
	printf("key: %s\n", node->key);
	printf("kind: %d\n", node->type->kind); */

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