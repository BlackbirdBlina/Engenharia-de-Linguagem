CC = gcc
LEX = flex
YACC = yacc
YFLAGS = -d -v

INPUT_LEX = src/lexer.l
INPUT_YACC = src/parser.y
RECORD = src/lib/symbolTable/impls/record.c
HASH_TABLE = src/lib/symbolTable/impls/symbol_table.c
INCLUDES = src/lib/symbolTable/includes
TARGET = compilador
TEST_FILE = tests/prob-1.kjt
OUTPUT_FILE = tests/output.c
OUTPUT_C_TARGET = testcode

.PHONY: all build run clean

all: build

build: lex.yy.c y.tab.c
	$(CC) y.tab.c lex.yy.c $(HASH_TABLE) -I $(INCLUDES) -o $(TARGET) $(RECORD)

y.tab.c: $(INPUT_YACC)
	$(YACC) $(YFLAGS) $(INPUT_YACC)

lex.yy.c: $(INPUT_LEX)
	$(LEX) $(INPUT_LEX)

run: build
	./$(TARGET) $(TEST_FILE) $(OUTPUT_FILE)

testc: run
	gcc $(OUTPUT_FILE) -lm -o $(OUTPUT_C_TARGET)
	./$(OUTPUT_C_TARGET)

clean:
	rm -f lex.yy.c y.tab.c y.tab.h y.output $(TARGET)
