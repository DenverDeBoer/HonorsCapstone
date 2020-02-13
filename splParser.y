/*
* Parser for SPL language
* Written By: Denver DeBoer
*/

%{
#include <stdio.h>
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
       | program expression EOL {printf("= %d\n", $2);}
;

expression: factor
	  | expression ADD factor {$$ = $1 + $3;}
	  | expression SUB factor {$$ = $1 - $3;}
;

factor: term
      | factor MUL term {$$ = $1 * $3;}
      | factor DIV term {$$ = $1 / $3;}
;

term: NUMBER
;

%%

/* Code Section */
main(int argc, char** argv)
{
	yyparse();
}

yyerror(char* e)
{
	fprintf(stderr, "ERROR: %s\n", e);
}
