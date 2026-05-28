/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    CONST = 258,                   /* CONST  */
    MUTABLE = 259,                 /* MUTABLE  */
    LET = 260,                     /* LET  */
    SEMICOLON = 261,               /* SEMICOLON  */
    OR = 262,                      /* OR  */
    AND = 263,                     /* AND  */
    NOT_EQUAL = 264,               /* NOT_EQUAL  */
    EQUAL = 265,                   /* EQUAL  */
    LESS = 266,                    /* LESS  */
    GREATER = 267,                 /* GREATER  */
    LESS_EQUAL = 268,              /* LESS_EQUAL  */
    GREATER_EQUAL = 269,           /* GREATER_EQUAL  */
    NOT = 270,                     /* NOT  */
    PLUS = 271,                    /* PLUS  */
    MINUS = 272,                   /* MINUS  */
    MULTIPLY = 273,                /* MULTIPLY  */
    DIVIDE = 274,                  /* DIVIDE  */
    REMAINDER = 275,               /* REMAINDER  */
    LEFT_PARENTHESIS = 276,        /* LEFT_PARENTHESIS  */
    RIGHT_PARENTHESIS = 277,       /* RIGHT_PARENTHESIS  */
    LEFT_BRACKET = 278,            /* LEFT_BRACKET  */
    RIGHT_BRACKET = 279,           /* RIGHT_BRACKET  */
    LEFT_BRACE = 280,              /* LEFT_BRACE  */
    RIGHT_BRACE = 281,             /* RIGHT_BRACE  */
    DOT = 282,                     /* DOT  */
    END = 283,                     /* END  */
    COMMA = 284,                   /* COMMA  */
    COLON = 285,                   /* COLON  */
    PROCEDURE = 286,               /* PROCEDURE  */
    FUNCTION = 287,                /* FUNCTION  */
    PURE = 288,                    /* PURE  */
    FOR = 289,                     /* FOR  */
    TO = 290,                      /* TO  */
    LOOP = 291,                    /* LOOP  */
    CONTINUE = 292,                /* CONTINUE  */
    BREAK = 293,                   /* BREAK  */
    IF = 294,                      /* IF  */
    IN = 295,                      /* IN  */
    THEN = 296,                    /* THEN  */
    ELSE = 297,                    /* ELSE  */
    RETURN = 298,                  /* RETURN  */
    REF = 299,                     /* REF  */
    PRINT = 300,                   /* PRINT  */
    ATTRIBUTION = 301,             /* ATTRIBUTION  */
    INCREMENT = 302,               /* INCREMENT  */
    DECREMENT = 303,               /* DECREMENT  */
    PLUS_ATTRIBUTION = 304,        /* PLUS_ATTRIBUTION  */
    MINUS_ATTRIBUTION = 305,       /* MINUS_ATTRIBUTION  */
    MULTIPLY_ATTRIBUTION = 306,    /* MULTIPLY_ATTRIBUTION  */
    DIVIDE_ATTRIBUTION = 307,      /* DIVIDE_ATTRIBUTION  */
    ID = 308,                      /* ID  */
    VALOR_INT = 309,               /* VALOR_INT  */
    VALOR_FLOAT = 310,             /* VALOR_FLOAT  */
    VALOR_BOOL = 311,              /* VALOR_BOOL  */
    VALOR_CHAR = 312,              /* VALOR_CHAR  */
    VALOR_STRING = 313,            /* VALOR_STRING  */
    TIPO_BOOL = 314,               /* TIPO_BOOL  */
    TIPO_S_INT8 = 315,             /* TIPO_S_INT8  */
    TIPO_S_INT32 = 316,            /* TIPO_S_INT32  */
    TIPO_S_SIZE = 317,             /* TIPO_S_SIZE  */
    TIPO_S_INT16 = 318,            /* TIPO_S_INT16  */
    TIPO_U_INT8 = 319,             /* TIPO_U_INT8  */
    TIPO_U_INT16 = 320,            /* TIPO_U_INT16  */
    TIPO_U_INT32 = 321,            /* TIPO_U_INT32  */
    TIPO_U_SIZE = 322,             /* TIPO_U_SIZE  */
    TIPO_FLOAT32 = 323,            /* TIPO_FLOAT32  */
    TIPO_FLOAT64 = 324,            /* TIPO_FLOAT64  */
    TIPO_CHAR = 325,               /* TIPO_CHAR  */
    TIPO_STRING = 326,             /* TIPO_STRING  */
    TIPO_VEC = 327,                /* TIPO_VEC  */
    TIPO_SET = 328,                /* TIPO_SET  */
    TIPO_MATRIX = 329,             /* TIPO_MATRIX  */
    TIPO_RESULT = 330,             /* TIPO_RESULT  */
    INTERVAL = 331,                /* INTERVAL  */
    MATCH = 332,                   /* MATCH  */
    WHILE = 333,                   /* WHILE  */
    STRUCT = 334,                  /* STRUCT  */
    ENUM = 335,                    /* ENUM  */
    ARROW = 336,                   /* ARROW  */
    MAIN = 337                     /* MAIN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define CONST 258
#define MUTABLE 259
#define LET 260
#define SEMICOLON 261
#define OR 262
#define AND 263
#define NOT_EQUAL 264
#define EQUAL 265
#define LESS 266
#define GREATER 267
#define LESS_EQUAL 268
#define GREATER_EQUAL 269
#define NOT 270
#define PLUS 271
#define MINUS 272
#define MULTIPLY 273
#define DIVIDE 274
#define REMAINDER 275
#define LEFT_PARENTHESIS 276
#define RIGHT_PARENTHESIS 277
#define LEFT_BRACKET 278
#define RIGHT_BRACKET 279
#define LEFT_BRACE 280
#define RIGHT_BRACE 281
#define DOT 282
#define END 283
#define COMMA 284
#define COLON 285
#define PROCEDURE 286
#define FUNCTION 287
#define PURE 288
#define FOR 289
#define TO 290
#define LOOP 291
#define CONTINUE 292
#define BREAK 293
#define IF 294
#define IN 295
#define THEN 296
#define ELSE 297
#define RETURN 298
#define REF 299
#define PRINT 300
#define ATTRIBUTION 301
#define INCREMENT 302
#define DECREMENT 303
#define PLUS_ATTRIBUTION 304
#define MINUS_ATTRIBUTION 305
#define MULTIPLY_ATTRIBUTION 306
#define DIVIDE_ATTRIBUTION 307
#define ID 308
#define VALOR_INT 309
#define VALOR_FLOAT 310
#define VALOR_BOOL 311
#define VALOR_CHAR 312
#define VALOR_STRING 313
#define TIPO_BOOL 314
#define TIPO_S_INT8 315
#define TIPO_S_INT32 316
#define TIPO_S_SIZE 317
#define TIPO_S_INT16 318
#define TIPO_U_INT8 319
#define TIPO_U_INT16 320
#define TIPO_U_INT32 321
#define TIPO_U_SIZE 322
#define TIPO_FLOAT32 323
#define TIPO_FLOAT64 324
#define TIPO_CHAR 325
#define TIPO_STRING 326
#define TIPO_VEC 327
#define TIPO_SET 328
#define TIPO_MATRIX 329
#define TIPO_RESULT 330
#define INTERVAL 331
#define MATCH 332
#define WHILE 333
#define STRUCT 334
#define ENUM 335
#define ARROW 336
#define MAIN 337

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 11 "parser.y"

	int    iValue; 	
	char   cValue; 	
	char * sValue;  
	

#line 238 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
