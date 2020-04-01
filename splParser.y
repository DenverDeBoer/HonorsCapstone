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
       | program statement EOL	{printf("PROGRAM: %d\n", $2);}
;

/* Branches off into various functions of the language */
statement: addsub
	 | var
	 | print
	 | ifstat
;

/* Handles addition and subtraction */
addsub: addsub ADD muldiv {$$ = $1 + $3;}
      | addsub SUB muldiv {$$ = $1 - $3;}
      | addsub nNUMBER	  {$$ = $1 + $2;}
      | muldiv
;

/* Handles multiplication and division */
muldiv: muldiv MUL power {$$ = $1 * $3;}
      | muldiv DIV power {if($3 != 0) $$ = $1 / $3; else;}
      | power
;

/* Handles exponents */
power: term POW power {if($3==0) $$=1; else{int x = $1; for(int i = 0; i < $3-1; i++) x*=$1; $$ = x;}}
     | term
;

/* Positive or negative numbers, and parentheses */
term: NUMBER			{$$ = $1;}
    | nNUMBER			{$$ = $1;}
    | WORD			{$$ = $1;}
    | OPENPAR addsub CLOSEPAR	{$$ = $2;}
;

/* Assigns value to variable */
var: WORD EQUAL term	{$$ = $3;}
/* WORD EQUALS STRING */
;

/* Displays information to the screen */
print: DISPLAY OPENPAR addsub CLOSEPAR {printf("DISPLAY: %d\n", $3);}
/* DISPLAY STRING */
;

/* If statement to test if a block of code should be run */
ifstat: IF OPENPAR term LESSTHAN term CLOSEPAR OPENBRACE statement CLOSEBRACE 		{if($3 < $5) printf("LT: %d\t%d\n", $3,$5); else printf("FALSE\n");}
      | IF OPENPAR term GREATERTHAN term CLOSEPAR OPENBRACE statement CLOSEBRACE  	{if($3 > $5) printf("GT: %d\t%d\n", $3,$5); else printf("FALSE\n");}
      | IF OPENPAR term EQUAL EQUAL term CLOSEPAR OPENBRACE statement CLOSEBRACE 	{if($3 == $6) printf("EE: %d\t%d\n", $3,$6); else printf("FALSE\n");}
      | IF OPENPAR term LESSTHAN EQUAL term CLOSEPAR OPENBRACE statement CLOSEBRACE 	{if($3 <= $6) printf("LTE: %d\t%d\n", $3,$6); else printf("FALSE\n");}
      | IF OPENPAR term GREATERTHAN EQUAL term CLOSEPAR OPENBRACE statement CLOSEBRACE  {if($3 >= $6) printf("GTE: %d\t%d\n", $3,$6); else printf("FALSE\n");}
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
