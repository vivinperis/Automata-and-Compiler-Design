%{
	#include <stdio.h> 
	#include "y.tab.h" 
	extern int yycolumn;
	extern int yyleng;
%}


SPACE			[ \t\v\f]
SINGLE_CHAR		[=(){};]

DEFINE "define"
INCLUDE "include"

%%

\n 		{ yycolumn = 0; yylineno++; }

([#][" "]*({INCLUDE})[ ]*([<]?)([A-Za-z]+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"]	 
([#][" "]*({DEFINE})[" "]*([A-Za-z]+)(" ")*[0-9]+)/["\n"|\/|" "|"\t"]		 


[0-9]+ |
[0-9]+\.[0-9]+		{ yycolumn += yyleng; return NUM; }
\".*\"            { yycolumn += yyleng; return STRING; }
"++" |
"--"	      { yycolumn += yyleng; return U_OPERATOR; }
"==" |
"<" |
">" |
"<=" |
">=" |
"!="		{ yycolumn += yyleng; return RELATIONAL; }
\+ |
\- |
\* |
\/ |        { yycolumn += yyleng; return ARITHMETIC}
{SPACE}		{ yycolumn += yyleng; }
"if"            { yycolumn += 2; return IF; }
"for"           { yycolumn += 3; return FOR; }
"int"		{ yycolumn += 3; return INT;}
"else"          { yycolumn += 4; return ELSE; }
"main()"        { yycolumn += 6; return MAIN; }
"char"		{ yycolumn += 4; return CHAR;}
"float"		{ yycolumn += 5; return FLOAT;}
"return"	{ yycolumn += 6;  return RETURN;}
"printf"    { yycolumn += 6; return PRINTF;}
[a-zA-Z_][a-zA-Z_0-9]*  		{ yycolumn += yyleng; return IDENTIFIER; }
{SINGLE_CHAR}   { yycolumn++; return yytext[0]; }
.		{ yycolumn += 1; return yytext[0];}

%%
  
int yywrap() {  
	return -1;  
}
