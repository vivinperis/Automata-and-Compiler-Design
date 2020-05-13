%{
int checkcomment = 0;
int keyword_count = 0;
int id = 0;
%}
void comment();
identifier [a-zA-Z_][a-zA-Z0-9_]*

%%

#.* {printf("id = %d  %s is a Preprocessor Directive\n", id++,yytext);}

void |
auto |
const |
short |
unsigned |
signed |
enum |
long |
case |
switch |
return |
else |
while |
for |
struct |
typedef |
register |
default |
goto |
sizeof |
volatile |
extern |
do |
if |
int |
float |
char |
double |
break |
continue |
union |
goto {keyword_count++; printf("%s is a Keyword\n", yytext);}

"/*" {checkcomment = 1;} {printf("%s */ is a Multiline Comment\n", yytext); comment();}
"//".* { /* consume //-comment */ printf("id = %d  // is a Single Line Comment\n",id++); }

{identifier}\( {if (!checkcomment) printf("id = %d  %s is a Function\n", id++ , yytext);}

\{ {if (!checkcomment) printf("id = %d Block Begins\n",id++);}
\} {if (!checkcomment) printf("id = %d  Block Ends\n",id++);}

{identifier}(\[[0-9]*\])? {if (!checkcomment) printf("id = %d  %s is an Identifier\n",id++, yytext);}

\".*\" {if (!checkcomment) printf("id = %d  %s is a String\n",id++, yytext);}

\'.\'' {if (!checkcomment) printf("id = %d  %s is a Character literal\n",id++, yytext);}

[0-9]+ {if (!checkcomment) printf("id = %d  %s is a Numeric literal\n",id++, yytext);}

\)(\:)? {if( !checkcomment) printf("\n"); ECHO;}
\( ECHO;

"++" |
"--" {if (!checkcomment) printf("id = %d  %s is a Unary Operator\n",id++, yytext);}


[,;] {if (!checkcomment) printf("id = %d  %s is a Separator\n",id++, yytext);}

&& |
"||" |
! {if (!checkcomment) printf("id = %d  %s is a Logical Operator\n",id++, yytext);}

& |
\| |
">>" |
"<<" |
"~" |
"^" {if (!checkcomment) printf("id = %d  %s is a Bitwise Operator\n",id++, yytext);}

\+ |
\- |
\* |
\/ |
% {if (!checkcomment) printf("id = %d  %s is a Arithmetic Operator\n",id++, yytext);}

"==" |
"<" |
">" |
"<=" |
">=" |
"!=" {if (!checkcomment) printf("id = %d %s is a relational operator\n", id++, yytext);}

\= |
"+=" |
"-=" |
"*=" |
"/=" |
"%=" {if (!checkcomment) printf("id = %d  %s is a Assignment Operator\n",id++, yytext);}


%%

int main()
{
char fileName[100];
printf("Enter the name of the file to open: ");
scanf("%s", fileName);

FILE* fp = fopen(fileName, "r");
if (!fp)
{
printf("File could not be opened\n");
exit(0);
}

yyin = fp;
printf("\n");
yylex();

printf("\nNumber of keywords: %d\n", keyword_count);
}

int yywrap()
{
return 1;
}

void comment()
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
            {
            checkcomment = 0;
                return;
            }

            if (c == 0)
                break;
        }
    printf("Unterminated Comment\n");
    exit(-1);
}