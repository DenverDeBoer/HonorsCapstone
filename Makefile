SPL: spl.l splParser.y
	bison -d splParser.y
	gcc -c splParser.tab.c
	flex spl.l
	gcc -c lex.yy.c
	gcc -o spl splParser.tab.o lex.yy.o -lm
