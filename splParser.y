/*
* Parser for SPL language
* Written By: Denver DeBoer
*/

%{
#include <stdio.h>
#include <math.h>
%}

/* Declearation of Tokens */
%token WORD NUMBER
%token ADD SUB MUL DIV POW
%token OPENPAR CLOSEPAR OPENBRACE CLOSEBRACE OPENBRACKET CLOSEBRACKET QUOTE
%token WHILE GREATERTHAN LESSTHAN EQUAL NOT IF ELSE
%token EOL

%%
/* Rules Section */
program: /*EMPTY*/
       | program addsub EOL {printf("= %d\n", $2);}
;

addsub: muldiv
	  | muldiv ADD muldiv {$$ = $1 + $3;}
	  | muldiv SUB muldiv {$$ = $1 - $3;}
;

muldiv: power
      | power MUL power {$$ = $1 * $3;}
      | power DIV power {$$ = $1 / $3;}
;

power: NUMBER
     | NUMBER POW power {$$ = $1 * $1;}
;
%%

/* Code Section */
int main(int argc, char** argv)
{
	yyparse();
}

int yyerror(char* e)
{
	fprintf(stderr, "ERROR: %s\n", e);
}
