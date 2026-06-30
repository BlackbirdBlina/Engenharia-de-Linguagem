#include "../../record.h"
#include "../parser.h"
#include "../semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* lltochar(long long i) {
    char* string = (char*)malloc(sizeof(char) * 20);
    sprintf(string, "%lld", i);
    return string;
}

void arrayDeclaration(ArrayType** $$, ArrayType* ArrayDeclForm_) {
    c_code tmp[] = {"{ ", ArrayDeclForm_->content, " }"};
    c_code content = cat(tmp, 3);

    type arrayDecl_[] = {"[", ArrayDeclForm_->type, ";", lltochar(ArrayDeclForm_->size), "]"};
    type type = cat(arrayDecl_, 5);
    if (lookup_symbol(typeTable, type) == NULL) {
        insert_symbol(typeTable, type, allocTypeArray(type, ArrayDeclForm_->type, ArrayDeclForm_->size));
    }
    *$$ = newArrayType(content, type, ArrayDeclForm_->size);
}

void arrayDeclForm_Expression(ArrayType** $$, Record* Expression, ArrayType* ArrayDeclForm_) {
    c_code temp[] = {Expression->code, ", ", ArrayDeclForm_->content};
    c_code content = cat(temp, 3);
    if (checkTypeCompat(Expression->type, ArrayDeclForm_->type, BOTH) == NULL) {
        printf("Line %d: Array declaration types don't match each other, found '%s' and '%s'\n", yylineno, Expression->type, ArrayDeclForm_->type);
        exit(1);
    }
    long long size = 1 + (ArrayDeclForm_->size);

    *$$ = newArrayType(content, Expression->type, size);
}

void arrayDeclForm_ArrayDecl(ArrayType** $$, ArrayType* ArrayDecl_, ArrayType* ArrayDeclForm_) {
    c_code temp[] = {ArrayDecl_->content, ", ", ArrayDeclForm_->content};
    c_code content = cat(temp, 3);
    if (checkTypeCompat(ArrayDecl_->type, ArrayDeclForm_->type, BOTH) == NULL) {
        printf("Line %d: Array declaration types don't match each other, found '%s' and '%s'\n", yylineno, ArrayDecl_->type, ArrayDeclForm_->type);
        exit(1);
    }
    long long size = 1 + (ArrayDeclForm_->size);

    *$$ = newArrayType(content, ArrayDecl_->type, size);
}
