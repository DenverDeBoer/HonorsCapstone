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
       | program equation EOL
       | program print EOL
;

print: DISPLAY OPENPAR WORD CLOSEPAR	{printf("%d\n", $3);}
     | DISPLAY OPENPAR equation CLOSEPAR	{printf("%d\n", $3);}
;

equation: addsub	{printf("%d\n", $1);}
	| WORD EQUAL addsub {int $$ = $3;}		/* BUG: equations don't assign result to variable */
;

addsub: addsub ADD addsub {$$ = $1 + $3;}
      | addsub SUB addsub {$$ = $1 - $3;}
      | addsub nNUMBER {$$ = $1 + $2;}
      | muldiv
;

muldiv: muldiv MUL muldiv {$$ = $1 * $3;}
      | muldiv DIV muldiv {$$ = $1 / $3;}
      | power
;

power: power POW power {if($3==0) $$=1; else{int x = $1; for(int i = 0; i < $3-1; i++) x*=$1; $$ = x;}}
     | term
;

term: NUMBER			{$$ = $1;}
   | nNUMBER			{$$ = $1;}
   | OPENPAR addsub CLOSEPAR	{$$ = $2;}
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
