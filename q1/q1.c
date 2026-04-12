#include <stdio.h>
#include <stdlib.h>

struct Node{
    int val;
    struct Node* left;
    struct Node* right;
} Node;

extern struct Node* make_node(int val);
extern struct Node* insert(struct Node* Root, int val);
extern struct Node* get(struct Node* Root, int val);
extern int getAtMost(int val, struct Node* Root);

int main(){
    int q;
    scanf("%d", &q);

    struct Node* Root = NULL;
    // 1 X -> Insert X into Binary Search Tree
    // 2 X -> Get pointer to Node containing X
    // 3 X -> Returns the greatest value <= X

    while(q--){
        int op, X;
        scanf("%d %d", &op, &X);

        if(op == 1){
            Root = insert(Root, X);
        }
        else if(op == 2){
            struct Node* ReqNode = get(Root, X);

            if(!ReqNode) printf("Node with value %d does not exist\n", X);
        }
        else if(op == 3){
            printf("%d\n", getAtMost(X, Root));
        }
        else{
            printf("Invalid Operation\n");
            q++;
        }
    }

    return 0;
}