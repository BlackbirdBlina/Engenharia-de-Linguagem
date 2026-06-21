#ifndef HASHTABLE
#define HASHTABLE
#define SET_SIZE 16
#include <stddef.h>

struct ht_entry {
    const char * key;
    void * value;
};

struct ht {
    ht_entry * entries;
    size_t capacity;
    size_t length;
};

typedef struct ht ht;

ht * ht_create(void);
ht * ht_get(ht *);
ht * ht_add(ht *);
ht * ht_destroy(void);

#endif
