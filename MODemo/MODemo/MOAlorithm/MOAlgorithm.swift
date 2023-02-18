//
//  MOAlgorithm.swift
//  SwiftDemo
//
//  Created by MikiMo on 2020/9/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

import Foundation

// MARK: - Public Methods

func testAlgorithm() {
    print("test algorithm")
    

    // 最少硬币数
//    let minCount = minCountOfCoins(20)
//    print("minCount: \(minCount)")
//    for (index, value) in minCounts.enumerated() {
//        print("index: \(index) = \(value)")
//    }
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
//        print("n: \(n) result:\(result)")
        return result
    }
    var result = Swift.min(minCountFor(n - 9), minCountFor(n - 7), minCountFor(n - 1))
    result = result + 1
//    print("n: \(n) result:\(result)")
    minCounts[n] = result
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
