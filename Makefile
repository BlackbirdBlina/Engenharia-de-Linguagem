CC = gcc
LEX = flex
YACC = yacc
YFLAGS = -d -v

INPUT_LEX = src/lexer.l
INPUT_YACC = src/parser.y
HASH_TABLE = src/symbolTable/impls/hash_table.c
INCLUDES = src/symbolTable/includes
TARGET = compilador
TEST_FILE = tests/all_tests.kjt

.PHONY: all build run clean

all: build

build: lex.yy.c y.tab.c
	$(CC) y.tab.c lex.yy.c $(HASH_TABLE) -I $(INCLUDES) -o $(TARGET)

y.tab.c: $(INPUT_YACC)
	$(YACC) $(YFLAGS) $(INPUT_YACC)

lex.yy.c: $(INPUT_LEX)
	$(LEX) $(INPUT_LEX)

run: build
	./$(TARGET) < $(TEST_FILE)

clean:
	rm -f lex.yy.c y.tab.c y.tab.h y.output $(TARGET)
