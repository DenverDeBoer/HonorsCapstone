/*
* Parser for SPL language
* Written By: Denver DeBoer
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbolTable.h"
#include "codeGenerator.h"
#include "stackMachine.h"

int yylex(void);
void yyerror(char*);

//Labels for data, if statement, and while loop
struct labels {
	int forGOTO;
	int forJMP_FALSE;
};

//Allocates space for labels
struct labels* newLabels() {
	return (struct labels*) malloc(sizeof(struct labels));
}

//Install identifier and check if previously defined
void install(char* sName) {
	struct node* s = getSymbol(sName);
	if(s == 0)
		s = putSymbol(sName);
	else
		printf("ERROR: splParser.y -> install -> %s already defined\n", sName);
}

//If identifier is defined then generate code
void contextCheck(enum codeOps operation, char* sName) {
	struct node* identifier = getSymbol(sName);
	if(identifier == 0)
		printf("ERROR: splParser.y -> contextCheck -> %s is undeclared identifier\n", sName);
	else
		generateCode(operation, identifier->offset);
}
%}

/* Semantic Record */
%union semanticRecord {
	int intValue;
	char* id;
	struct labels* lbs;
}

/* Declearation of Tokens */
%start program
%token <id> STRING WORD
%token <intValue> NUMBER nNUMBER
%token <lbs> WHILE IF
%token ELSE GREATERTHAN LESSTHAN EQUALITY EQUAL NOT
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
statement: addsub		/*COMPLETED*/
	 | conditional		/*COMPLETED -> GTE, LTE, Singular*/
	 | var			/*COMPLETED -> string*/
	 | print		/*COMPLETED -> string/READ*/
	 | ifstat
	 | loop
;

/* Handles addition and subtraction */
addsub: addsub ADD muldiv	{generateCode(ADD, 0);}
      | addsub SUB muldiv	{generateCode(SUB, 0);}
      | addsub nNUMBER		{generateCode(ADD, 0);}
      | muldiv
;

/* Handles multiplication and division */
muldiv: muldiv MUL power	{generateCode(MUL, 0);}
      | muldiv DIV power	{generateCode(DIV, 0);}
      | power
;

/* Handles exponents */
power: term POW power		{generateCode(POW, 0);}
     | term
;

/* Handles conditionals */
conditional: term LESSTHAN term		{generateCode(LT, 0);}
	   | term GREATERTHAN term	{generateCode(GT, 0);}
	   | term EQUALITY term		{generateCode(EQ, 0);}
/******************GTE LTE SINGULAR****************************/
;

/* Positive or negative numbers, and parentheses */
term: NUMBER			{generateCode(LD_INT, $1);}
    | nNUMBER			{generateCode(LD_INT, $1);}
    | WORD			{generateCode(LD_VAR, $1);}
    | OPENPAR addsub CLOSEPAR
;

/* Assigns value to variable */
var: WORD EQUAL addsub		{contextCheck(STORE, $1);}
/*******************WORD EQUALS STRING*************************/
;

/* Displays information to the screen */
print: DISPLAY OPENPAR addsub CLOSEPAR		{generateCode(WRITE_INT, 0);}
/**********************DISPLAY STRING**********************/
/**********************READ INPUT**************************/
;

/* If statement to test if a block of code should be run */
ifstat: IF OPENPAR conditional CLOSEPAR		{$1 = (struct labels*) newLabels();
      						 $1->forJMP_FALSE = reserveLocation();}
        OPENBRACE statement CLOSEBRACE		{$1->forGOTO = reserveLocation();}
	ELSE OPENBRACE statement CLOSEBRACE	{backpatch($1->forJMP_FALSE, JMP_FALSE, codeLocation());}
;

/* While loop to execute a block of code numerous times */
loop: WHILE OPENPAR conditional CLOSEPAR OPENBRACE statement CLOSEBRACE
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
