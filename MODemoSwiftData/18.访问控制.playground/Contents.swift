import UIKit

// 访问控制

// public 可以访问自己模块中源文件里的实体文件, 别人也可以通过引入改模块来访问源文件例的所有实体
// internal 可以访问自己模块中源文件里的任何实体, 但是别人不能访问该模块中源文件里的实体
// fileprivate 文件内私有, 只能在当前文件中使用
// private 只能在类中访问, 离开了这个类或者结构体的作用域外就无法访问

// 未指定访问级别默认为 internal

// 1.函数类型访问权限
// 根据参数类型和返回类型的访问级别得出, 跟最低的一致

private class SomePrivateClass {}
class SomeInternalClass {}    // 访问级别为 internal
let someInternalConstant = 0  // 访问级别为 internal

private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
    return (SomeInternalClass(), SomePrivateClass())
}

// 2.枚举类型访问权限
// 枚举中成员的访问级别继承自该枚举，你不能为枚举中的成员单独申明不同的访问级别。

// 3.子类访问权限
// 子类的访问级别不得高于父类的访问级别


// 4.常量、变量、属性、下标访问权限
// 常量、变量、属性不能拥有比它们的类型更高的访问级别。
// 比如说，你定义一个public级别的属性，但是它的类型是private级别的，这是编译器所不允许的。

// 5.Getter 和 Setter访问权限
// 常量、变量、属性、下标索引的Getters和Setters的访问级别继承自它们所属成员的访问级别。
// Setter的访问级别可以低于对应的Getter的访问级别，这样就可以控制变量、属性或下标索引的读写权限。


// 6.构造器和默认构造器访问权限
// 初始化
// 声明时不得高于它所属类的访问级别。
// 必要构造器例外，它的访问级别必须和所属类的访问级别相同。
// 默认初始化方法 同类

// 7.协议访问权限
// 如果想为一个协议明确的申明访问级别，那么需要注意一点，就是你要确保该协议只在你申明的访问级别作用域中使用。
// 如果你定义了一个public访问级别的协议，那么实现该协议提供的必要函数也会是public的访问级别。这一点不同于其他类型
// 比如，public访问级别的其他类型，他们成员的访问级别为internal。

// 8.扩展访问权限
// 默认跟原类一致, 也可以声明???


// 8.泛型访问权限
// 泛型类型 函数本身 泛型类型参数 三者中最低

// 9.类别名 typealias
// 不得高于原类型 访问级别






