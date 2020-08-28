#include <stdio.h>

#define BUFSIZE 100

int main( int argc, char *argv[] )
{
    char *filename;
    FILE *file;
    char buf[BUFSIZE];

    if (argc != 2) {
        fprintf (stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    file = fopen (argv[1], "r");
    while (fgets (buf, BUFSIZE, file))
        puts (buf);

    fclose (file);

    return 0;
}
