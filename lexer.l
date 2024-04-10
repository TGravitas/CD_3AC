%{
#include "y.tab.h"
extern char *yytext; // yytext is provided by Flex to hold the matched text
extern int yylval;   // Declare yylval as an external variable
char *identifier_value; // Global variable to store the value of IDENTIFIER token
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }
"int"       { return INT; }
"printf"    { return PRINTF; }
"return"    { return RETURN; }
"scanf"     { return SCANF; }
"while"     { return WHILE; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULTIPLY; }
"/"         { return DIVIDE; }
"="         { return ASSIGN; }
"=="        { return EQUAL; }
"!="        { return NOTEQUAL; }
"<"         { return LESS; }
">"         { return GREATER; }
"<="        { return LESSEQUAL; }
">="        { return GREATEREQUAL; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*    { identifier_value = strdup(yytext); return IDENTIFIER; }
[ \t\n]+    ;  /* skip whitespace */
.           { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
