#include <stdio.h>

size_t get_size(const char *PATH)
{
    FILE *f = fopen(PATH, "r");
    size_t size = 0;
    while (fgetc(f) != '\n')
        ++size;
    fclose(f);
    return size;
}

int calculate_vision(const size_t size, int (*matrix)[size], int irow, int icol)
{
    int cval = matrix[irow][icol];
    int jrow = irow;
    int jcol = icol - 1;

    int up = 1;
    while (jcol >= 1 && matrix[jrow][jcol] < cval)
    {
        ++up;
        --jcol;
    }
    jrow = irow;
    jcol = icol + 1;
    int down = 1;
    while (jcol < size - 1 && matrix[jrow][jcol] < cval)
    {
        ++down;
        ++jcol;
    }
    jrow = irow - 1;
    jcol = icol;
    int left = 1;
    while (jrow >= 1 && matrix[jrow][jcol] < cval)
    {
        ++left;
        --jrow;
    }
    jrow = irow + 1;
    jcol = icol;
    int right = 1;
    while (jrow < size - 1 && matrix[jrow][jcol] < cval)
    {
        ++right;
        ++jrow;
    }

    return up * down * left * right;
}

int second_part(const char *PATH)
{
    char c;
    size_t size = get_size(PATH);
    int matrix[size][size];
    int i, j = 0;
    FILE *file = fopen(PATH, "r");

    while ((c = fgetc(file)) != EOF)
    {
        if (c == '\n')
        {
            ++j;
            i = 0;
            continue;
        }
        matrix[i][j] = (int)(c - '0');
        ++i;
    }
    int msf = 0;
    for (size_t irow = 1; irow < size - 1; irow++)
    {
        for (size_t icol = 1; icol < size - 1; icol++)
        {
            int val = calculate_vision(size, matrix, irow, icol);
            if (val > msf)
                msf = val;
        }
    }
    return msf;
}