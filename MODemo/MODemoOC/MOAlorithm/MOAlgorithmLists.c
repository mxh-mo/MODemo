//
//  MOAlgorithmLists.c
//  MODemo
//
//  Created by mikimo on 2023/2/1.
//

#include "MOAlgorithmLists.h"
#include <stdlib.h>

/// 结点
typedef struct ListNode {
    int val;
    struct ListNode *next;
} Node;

/// 创建链表
Node *creatList(int nums[], int count) {
    if (count <= 0) {
        return NULL;
    }
    Node *head = (Node *)malloc(sizeof(Node));
    head->val = nums[0];
    
    Node *preNode = head;
    for (int i = 1; i < count; i++) {
        
        Node *current = (Node *)malloc(sizeof(Node));
        current->val = nums[i];

        preNode->next = current;
        preNode = current;
    }
    
    return head;
}

/// 输出链表
void printList(Node *head) {
    Node *cur = head;
    while (cur != NULL) {
        printf("%i", cur->val);
        cur = cur->next;
    }
}

/// 合并两个有序链表
Node *mergeTwoLists(Node *list1, Node *list2) {
    Node *cur1 = list1;
    Node *cur2 = list2;
    
    Node *result = malloc(sizeof(Node));
    Node *curResult = result;
    
    while (cur1 != NULL && cur2 != NULL) {
        if (cur1->val > cur2->val) {
            curResult->next = cur2;
            cur2 = cur2->next;
        } else {
            curResult->next = cur1;
            cur1 = cur1->next;
        }
        curResult = curResult->next;
    }
    curResult->next = cur1 != NULL ? cur1 : cur2;
    return result;
}




void runAlorithmLists(void) {
    printf("run alorithm lists \n");

    // 合并两个有序链表
    int arr1[] = {1, 2, 5};
    Node *list1 = creatList(arr1, 3);
    printList(list1);
    printf("\n");

    int arr2[] = {1, 3, 4};
    Node *list2 = creatList(arr2, 3);
    printList(list2);
    printf("\n");
    
    Node *mergeResult = mergeTwoLists(list1, list2);
    printList(mergeResult);

    
    

}
