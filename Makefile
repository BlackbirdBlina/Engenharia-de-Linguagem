CC = gcc
LEX = flex
YACC = yacc
YFLAGS = -d -v

INPUT_LEX = src/lexer.l
INPUT_YACC = src/parser.y

RECORD = src/lib/record.c
HASH_TABLE = src/lib/symbol_table.c
SCOPE = src/lib/scope_stack.c
LINKED_LIST = src/lib/linked_list.c
SEMANTIC = src/lib/parser/semantics.c

INCLUDE_RECORD = src/lib/record.h
INCLUDE_SYMBOL_TABLE = src/lib/symbol_table.h
INCLUDE_SCOPE = src/lib/scope_stack.h
INCLUE_LINKED_LIST = src/lib/linked_list.h
INCLUDE_SEMANTICS = src/lib/parser/semantics.h
INCLUDE_TYPES = src/lib/parser/types.h

SOURCES = $(RECORD) $(HASH_TABLE) $(SCOPE) $(LINKED_LIST) $(SEMANTIC)

TARGET = compilador
TEST_FILE = src/examples/testes.kjt
OTHERS_TESTS = src/examples/tests/all_tests.kjt
OUTPUT_FILE = problems/output.c
OUTPUT_C_TARGET = testcode

HEADERS = $(INCLUDE_RECORD) $(INCLUDE_SYMBOL_TABLE) $(INCLUDE_SCOPE) \
          $(INCLUE_LINKED_LIST) $(INCLUDE_SEMANTICS) $(INCLUDE_TYPES)

INCLUDES = -I src -I src/lib -I src/lib/parser -I src/lib/parser/grammar -I .

.PHONY: all build run clean

all: build

build: lex.yy.c y.tab.c $(SOURCES) $(HEADERS)
	$(CC) y.tab.c lex.yy.c $(SOURCES) $(INCLUDES) -o $(TARGET)

y.tab.c: $(INPUT_YACC)
	$(YACC) $(YFLAGS) $(INPUT_YACC)

lex.yy.c: $(INPUT_LEX) y.tab.c
	$(LEX) $(INPUT_LEX)

run: build
	./$(TARGET) $(TEST_FILE) $(OUTPUT_FILE)

testc: run
	gcc $(OUTPUT_FILE) -lm -o $(OUTPUT_C_TARGET)
	./$(OUTPUT_C_TARGET)

clean:
	rm -f lex.yy.c y.tab.c y.tab.h y.output $(TARGET) $(OUTPUT_C_TARGET)