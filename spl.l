/*
* Lexer for SPL language
* Written By: Denver DeBoer
*/

/* Definition */
%{
#include "splParser.tab.h"
#include <string.h>
%}
  
/* Rule */
%%
\"[^"]*\" {return yytext[0];}
"start"	{return START;}
"end"	{return END;}
"while"	{return WHILE;}
"if"	{return IF;}
"else"	{return ELSE;}
"display" {return DISPLAY;}
[A-Za-z][A-Za-z0-9]* {yylval.id = (char*)strdup(yytext); return WORD;}
[0-9]+ {yylval.intValue = atoi(yytext); return NUMBER;}
-[0-9]+ {yylval.intValue = atoi(yytext); return nNUMBER;}
"+" {return ADDITION;}
"-" {return SUBTRACTION;}
"*" {return MULTIPLICATION;}
"/" {return DIVISION;}
"^" {return EXPONENT;}
"(" {return OPENPAR;}
")" {return CLOSEPAR;}
"{" {return OPENBRACE;}
"}" {return CLOSEBRACE;}
"[" {return OPENBRACKET;}
"]" {return CLOSEBRACKET;}
">" {return GREATERTHAN;}
"<" {return LESSTHAN;}
"==" {return EQUALITY;}
"=" {return EQUAL;}
"!" {return NOT;}
";" {return EOL;}
[\t\n ] {}
. {return yytext[0];}
%%
 
/* Code Section */
int yywrap(void){}
