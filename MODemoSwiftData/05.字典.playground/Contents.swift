import UIKit

// 字典元素类型必须相同, 否则报错
// 泛型集合

// 创建字典
// var dic = [keyType: valueType]()
// var dic:[keyType: valueType] = [key:value, key:value]
var dic1 = [Int: String]()
var dic2:[Int: String] = [1:"One", 2:"Two", 3:"Three", 4:"four", 5:"five"]
var dic3 = ["name":"summer", "age":18] as [String : Any]
dic2.count
dic2.isEmpty

// 访问字典
dic2[1]
dic2.keys
dic2.values

// 修改字典
dic2.updateValue("one", forKey: 1)
dic2[2] = "two"
dic3["name"] = "sun"

// 删除key-value对
dic2.removeValue(forKey: 3)
dic2[2] = nil
print(dic2)

// 遍历字典
for (key, value) in dic2 {
    print("key:\(key), value:\(value)")
}

for (key, value) in dic2.enumerated() {
    print("enumerated \(key):\(value)")
}









