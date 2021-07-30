import UIKit


// 可选链: 请求/调用的目标当前可能为空(nil)
// 若可选的目标有值, 则调用成功
// 若可选的目标为空, 这返回空(nil)
// 多次调用形成一个链, 其中一个节点为空, 将导致整个链调用失败

// 根据返回值是否为空, 判断调用是否成功!!


// 例:
// 人Person有一只狗Dog, 狗有一个玩具(Toy), 玩具有价格(price)
class Toy {
    var price: Double = 0.0
}
class Dog {
    var toy: Toy?
}
class Person {
    var dog: Dog?
}
let person = Person()
let dog = Dog()
let toy = Toy()
toy.price = 100
person.dog = dog
dog.toy = toy

// 获取可选值
let price = person.dog?.toy?.price
// 加上判断
if (person.dog?.toy?.price) != nil {
    print("赋值成功");
} else {
    print("赋值失败");
}

//  可选项的判断
func demo1(x: Int?, y: Int?) {
    /**
     ?? 是一个简单的三目
     - 如果有值, 使用值
     - 如果没有值, 使用 ?? 后面的值替代
     */
    print((x ?? 0) + (y ?? 0))
    
    let name: String? = "老王"
    print((name ?? "") + "你好")
    
    // ?? 操作符优先级 低, 在使用的时候, 最好加上 () 包一下
    print(name ?? "" + "你好")
}

func demo2() {
    let oName: String? = "老王"
    let oAge: Int? = 10
    
    if oName != nil && oAge != nil {
        print(oName! + String(oAge!))
    }
    
    if var name = oName,
       let age = oAge {
        name = "老李" // 局部变量
        print(name + String(age))
    } else {
        print("name 或 age 为 nil")
    }
}

// guard let 和 if let 刚好相反
func demo3() {
    let oName: String? = "老王"
    let oAge: Int? = 10
    
    guard let name = oName,
          let age = oAge else {
        print("姓名或者年龄为 nil")
        return
    }
    print(name + String(age))
}










