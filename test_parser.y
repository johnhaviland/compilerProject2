%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "test_symbolTable.h"
#include "test_AST.h"
// #include "test_semantic.h"
#include "test_IRcode.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
char currentScope[50]; // global or the name of the function

int syntaxCorrect = 1;
int semanticCorrect = 1;
%}

%union {
	int number;
	char character;
	char* string;
	struct AST* ast;
}

%token <string> TYPE
%token <string> ID
%token <character> SEMICOLON
%token <character> EQ
%token <number> NUMBER
%token <string> WRITE
%token <character> PLUS

%printer { fprintf(yyoutput, "%s", $$); } ID;
%printer { fprintf(yyoutput, "%d", $$); } NUMBER;

%type <ast> Program DeclList Decl VarDecl Stmt StmtList Expr Term

%start Program

%%

Program: DeclList  { $$ = $1;
					 printf("\n--- Abstract Syntax Tree ---\n\n");
					 printAST($$,0);
					}
;

DeclList:	Decl DeclList	{ $1->left = $2;
							  $$ = $1;
							}
	| Decl	{ $$ = $1; }
;

Decl:	VarDecl { $$ = $1; }
	| StmtList
;

VarDecl:	TYPE ID SEMICOLON	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Var %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
;

StmtList:	
	| Stmt StmtList
;

Stmt:	SEMICOLON	{}
	| Expr SEMICOLON	{$$ = $1;}
;

