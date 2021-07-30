import UIKit

// 在 Swift 中，错误用符合Error协议的类型的值来表示。这个空协议表明该类型可以用于错误处理。
// 为了表示一个函数、方法或构造器可以抛出错误，在函数声明的参数列表之后加上throws关键字。一个标有throws关键字的函数被称作throwing函数。如果这个函数指明了返回值类型，throws关键词需要写在箭头（->）的前面。

enum Error1: Error {
    case ErrorOne
    case ErrorTwo
    case ErrorThree(String)
    case ErrorOther
}

func numberTest(num: Int) throws {
    if num == 1 {
        print("成功")
    } else if num == 2 {
        throw Error1.ErrorTwo
    } else if num == 3 {
        throw Error1.ErrorThree("失败")
    } else {
        throw Error1.ErrorOther
    }
}

func throwDeliver(num: Int) throws -> String {
    try numberTest(num: num)
    return "无错误"
}

// 使用do-catch捕获异常
// do闭包里执行会抛出异常的代码, catch分支里匹配异常处理
do {
    try throwDeliver(num: 2)
} catch Error1.ErrorOne {
    print("ErrorOne")
} catch Error1.ErrorTwo {
    print("ErrorTwo")
} catch Error1.ErrorThree(let description) {
    print("ErrorThree:" + description)
} catch Error1.ErrorOther {
    print("ErrorOther")
}

// 将异常转换成可选值
if let returnMessage = try? throwDeliver(num: 1) {
    print("可选值非空:" + returnMessage)
}

// 禁止异常传递, 只有但你确定这个语句不会抛出异常你才可以这么做, 否则会引发运行时错误
print(try! throwDeliver(num: 1) + "禁止错误传递")


// guard 守护, 表达式返回值为Opertion
guard let age = str3 else {
    print("未成年, 不得进入")
    throw Error1.ErrorOne
}
















