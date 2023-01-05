//
//  MOAlgorithmStrings.swift
//  MODemoSwift
//
//  Created by mikimo on 2023/1/5.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

import Foundation

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

// MARK: - 最长回文子串


