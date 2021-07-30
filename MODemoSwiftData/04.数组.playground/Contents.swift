import UIKit

// 注意: swift数组中类型必须一致, 这点与OC不同
// swift 会强制检测元素类型, 若类型不同则会报错

// 1. 初始化
var emptyArr1:[Int] = []
var emptyArr2:Array<Int> = []

var emptyArr31 : [Int]  // 定义
emptyArr31 = [Int]()  // 初始化
// --------
var emptyArr3 = [Int]() // 合成一句

var emptyArr4 = Array<Int>()
var arr1 = [0, 1, 2, 3]
var arr11 = ["张三", "小芳", "小羊"]
// 以n个初始值 初始化数组
var arr2 = [NSInteger](repeating: 0, count: 5)

// 2.访问数组
arr1[1]
arr1.first
arr1.last
arr1.min()  // 最小值
arr1.max()  // 最大值
arr1[2..<4] // 区间获取
arr1[2..<arr1.count]
arr1.index(of: 3)   // 寻找指定元素位置

// 3.修改数组

// 添加元素
arr1.append(40)
arr1.insert(50, at: 3)
arr1 += [50]

// 修改元素
arr1[0] = 100

// 删除元素
arr1.removeFirst()
arr1.removeLast()
arr1.remove(at: 1)
arr1.removeSubrange(0..<2)
arr1.removeAll()
arr1.removeFirst(0) // 删除第一个0
arr1.removeLast(0)  // 删除最后一个0

// 4.遍历数组
for item in arr11 {
    print(item)
}
for index in 0..<arr11.count {
    print(arr2[index])
}
for (index, value) in arr11.enumerated() {
    print("\(index+1): \(value)")
}
for e in arr11.enumerated() {
    print("\(e.offset) \(e.element)")
}
// 对所有元素进行变形
arr11.map { (item) -> String in
    return item + "."
}
print("map:\(arr11)")
arr11.flatMap { (item) -> Sequence in
    
}

arr11.forEach {
    print("item: \($0)")
}
// 反序索引
for (index, value) in arr11.enumerated().reversed() {
    print("reversed \(index) \(value)")
}
// 遍历除了第一个以外的其余部分
for item in arr11.dropFirst() {
    print(item)
}
// 遍历除了后2个元素以外的部分
for item in arr11.dropLast(2) {
    print(item)
}
// 筛选出标准元素
let filterArr = arr11.filter { (item) -> Bool in
    return item.hasPrefix("张")
}
print("filter:\(arr11)")


// 5.合并数组
var arr3 = arr1 + arr2

// 6.基本操作
arr3.count       // 个数
arr3.isEmpty     // 判空
arr3.contains(1) // 包含与否
arr1 == arr3     // 比较

// 二维数组
var board1 = [ [1024,16,2,0] , [256,4,2,0] , [64,2,0,0] , [2,0,0,0] ]
var board2:[[Int]] = [ [1024,16,2,0] , [256,4,2,0] , [64,2,0,0] , [2,0,0,0] ]
var board3:[Array<Int>] = [ [1024,16,2,0] , [256,4,2,0] , [64,2,0,0] , [2,0,0,0] ]
var board4:Array<[Int]> = [ [1024,16,2,0] , [256,4,2,0] , [64,2,0,0] , [2,0,0,0] ]
var board5:Array<Array<Int>> = [ [1024,16,2,0] , [256,4,2,0] , [64,2,0,0] , [2,0,0,0] ]








