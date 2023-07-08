//Abstract Syntax Tree Implementation
#include <string.h>

struct AST{
	char nodeType[50];
	char LHS[50];
	char RHS[50];
	
	struct AST * left;
	struct AST * right;
	// review pointers to structs in C 
	// complete the tree struct with pointers
};



struct AST* AST_assignment(char nodeType[50], char LHS[50], char RHS[50]) {
    struct AST* ASTassign = malloc(sizeof(struct AST));
    strcpy(ASTassign->nodeType, nodeType);
    strcpy(ASTassign->LHS, LHS);
    strcpy(ASTassign->RHS, RHS);
    ASTassign->left = NULL;
    ASTassign->right = NULL;

/*
       =
	 /   \
	x     y

*/	

	return ASTassign;
	
}
struct AST * AST_BinaryExpression(char nodeType[50], char LHS[50], char RHS[50]){

	struct AST* ASTBinExp = malloc(sizeof(struct AST));
	strcpy(ASTBinExp->nodeType, nodeType);
	strcpy(ASTBinExp->LHS, LHS);
	strcpy(ASTBinExp->RHS, RHS);
	return ASTBinExp;
	
}

struct AST * AST_Number(char nodeType[50], char value[50]) {
    struct AST* ast = (struct AST*)malloc(sizeof(struct AST));
    strcpy(ast->nodeType, nodeType);
    strcpy(ast->LHS, value);
    strcpy(ast->RHS, "");
    ast->left = NULL;
    ast->right = NULL;
    return ast;
}

struct AST * AST_Type(char nodeType[50], char LHS[50], char RHS[50]){

	struct AST* ASTtype = malloc(sizeof(struct AST));
	strcpy(ASTtype->nodeType, nodeType);
	strcpy(ASTtype->LHS, LHS);
	strcpy(ASTtype->RHS, RHS);
		
	return ASTtype;
	
}

struct AST * AST_Func(char nodeType[50], char LHS[50], char RHS[50]){
	
	struct AST* ASTtype = malloc(sizeof(struct AST));
	strcpy(ASTtype->nodeType, nodeType);
	strcpy(ASTtype->LHS, LHS);
	strcpy(ASTtype->RHS, RHS);
		
	return ASTtype;
	
}

struct AST * AST_Write(char nodeType[50], char LHS[50], char RHS[50]){
	
	struct AST* ASTtype = malloc(sizeof(struct AST));
	strcpy(ASTtype->nodeType, nodeType);
	strcpy(ASTtype->LHS, LHS);
	strcpy(ASTtype->LHS, RHS);
		
	return ASTtype;
	
}

void printDots(int num)
{
	for (int i = 0; i < num; i++)
		printf("      ");
}

void printAST(struct AST* ast, int level) {
    if (ast == NULL) {
        return;
    }

    // Print indentation based on the level
    for (int i = 0; i < level; i++) {
        printf("  ");
    }

    // Print node type and value (if applicable)
    if (strcmp(ast->nodeType, "Number") == 0) {
        printf("%s: %s\n", ast->nodeType, ast->LHS);
    } else {
        printf("%s\n", ast->nodeType);
    }

    // Recursively print child nodes
    printAST(ast->left, level + 1);
    printAST(ast->right, level + 1);
}

























