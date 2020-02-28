/**
* Lexer for SPL language
* Written By: Denver DeBoer
* Resource: https://www.oreilly.com/library/view/flex-bison/9780596805418/ch01.html
*/

/**
Definition
Contains a list of values for each token in the language
An integer that can hold the value of numbers
**/
%{
#include "splParser.tab.h"
/**
enum yytokentype {
	COMMENT Words and Numbers
	WORD = 258,
	NUMBER = 259,

	COMMENT Mathematical Operations
	ADD = 260,
	SUB = 261,
	MUL = 262,
	DIV = 263,
	POW = 264,

	COMMENT Special Symbols
	OPENPAR = 265,
	CLOSEPAR = 266,
	OPENBRACE = 267,
	CLOSEBRACE = 268,
	OPENBRACKET = 269,
	CLOSEBRACKET = 270,
	QUOTE = 271,

	COMMENT Loops and Conditionals
	WHILE = 272,
	GREATERTHAN = 273,
	LESSTHAN = 274,
	EQUAL = 275,
	NOT = 276,
	IF = 277,
	ELSE = 278,

	COMMENT End of Line
	EOL = 279
};

int yylval;
**/
%}
  
/**
Rule Section
These rules govern the validity of tokens for the language
**/
%%
"while"	{return WHILE;}
"if"	{return IF;}
"else"	{return ELSE;}
[A-Za-z]+ {return WORD;}
[0-9]+ {yylval = atoi(yytext); return NUMBER;}
-[0-9]+ {yylval = atoi(yytext); return nNUMBER;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"^" {return POW;}
"(" {return OPENPAR;}
")" {return CLOSEPAR;}
"{" {return OPENBRACE;}
"}" {return CLOSEBRACE;}
"[" {return OPENBRACKET;}
"]" {return CLOSEBRACKET;}
(\"|') {return QUOTE;}
">" {return GREATERTHAN;}
"<" {return LESSTHAN;}
"=" {return EQUAL;}
"!" {return NOT;}
"\n" {return EOL;}
[\t ] {}
"display" {return DISPLAY;}
. {printf("%s is an invalid character\n", yytext);}
%%
 
/**
Code Section
Provides additional functionalities
**/

/**
int yywrap(){}; 	//Wraps the rule section

//Print each token received and the associated value
int main(int argc, char** argv) {
	int token;
	
	while(token = yylex()) {
		printf("%d", token);
		if(token == NUMBER)
			printf(" = %d\n", yylval);
		else
			printf(" = %s\n", yytext);
	}
	printf("\n");
	return 0;
}
**/
