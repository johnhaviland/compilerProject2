#include <stdio.h>

int ArrayofNumbers[10];
int curentIndex = 0;

void addItems(int item)
{
    ArrayofNumbers[cuurentIndex] = item;
    curentIndex++;
}

int sumOfItems(){
    int sum = 0;
    for (int i = 0; i < 50; i++){
        sum += ArrayofNumbers[i];
        ArrayofNumbers[i] = 0;
    }
    
    return sum;
}
