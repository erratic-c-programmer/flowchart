%define parse.trace

%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

char *proctext(char *s)
{
    s[strlen(s) - 1] = 0;
    return s + 1;
}

int nid = 1;
%}

%union {
    int ival;
    float fval;
    char *sval;
}

%token <ival> INTEG
%token <fval> FLOAT

%token SWTCH
%token SCASE
%token WHILE
%token OBRCE
%token CBRCE

%token <sval> IDENT
%token <sval> PTEXT

%type <sval> flowchart caseexprs

%%

input:
     flowchart { printf("%s\n", $1); }
     ;

flowchart:
         %empty { $$ = strdup(""); }
         | flowchart PTEXT {
            asprintf(&$$, "%s %d[%s]", $1, nid++, proctext($2));
            free($1);
            free($2);
         }

         | flowchart WHILE PTEXT OBRCE flowchart CBRCE {
            asprintf(&$$, "%s while (\"%s\") { %s }", $1, proctext($3), $5);
            free($1);
            free($3);
            free($5);
         }
         | flowchart SWTCH PTEXT OBRCE caseexprs CBRCE {
            asprintf(&$$, "%s switch (\"%s\") { %s }", $1, proctext($3), $5);
            free($1);
            free($3);
            free($5);
         }
         ;

caseexprs:
        %empty { $$ = strdup(""); }
        | caseexprs PTEXT SCASE OBRCE flowchart CBRCE {
            asprintf(&$$, "case \"%s\": { %s } %s", proctext($2), $5, $1);
            free($1);
            free($2);
            free($5);
        }
        ;

%%

int main(void)
{
    //yydebug = 1;
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    printf("Parse error: %s\n", s);
}
