import UIKit

// 1.函数分类
func fun1 () {
}

func fun2 () -> String {
    return "swift"
}

func fun3 (param: String) {
}

func fun4 (site: String) -> String {
    return site
}

func fun5 (name: String, age: String) -> String {
    return name + age
}

// 元组 做为返回值
func fun6 (array: [Int]) -> (min: Int, max: Int)? {
    // 安全处理
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array {
        if value < currentMin {
            currentMin = value
        }
        if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
let result = fun6(array: [8, -6, 2, 109, 3, 71])
// 元组可选 安全处理
print("min:\(String(describing: result?.min)) max:\(String(describing: result?.max))");

// 以上的参数名都是局部参数名

// 2.外部参数名
func pow (base a: Int, power b: Int = 12) -> Int64 {  // = 12 默认参数值
    var res = a
    for _ in 1..<b {
        res = res * a  // 5 * 5 * 5
    }
    print(res)
    return Int64(res)
}
pow(base: 5, power: 3)    // 5的3次幂

// 3.可变参数
func fun7<N>(members: N...) {
    for i in members {
        print(i)
    }
}
fun7(members: 4, 3, 5)
fun7(members: 4.5, 3.1, 5.6)
fun7(members: "Google", "Baidu", "Github")

// 4.常量, 变量, I/O参数
// 一般函数中参数默认时常量参数, 仅可以查询使用, 不可修改
// 一般默认的参数传递都是传值调用, 而不是传引用, 所以在函数内改变, 也不影响原来的参数

// 若需要声明变量参数, 需加 inout, 就可改变其值了
// 然后传参时, 需要在参数名前加&符, 传入地址引用
func swapTwoInts (_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}
var x = 1
var y = 5
swapTwoInts(&x, &y)
print("x:\(x) y:\(y)")
// 参数名前加"_": 在调用时可以省略参数名


// 5.定义函数类型
// addition变量的类型 跟 pow函数的类型一致
var addition: (Int, Int) -> Int64 = pow
print(addition(5, 3))


// 6.函数类型做为参数
func another(add: (Int, Int) -> Int64, a: Int, b: Int) {
    print(add(a, b))
}
another(add: pow, a: 20, b: 10)

// 7.函数类型做为返回值
// 函数嵌套: 返回一个函数类型
func fun8(total: Int) -> () -> Int {
    var sum = 10;
    func fun9 () -> Int {
        sum -= total
        return sum
    }
    return fun9
}
let fun9 = fun8(total: 30)
print(fun9())

// 8.内置函数
// (1.assert(断言): 参数为true则继续, 否则抛出异常
// 断言可以引发程序终止, 主要用于调试阶段
let number = 3
assert(number > 2, "number 不大于 3")

// (2.enumerated 将 有序列 转换成以元组作为元素的序列
let arr = ["b", "a", "c"];
for (index, value) in arr.enumerated() {
    print("\(index) : \(value)")
}

// (3.min() max() 最小值, 最大值
min(3, 9)
max(2, 5, 9)

// (4.sorted 排序
let arr1 = arr.sorted()
print(arr1) // 默认升序


let arr2 = arr.sorted { (a, b) -> Bool in
    return a < b
}
print(arr2)

// (5.map函数: 遍历元素, 进行操作
let arr3 = [2, 1, 3]
// 2倍放大
let doubleArr = arr3.map{ $0 * 2 }
print(doubleArr);

// Int 转 String
let moneyArr = arr3.map{ ("¥\($0 * 2)") }
print(moneyArr)

// 数组 -> 元组
let groupArr = arr3.map{ ($0, "\($0)") }
print(groupArr)

// (6.flapMap  降维 判空
let array = [["B", "A", "C"],["1","5"]]
let flapArray = array.flatMap{ $0 }
print(flapArray)

// (7.filter 筛选
let numbers = [1, 2, 3, 4, 5, 6]
let evens = numbers.filter{ ($0 % 2 == 0) } // 获取偶数
print(evens)

// (8.reduce 求和,()内传入初始值
let sum = arr3.reduce(0) { $0 + $1 }    // 求和
print("sum=\(sum)")

let mul = arr3.reduce(0) { $0 * $1 }    // 求和
print("mul=\(mul)")

// (9.abs() 求绝对值
abs(-1)

















