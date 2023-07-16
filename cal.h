#include <stdio.h>

int numbers[10];
int index = 0;

void addNumbers(int num){
    numbers[index] = num;
    index++;
}

int sumOfNumbers(){
    int sum = 0;
    for (int i = 0; i < 50; i++){
        sum += numbers[i];
        numbers[i] = 0;
    }
    
    return sum;
}
