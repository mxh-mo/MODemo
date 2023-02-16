//
//  MOAlgorithmLists.swift
//  MODemo
//
//  Created by mikimo on 2023/1/3.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//
//  算法：链表相关

import Foundation

// MARK: - 链表

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

// MARK: - Helper Methods

fileprivate func creatList(_ nums: [Int]) -> ListNode? {
    if nums.isEmpty {
        return nil
    }
    var result: ListNode? = nil
    var current: ListNode? = nil
    for value in nums {
        if current == nil {
            current = ListNode(value)
            result = current
        } else {
            current?.next = ListNode(value)
            current = current?.next
        }
    }
    return result
}

fileprivate func printList(_ list: ListNode?) {
    var cur: ListNode? = list
    while cur != nil {
        print("\(String(describing: cur?.val))")
        cur = cur?.next
    }
}

// MARK: - Public Methods

func test() {

}

// MARK: - 合并两个有序链表
//let list1 = creatList([1, 2, 5])
//let list2 = creatList([1, 3, 4])
//let result = mergeTwoLists(list1, list2)
func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    var cur1: ListNode? = list1
    var cur2: ListNode? = list2
    let result = ListNode(0)
    var curR: ListNode? = result
    
    while cur1 != nil && cur2 != nil {
        if cur1!.val > cur2!.val {
            curR?.next = cur2
            print(cur2?.val as Any)
            cur2 = cur2?.next
        } else {
            curR?.next = cur1
            print(cur1?.val as Any)
            cur1 = cur1?.next
        }
        curR = curR?.next
    }
    curR?.next = (cur1 != nil) ? cur1 : cur2
    return result.next
}

// MARK: - 回文串

func isPalindrome(_ head: ListNode?) -> Bool {
    if head == nil {
        return true
    }
    let midNode: ListNode? = findMidNode(head)
    let lastHalfHead: ListNode? = reversedLink(midNode?.next) ?? nil
    
    var forward: ListNode? = head   // 正序链表
    var back: ListNode? = lastHalfHead  // 逆序链表
    
    var result: Bool = true
    while result && back != nil {
        if forward?.val == back?.val {
            forward = forward?.next
            back = back?.next
        } else {
            result = false
            break
        }
    }
    return result
}

// MARK: - 快慢指针找中间结点

func findMidNode(_ head: ListNode?) -> ListNode? {
    var slow: ListNode? = head
    var fast: ListNode? = head
    while fast?.next != nil && fast?.next?.next != nil {
        fast = fast?.next?.next
        slow = slow?.next
    }
    return slow
}

// MARK: - 反转链表

func reversedLink(_ head: ListNode?) -> ListNode? {
    var cur: ListNode? = head
    var pre: ListNode? = nil
    while cur != nil {
        let tmp = cur?.next
        cur?.next = pre
        pre = cur
        cur = tmp
    }
    return pre
}
