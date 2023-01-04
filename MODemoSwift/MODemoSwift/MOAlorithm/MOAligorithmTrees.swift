//
//  MOAligorithmTrees.swift
//  MODemoSwift
//
//  Created by mikimo on 2023/1/4.
//
//  算法：树相关

import Foundation

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
