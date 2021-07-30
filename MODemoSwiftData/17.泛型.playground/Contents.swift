import UIKit

// Swift标准库是通过泛型代码构建出来的
// Swift的数组和字典类型都是泛型集
// 类似OC的重载函数

// 例1: 交换两个变量
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}
var num1 = 100
var num2 = 200
swapTwoValues(&num1, &num2)
print("\(num1) \(num2)")

var str1 = "a"
var str2 = "b"
swapTwoValues(&str1, &str2)
print("\(str1) \(str2)")


// 例2: 泛型的栈
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var strStack = Stack<String>()
strStack.push("google")
strStack.push("youtobe")
print("pop \(strStack.pop())")

var IntStack = Stack<Int>()
IntStack.push(1)
IntStack.push(2)
print("pop \(IntStack.pop())")


// 泛型类型的扩展
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items.last
    }
}
print(strStack.topItem)

// 类型约束
//func someFunc<T: SomeClass, U: SomeProtocol> (someT: T, someU: U) {
//  // 泛型函数的函数体
//}

// 例: 查找字符串再数组中的位置
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let strings = ["google", "weibo", "taobao", "facebook"]
if let index = findIndex(ofString: "weibo", in: strings) {
    print("weibo index: \(index)")
}

// 关联类 用associatedtype指定
// 定义协议时, 可以声明一个或多个关联类型做为协议定义的一部分.
// 关联类型为协议中的某个类型提供了一个别名

// 例: 更新Cell方法
struct Model {
    let age: Int
}
protocol UpdateCell {
    associatedtype T
    func updateCell(_ data: T)  // 这个T可以又你指定任何类型
}
class MyTableViewCell: UITableViewCell, UpdateCell {
    typealias T = Model
    func updateCell(_ data: Model) {
        // do something ...
    }
}

// where 关键字
// (1).用在switch里
var value:(Int, String) = (1, "momo")
switch value {
case let (x, y) where x < 60:
    print("不及格")
default:
    print("及格")
}

// (2).与泛型结合
// 第一种写法
func func1<MyTableViewCell> (cell: MyTableViewCell) where MyTableViewCell:UpdateCell {
}
// 第二种写法
func func2<MyTableViewCell:UpdateCell> (cell: MyTableViewCell) {
}

// (3).for in
let array = [1, 2, 3, 4, 5]
let dict = [1: "hehe1", 2:"hehe2"]
for i in array where dict[i] != nil {
    print(i)
}

// (4).与协议结合
protocol ProtocolA {
}

// 只给遵循了ProtocolA协议的UIView添加了拓展
extension ProtocolA where Self:UIView {
    func getString() -> String {
        return "string"
    }
}
class MyView:UIView, ProtocolA {
}

let view = MyView()
let aStr = view.getString()

// (5).在补充do/catch里使用
enum SomeError: Error {
    case error1(Int)
    case error2(String)
}
func methodError() throws {
    throw SomeError.error1(1)
}
do {
    try methodError()
} catch SomeError.error1(let param) where param > 2 {
    print(param)
} catch {
    print("默认异常处理")
}








