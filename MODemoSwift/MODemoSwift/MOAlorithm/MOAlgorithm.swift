//
//  MOAlgorithm.swift
//  SwiftDemo
//
//  Created by MikiMo on 2020/9/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

import Foundation

// MARK: - 最少硬币数

var coinArray: [Int] = []
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