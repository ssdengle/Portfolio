#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int h;

    do
    {
        h = get_int("Height: ");
    }
    while(h <= 0 || h >= 9);


    for (int i = 0; i < h; i++)
    {

        //spaces
        for (int j = h - 1; j > i; j--)
        {
            printf(" ");
        }

        //hashes
        for (int j = 0; j<=i; j++)
             {
                 printf("#");
             }

        printf("\n");
    }

}
