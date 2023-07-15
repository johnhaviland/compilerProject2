#include <stdio.h>
// Set of functions to emit MIPS code
FILE * MIPScode;
void  initAssemblyFile(){
    printf("accessed initAssemblyFile");
    FILE * MIPScode;
    MIPScode = fopen("MIPScode.asm", "w");
    printf("opened MIPScode");
    
    fprintf(MIPScode, ".text\n");
    fprintf(MIPScode, "main:\n");
    fprintf(MIPScode, "# -----------------------\n");

}

void emitMIPSAssignment(char * id1, char * id2){

  fprintf(MIPScode, "li $t1,%s\n", id1);
  fprintf(MIPScode, "li $t2,%s\n", id2);
  fprintf(MIPScode, "li $t2,$t1\n");
}
int anything = 0;
void emitMIPSConstantIntAssignment (char id1[50], char id2[50],int curScope[50]){

    fprintf(MIPScode, "li $t%d,%s\n",curScope, id2);
}

void emitMIPSWriteId(char * id, int count){
        fprintf(MIPScode, "move $a0,$t%d\n", count);
        fprintf(MIPScode, "li $v0,1   # call code for terminate\n");
        fprintf(MIPScode, "syscall      # system call (terminate)\n");
        fprintf(MIPScode, "li $a0, 10\nli $v0, 11\nsyscall\n\n");
}

void emitEndOfAssemblyCode(){
    fprintf(MIPScode, "# -----------------\n");
    fprintf(MIPScode, "#  Done, terminate program.\n\n");
    fprintf(MIPScode, "li $v0,10   # call code for terminate\n");
    fprintf(MIPScode, "syscall      # system call (terminate)\n");
    fprintf(MIPScode, ".end main\n");
}
    