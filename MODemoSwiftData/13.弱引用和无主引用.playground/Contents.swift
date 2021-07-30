import UIKit

// 弱引用: 生命周期中会变为nil的实例 (所引用对象被回收后会被置为nil, 再访问会返回nil)
// 无主引用: 初始化后不会变成nil的实例 (相当于OC的unsafe_unretained, 若所引用的对象被回收了,不会被置为nil, 此时再访问会导致运行时错误)

// 1.弱引用
class Module {
    var sub: SubModule?
    deinit {
        print("deinit Module")
    }
}

class SubModule {
    weak var mod: Module? // 弱引用
    deinit {
        print("deinit SubModule")
    }
}

var mod: Module? = Module()
var sub: SubModule? = SubModule()

mod!.sub = sub
sub!.mod = mod

mod = nil // 此时sub.mod已经被回收了, 置为nil
sub = nil

// 2.无主引用
class Student {
    var marks: Marks?
    deinit {
        print("deninit Student")
    }
}
class Marks {
    unowned let student: Student // 不可能为nil, 因为既然有这个分数存在, 就表示有这个学生
    init(stu: Student) {
        self.student = stu
    }
    deinit {
        print("deninit Marks")
    }
}
var stu: Student? = Student()

stu!.marks = Marks(stu: stu!)
stu = nil

// 3.闭包引起的循环强引用
// 例
class HTMLElement {
    let name: String?
    let text: String?
    // 循环强引用: asHTML强引用self, self强引用asHTML
    lazy var asHTML: () -> String = { // 闭包
        // 此时的self不可能为nil, 所以用无主引用 !!!
        [unowned self] in
        if let text = self.text {
            return "\(self.name) \(text) \(self.text)"
        } else {
            return "\(self.name)"
        }
    }
    init(name: String, text:String) {
        self.name = name
        self.text = text
    }
    deinit {
        print("deinit HTMLElement")
    }
}
var html: HTMLElement? = HTMLElement(name: "p", text: "swift")
print(html?.asHTML)
html = nil















