import UIKit

// 扩展extension: 向一个已有的 类、结构体、枚举 添加新功能，但不能重写已有功能

// 1. 添加属性
// 2. 定义 实例方法 和 类方法
// 3. 提供新的构造器
// 4. 定义下标
// 5. 定义和使用新的嵌套类型
// 6. 让已有类型遵循协议

//extension SomeType: SomeProtocol, AnotherProctocol {
//  // 协议实现写到这里
//}

//extension Int :  {
//
//}

// 计算型属性
extension Int {
    var add: Int {
        return self + 10
    }
    var sub: Int {
        return self - 10
    }
    // 添加新的构造器 （但不能添加新的 指定构造器/析构函数deinit）
    init(orginValue: Int) {
        self = orginValue
    }
    // 方法
    func topics(sum: () -> ()) {
        for _ in 0..<self {
            sum()
        }
    }
    // 下标
    subscript(mul: Int) -> Int {
        var num = 1
        var index = mul
        while index > 0 {
            num *= 10
            index = index - 1
        }
        return (self / num) % 10
    }
    // 嵌套类型
    enum type {
        case add
        case sub
        case anything
    }
    var print: type {
        switch self {
        case 0: return .add
        case 1: return .sub
        default: return .anything
        }
    }
}
let add3 = 3.add
let sub3 = 3.sub
let num = Int(orginValue: 4)
3.topics {
    print("扩展模块内")
}
print(1234[2])
print(1.print)

// 可变实例方法
// 需修改self、属性的方法需要标注为mutating
extension Double {
    mutating func square() {
        self = self * self
    }
}
var doub = 3.2
doub.square()
print(doub)

























