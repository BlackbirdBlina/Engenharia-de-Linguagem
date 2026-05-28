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
    EXPONENTIAL = 272,             /* EXPONENTIAL  */
    MINUS = 273,                   /* MINUS  */
    MULTIPLY = 274,                /* MULTIPLY  */
    DIVIDE = 275,                  /* DIVIDE  */
    REMAINDER = 276,               /* REMAINDER  */
    LEFT_PARENTHESIS = 277,        /* LEFT_PARENTHESIS  */
    RIGHT_PARENTHESIS = 278,       /* RIGHT_PARENTHESIS  */
    LEFT_BRACKET = 279,            /* LEFT_BRACKET  */
    RIGHT_BRACKET = 280,           /* RIGHT_BRACKET  */
    LEFT_BRACE = 281,              /* LEFT_BRACE  */
    RIGHT_BRACE = 282,             /* RIGHT_BRACE  */
    DOT = 283,                     /* DOT  */
    END = 284,                     /* END  */
    COMMA = 285,                   /* COMMA  */
    COLON = 286,                   /* COLON  */
    PROCEDURE = 287,               /* PROCEDURE  */
    FUNCTION = 288,                /* FUNCTION  */
    PURE = 289,                    /* PURE  */
    FOR = 290,                     /* FOR  */
    TO = 291,                      /* TO  */
    LOOP = 292,                    /* LOOP  */
    CONTINUE = 293,                /* CONTINUE  */
    BREAK = 294,                   /* BREAK  */
    IF = 295,                      /* IF  */
    IN = 296,                      /* IN  */
    THEN = 297,                    /* THEN  */
    ELSE = 298,                    /* ELSE  */
    RETURN = 299,                  /* RETURN  */
    REF = 300,                     /* REF  */
    PRINT = 301,                   /* PRINT  */
    ATTRIBUTION = 302,             /* ATTRIBUTION  */
    INCREMENT = 303,               /* INCREMENT  */
    DECREMENT = 304,               /* DECREMENT  */
    PLUS_ATTRIBUTION = 305,        /* PLUS_ATTRIBUTION  */
    MINUS_ATTRIBUTION = 306,       /* MINUS_ATTRIBUTION  */
    MULTIPLY_ATTRIBUTION = 307,    /* MULTIPLY_ATTRIBUTION  */
    DIVIDE_ATTRIBUTION = 308,      /* DIVIDE_ATTRIBUTION  */
    ID = 309,                      /* ID  */
    VALOR_INT = 310,               /* VALOR_INT  */
    VALOR_FLOAT = 311,             /* VALOR_FLOAT  */
    VALOR_BOOL = 312,              /* VALOR_BOOL  */
    VALOR_CHAR = 313,              /* VALOR_CHAR  */
    VALOR_STRING = 314,            /* VALOR_STRING  */
    TIPO_BOOL = 315,               /* TIPO_BOOL  */
    TIPO_S_INT8 = 316,             /* TIPO_S_INT8  */
    TIPO_S_INT32 = 317,            /* TIPO_S_INT32  */
    TIPO_S_SIZE = 318,             /* TIPO_S_SIZE  */
    TIPO_S_INT16 = 319,            /* TIPO_S_INT16  */
    TIPO_U_INT8 = 320,             /* TIPO_U_INT8  */
    TIPO_U_INT16 = 321,            /* TIPO_U_INT16  */
    TIPO_U_INT32 = 322,            /* TIPO_U_INT32  */
    TIPO_U_SIZE = 323,             /* TIPO_U_SIZE  */
    TIPO_FLOAT32 = 324,            /* TIPO_FLOAT32  */
    TIPO_FLOAT64 = 325,            /* TIPO_FLOAT64  */
    TIPO_CHAR = 326,               /* TIPO_CHAR  */
    TIPO_STRING = 327,             /* TIPO_STRING  */
    TIPO_VEC = 328,                /* TIPO_VEC  */
    TIPO_SET = 329,                /* TIPO_SET  */
    TIPO_MATRIX = 330,             /* TIPO_MATRIX  */
    TIPO_RESULT = 331,             /* TIPO_RESULT  */
    INTERVAL = 332,                /* INTERVAL  */
    MATCH = 333,                   /* MATCH  */
    WHILE = 334,                   /* WHILE  */
    STRUCT = 335,                  /* STRUCT  */
    ENUM = 336,                    /* ENUM  */
    ARROW = 337,                   /* ARROW  */
    MAIN = 338                     /* MAIN  */
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
#define EXPONENTIAL 272
#define MINUS 273
#define MULTIPLY 274
#define DIVIDE 275
#define REMAINDER 276
#define LEFT_PARENTHESIS 277
#define RIGHT_PARENTHESIS 278
#define LEFT_BRACKET 279
#define RIGHT_BRACKET 280
#define LEFT_BRACE 281
#define RIGHT_BRACE 282
#define DOT 283
#define END 284
#define COMMA 285
#define COLON 286
#define PROCEDURE 287
#define FUNCTION 288
#define PURE 289
#define FOR 290
#define TO 291
#define LOOP 292
#define CONTINUE 293
#define BREAK 294
#define IF 295
#define IN 296
#define THEN 297
#define ELSE 298
#define RETURN 299
#define REF 300
#define PRINT 301
#define ATTRIBUTION 302
#define INCREMENT 303
#define DECREMENT 304
#define PLUS_ATTRIBUTION 305
#define MINUS_ATTRIBUTION 306
#define MULTIPLY_ATTRIBUTION 307
#define DIVIDE_ATTRIBUTION 308
#define ID 309
#define VALOR_INT 310
#define VALOR_FLOAT 311
#define VALOR_BOOL 312
#define VALOR_CHAR 313
#define VALOR_STRING 314
#define TIPO_BOOL 315
#define TIPO_S_INT8 316
#define TIPO_S_INT32 317
#define TIPO_S_SIZE 318
#define TIPO_S_INT16 319
#define TIPO_U_INT8 320
#define TIPO_U_INT16 321
#define TIPO_U_INT32 322
#define TIPO_U_SIZE 323
#define TIPO_FLOAT32 324
#define TIPO_FLOAT64 325
#define TIPO_CHAR 326
#define TIPO_STRING 327
#define TIPO_VEC 328
#define TIPO_SET 329
#define TIPO_MATRIX 330
#define TIPO_RESULT 331
#define INTERVAL 332
#define MATCH 333
#define WHILE 334
#define STRUCT 335
#define ENUM 336
#define ARROW 337
#define MAIN 338

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 11 "parser.y"

	int    iValue; 	
	char   cValue; 	
	char * sValue;  
	

#line 240 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
