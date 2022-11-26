//
//  MOExtensions.swift
//  MODemoSwift
//
//  Created by MikiMo on 2021/8/6.
//

import Foundation

func moPrint(_ target: NSObject, _ line: Int, _ params: Any) {
    print("\(Date()): <\(type(of: target)), \(String(format: "%p", target))> \(line): \(params)")
}

extension String {
    // 参考： https://juejin.cn/post/6856418701584007176
    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex...endIndex])
    }
    
    subscript(_ indexs: Range<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    // Demo
    func testString() {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        print(alphabet[alphabet.index(alphabet.startIndex, offsetBy: 3)])
        print(alphabet[..<4])  // ABCD
        print(alphabet[...4])  // ABCDE
        print(alphabet[5..<10]) // FGHIJ
        print(alphabet[5...10]) // FGHIJK
        print(alphabet[11...])  // LMNOPQRSTUVWXYZ
    }
}
