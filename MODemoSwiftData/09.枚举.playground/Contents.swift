import UIKit

// 1. 功能
// 声明在类中, 可通过实例化类来访问它的值
// 枚举也可以定义构造函数(initializers)来提供一个初始成员值
// 可以遵循协议(protocol)来提供标准的功能

// 2. 任意类型的枚举
// (1). 可将成员定义成不同的类型
// (2). 可不定义成员, 形成空的枚举类型
enum Enum1 {
}
// 3. 指定类型的枚举
// (1). 原始值类型非整形, 需指定原始值
// (2). 指定数据类型后, 所有成员都为此数据类型, 不可定义其他类型
// (3). 原始值必须为唯一标识的
// (4). 必须使用case关键字定义成员

// 4. 原始值
// Int Double String Bool 必须唯一
// 例: 当使用Int做为原始值时, 隐式赋值一次递增1. 默认从0开始
enum Enum2:Int {
    case First
    enum Enum {   // 嵌套枚举
        case first
        case three
    }
}
enum Enum3:Int {
    case age1
    case age2
    case age3 = 20
    case age4
}

enum Enum4:String {   // 所有case必须赋值
    case name1 = "name01"
    case name2 = "name02"
    // 枚举的可失败构造器
    init?(name: String) {
        switch name {
        case name1:
            self = .name1
        case name2
        self = .name2
        default:
            return nil
        }
    }
}
print("Enum3.age1: \(Enum3.age1)")
print("Enum3.age1: \(Enum3.age1.rawValue)")

// 5. 根据原始值获取枚举成员
let ageEnum = Enum3(rawValue: 20)
let nameEnum = Enum4(rawValue: "name02")

// 6. 任意类型枚举  相关值
enum Student {
    case Name(String)
    case Mark(Int, Int, Int)
}
var stuDetail = Student.Name("momo")
var stuMark = Student.Mark(98, 97, 95)

switch stuMark {
case .Name(let studName):
    print("学生的名字:\(studName)")
case .Mark(let Mark1, let Mark2, let Mark3):
    print("学生的成绩:\(Mark1), \(Mark2), \(Mark3)")
}

// 7. 根据已有的rawValue创建enum case
// 若枚举类型定义时, 使用了原始值, 那么将自动创建一个初始化方法
// 枚举类型名(rawValue:), 参数: 原始值类型, 返回值: 枚举成员 or nil
let age = Enum3(rawValue:13)
print("age: \(age)")
// 原始值构造器是一个可失败构造器, 返回值是一个Option

// 8. 递归枚举 indirect
enum Calculate {
    case number(Int)
    indirect case addition(Calculate, Calculate)
    indirect case multipliation(Calculate, Calculate)
}
// 也可在枚举类型开头加上indirect表示所有成员均可递归
indirect enum Expression {
    case number(Int)  // 纯数字
    case add(Expression, Expression) // 两个表达式相加
    case mul(Expression, Expression)  // 两个表达式相乘
}

let one = Expression.number(1)
let two = Expression.number(2)
let sum = Expression.add(one, two)
let mul = Expression.mul(sum, Expression.number(3))

// 9. 递归函数
func evaluate(_ expression: Expression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .add(left, right):
        return evaluate(left) + evaluate(right)
    case let .mul(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(mul))



// 例:
enum DaysOfWeek {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

var weekDay = DaysOfWeek.Thursday
weekDay = .Thursday

switch weekDay {
case .Monday: print("星期一")
case .Tuesday: print("星期二")
default: print("...")
}









