%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "flow.tab.h"

#define tokadd(t, x, rt) do { yylval.t##val = x; return rt; } while (0)
int n = 0;
%}

lettr [A-Za-z_]
digit [0-9]
alpha ({lettr}|{digit})
whtsp [ \t\n]+
ptext [^\]\[]*

%%

\[([^\[\]]|\\.)*\]  tokadd(s, strdup(yytext), PTEXT);

"switch"            tokadd(i, 0, SWTCH);
"->"                tokadd(i, 0, SCASE);
"while"             tokadd(i, 0, WHILE);
"{"                 tokadd(i, 0, OBRCE);
"}"                 tokadd(i, 0, CBRCE);

{lettr}{alpha}*     tokadd(s, strdup(yytext), IDENT);
{digit}+            tokadd(i, atoi(yytext), INTEG);
{digit}+\.{digit}+  tokadd(f, atof(yytext), FLOAT);

{whtsp} ;

%%
