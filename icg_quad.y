%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
int top=-1;
void yyerror(char *);
extern FILE *yyin;
#include "y.tab.h" // Include the Yacc header file
#define YYSTYPE char*
typedef struct quadruples
{
  char *op;
  char *arg1;
  char *arg2;
  char *res;
}quad;
int quadlen = 0;
quad q[100];
%}

%start S
%token ID NUM FLOATNUM T_lt T_gt T_lteq T_gteq T_neq T_eqeq T_and T_or T_incr T_decr T_not T_eq WHILE INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE COUT STRING FOR ENDL T_ques T_colon

%token T_pl T_min T_mul T_div
%left T_lt T_gt
%left T_pl T_min
%left T_mul T_div

%%
S
      : START { printf("Input accepted.\n"); }
      ;

START
      : INCLUDE T_lt H T_gt MAIN
      | INCLUDE "\"" H "\"" MAIN
      ;

MAIN
      : VOID MAINTOK BODY
      | INT MAINTOK BODY
      ;

BODY
      : '{' C '}'
      ;

C
      : C statement ';'
      | C LOOPS
      | statement ';'
      | LOOPS
      ;

LOOPS
      : WHILE { while1(); } '(' COND ')' { while2(); } LOOPBODY { while3(); }
      | FOR '(' ASSIGN_EXPR { for1(); } ';' COND { for2(); } ';' statement { for3(); } ')' LOOPBODY { for4(); }
      | IF '(' COND ')' { ifelse1(); } LOOPBODY { ifelse2(); } ELSE LOOPBODY { ifelse3(); }
      | IF '(' COND ')' { if1(); } LOOPBODY { if3(); }
      | TERNARY_EXPR { ternary1(); } T_ques statement { ternary2(); } T_colon statement { ternary3(); }
      ;

LOOPBODY
      : '{' LOOPC '}'
      ;

LOOPC
      : LOOPC statement ';'
      | LOOPC LOOPS
      | LOOPC statement ';'
      | LOOPS
      ;

TERNARY_EXPR
      : statement '?' statement ':' statement
      ;

statement
      : assignment { codegen_assign(); }
      | COUT cout { codegen_cout(); }
      | BREAK { codegen_break(); }
      | CONTINUE { codegen_continue(); }
      | RETURN { codegen_return(); }
      | expression { codegen_expression(); }
      ;

assignment
      : ID '=' expression { $$ = $3; }
      | ID T_pl T_pl { $$ = yytext; }
      | ID T_min T_min { $$ = yytext; }
      ;

expression
      : expression T_pl expression { $$ = $1 + $3; }
      | expression T_min expression { $$ = $1 - $3; }
      | expression T_mul expression { $$ = $1 * $3; }
      | expression T_div expression { $$ = $1 / $3; }
      | '(' expression ')' { $$ = $2; }
      | '-' expression %prec T_min { $$ = -$2; }
      | '+' expression %prec T_pl { $$ = $2; }
      | ID { $$ = $1; }
      | NUM { $$ = $1; }
      | FLOATNUM { $$ = $1; }
      ;

COND
      : expression T_lt expression { $$ = $1 < $3; }
      | expression T_gt expression { $$ = $1 > $3; }
      | expression T_lteq expression { $$ = $1 <= $3; }
      | expression T_gteq expression { $$ = $1 >= $3; }
      | expression T_neq expression { $$ = $1 != $3; }
      | expression T_eqeq expression { $$ = $1 == $3; }
      | expression { $$ = $1; }
      ;

cout
      : STRING
      | ENDL
      ;

%%
void yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}

int main(int argc, char *argv[])
{
  FILE *f = fopen(argv[1], "r");
  if (!f)
  {
    perror(argv[1]);
    return 1;
  }
  yyin = f;
  yyparse();
  fclose(f);
  return 0;
}

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

int yylex(void) {
  int c;
  while ((c = getchar()) != EOF) {
    if (c == '\n') return '\n';
    else if (c == '"') {
      do {
        c = getchar();
      } while (c != EOF && c != '"');
      if (c == EOF) return 0;
    } else if (c == '/') {
      c = getchar();
      if (c == '/') {
        while ((c = getchar()) != EOF && c != '\n');
        if (c == EOF) return 0;
      }
      else return '/';
    } else if (c == '%') {
      c = getchar();
      if (c == '/') {
        while ((c = getchar()) != EOF && c != '\n');
        if (c == EOF) return 0;
      }
      else return '%';
    } else if (c == 'p') {
      char buffer[10];
      int i = 0;
      buffer[i++] = c;
      while ((c = getchar()) != EOF && isalpha(c)) {
        buffer[i++] = c;
      }
      buffer[i] = '\0';
      if (strcmp(buffer, "printf") == 0) {
        while ((c = getchar()) != EOF && c != '\n');
        if (c == EOF) return 0;
      } else {
        return ID;
      }
    } else if (c == 's') {
      char buffer[10];
      int i = 0;
      buffer[i++] = c;
      while ((c = getchar()) != EOF && isalpha(c)) {
        buffer[i++] = c;
      }
      buffer[i] = '\0';
      if (strcmp(buffer, "scanf") == 0) {
        while ((c = getchar()) != EOF && c != '\n');
        if (c == EOF) return 0;
      } else {
        return ID;
      }
    } else {
      return c;
    }
  }
  return 0;
}
