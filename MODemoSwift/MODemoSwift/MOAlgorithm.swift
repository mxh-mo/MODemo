//
//  MOAlgorithm.swift
//  SwiftDemo
//
//  Created by MikiMo on 2020/9/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

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

// MARK: - 二叉树

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public var isFirst: Bool // 是否第一次出现在栈顶（非递归后续遍历用到）
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
        self.isFirst = false
    }
}

func test() {
    print(totalRoad(3, 4))
}

var coinArray: [Int] = []

// MARK: - 最少硬币数

func leastCoin(_ n: Int) -> Int {
    // 给定一个数额，计算由1、7、9面值的硬币组成的，最少硬币数是几个
    if n <= 0 {
        return 0
    }
    coinArray = [Int](repeating: 0, count: n)
    return lestCoinFor(n)
}

func lestCoinFor(_ n: Int) -> Int {
    if n <= 0 {
        return 0
    }
    if coinArray[n - 1] > 0 {
        return coinArray[n - 1]
    }
    if n <= 9 {
        var result = 0
        if n == 7 || n == 9 {
            result = 1
        } else if n == 8 {
            result = 2
        } else { // n < 7
            result = n
        }
        coinArray[n - 1] = result
        return result
    }
    var result = Swift.min(lestCoinFor(n - 9), lestCoinFor(n - 7), lestCoinFor(n - 1))
    result = result + 1
    print("n: \(n) result:\(result)")
    coinArray[n - 1] = result
    return result
}

// MARK: - m*n矩阵路径总数

func totalRoad(_ n: Int, _ m: Int) -> Int {
    if n <= 0 || m <= 0 {
        return 0
    }
    if n == 1 || m == 1 {
        return 1
    }
    return totalRoad(n - 1, m) + totalRoad(n, m - 1)
}

// MARK: - 盛水最多的容器

func maxArea(_ height: [Int]) -> Int {
    if height.count <= 1 {
        return 0
    }
    // 双指针（移动较矮那边）
    var left: Int  = 0
    var right: Int = height.count - 1
    var maxArea = 0 // 历史最大容量
    while left < right {
        let minHeight = min(height[left], height[right])
        let area = minHeight * (right - left)
        if area > maxArea {
            maxArea = area
        }
        if height[left] <= height[right]  {
            left = left + 1
        } else {
            right = right - 1
        }
    }
    return maxArea
}

// MARK: - 买卖股票最佳时机

func maxProfit(_ prices: [Int]) -> Int {
    if prices.isEmpty {
        return 0
    }
    var minPrice: Int = prices.first! // 历史最低价
    var maxProfit: Int = 0 // 最高收益
    for price in prices {
        if minPrice > price {
            minPrice = price
        } else {
            let profit = price - minPrice
            if profit > maxProfit {
                maxProfit = profit
            }
        }
    }
    return maxProfit
}

// MARK: -  二叉树前序遍历(非递归)

func preOrder(_ root: TreeNode?) {
    var current: TreeNode? = root
    var stack: [TreeNode] = []
    while current != nil || !stack.isEmpty {
        if let cur = current {
            print(cur.val) //
            current = cur.left
            if let right = cur.right {
                stack.append(right)
            }
        } else {
            current = stack.popLast()
        }
    }
}
// MARK: - 二叉树中序遍历(非递归)

func inOrder(_ root: TreeNode?) {
    var current: TreeNode? = root
    var stack: [TreeNode] = []
    while current != nil || !stack.isEmpty {
        if let cur = current {
            stack.append(cur)
            current = cur.left
        } else {
            let node: TreeNode = stack.popLast()!
            print(node.val) //
            current = node.right
        }
    }
}

// MARK: - 二叉树后序遍历(非递归)

func postOrder(_ root: TreeNode?) {
    var stack: [TreeNode] = []
    var current: TreeNode? = root
    while current != nil || !stack.isEmpty {
        while let cur = current { // 沿着左子树一直往下，直到没有左子树为止
            cur.isFirst = true
            stack.append(cur)
            current = cur.left
        }
        if !stack.isEmpty {
            let node: TreeNode = stack.popLast()!
            if node.isFirst { // 第一次出现在栈顶
                node.isFirst = false
                stack.append(node)
                current = node.right
            } else { // 第二次出现在栈顶
                print(node.val)
                current = nil
            }
        }
    }
}

// MARK: - 最长子串 长度

func lengthOfLongestSubstring(_ string: String) -> Int {
    if string.isEmpty {
        return 0
    }
    var maxStr = String()
    var curStr = String()
    for char in string {
        while curStr.contains(char) {
            curStr.remove(at: curStr.startIndex)
        }
        curStr.append(char)
        if curStr.count > maxStr.count {
            maxStr = curStr
        }
    }
    return maxStr.count
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

