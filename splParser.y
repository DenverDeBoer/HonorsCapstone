/*
* Parser for SPL language
* Written By: Denver DeBoer
*/

%{
#include <stdio.h>
#include <math.h>
#include <string.h>
int yylex(void);
void yyerror(char*);
%}

/* Declearation of Tokens */
%token STRING WORD NUMBER nNUMBER
%token ADD SUB MUL DIV POW
%token OPENPAR CLOSEPAR OPENBRACE CLOSEBRACE OPENBRACKET CLOSEBRACKET QUOTE
%token WHILE GREATERTHAN LESSTHAN EQUAL NOT IF ELSE
%token EOL DISPLAY

%%
/* Rules Section */
program: /*EMPTY*/
       | program addsub EOL	{printf("%d\n", $2);}
       | program var EOL
       | program print EOL
;

addsub: addsub ADD addsub {$$ = $1 + $3;}
      | addsub SUB addsub {$$ = $1 - $3;}
      | addsub nNUMBER {$$ = $1 + $2;}
      | muldiv
;

muldiv: muldiv MUL muldiv {$$ = $1 * $3;}
      | muldiv DIV muldiv {if($3 != 0) $$ = $1 / $3; else printf("DIVISION BY ZERO ERROR\n");}
      | power
;

power: power POW power {if($3==0) $$=1; else{int x = $1; for(int i = 0; i < $3-1; i++) x*=$1; $$ = x;}}
     | term
;

term: NUMBER			{$$ = $1;}
   | nNUMBER			{$$ = $1;}
   | OPENPAR addsub CLOSEPAR	{$$ = $2;}
;

var: WORD EQUAL contents	{$$ = $3;}	/*BUG: Storing arithemtic results*/
;

print: DISPLAY OPENPAR contents CLOSEPAR	{printf("%d\n", $3);} /* BUG: displaying text */
;

contents: WORD	{$$ = $1;}
	| addsub {$$ = $1;}
	| STRING {$$ = $1;} /*{char s[10]; char c[] = $1; if(strlen(c) > 2) strncpy(s, c+1, strlen(c)-2); else s = ""; $$ = s;}*/
;
%%

/* Code Section */
int main(int argc, char** argv)
{
	yyparse();
}

void yyerror(char* e)
{
	fprintf(stderr, "ERROR: %s\n", e);
}
