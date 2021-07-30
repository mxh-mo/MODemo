import UIKit

// 下标脚本 subscript
// 类 结构体 枚举
// 在实例后面的[]中传入1个/n个索引值来进行访问和赋值

// 例1
struct subExample {
    let decrementer: Int
    subscript(index: Int) -> Int {
        return decrementer / index
    }
}
let division = subExample(decrementer: 100)
print("100 / 9 = \(division[9])")
print("100 / 2 = \(division[2])")

// 例2
class WeekDays {
    private var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Staturaday", "Sunday"]
    subscript(index: Int) -> String {
        get {
            return days[index]
        }
        set(newValue) {
            self.days[index] = newValue
        }
    }
}
var days = WeekDays()
print(days[0])
days[2] = "wednesday"
print(days[2])























