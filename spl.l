
/**
Definition
Contains variables that can be accessed in
yylex() and main()
**/
%{
%}
  
/**
Rule Section
These rules govern the validity of statements written
for the language
As a test...reads characters and returns if they are valid or not
**/
%%
[A-Z] {printf("%s is a capital letter and valid\n", yytext);}
[a-z] {printf("%s is a lowercase letter and valid\n", yytext);}
[0-9] {printf("%s is a digit and valid\n", yytext);}
[-\+\*/] {printf("%s is an arithmetic and is valid\n", yytext);}
[\t\n ] {printf("%s is whitespace and valid\n", yytext);}
. {printf("%s is an invalid character\n", yytext);}
(END) {return 0;}
%%
 
/**
Code Section
Provides additional functionalities
**/
int yywrap(){} 	//Wraps the rule section
int main(){
yylex();	//Main FLEX function that runs the rules section  
return 0;
}
