//
//  MOAligorithmTrees.swift
//  MODemo
//
//  Created by mikimo on 2023/1/4.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//
//  算法：树相关

import Foundation

// MARK: - Public Methods

func testTrees() {
    
}

// MARK: - 二叉树
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

// MARK: - 二叉树前序遍历
/// https://leetcode.cn/problems/binary-tree-preorder-traversal/
func preorderTraversal(_ root: TreeNode?) -> [Int] {
    guard let root = root else { return [] }
    var result: [Int] = []
    result.append(root.val)
    result += preorderTraversal(root.left)
    result += preorderTraversal(root.right)
    return result
}

// MARK: - 二叉树中序遍历
/// https://leetcode.cn/problems/binary-tree-inorder-traversal/
func inorderTraversal(_ root: TreeNode?) -> [Int] {
    guard let root = root else { return [] }
    var result: [Int] = []
    result += inorderTraversal(root.left)
    result.append(root.val)
    result += inorderTraversal(root.right)
    return result
}

// MARK: - 二叉树后序遍历
/// https://leetcode.cn/problems/binary-tree-postorder-traversal/
func postorderTraversal(_ root: TreeNode?) -> [Int] {
    guard let root = root else { return [] }
    var result: [Int] = []
    result += postorderTraversal(root.left)
    result += postorderTraversal(root.right)
    result.append(root.val)
    return result
}
