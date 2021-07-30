import UIKit

// 1. 算数运算符 + - * /  %(求余)
// 注意: swift3 中已经取消了 ++ --
// 例
var A = 10
var B = 20

print("A + B 结果为：\(A + B)")
print("A - B 结果为：\(A - B)")

A += 1   // 类似 A++
print("A += 1 后 A 的值为 \(A)")
B -= 1   // 类似 B--
print("B -= 1 后 B 的值为 \(B)")

// 2. 比较运算符  ==   !=   >   <   >=   <=
print("A == B 结果为：\(A == B)")
print("A != B 结果为：\(A != B)")


// 3. 逻辑运算符 && || !
var a = true
var b = false
print("a && b 结果为：\(a && b)")
print("a || b 结果为：\(a || b)")
print("!a 结果为：\(!a)")

// 4. 位运算符
// ~ : 取反
// & : 按位与与     (有0为0)
// | : 按位与或     (有1为1)
// ^ : 按位与异或   (相同为0 不同为1)
// << : 按位左移
// >> : 按位右移
var x = 60  // 二进制为 0011 1100
var y = 13 // 二进制为 0000 1101
print("x&y 结果为：\(x&y)")
print("x|y 结果为：\(x|y)")
print("x^y 结果为：\(x^y)")
print("~x 结果为：\(~x)")

// 5. 赋值运算
// +=  -=  *=  /=  %=  <<=  >>=  &=  ^=  |=

// 区间运算符
// 闭区间 (a...b)   1...5
// 半开区间 (a..)   1..<5
print("闭区间运算符:")
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}

print("半开区间运算符:")
for index in 1..<5 {
    print("\(index) * 5 = \(index * 5)")
}


// 6. 三元运算符 condition ? X : Y

// 7. 运算符优先级
// 指针最优，单目运算优于双目运算。如正负号。
// 先乘除（模），后加减。
// 先算术运算，后移位运算，最后位运算。请特别注意：1 << 3 + 2 & 7 等价于 (1 << (3 + 2))&7
// 逻辑运算最后计算


// 8. 循环
// for in
// while
var index = 10
while index < 15 {
    index += 1;
    print("index: ", index)
}

// repeat while (至少执行一次, 循环结束才判断下一次的条件)
repeat {
    // dong something
} while (true)  // 数字0 字符串"0" 空数组 未定义变量都是false


// continue 停止本次循环, 开始下一次循环
// break 中断当前循环
// fallthrought case里,继续下一个case









