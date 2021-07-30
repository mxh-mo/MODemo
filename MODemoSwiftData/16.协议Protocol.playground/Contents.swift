import UIKit

// 如果类在遵循协议的同时继承父类，父类名应该放在协议名之前，以逗号分隔
// 协议用于指定特定的实例属性或类属性， 而不用指定是 存储型 or 计算型 属性
// 必须指明 只读 or 可读可写 {set get}
// 协议中属性要求声明为变量var
// 再swift中，除了某些特殊情况外，构造器是不被子类继承的, 但可以用协议required实现
//
// 使用场景
// 1.作为函数, 方法, 构造器 中的 参数 or 返回值 类型
// 2.作为常量, 变量, 属性 的类型
// 3.做为数组, 字典, 其他容器 中的元素类型
//
// is 操作符用来检查实例是否遵循了每个协议
// as? 返回一个Optional, 当实例遵循协议时: 返回协议类型, 否则返回nil
// as 用以强制向下转型, 若强转失败, 会引起运行时错误 ????


protocol ProtocolA {
    // 协议不指定是否是 存储型 or 计算型 属性
    // 只指定 名称 类型 读写性
    var name: String { get set } // 可读可写
    var present : Bool { get }  // 只读
    
    func sayHi()
    func attendance() -> String // 不能有实现体
    init(present: Bool)
}

// 一个协议可以继承多个协议
protocol ProtocolB : ProtocolA {
    var result: Bool { get }
}

// 运用扩展 实现协议方法的默认实现
extension ProtocolB {
    func attendance() -> String {
        return "name: \(name)"
    }
}

class ClassA : ProtocolB {
    // 必须拥有协议声明的属性
    var present: Bool
    var result: Bool
    var name: String
    
    // 没有默认实现体的 必须实现
    func sayHi() {
        print("\(name) sayHi")
    }
    required init(present: Bool) {
        self.present = present
        self.result = true
        self.name = ""
    }
}

class ClassB : ClassA {
    // 继承了父类的init的实现体
    // 也可以重写
    required init(present: Bool) {
        super.init(present: present)
    }
}

var instanceA = ClassA(present: true)
instanceA.name = "momo"
print(instanceA.attendance())

// 继承了父类的init的实现体
var instanceB = ClassB(present: false)
print(instanceB.attendance())
print(instanceB.result)


// 类的专属协议: 只能被class类型遵循
protocol ProtocolC : class {
    
}

// 协议的合成
class Root: ProtocolA, ProtocolB {
    var name: String
    var present: Bool
    var result: Bool
    
    required init(present: Bool) {
        self.present = present
        self.name = ""
        self.result = true
    }
    func sayHi() {
    }
}

// 检验协议的一致性
if instanceA is ProtocolA {
    print("instanceA follow protocolA")
} else {
    print("instanceA don't follow protocolA  ")
}

let result = instanceA as? ProtocolA
if (result != nil) {
    print("instanceA follow protocolA")
} else {
    print("instanceA don't follow protocolA  ")
}




