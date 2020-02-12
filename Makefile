SPL: spl.l splParser.y
	bison -d splParser.y
	flex spl.l
	gcc splParser.tab.c lex.yy.c -lfl -o spl
