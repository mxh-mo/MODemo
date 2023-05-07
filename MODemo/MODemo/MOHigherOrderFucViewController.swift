//
//  MOHigherOrderFucViewController.swift
//  MODemo
//
//  Created by mikimo on 2023/5/7.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

import UIKit

class MOHigherOrderFucViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testMap() // 转换
        testCompactMap() // Set、Array取非空
        testCompactMapValues() // Dict取非空
        testFlatMap() // 降维
        testFilter() // 过滤
        testReduce() // 处理累积
        testSort()  // 排序
    }

    func testMap() {
        // 1. 遍历集合处理后，组成新的集合
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        let lowercaseNames = cast.map { $0.lowercased() }
        print(lowercaseNames) // ["vivien", "marlon", "kim", "karl"]
        
        let letterCounts = cast.map { $0.count }
        print(letterCounts) // [6, 6, 3, 4]

        
        // 2. 解包 Optional
        let num: Int? = 2
        var res = num.map {
            $0 * 2
        }
        print(res)
        
        /// 而不需要额外解包
        if let num = num {
            res = num * 2
        } else {
            res = nil
        }
        
        // 3. 获得 index
        let indexRes = cast.enumerated().map{ (index, element) in
            return "\(index):\(element)"
        }
        print(indexRes)
    }
    
    func testCompactMap() {
        let possibleNumbers = ["1", "2", "three", "///4///", "5"]

        let mapped = possibleNumbers.map { Int($0) }
        print(mapped) // [Optional(1), Optional(2), nil, nil, Optional(5)]

        // compactMap 获得非 optional 元素
        let compactMapped = possibleNumbers.compactMap { Int($0) }
        print(compactMapped) // [1, 2, 5]
        
        // compactMap 用于 Array 和 Set，可以获得非空集合
        // 但对于 Dictionary 不起作用
    }
    
    func testCompactMapValues() {
        let dict = ["a": "1", "b": "three", "c": "///4///"]

        let maped = dict.mapValues { Int($0) }
        print(maped) // ["a": Optional(1), "b": nil, "c": nil]

        let compactMaped = dict.compactMapValues { Int($0) }
        print(compactMaped) // ["a": 1]
    }

    func testFlatMap() { // 降维
        let scoreDict = ["Momo": [1, 2, 3], "Bibi": [4, 5, 6]]
        let resultSorce1 = scoreDict.map { $0.value }
        print(resultSorce1) // [[4, 5, 6], [1, 2, 3]]

        let reslutSorce2 = scoreDict.flatMap { $0.value }
        print(reslutSorce2) // [4, 5, 6, 1, 2, 3]
    }
    
    func testFilter() {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        let shortNames = cast.filter { $0.count < 5 }
        print(shortNames) // ["Kim", "Karl"]
    }
    
    func testReduce() {
        let numbers = [1, 2, 3, 4]
        let numberSum = numbers.reduce(0, { x, y in
            x + y
        })
        print(numberSum) // 10
    }
    
    func testSort() {
        let nums = [4, 1, 3, 2]
        let res = nums.sorted {
            $0 > $1 // 降序
        }
        print(res)
    }
    
}
