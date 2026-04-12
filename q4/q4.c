#include <stdio.h>
#include <string.h>
#include <dlfcn.h>
// Allows to load/unload shared libraries while program is running

int main(){
    while(1){
        char s1[14] = "./lib";
        char s2[] =  ".so";
        char op[6];
        int num1, num2;

        scanf("%s %d %d", op, &num1, &num2);

        strcat(s1, op);
        strcat(s1, s2);
        // s1 is now "./lib<op>.so"
        
        void* handle = dlopen(s1, RTLD_LAZY);
        // Allows us to resolve only the <op> function when required

        if(!handle){
            printf("Could not find the library: %s\n", dlerror());
            continue;
        }

        int (*operation)(int, int) = (int (*) (int, int)) dlsym(handle, op);
        // Finds the memory address of <op> function

        char* error = dlerror();
        if(error != NULL){
            printf("Could not find the operation: %s\n", error);
            dlclose(handle);
            continue;
        }

        int ans = operation(num1, num2);
        printf("%d\n", ans);

        dlclose(handle);
        // Prevents clogging of RAM by removing the shared library after it's use
    }

    return 0;
}