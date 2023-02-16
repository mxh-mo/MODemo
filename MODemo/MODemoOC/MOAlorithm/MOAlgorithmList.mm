//
//  MOAlgorithmList.m
//  MODemo
//
//  Created by mikimo on 2023/2/3.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "MOAlgorithmList.h"

#include <stdio.h>
#include <iostream>

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int value, ListNode *nextNode) {
        val = value;
        next = nextNode;
    }
};

class MOBridge {
public:
    static void runList() {
        std::cout << "Hello, world! \n";
        
        MOBridge bridge = MOBridge();
        bridge.log();
        
//        int arr1[] = {1, 2, 5};
//        ListNode *head = bridge.createList(arr1, 3);
        

    }
    
    void log();
    
//    ListNode *createList(int nums[], int count) {
//        ListNode *head = &ListNode();
//        ListNode *preNode = head;
//        for (int i = 1; i < count; i++) {
//            
//            ListNode *next = ListNode(nums[i], NULL);
//            preNode.next = &next;
//            
//            preNode = next;
//        }
//        return &head;
//    }
    
};

void MOBridge:: log() {
    std::cout << "bridge \n";
}

@implementation MOAlgorithmList

+ (void)run {
    MOBridge:: runList();
}

@end
