#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "caesar.h"

void gen_test(char *str, int str_len, int shift)
{
    char *res1, *res2;

    printf("Encrypt text '%s'\n", str);
    res1 = caesar_encrypt(str, str_len, shift);
    if (!res1) return;
    printf("Result:       %s\n", res1);

    printf("Decrypt text '%s'\n", res1);
    res2 = caesar_decrypt(res1, str_len, shift);
    if (!res2) return;
    printf("Result:       %s\n", res2);

    free(res1);
    free(res2);
}

int main_with_filesystem() {
    FILE *fp;
    char *line1 = NULL;
    char *line2 = NULL;
    size_t len = 0;
    ssize_t read;
    int shift;
    int str_len;

    fp = fopen("/var/demo/caesar/test-suite.txt", "r");
    if (fp == NULL) return 1;

    while ((read = getline(&line1, &len, fp)) != -1) {
        if ((read = getline(&line2, &len, fp)) == -1)
            break;
        shift = atoi(line2);
        str_len = strlen(line1) + 1;

        printf("Test with a shift value of: %d\n", shift);
        gen_test(line1, str_len, shift);
    }

    fclose(fp);
    if (line1) free(line1);
    if (line2) free(line2);

    return 0;
}

int main_with_input(int argc, char *argv[]) {
    if ( argc != 3 ) return 1;

    char* orig_str = argv[1];
    int shift = atoi(argv[2]);
    int str_len = strlen(orig_str) + 1;

    printf("Test with a shift value of: %d\n", shift);
    gen_test(orig_str, str_len, shift);

    return 0;
}

int main(void)
{
    check_magic_number();

    char orig_str[] = "People of Earth, your attention please";
    int str_len = sizeof orig_str;

    printf("Test 1: Shift with a negative input\n");
    gen_test(orig_str, str_len, -3);
    printf("\nTest 2: Shift with a positive input\n");
    gen_test(orig_str, str_len, 7);

    return 0;
}
