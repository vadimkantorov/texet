#include <stdio.h>
#include <unistd.h>

#define BUFSIZE 100
#define PATHMAX 100

int main( int argc, char *argv[] )
{
    char *filename;
    FILE *file;
    char buf[BUFSIZE];

    char cwd[PATHMAX];
    if (getcwd(cwd, sizeof(cwd)) != NULL) 
        printf("Current working dir: %s\n", cwd);

    printf("%d %s %s\n", argc, argv[0], argv[1]);
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
