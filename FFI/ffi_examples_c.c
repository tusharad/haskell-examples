#include<stdlib.h>

void swap_nums(int* x,int* y){
    int temp = *x;
    *x = *y;
    *y = temp;
}

int* create_arr(int size){
    int* arr = (int*)malloc(size*sizeof(int));
    for(int i = 0;i < size;i++){
        arr[i] = i*i;
    }
    return arr;
}

void free_arr(int* arr){
    free(arr);
}
