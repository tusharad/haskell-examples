#include<stdlib.h>
#include<string.h>
#include<stdio.h>

void swap_nums(int* x,int* y){
    int temp = *x;
    *x = *y;
    *y = temp;
}

void bubbleSort(int* arr,int n){
  printf("array from bubble sort\n");
  for(int i = 0;i < n;i++){
    for(int j = 0;j < n-i-1;j++){
      if(arr[j] > arr[j+1]){
        int temp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = temp;
      }
    }
  }
  for(int i = 0;i < 5;i++)
    printf("%d ",arr[i]);
}

void toUpper(char* str){
  for(int i = 0;str[i] != '\0';i++)
    str[i] -= 32;
  printf("\n%s\n",str);
}

char* intToString(int x){
  const int MAXLENGTH = 10;
  char* num = malloc(MAXLENGTH*sizeof(char));
  sprintf(num,"%d",x);
  return num;
}

int* addThreeArrays(int* arr1,int n1,int* arr2,int n2,int* arr3,int n3){
  int num = n1+n2+n3;
  int* arr = malloc(num*sizeof(int*));
  int k =0;
  for(int i = 0;i < n1;i++){
    arr[k++] = arr1[i];
  }
  for(int i = 0;i < n2;i++){
    arr[k++] = arr2[i];
  }
  for(int i = 0;i < n3;i++){
    arr[k++] = arr3[i];
  }
  return arr;
}

int* addTwoArrays(int* arr1,int n1,int* arr2,int n2){
  int num = n1+n2;
  int* arr = malloc(num*sizeof(int*));
  int k =0;
  for(int i = 0;i < n1;i++){
    arr[k++] = arr1[i];
  }
  for(int i = 0;i < n2;i++){
    arr[k++] = arr2[i];
  }
  return arr;
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
