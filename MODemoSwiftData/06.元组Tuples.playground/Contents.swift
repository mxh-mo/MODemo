import UIKit

// Tuples
// 元组类型由N个数据组成
// 元素名称可以省略
// 可以指名元素类型

// 例
let position1 = (x:10.5, y:20) // x y: 是元素的名称
let position2 = (10.5, 20)

let person1 = (name:"jack", x:0)
let person2 = ("jack", 0)

let data = ()

// 元素的访问
// (1) 用元素名称
position1.x

// (2) 用元素下标
position1.0

print(position1)

// 指明元素类型
var person3: (Int, String) = (age:23, name:"rose")

// 可以用多个变量接收元组数据
var (x, y) = (10, 20)
var point = (x, y)
var (a, b) = position1

// 使用_ 忽略某个元素的值, 取出其他元素的值
var (_, name) = person1



































