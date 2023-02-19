//
//  MOAlgorithmStrings.swift
//  MODemo
//
//  Created by mikimo on 2023/1/5.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//
//  算法：字符串相关

import Foundation

func testStrings() {
    
}

// MARK: - 无重复字符的最长子串
/// https://leetcode.cn/problems/longest-substring-without-repeating-characters/
/*
 let length = lengthOfLongestSubstring("1234567812")
 print("length: \(length)")
 */
func lengthOfLongestSubstring(_ string: String) -> Int {
    if string.isEmpty {
        return 0
    }
    var maxStr = String() // 最长只串
    var curStr = String() // 当前无重复串
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

// MARK: - 最长回文子串
