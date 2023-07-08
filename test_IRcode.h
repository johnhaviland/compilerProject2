#include <stdio.h>

FILE* IRcode; // File pointer for IR code

void initIRcodeFile() {
    IRcode = fopen("IRcode.ir", "a");
}

void emitBinaryOperation(char op[1], const char* id1, const char* id2) {
    fprintf(IRcode, "T1 = %s %s %s\n", id1, op, id2);
}

void emitAssignment(char* id1, char* id2) {
    fprintf(IRcode, "%s = %s\n", id1, id2);
}

void emitConstantIntAssignment(char id1[50], char id2[50]) {
    fprintf(IRcode, "%s = %s\n", id1, id2);
}

void emitWriteId(char* id) {
    fprintf(IRcode, "output %s\n", id);
}
