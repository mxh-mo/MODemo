//
//  MOAlgorithm.swift
//  SwiftDemo
//
//  Created by MikiMo on 2020/9/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//
//  剑指 Offer（第 2 版）
// https://leetcode.cn/problem-list/xb9nqhhg/?sorting=W3sic29ydE9yZGVyIjoiQVNDRU5ESU5HIiwib3JkZXJCeSI6IkZST05URU5EX0lEIn1d

import Foundation

// MARK: - Public Methods

func testAlgorithm() {
    print("test algorithm")
    
    // 二维数组中的查找
//    let array1 = [
//        [1,   4,  7, 11, 15],
//        [2,   5,  8, 12, 19],
//        [3,   6,  9, 16, 22],
//        [10, 13, 14, 17, 24],
//        [18, 21, 23, 26, 30]
//      ]
//    let array2 = [[1, 2]]
//    let didFind = findNumberIn2DArray(array1, 100)
//    print("find: \(didFind)")
    
    // 数组中重复的数字
//    let result = findRepeatNumber([1, 2, 3, 4, 3])
//    print("repeat num: \(result)")
    // 最少硬币数
//    let minCount = minCountOfCoins(20)
//    print("minCount: \(minCount)")
//    for (index, value) in minCounts.enumerated() {
//        print("index: \(index) = \(value)")
//    }
}

// MARK: - 二维数组中的查找 ⚠️
/// https://leetcode.cn/problems/er-wei-shu-zu-zhong-de-cha-zhao-lcof/?favorite=xb9nqhhg
/// 从右上角开始找，优先动列
func findNumberIn2DArray(_ matrix: [[Int]], _ target: Int) -> Bool {
    if matrix.isEmpty {
        return false
    }
    let maxLine = matrix.count
    let maxColume = matrix[0].count
    
    var curLine = 0, curColume = maxColume - 1
    
    while curLine < maxLine && curColume >= 0 {
        let cur = matrix[curLine][curColume]
        if cur == target {
            return true
        }
        if cur > target {
            curColume -= 1
        } else {
            curLine += 1
        }
    }
    return false
}

// MARK: - 数组中重复的数字
/// https://leetcode.cn/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/
func findRepeatNumber(_ nums: [Int]) -> Int {
    var dict: [Int: Int] = [:]
    for num in nums {
        if let count = dict[num] {
            dict[num] = count + 1
            return num
        } else {
            dict[num] = 1
        }
    }
    return 0
}

// MARK: - 最少硬币数
/// 有3种硬币，面值为1、7、9，数量无限
/// 选用硬币，使其金额和为n
/// 求出最少数量的硬币组合
// 方法1：递归，会造成大量的重复计算
// 方法2：动态规划，可存储已经计算过的结果，避免大量重复运算
var minCounts: [Int] = [] // 记录idx最少数量
func minCountOfCoins(_ n: Int) -> Int {
    if n <= 0 {
        return 0
    }
    minCounts = [Int](repeating: 0, count: n + 1)
    return minCountFor(n)
}

func minCountFor(_ n: Int) -> Int {
    if n <= 0 {
        return Int.max
    }
    if minCounts[n] > 0 {
        return minCounts[n]
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
        minCounts[n] = result
        return result
    }
    var result = Swift.min(minCountFor(n - 9), minCountFor(n - 7), minCountFor(n - 1))
    result = result + 1
    minCounts[n] = result
    return result
}

// MARK: - m*n矩阵路径总数
/// 动态规划
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
/// https://leetcode.cn/problems/container-with-most-water/
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
/// https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/
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
