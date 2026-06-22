#ifndef HASHTABLE
#define HASHTABLE

#include <cstddef>

typedef struct ht_entry ht_entry;
typedef struct ht ht;

ht* ht_create();

unsigned long ht_hash(const char * key);

ht_entry * ht_get(ht * ht, const char * key);

ht_entry * ht_add(ht * ht, const char * key, void * value);

bool ht_destroy(ht * ht);

bool ht_remove(ht * ht, const char * key);
void ht_print(ht * ht);

#endif
