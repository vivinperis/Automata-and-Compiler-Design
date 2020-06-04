%{ 
    int yyerror(const char* s);
    int yylex();
	#include "stdio.h"
    int success = 1, errors = 0, yycolumn = 0;
      
%} 
  

%token IF 
%token FOR 
%token IDENTIFIER
%token U_OPERATOR 
%token ARITHMETIC
%token RELATIONAL 
%token NUM 
%token INT CHAR FLOAT
%token RETURN MAIN
%token PRINTF
%token STRING
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%left '+' '-'
%left '*' '/'

%%
   STMTS :   STMTS STMT
         |   %empty
         ;
   STMT  :   ';'
         |   EXPR ';'
         |   IF '('EXPR')' STMT  %prec LOWER_THAN_ELSE
         |   IF '('EXPR')' STMT ELSE STMT
         |   FOR '('EXPR';'EXPR';'EXPR')' STMT
         |   PRINTF '(' STRING ')' STMT
         |   '{'STMTS'}'
	     |   INT MAIN 
         ;
   EXPR  :  TERM
         |  IDENTIFIER U_OPERATOR
         |  U_OPERATOR IDENTIFIER
         |  TERM RELATIONAL EXPR
         |  TERM ARITHMETIC EXPR
         |  IDENTIFIER '=' EXPR
	     |  INT DEFINE
	     |  CHAR DEFINE
	     |  FLOAT DEFINE
         ;

   DEFINE: IDENTIFIER
         | IDENTIFIER '=' IDENTIFIER 
   TERM  :  IDENTIFIER
         |  NUM
         ;
    
%% 

extern FILE *yyin;

int main(int argc , char **argv) {
    yyin = fopen(argv[1], "r");
    yyparse();
    if(success) {
        printf("OK\n");
    }
    else {
        printf("\n%d error(s) occured\n", errors);
    }
    return 0;
}

int yyerror(const char *msg) {
    extern char* yytext;
    extern int yylineno;
    extern int yycolumn;
    printf("\nError occured at column %d of the line %d near '%s'\nError: %s\n", yycolumn, yylineno, yytext, msg);
    errors++;
    success = 0;
    return 1;
}
