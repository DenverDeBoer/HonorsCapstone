/*
* Parser for SPL language
* Written By: Denver DeBoer
*/

%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char*);
%}

/* Declearation of Tokens */
%start program
%token STRING WORD NUMBER nNUMBER
%token WHILE IF ELSE
%token GREATERTHAN LESSTHAN EQUAL NOT
%left ADD SUB
%left MUL DIV
%right POW
%token OPENPAR CLOSEPAR OPENBRACE CLOSEBRACE OPENBRACKET CLOSEBRACKET
%token EOL DISPLAY

%%
/* Rules Section */
program: /*EMPTY*/
       | program statement EOL
;

/* Branches off into various functions of the language */
statement: addsub
	 | var
	 | print
	 | ifstat
;

/* Handles addition and subtraction */
addsub: addsub ADD muldiv
      | addsub SUB muldiv
      | addsub nNUMBER
      | muldiv
;

/* Handles multiplication and division */
muldiv: muldiv MUL power
      | muldiv DIV power
      | power
;

/* Handles exponents */
power: term POW power
     | term
;

/* Positive or negative numbers, and parentheses */
term: NUMBER
    | nNUMBER
    | WORD
    | OPENPAR addsub CLOSEPAR
;

/* Assigns value to variable */
var: WORD EQUAL term
/*******************WORD EQUALS STRING*************************/
;

/* Displays information to the screen */
print: DISPLAY OPENPAR addsub CLOSEPAR
/**********************DISPLAY STRING**********************/
;

/* If statement to test if a block of code should be run */
ifstat: IF OPENPAR term LESSTHAN term CLOSEPAR OPENBRACE statement CLOSEBRACE
      | IF OPENPAR term GREATERTHAN term CLOSEPAR OPENBRACE statement CLOSEBRACE
      | IF OPENPAR term EQUAL EQUAL term CLOSEPAR OPENBRACE statement CLOSEBRACE
      | IF OPENPAR term LESSTHAN EQUAL term CLOSEPAR OPENBRACE statement CLOSEBRACE
      | IF OPENPAR term GREATERTHAN EQUAL term CLOSEPAR OPENBRACE statement CLOSEBRACE
;
%%

/* Code Section */
int main(int argc, char** argv)
{
	if((argc > 1) && (freopen(argv[1], "r", stdin) == NULL)) {
		printf("ERROR opening file\n");
		exit(1);
	}
	yyparse();
}

void yyerror(char* e)
{
	fprintf(stderr, "ERROR: %s\n", e);
}
