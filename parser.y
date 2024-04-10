%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h" // Include the YACC-generated header file

// Define YYSTYPE if not already defined
#ifndef YYSTYPE
#define YYSTYPE int // Change int to the type you need for yylval
#endif

extern int yylex(); // Declare yylex function
extern char *identifier_value; // Declare identifier_value as an external variable
extern int yylval; // Declare yylval as an external variable

extern int isPrime(int num); // Declaration for the prime checking function

%}

%token IF ELSE INT PRINTF RETURN SCANF WHILE PLUS MINUS MULTIPLY DIVIDE ASSIGN EQUAL NOTEQUAL LESS GREATER LESSEQUAL GREATEREQUAL LPAREN RPAREN LBRACE RBRACE SEMICOLON NUMBER IDENTIFIER

%%
program : statement_list
        ;
        
statement_list : statement
               | statement_list statement
               ;

statement : expression_statement
          | if_statement
          | while_statement
          | declaration_statement
          | print_statement
          | scan_statement
          ;

expression_statement : expression SEMICOLON { printf("Result: %d\n", $1); fflush(stdout); }
                      ;

expression : IDENTIFIER ASSIGN expression
           | simple_expression { $$ = $1; }
           ;

simple_expression : additive_expression
                  | simple_expression EQUAL additive_expression { $$ = ($1 == $3) ? 1 : 0; }
                  | simple_expression NOTEQUAL additive_expression { $$ = ($1 != $3) ? 1 : 0; }
                  | simple_expression LESS additive_expression { $$ = ($1 < $3) ? 1 : 0; }
                  | simple_expression GREATER additive_expression { $$ = ($1 > $3) ? 1 : 0; }
                  | simple_expression LESSEQUAL additive_expression { $$ = ($1 <= $3) ? 1 : 0; }
                  | simple_expression GREATEREQUAL additive_expression { $$ = ($1 >= $3) ? 1 : 0; }
                  ;

additive_expression : multiplicative_expression
                     | additive_expression PLUS multiplicative_expression { $$ = $1 + $3; }
                     | additive_expression MINUS multiplicative_expression { $$ = $1 - $3; }
                     ;

multiplicative_expression : primary_expression
                           | multiplicative_expression MULTIPLY primary_expression { $$ = $1 * $3; }
                           | multiplicative_expression DIVIDE primary_expression { $$ = $1 / $3; }
                           ;

primary_expression : IDENTIFIER { $$ = atoi(identifier_value); }
                    | NUMBER { $$ = yylval; }
                    | LPAREN expression RPAREN { $$ = $2; }
                    ;

if_statement : IF LPAREN expression RPAREN LBRACE statement_list RBRACE
             | IF LPAREN expression RPAREN LBRACE statement_list RBRACE ELSE LBRACE statement_list RBRACE
             ;

while_statement : WHILE LPAREN expression RPAREN LBRACE statement_list RBRACE
                ;

declaration_statement : INT IDENTIFIER SEMICOLON
                       ;

print_statement : PRINTF LPAREN expression RPAREN SEMICOLON
                ;

scan_statement : SCANF LPAREN IDENTIFIER RPAREN SEMICOLON
               ;

%%

int yyerror(const char *s) {
    printf("Parse error: %s\n", s);
    return 0;
}
