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
       | program print EOL
;

print: equation
       | DISPLAY var	{printf("%s\n", $1);}
;

var: WORD EQUAL NUMBER	{$$ = $3;}
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
   | OPENPAR addsub CLOSEPAR
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
