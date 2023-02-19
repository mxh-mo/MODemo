//
//  MOAligorithmTrees.swift
//  MODemo
//
//  Created by mikimo on 2023/1/4.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//
//  算法：树相关

import Foundation

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

// MARK: - Public Methods

func testTrees() {
    

}

// TODO: -  重建二叉树
///// https://leetcode.cn/problems/zhong-jian-er-cha-shu-lcof/?favorite=xb9nqhhg
/*
 let res = buildTree([3,9,20,15,7], [9,3,15,20,7])
 print(res)
 */
//func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
//    guard preorder.count == inorder.count,
//            preorder.count > 0,
//            inorder.count > 0 else {
//        return nil
//    }
//
//    // 前序遍历中, value 对应 index
//    var preValIdxDict: [Int: Int] = [:]
//    for (idx, va) in preorder.enumerated() {
//        preValIdxDict[va] = idx
//    }
//
//    // 中序遍历中, value 对应 index
//    var inValIdxDict: [Int: Int] = [:]
//    for (idx, va) in inorder.enumerated() {
//        inValIdxDict[va] = idx
//    }
//
//    let root = myBuildTree(preorder, inorder, preValIdxDict, inValIdxDict)
//    return root
//}
//
//func myBuildTree(_ preorder: [Int],
//                 _ inorder: [Int],
//                 _ preValIdxDict: [Int: Int],
//                 _ inValIdxDict: [Int: Int]) -> TreeNode? {
//    if preorder.isEmpty {
//        return nil
//    }
//
//    let rootVal = preorder[0]
//    let root = TreeNode(rootVal)
//
//    let inRootIdx: Int = inValIdxDict[rootVal] ?? 0
//    let inLefts: [Int] = Array(inorder[0...inRootIdx])
//    let inRights: [Int] = Array(inorder[(inRootIdx + 1)..<inorder.count])
//
//    let preLefts: [Int] = Array(preorder[1...inLefts.count])
//    let preRights: [Int] = Array(preorder[(inLefts.count + 1)...inRights.count])
//
//    root.left = myBuildTree(preLefts, inLefts, preValIdxDict, inValIdxDict)
//    root.right = myBuildTree(preRights, inRights, preValIdxDict, inValIdxDict)
//
//    return root
//}

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
