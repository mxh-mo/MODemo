import UIKit

// swift的闭包类似OC中的block
// 全局函数 和 嵌套函数 其实就是特殊的闭包
// 闭包是引用类型

// 1.形式
// (1).全局函数: 有名字但不能捕获任何值
// (2).嵌套函数: 有名字, 也能捕获封闭函数内的值
// (3).无名闭包: 使用轻量级语法, 可以根据上下文环境捕获值

// 2.优化
// (1).根据上下文推断参数和返回值类型
// (2).从单行表达式闭包何总隐式返回 (及:闭包只有一行代码, 可以省略return)
// (3).可以使用简化参数名, 如:$0, $1 ($0:第i个参数, 以此类推)
// (4).提供了尾随闭包语法

// 3.语法
//  {(参数列表) -> 返回值 in
//    闭包代码
//  }

// 最简单的闭包
// () -> () 没有参数, 没有返回值的函数
let b1 = {
    print("hello")
}
// 执行闭包
b1()

let closure:() -> Void = {
    print("closure")
}
closure()

// 4.实现
let closure1:(Int, Int) -> Int = {
    (a: Int, b: Int) -> Int in
    return a * b
}

// 简化1: 闭包类型自动推导 (省略了类型声明: (Int, Int) -> Int)
let closure2 = {
    (a: Int, b: Int) -> Int in
    return a * b
}

// 简化2: 若闭包只包含一句return, 可省略return
let closure4 = {
    (a: Int, b: Int) in
    a * b
}

// 简化3: 通过$i获取变量列表, 故可省略 参数列表(a, b) 和 关键字in
let closure5:(Int, Int) -> Int = {
    $0 * $1
}

// 闭包做为函数参数
func func1(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}
// 传入闭包
func1(4, 2, operation: closure1)
// 实现闭包
func1(4, 2) { (a: Int, b: Int) -> Int in
    return a * b
}
// 参数名缩写: 可用$0 $1...来顺序调用闭包的参数
func1(4, 2, operation: { $0 * $1 })
// 运算符函数: Int类型定义好了关于(*)运算符的实现, 正好与当前所需函数类型一致
func1(4, 2, operation: *)
// 尾随闭包: 闭包做为函数最后一个参数, 可见闭包后置到函数体外部
func1(4, 3) {
    $0 * $1
}

// 5. 捕获值
// 闭包可以从上下文环境中捕获常量, 变量, 并在自己的作用域内使用
// 即使这些量的原域已经不存在了, 闭包仍可以引用和修改
var counter = 0
let closure6 = {
    counter += 1
    print("counter: \(counter)")
}
closure6()
closure6()

func closure7(amount a: Int) -> () -> Int {
    var run = 0
    func closure() -> Int {  // 可访问 a 和 run
        run += a      // run 被拷贝并存储, 被累加?
        print("run: \(run)")
        return run;
    }
    return closure
}
let closure8 = closure7(amount: 10)
closure8()
closure8()
closure8()

// 6. 闭包在集合中的应用
// 排序: sorted()方法 (不会修改原数组)
// sorted(by:)需传入一个闭包函数, 对已知类型的数组进行排序
// 函数需传入与数组元素类型相同的两个值, 并返回一个bool值 (true:参数1 在 参数2 前)
let numbers = [7, 5, 6, 3, 2, 1]
numbers.sorted()
print("sorted(): \(numbers.sorted())")

// 更改规则, 重载函数
func rule(s1: Int, s2: Int) -> Bool {
    return s1 > s2
}
let reversed = numbers.sorted(by: rule)
print(reversed)

// 7. 一些内置函数用到的闭包
// forEach(body:) 遍历
numbers.forEach {
    print("item: \($0)")
}
// filter(isIncluded:)  过滤
let filterNums = numbers.filter {
    $0 > 4
}
print("filterNums: \(filterNums)")

// map 数组映射
let mapNums = numbers.map {
    "map\($0)"
}
print("mapNums: \(mapNums)")

// reduce 累计
let reduceNums = numbers.reduce(0) {
    return $0 + $1
}
print("reduceNums: \(reduceNums)")



// 8. 逃逸闭包 和 非逃逸闭包
// 闭包以参数形式传入函数,
// 非逃逸闭包: 闭包在函数结束前被调用
// 逃逸闭包 @escaping: 该闭包在函数返回后才被调用, 及该闭包逃离了函数的作用域

// 闭包会强引用它捕获的所有对象, 调用这些对象时隐形中使用了self
// 非逃逸闭包不会产生循环引用, 它会在函数作用域内释放
// 逃逸闭包, 强制需@escaping标记, 此时必须显示引用self

func loadData(completion: @escaping ( _ : [String]) -> () ) {
    DispatchQueue.global().async {
        print("current queue: \(Thread.current)")
        Thread.sleep(forTimeInterval: 3)
        let json = ["swift"]
        
        DispatchQueue.main.async {
            print("current queue: \(Thread.current)")
            completion(json)
        }
        print("loadData finish")
    }
}
loadData() {_ in
    print("completion")
}





