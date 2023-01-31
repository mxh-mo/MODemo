//
//  MOAlorithm.c
//  MODemoSwift
//
//  Created by mikimo on 2023/1/31.
//

#include "MOAlorithm.h"

int min(int x, int y) {
    if (x < y) {
        return x;
    } else {
        return y;
    }
}

int max(int x, int y) {
    if (x < y) {
        return y;
    } else {
        return x;
    }
}

// MARK: - 最少硬币数
// 给定一个数额，计算由1、7、9面值的硬币组成的，最少硬币数是几个

// 动态规划 ？？？
int coins[];
int lestCoinFor(int n) {
    if (n <= 0) {
        return 0;
    }
    if (coins[n - 1] > 0) {
        return coins[n - 1];
    }
    if (n <= 9) {
        int result = 0;
        if (n == 7 || n == 9) {
            result = 2;
        } else if (n == 8) {
            result = 2;
        } else {
            result = n;
        }
        coins[n - 1] = result;
        return result;
    }
    
    /// 取最小值
    int result = 0;
    if (lestCoinFor(n - 9) < lestCoinFor(n - 7)) {
        result = lestCoinFor(n - 9);
    } else {
        result = lestCoinFor(n - 7);
    }
    
    if (lestCoinFor(n - 1) < result) {
        result = lestCoinFor(n - 1);
    }
    
    result = result + 1;
    printf("n: %i result: %i", n, result);
    coins[n - 1] = result;
    return result;
}

int leastCoin(int n) {
    if (n <= 0) {
        return 0;
    }
    return lestCoinFor(n);
}

// MARK: - m*n矩阵路径总数

int totalRoad(int n, int m) {
    if (n <= 0 || m <= 0) {
        return 0;
    }
    if (n == 1 || m == 1) {
        return 1;
    }
    return totalRoad(n - 1, m) + totalRoad(n, m - 1);
}

// MARK: - 盛水最多的容器

int maxArea(int height[], int count) {
    if (count <= 1) {
        return 0;
    }
    // 双指针（移动较矮的一边）
    int left = 0;
    int right = count - 1;
    int maxArea = 0;
    while (left < right) {
        int minHeight = min(height[left], height[right]);
        int area = minHeight * (right - left);
        if (area > maxArea) {
            maxArea = area;
        }
        if (height[left] <= height[right]) {
            left = left + 1;
        } else {
            right = right + 1;
        }
    }
    return maxArea;
}

// MARK: - 买卖股票最佳时机

/// 输出最大利润
int maxProfit(int* prices, int pricesSize) {
    if (pricesSize <= 0) {
        return 0;
    }
    int max = 0, min = prices[0];
    for (int i = 0; i < pricesSize; i++) {
        if (prices[i] < min) {
            min = prices[i];
        } else if (prices[i] - min > max) {
            max = prices[i] - min;
        }
    }
    return max;
}

void runAlorithm(void) {
    printf("run alorithm \n");

//    printf("leastCoin: %i", leastCoin(9)); // 最少硬币数
//    printf("totalRoad: %i", totalRoad(2, 3)); // m*n矩阵路径总数
    
//    int lines[] = {0, 2, 1, 4};
//    printf("maxArea: %i", maxArea(lines, 4)); // 盛水最多的容器

    int prices[] = {2, 3, 4};
    printf("maxProfit: %i", maxProfit(prices, 3)); // 买卖股票最佳时机

}
