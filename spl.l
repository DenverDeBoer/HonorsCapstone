/**
* Lexer for SPL language
* Written By: Denver DeBoer
*/

/*
Definition
*/
%{
#include "splParser.tab.h"
%}
  
/**
Rule Section
These rules govern the validity of tokens for the language
**/
%%
\"[^"]*\" {return yytext[0];}
"while"	{return WHILE;}
"if"	{return IF;}
"else"	{return ELSE;}
"display" {return DISPLAY;}
[A-Za-z][A-Za-z0-9]* {return WORD;}
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
">" {return GREATERTHAN;}
"<" {return LESSTHAN;}
"=" {return EQUAL;}
"!" {return NOT;}
";" {return EOL;}
[\t\n ] {;}
. {return yytext[0];}
%%
 
/**
Code Section
Provides additional C code functionalities
**/
