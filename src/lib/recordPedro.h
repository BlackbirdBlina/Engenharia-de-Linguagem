#ifndef RECORD
#define RECORD

// Teremos duas áreas principais:
//     name: será o ID da variável + '#' + o escopo (tipo um for) + um contador global
//     type: os tipos da nossa linguagem (incluindo tipos definidos pelo usuário)
struct record {
    char * name;
    char * type;
};

// Ao invés de:
// ``` C
//      struct record r;
// ```
// Podemos declarar um record dessa maneira:
// ``` C
//      record r;
// ```
// Utilizando essa linha:
typedef struct record record;

void freeRecord(record *);
record * createRecord(char *, char *);

#endif
