import UIKit

print("hello word")
// let 不可变
// var 可变
// swift可以自动识别属性类别。

// 1. 数据类型
let a : Int = 3
let f : Float = 4
let b : Double = 5.5
let r : Bool = true // true false nil

let s : String = "hello"
let c : Character = "c"

// 2. 类型别名
// 语法: typealias newname = type
typealias Feet = Int

// 3. ? Optional 可选类 (有值/没有值)
// 以下两种写法等价
let option1 : Optional<Int>
let option2 : Int?
let array : ([Int])?  // 可选型数组
// 可选类型类似于OC中指针的nil值，但是nil只对类(class)有用，而可选类型对所有的类型都可用，并且更安全。
print("整形:\(a) 浮点:\(f)")
print(s+s)  // + 两边类型必须相同
print(s+s)

var str1:String? = nil
if str1 != nil {
    print(str1)
} else {
    print("str1 为 nil")
}

// 4: ! 强制解析
// 当你确定可选类型确实包含值之后，你可以在可选的名字后面加一个感叹号（!）来获取值。
// 这个感叹号表示"我知道这个可选有值，请使用它。
var str2:String?
str2 = "Hello, Swift!"
if str2 != nil {
    print(str2)   // Optional("Hello, Swift!")
    print(str2!)   // 强制解析 Hello, Swift!
} else {
    print("str2 为 nil")
}
//注意: 使用!来获取一个不存在的可选值会导致运行时错误。使用!来强制解析值之前，一定要确定可选包含一个非nil的值。


// 5. 自动解析
// 你可以在声明可选变量时使用感叹号（!）替换问号（?）。这样可选变量在使用时就不需要再加一个感叹号（!）来获取值，它会自动解析。

// 6. 可选绑定
// 使用可选绑定来判断可选类型是否包含值，如果包含就把值赋给一个临时常量或者变量。
// 可选绑定可以用在if和while语句中来对可选类型的值进行判断并把值赋给一个常量或者变量。
var str3:String?
str3 = "Hello, Swift!"
if let str = str3 {
    print("str3为 - \(str)")
} else {
    print("str3没有值")
}

// 7.元组 (类似于C的结构体)
// 每个元素都会有个序列号  例: person1.1 person1.2 person1.3
var person1 = ("lili", 20, "男", "爱好:女")
print(person1.0)

var person2 = (name: "李波", age : 26, sex : "男", hobby : "足球")
print(person2.name)






