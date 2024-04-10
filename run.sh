#!/bin/bash

sudo apt install graphviz -y
lex lexer.l
yacc -d parser.y
gcc lex.yy.c y.tab.c prime.c -o pal_parser
bison --report=states,itemsets --graph parser.y
dot -Tpng parser.gv -o parser.png
bison -v parser.y
gcc -fdump-tree-all prime.c
gcc -O0 -fdump-tree-gimple -c prime.c
objdump -d a.out > machine_code.txt

sudo apt install libfl-dev libbison-dev -y
gcc y.tab.c -ll -ly -w
./a.out > 3AC.txt

echo "Done. View parser.output, parser.png, 3AC.txt and machine_code.txt"