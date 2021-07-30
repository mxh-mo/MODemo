import UIKit


// is 类型检查
// as 向下转型
// as? 类型转换的条件形式, 不确定是否转型成功, 返回Option值
// as! 类型转换的强制形式, 确定一定能转型成功时

class Subject {
    var name: String
    init(name: String) {
        self.name = name
    }
}
class Chemistry: Subject {
}
class Maths: Subject {
}

let chemistry = Chemistry(name: "化学")
let maths = Maths(name: "数学")

let subjects = [chemistry, maths]

for index in 0..<subjects.count {
    // is 类型检查
    if subjects[index] is Chemistry {
        print("\(index) is 化学")
    } else if subjects[index] is Maths {
        print("\(index) is 数学")
    }
}

for item in subjects {
    // as? 条件转换, 是该类型则转换成功, 否则返回nil
    if let show = item as? Chemistry {
        print("化学: \(show.name)")
    } else if let show = item as? Maths {
        print("数学: \(show.name)")
    }
}

// Any 可以表示任何类型, 包括值类型, 方法类型
// AnyObject 可以表示任何class类型的实例
var anys: [Any] = [chemistry, maths, 12, 3.14, "Any"]
for any in anys {
    switch any {
    case let item as Int: print("Int \(item)")
    case let item as Double: print("Double \(item)")
    case let item as String: print("String \(item)")
    case let item as Chemistry: print("Chemistry \(item)")
    case let item as Maths: print("Maths \(item)")
    default: print("None")
    }
}















