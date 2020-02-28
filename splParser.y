/*
* Parser for SPL language
* Written By: Denver DeBoer
*/

%{
#include <stdio.h>
#include <math.h>
int yylex(void);
void yyerror(char*);
%}

/* Declearation of Tokens */
%token WORD NUMBER
%token ADD SUB MUL DIV POW
%token OPENPAR CLOSEPAR OPENBRACE CLOSEBRACE OPENBRACKET CLOSEBRACKET QUOTE
%token WHILE GREATERTHAN LESSTHAN EQUAL NOT IF ELSE
%token EOL DISPLAY

%%
/* Rules Section */
program: /*EMPTY*/
       | program equation EOL
       | program print EOL
;

print: var
       | DISPLAY WORD	{printf("%s\n", $1);}		/* BUG: displaying to screen */
;

var: WORD EQUAL NUMBER	{$$ = $3;}			/* BUG: declaring and initializing variables */
;

equation: addsub	{printf("= %d\n",$1);}
;

addsub: addsub ADD addsub {$$ = $1 + $3;}
      	| addsub SUB addsub {$$ = $1 - $3;}
	| muldiv
;

muldiv: muldiv MUL muldiv {$$ = $1 * $3;}
      	| muldiv DIV muldiv {$$ = $1 / $3;}
	| power
;

power: power POW power {if($3==0) $$=1; else{int x = $1; for(int i = 0; i < $3-1; i++) x*=$1; $$ = x;}}
     | par
;

par: NUMBER
   | OPENPAR addsub CLOSEPAR				/* BUG: parenthesis in order of operatons */
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
