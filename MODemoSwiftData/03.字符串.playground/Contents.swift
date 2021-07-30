import UIKit

// 字符串 初始化
var stringA = ""
let stringB = String("stringB")
let fStr = String(format: "%.2f", 123.4322) // 格式化初始字符串

// 以subString 初始化字符串
let subStr : Substring = Substring()
let substr = String(subStr)

// 以C语言的字符串初始化 String(cString:"")
let validUTF8: [CChar] = [67, 97, 102, -61, -87, 0]
validUTF8.withUnsafeBufferPointer { ptr in
    let s = String(cString: ptr.baseAddress!)
    print(s) // Prints "Café"
}

// 判空
stringA.isEmpty

// 长度
stringB.count

// 拼接
stringA += stringB
stringA.append(stringB)
print("stringA: \(stringA)  stringB: \(stringB)")

// 比较
stringA == stringB
stringA.hasPrefix("s")
stringA.hasSuffix("B")

// 逆序
stringA.reversed()

// 包含 contains
stringA.contains("gB")

// 插入 insert
stringA.insert("*", at: stringA.index(stringA.startIndex, offsetBy: 3))

// 移除 remove
stringA.remove(at: stringA.index(stringA.startIndex, offsetBy: 3))

// 截取
let pre = stringA.prefix(3)
let suf = stringA.suffix(3)
let dropFirst = stringA.dropFirst() // 去掉第一个
let dropLast = stringA.dropLast() // 去掉第二个
// 注意这些返回值是Substring类型, 要使用需转换成String
let newStr = String(suf)

// 转为整型
Int(stringA)

// 遍历字符
for c in stringB {
    print(c)
}

// 按对应字符分割成数组
let line = "I don't want realism. I want magic!"
print(line.split(separator: " "))
print(line.split(separator: " ", maxSplits: 1)) // maxSplits:最多切分的次数
print(line.split(separator: " ", omittingEmptySubsequences: false)) // 省略空字符串 默认true

// 多行写法:  """
// 要想输出不换行  在行末加 \
// \0 : 空字符
// \" : "
// \"" : ""
// \\ : \
// \t : tab
// \n : 换行
// \r : 回车
let multiLineStr = """
Hello this is \
some line \""
\" , \t , \0 , \n , \r , \\
\"multiLineStr\"
"""
print(multiLineStr)

// 参数: 泛型

// enumerated 遍历
for (index, c) in "Swift".enumerated() {
    print("\(index): '\(c)'")
}

// map 遍历
var prices = [10, 20, 30]
var strPrices = prices.map { "￥\($0)" } // $0: 元素
print(strPrices) //  ["￥10", "￥20", "￥30"]

strPrices = prices.map({value -> String in   // String: return 的类型
    return "￥\(value)"
})
strPrices = prices.map({value in
    return "￥\(value)"
})
print(strPrices)

// flatMap 返回后的数组中不存在nil, 同时会把Option解包, 还会降维 n纬度->1纬
prices = prices.compactMap{ $0 }

// flatMap 把两个不同的数组合并成一个数组 n*n
let fruits = ["Apple", "Orange", "Puple"]
let counts = [2, 3, 5]
let array = counts.flatMap { count in
    fruits.map ({ fruit in
        return fruit + "  \(count)"
    })
}
array // ["Apple 2", "Orange 2", "Puple 2", "Apple 3", "Orange 3", "Puple 3", "Apple 5", "Orange 5", "Puple 5"]

// filter 过滤
let p = [10, 20, 33, 44, 87, 15]
var res = p.filter{ $0>20 }
print(res)

res = p.filter({ (value) -> Bool in
    return value > 20
})
print(res)

// reduce 计算
// 把数组元素组合计算为一个值，并且会接受一个初始值，这个初始值得类型可能和数组元素类型不同
// 累积计算
let p1 = [20, 20, 10]
let sum = p1.reduce(0) { $0+$1 }  // $0:计算后的结果  $1:元素
print(sum) // 50

let sum2 = p1.reduce(4) { $0+$1 }
print(sum2) // 54

let sum1 = p1.reduce("2") { " \($0) , \($1)" }
print(sum1) //  2 , 20 , 20 , 10

// Unicode 字符串
var unicodeString = "Unicode"
for code in unicodeString.utf8 {
    print("\(code) ")
}

for code in unicodeString.utf16 {
    print("\(code) ")
}

// 例: 把一个字符串转成 NSDate 实例，如果不用 map 方法，我们只能这么写：
var date: NSDate? = NSDate()
//var formatted = date == nil ? nil : NSDateFormatter().stringFromDate(date!)
// 而使用 map 函数后，代码变得更短，更易读：
//formatted = date.map(NSDateFormatter().stringFromDate)


// 例 遍历字符串中","分割的单词
let values = "one,two,three..."
var i = values.startIndex
while let comma = values[i..<values.endIndex].index(of: ",") {
    if values[i..<comma] == "two" {
        print("found it!")
    }
    i = values.index(after: comma)
}

// 例: 获取文件路径
let libraryPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
print("library路径----\(libraryPath)")

let cachePath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
print("Cache路径----\(cachePath)")

let preferPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.preferencePanesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
print("Prefer路径----\(preferPath)")

let homeDir:String = NSHomeDirectory()
print("沙盒地址---\(homeDir)")

let imagePath = Bundle.main.path(forResource: "sale", ofType: "png")
print("FlyElephnt-图片路径----\(String(describing: imagePath))")

let bundlePath = Bundle.main.bundleURL.path
print("FlyElephnt-App资源文件路径--\(bundlePath)")

let testDataPath = Bundle.main.bundleURL.appendingPathComponent("FlyElephant").path
print("压缩文件的路径---\(testDataPath)")












