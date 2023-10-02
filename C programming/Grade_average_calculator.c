/* Name: Srinivas Dengle

About: This code takes input from the user and asks how
        many grades they want to enter in order to
        calculate the average of those grades.
Example:
How many scores you want to calculate: 3
score: 45
score: 98
score: 77
The average: 73.33
*/
#include <stdio.h>
#include<cs50.h>

float average(int r[]); // prototype
int a; // global variable

int main(void)
{
    a = get_int("How many scores you want to calculate: ");
    int r[a];
    for (int i = 0; i<a; i++)
    {
        r[i]= get_int("score: ");
    }
    printf("The average: %0.2f\n", average(r));
}

float average(int r[])
{
    int sum = 0;
    for (int i = 0; i<a; i++)
    {
        sum = sum + r[i];
    }
    return sum/ (float) a;
}