Expr: ID EQ ID {
        printf("\n RECOGNIZED RULE: Assignment statement\n");
        // ----SEMANTIC ACTIONS by PARSER
        $$ = AST_assignment("=", $1, $3);

        // ---- SEMANTIC ANALYSIS: CHECK VARIABLE DECLARATION ----
        // check if the variable is in the symbol table
        int inSymTab = found($1, currentScope);
        if (inSymTab == 0){
            printf("SEMANTIC ERROR: Var %s is not in the symbol table\n", $1);
            semanticCorrect = 0;
        }
        else{
            printf("Var %s is in the symbol table\n", $1);
        }
        /*
        // ---- SEMANTIC ANALYSIS: CHECK VARIABLE TYPE COMPATIBILITY ----
        // get the type of the first ID (LHS)
        // get the type of the second ID (RHS)
        // if the types are not the same, print error
        if (strcmp(getType($1, currentScope), getType($3, currentScope)) != 0){
            printf("SEMANTIC ERROR: Uncompatible types\n");
            semanticCorrect = 0;
        }
        else{
            printf("Type match\n");
        }
        */

        // ---- SEMANTIC ANALYSIS: EMIT IR CODE ----
        if (semanticCorrect == 1 && syntaxCorrect == 1){
            // emit code
            printf("Emit IR code for assignment statement: ID1 = ID2\n");
            
            /*
            Load ID2 into register represented by temp var T1
            Load T1 into another register represented by temp var T2
            */

            //printf("T1 = $3\n");
            //printf("T2 = T1\n");
            
            emitAssignment($1, $3);
        }
        else{
            printf("SEMANTIC ERROR: Cannot emit IR code\n");
        }
        
    }
    | ID EQ NUMBER {
        printf("\n RECOGNIZED RULE: Assignment statement\n");

        // ---- SEMANTIC ACTIONS by PARSER ----
        char str[50];
        sprintf(str, "%d", $3);
        $$ = AST_assignment("=", $1, str);

        // --- SEMANTIC ANALYSIS: CHECK VARIABLE DECLARATION ----
        // check if the variable is in the symbol table
        int inSymTab = found($1, currentScope);
        if (inSymTab == 0){
            printf("SEMANTIC ERROR: Var %s is not in the symbol table\n", $1);
            semanticCorrect = 0;
        }
        else{
            printf("Var %s is in the symbol table\n", $1);
        }

        /*
        // ---- SEMANTIC ANALYSIS: CHECK VARIABLE TYPE COMPATIBILITY ----
        // get the type of the first ID (LHS)
        // get the type of the second ID (RHS)
        // if the types are not the same, print error
        if (strcmp(getType($1, currentScope), getType($3, currentScope)) != 0){
            printf("SEMANTIC ERROR: Uncompatible types\n");
            semanticCorrect = 0;
        }
        else{
            printf("Type match\n");
        }
        */

        // ---- SEMANTIC ANALYSIS: EMIT IR CODE ----
        if (semanticCorrect == 1 && syntaxCorrect == 1){
            // emit code
            printf("Emit IR code for assignment statement: ID1 = ID2\n");
            
            /*
            Load ID2 into register represented by temp var T1
            Load T1 into another register represented by temp var T2
            */

            //printf("T1 = $3\n");
            //printf("T2 = T1\n");
            
            emitConstantIntAssignment($1, $3);
        }
        else{
            printf("SEMANTIC ERROR: Cannot emit IR code\n");
        }
        

    }
    | ID PLUS ID {
        printf("\n RECOGNIZED RULE: Assignment statement (with addition)\n");
        char str[50];
        sprintf(str, "%s + %s", $1, $3);
        $$ = AST_BinaryExpression("+", str, "");
    }
    | ID EQ Term {
        printf("\n RECOGNIZED RULE: Assignment statement\n");
        $$ = AST_assignment("=", $1, $3->LHS);
    }
    | WRITE ID {
        printf("\n RECOGNIZED RULE: WRITE statement\n");
        
        // ---- SEMANTIC ACTIONS by PARSER ----
        $$ = AST_Write("write", $2, "");

        // ---- SEMANTIC ANALYSIS: CHECK VARIABLE DECLARATION ----
        // check if the variable is in the symbol table
        int inSymTab = found($2, currentScope);
        if (inSymTab == 0){
            printf("SEMANTIC ERROR: Var %s is not in the symbol table\n", $1);
            semanticCorrect = 0;
        }
        else{
            printf("Var %s is in the symbol table\n", $1);
        }

        // ---- SEMANTIC ANALYSIS: EMIT IR CODE ----
        if (semanticCorrect == 1 && syntaxCorrect == 1){
            // emit code
            printf("Emit IR code for assignment statement: ID1 = ID2\n");
            
            /*
            Load ID2 into register represented by temp var T1
            Load T1 into another register represented by temp var T2
            */

            //printf("T1 = $3\n");
            //printf("T2 = T1\n");
            
            emitWriteId($2);
        }
        else{
            printf("SEMANTIC ERROR: Cannot emit IR code\n");
        }
    }
    ;

Term: NUMBER {
        printf("\n RECOGNIZED RULE: Assignment statement\n");
        char str[50];
        sprintf(str, "%d", $1);
        $$ = AST_assignment("=", str, "");
    }
    | ID {
        printf("\n RECOGNIZED RULE: Assignment statement\n");
        $$ = AST_assignment("=", $1, "");
    }
    | Term PLUS Term {
        printf("\n RECOGNIZED RULE: Addition within Term\n");
        char str[50];
        sprintf(str, "%s", $1, $3);
        $$ = AST_BinaryExpression("+", str, "");
    }
    | Term PLUS Term PLUS Term {
        printf("\n RECOGNIZED RULE: Multiple Additions within Term\n");
        char str[50];
        sprintf(str, "%s", $1, $4);
        $$ = AST_BinaryExpression("+", str, "");
    }
    ;



%%

int main(int argc, char**argv)
{
/*
	#ifdef YYDEBUG
		yydebug = 1;
	#endif
*/
	printf("\n\n##### COMPILER STARTED #####\n\n");
	
	if (argc > 1){
	  if(!(yyin = fopen(argv[1], "r")))
          {
		perror(argv[1]);
		return(1);
	  }
	}
    initIRcodeFile();
	yyparse();
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
