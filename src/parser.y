%{
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern int32_t line_num;    /* declared in scanner.l */
extern char current_line[]; /* declared in scanner.l */
extern FILE *yyin;          /* declared by lex */
extern char *yytext;        /* declared by lex */

extern int yylex(void);
static void yyerror(const char *msg);
extern int yylex_destroy(void);
%}

%right ASSIGN

%token ID INTCONST REALCONST STRCONST BOOLCONST
%token VAR ARRAY OF INT REAL STR BOOL
%token DEF RETURN
%token KWBEGIN END
%token WHILE DO
%token IF THEN ELSE
%token FOR TO
%token PRINT READ

%left OR
%left AND
%token NOT
%nonassoc REL
%left ADD SUB
%left MUL DIV MOD
%nonassoc UMINUS

%%

start : program | function ;

    /* Program */
program : ID ';' zero_more_dec zero_more_func cmpd END ;

zero_more_func : /*empty*/ | function zero_more_func;
    /* Function */
function : funcdec | funcdef ;

funcdec : ID '(' zero_more_formal_arg ')' ';' | ID '(' zero_more_formal_arg ')' ':' type  ';' ;
funcdef : ID '(' zero_more_formal_arg ')' cmpd END | ID '(' zero_more_formal_arg ')' ':' type cmpd END ;

formal_arg : id_list ':' type ;
non_empty_formal_arg : formal_arg | formal_arg ',' ; 
zero_more_formal_arg : /*empty*/ | non_empty_formal_arg ;

    /* Data Types and Declaration */
dec : vardec | arrdec | constdec ;

vardec : VAR id_list ':' type ';' ;
arrdec : VAR id_list ':' arr_dim type ';' ;
constdec : VAR id_list ':' lit_const ';' ;

id_list : ID | ID ',' id_list ;
type : INT | REAL | STR | BOOL ;
arr_dim : ARRAY INTCONST OF | ARRAY INTCONST OF arr_dim ;
lit_const : INTCONST | REALCONST | STRCONST | BOOLCONST ;
    /* -------------------------- */

    /* Statements */
stmt : cmpd | simple | condi | while | for | return | funccall ; 
    /* Compound */
cmpd : KWBEGIN zero_more_dec zero_more_stmt END ;

zero_more_dec : /*empty*/ | dec zero_more_dec ; 
zero_more_stmt : /*empty*/ | stmt zero_more_stmt ;
    /* Simple */
simple : assignment | print | read ;

assignment : var_ref ASSIGN expr ';' ;
print : PRINT expr ';' ;
read : READ var_ref ';' ;

var_ref: ID arr_brackets ;
arr_brackets :  /*empty*/ | '[' expr ']' arr_brackets ;

    /* Conditional */
condi : IF expr THEN cmpd ELSE cmpd END IF | IF expr THEN cmpd END IF ;

    /* While */
while : WHILE expr DO cmpd END DO ;

    /* For */
for : FOR ID ASSIGN INTCONST TO INTCONST DO cmpd END DO ;

    /* Return */
return : RETURN expr ';' ;

    /* Function Call */
funccall : ID '(' func_inputs ')' ';' ;

func_inputs : /*empty*/ | non_empty_func_inputs ;
non_empty_func_inputs : expr | expr ',' non_empty_func_inputs ;
    /* ---------- */

    /* Expressions */
expr : lit_const | var_ref | funccall_no_semicolon | arith_expr ;

funccall_no_semicolon : ID '(' func_inputs ')' ;

arith_expr: logi ;
logi : rela | NOT logi | logi AND logi | logi OR logi | '(' logi ')' ;
rela : math | math REL math ;
math : operand | math ADD math | math SUB math | math MUL math | math DIV math | math MOD math 
     | '(' math ')' | SUB math %prec UMINUS ;
operand : var_ref | funccall_no_semicolon | lit_const;

%%

void yyerror(const char *msg) {
    fprintf(stderr,
            "\n"
            "|-----------------------------------------------------------------"
            "---------\n"
            "| Error found in Line #%d: %s\n"
            "|\n"
            "| Unmatched token: %s\n"
            "|-----------------------------------------------------------------"
            "---------\n",
            line_num, current_line, yytext);
    exit(-1);
}

int main(int argc, const char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        exit(-1);
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("fopen() failed");
        exit(-1);
    }

    yyparse();

    fclose(yyin);
    yylex_destroy();

    printf("\n"
           "|--------------------------------|\n"
           "|  There is no syntactic error!  |\n"
           "|--------------------------------|\n");
    return 0;
}
