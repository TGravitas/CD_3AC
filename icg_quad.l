%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int line = 0;
    #define YYSTYPE char *
    extern int yylval;
    #include "y.tab.h"  // Include the Yacc header file
%}

alpha [A-Za-z_]
digit [0-9]
%option yylineno
%%
[ \t\n] { /* Ignore whitespace and newline */ }
":" { return T_colon; }
"?" { return T_ques; }
"while" { return WHILE; }
"for" { return FOR; }
"if" { return IF; }
"else" { return ELSE; }
"cout" { return COUT; }
"endl" { return ENDL; }
"break" { return BREAK; }
"continue" { return CONTINUE; }
"int" { return INT; }
"float" { return FLOAT; }
"char" { return CHAR; }
"void" { return VOID; }
"#include" { return INCLUDE; }
"main()" { return MAINTOK; }
{digit}+    { yylval = atoi(yytext); return NUM; } // Convert string to integer and return
{digit}+"."{digit}+ { yylval = atof(yytext); return FLOATNUM; } // Convert string to float and return
{alpha}({alpha}|{digit})* { yylval = strdup(yytext); return ID; }
{alpha}({alpha}|{digit})*"\.h"?  { return H; }
\".*\" { yylval = strdup(yytext); return STRING; }
"<" { return T_lt; }
">" { return T_gt; }
"=" { return T_eq; }
"<=" { return T_lteq; }
">=" { return T_gteq; }
"==" { return T_eqeq; }
"!=" { return T_neq; }
"+" { return T_pl; }
"-" { return T_min; }
"*" { return T_mul; }
"/" { return T_div; }
"++" { return T_incr; }
"--" { return T_decr; }
"!" { return T_not; }
"||" { return T_or; }
"&&" { return T_and; }
"%" { return T_percent; }
. { return yytext[0]; } // Return single characters
%%

