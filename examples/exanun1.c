#include <stdio.h>
#include <string.h>

/* anonymous union inside a struct we have to patch */
struct breaking {
    union {
        long sa_sigaction;
        double sa_equivalent;
    };
    long sa_flags;
};

static const struct breaking t1 = {
    .sa_sigaction = 0,
    .sa_flags = TWO | THREE,
};

static __attribute__((constructor)) void myctor() {
  printf("t1.sa_flags = %d, t1.sa_sigaction = %d (%f)\n", t1.sa_sigaction, t1.sa_equivalent, t1.sa_flags);
}

int main(int argc, char **argv) {
  printf("hi\n");
  return 0;
}
