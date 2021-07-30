import UIKit

// 类和结构体在实例创建时, 必须为所有存储型属性设置合适的初始值
// 存储属性在构造器中赋值时, 是直接设置, 不会触发任何属性观测器

// ---------------- 结构体
// 结构体: 可以定义属性(常量, 变量)和添加方法, 从而扩展结构体的功能
// 赋值: 值传递

struct rectangle {
    var length: Double
    var breadth: Double
    var are: Double?  // 可选型 值属性 默认初始化为nil
    init() {  // 必须为所有存储型属性设置初始值
        length = 6
        breadth = 12
    }
}

struct nameStruct {
    // 或在声明时设置默认值
    var name1 = "name_1"
    var name2 = "name_2"
    func sayHi() {
        print("nameStruct Hi")
    }
}
let names = nameStruct()
names.sayHi()

struct StudentMark {
    var mark1: Int
    var mark2: Int
    var mark3: Int
    mutating func scaleBy(res: Int) { // mutating 变异方法, 可以改变结构体内的值类型属性
        mark1 *= res
        mark2 *= res
        mark3 *= res
    }
}
let marks = StudentMark(mark1: 100, mark2: 78, mark3: 98)

// 结构体常量, 属性不能改变
// 类常量, 属性可以改变

// ---------------- 类
// 当需要重写父类指定构造器时, 需要加override修饰符
// 父类加上final修饰符的 属性,方法 都是禁止覆盖的
class Person {
    var name: String
    var age: Int  //  加final: 禁止override
    let gender: String
    // 可失败构造器 ?
    init?(name: String, age: Int, gender: String) {
        if name.isEmpty { return nil }
        self.name = name
        self.age = age
        self.gender = gender  // 可以在构造器里修改常量值
    }
    // 析构函数
    deinit {
        // todo something
    }
}

class Student : Person {
    var mark1: Int
    var mark2: Int
    // 指定构造器 designated initializers (必须调用父类init)
    init(person: Person, mark1: Int, mark2: Int) {
        // 需要保证在子类实例的成员初始化完成后才能调用父类的初始化方法
        self.mark1 = mark1
        self.mark2 = mark2
        super.init(name: person.name, age: person.age, gender: person.gender)!
    }
    // 遍历构造器 convenience initializer (必须调用自己的一个指定构造器)
    convenience override init(name: String, age: Int, gender: String) {
        self.init(person: Person(name: name, age: age, gender: gender)!, mark1: 0, mark2: 0)
    }
    // 子类不能直接覆盖父类属性, 只能覆盖set/get方法来实现
    override var age : Int {
        set {
            self.age = newValue
        }
        get {
            return self.age
        }
    }
    
    func sayHi() {
        print("Student Hi")
    }
    lazy var nams = nameStruct()  // lazy懒存储属性: 第一次被调用时才创建
    
    // 计算型属性: 不会存储值, 提供getter和可选setter
    var average: Int {
        get {
            return (self.mark1 + self.mark2 ) / 2
        }
        set(newAverage) {
            self.mark1 = newAverage;
            self.mark2 = newAverage;
        }
    }
    // 只读的计算型属性: 只有getter方法, 必须用var修饰, 因为其值是不固定的
    var aver : Int {
        return (self.mark1 + self.mark2 ) / 2
    }
    
    // 属性观察者
    // willSet和didSet观察器在属性初始化过程中不会被调用
    var totalSteps: Int = 0 {
        // 值被存储之前调用
        willSet (newTotalSteps) {
            print("newTotalSteps: \(newTotalSteps)")
        }
        // 值被存储之后调用
        didSet {
            print("totalSteps: \(totalSteps)  oldValue: \(oldValue)")
        }
    }
}

let stu1 = Student(person:Person(name: "momo", age: 25, gender: "girl")!, mark1: 100, mark2: 99)
print("name: \(stu1.name), \(stu1.mark1), \(stu1.mark2)")
stu1.sayHi()

var stu2 = Student(person:Person(name: "lili", age: 24, gender: "boy")!, mark1: 100, mark2: 99)

if stu1 === stu2 {
    print("恒等")   // stu1 === stu2
} else {
    print("不恒等")  // stu1 !== stu2
}

stu2 = stu1
if stu1 !== stu2 {
    print("不恒等")
} else {
    print("恒等")
}

// 便利构造器 convenience
// 常用在对系统的类进行构造函数的扩充时使用
class User : NSObject {
    var name: String = ""
    override convenience init() {
        self.init()
        self.name = "name"
    }
}

// 类型属性, 关键字static修饰 (结构体 枚举 类)
// (1).结构体
struct SomeStruct {
    static var storedProperty = "SomeStruct.property"
    static var computedproperty: Int {
        return 1
    }
    // 类型方法
    static func sayHi() {
        print("\(self) sayHi")
    }
}
print(SomeStruct.storedProperty)
SomeStruct.sayHi()

// (2).枚举
enum SomeEnum {
    static var storedProperty = "SomeEnum.property"
    static var computedproperty: Int {
        return 6
    }
    // 类型方法
    static func sayHi() {
        print("\(self) sayHi")
    }
}
print(SomeEnum.computedproperty)
SomeEnum.sayHi()

// (3).类
class SomeClass {
    static var storedProperty = "SomeClass.property"
    static var computedproperty: Int {
        return 27
    }
    class func sayHi() {
        print("\(self) sayHi ")
    }
}
print(SomeClass.computedproperty)
SomeClass.sayHi()


// 防止继承 final class
// 防止子类重写: final ...(属性定义)


/*
 Swift中的类和结构体有许多相同点：
 >> 定义属性
 >> 定义方法
 >> 定义下标，可使用下标来存取他们的值
 >> 定义初始化方法
 >> 可被扩展
 >> 遵从协议
 
 类有一些结构体所没有的能力：
 >> 继承
 >> 类型转化，可以在运行时检查和解析某个类实例的类型。
 >> 析构器
 >> 引用计数
 */




