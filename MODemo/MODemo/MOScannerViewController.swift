//
//  MOScannerViewController.swift
//  MODemo
//
//  Created by MikiMo on 2021/8/3.
//

import UIKit

class MOScannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // 一、说明
        // `Scanner`继承自`NSObject`, 遵循`NSCopying`协议。是一个用于扫描指定字符串的抽象类
        // 初始化时指定需要扫描的String，可以设置需要跳过的字符集合
        // 调用scan方法，scanner会按要求扫描出需要提取的字符串
        
        // 二、初始化
        let scanner: Scanner = Scanner(string: "http://www.baidu.com?type=value&age=18")

        // 三、属性
        let string: String = scanner.string // 初始化时输入的目标字符串，只读
        let characters: CharacterSet? = scanner.charactersToBeSkipped // 想要跳过的字符串集合
        // 例如：”?111.1=222&name=mo“，把`?&`作为`charactersToBeSkipped`，则会忽略`?&`

        let caseSensitive: Bool = scanner.caseSensitive // 是否大小写敏感，默认false
        // scanner.locale 本地化，用在小数点分隔符上，一般不用指定
        let isAtEnd: Bool = scanner.isAtEnd // 字符串是否已经扫描完毕(如果都是charactersToBeSkipped则返回true)

        let scanLocation: Int = scanner.scanLocation // 扫描位置，iOS13已弃用
        let currentIndex: String.Index = scanner.currentIndex // 当前扫描位置
        
        // 四、方法
        // scannerMethod()
        
        scannURL()
        
        // 例子：解析Hex颜色字符串，返回color
//        scanColor()

    }
    
    func scannerMethod() {
        let scanner: Scanner = Scanner(string: "?11*2.2*3.3*namemoyan&Tqqyycxcttage=18")
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "?*&") // 指定需要过滤的字符集合

        var intNum: Int = 0
        scanner.scanInt(&intNum) // 还可以扫描 int32 int64 的数字
        moPrint(self, #line, intNum) // 11

        var float1: Float = 0.0
        scanner.scanFloat(&float1) // 还可以扫描 Double 的数字
        moPrint(self, #line, float1) // 2.2

        let decimal: Decimal? = scanner.scanDecimal()   // 扫描小数
        moPrint(self, #line, decimal ?? " ") // 3.3

        let str1: String? = scanner.scanString("name") // 扫描指定字符串
        moPrint(self, #line, str1 ?? "") // name

        // 扫描指定字符集
        let str2: String? = scanner.scanCharacters(from: CharacterSet(charactersIn: "moxiaoyan"))
        moPrint(self, #line, str2 ?? "") // moyan

        // 扫描一个字符
        let chart: Character? = scanner.scanCharacter()
        moPrint(self, #line, chart ?? "") // T

        // 扫描到指定字符串时停下，result是指定字符串前面的字符串
        let str3: String? = scanner.scanUpToString("yy")
        moPrint(self, #line, str3 ?? "") // qq

        // 扫描到指定字符集合时停下，result是指定字符前面的字符串
        let str4: String? = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "eag"))
        moPrint(self, #line, str4 ?? "") // yycxctt
    }
    
    func scannURL() {
        let scanner: Scanner = Scanner(string: "http://www.baidu.com?name=momo&age=18")
        let domain = scanner.scanUpToString("?")
        moPrint(self, #line, domain) // http://www.baidu.com

        scanner.scanCharacter()

        var param: [String: String] = [:]
        while !scanner.isAtEnd {
            let type = scanner.scanUpToString("=")
            scanner.scanCharacter()
            let value = scanner.scanUpToString("&")
            guard let type = type else {
                break
            }
            param[type] = value
        }
        moPrint(self, #line, param) //["name": "momo", "&age": "18"]

    }
    
    func scanColor() {
        let color: UIColor? = color(hex: "#5468FF")
        moPrint(self, #line, color ?? " ")

        let moView = UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        moView.backgroundColor = color
        view.addSubview(moView)
    }
    
    // MARK - 解析Hex颜色字符串，返回color
    func color(hex: String) -> UIColor? {
        
        guard hex.count >= 7 else {
            return nil
        }
        
        var tempHex = hex
        if tempHex.hasPrefix("#") {
            tempHex = String(tempHex.dropFirst()) // 去掉`#`前缀
        }
        
        let redStr = tempHex[0...1]
        let greenStr = tempHex[2...3]
        let blueStr = tempHex[4...5]

        var redInt: UInt64 = 0
        var greenInt: UInt64 = 0
        var blueInt: UInt64 = 0
        Scanner(string: redStr).scanHexInt64(&redInt)
        Scanner(string: greenStr).scanHexInt64(&greenInt)
        Scanner(string: blueStr).scanHexInt64(&blueInt)
        
        let color = UIColor(red: CGFloat(Double(redInt) / 255.0),
                            green: CGFloat(Double(greenInt) / 255.0),
                            blue: CGFloat(Double(blueInt) / 255.0),
                            alpha: 1)
        return color
    }
}

