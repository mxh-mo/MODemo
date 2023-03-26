//
//  MOArrayDataSource.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//

import UIKit

typealias MOCellSelectedClosure = () -> Void
typealias MOCellConfigureClosure = (_ cell: UITableViewCell,_ item: Any) -> Void

class MOCellModel: NSObject {
    
    var title: String
    var vcName: String?
    var selectedClosure: MOCellSelectedClosure?
    
    init(_ title: String, _ vcName: String) { // TODO delete try
        self.title = title
        self.vcName = vcName
    }
    init(_ title: String, _ selectedClosure: @escaping MOCellSelectedClosure) {
        self.title = title
        self.selectedClosure = selectedClosure
    }
}

class MOArrayDataSource: NSObject, UITableViewDataSource {
    
    var sections: [[Any]]
    var cellIndentifer: String
    var cellConfigureClosure: MOCellConfigureClosure
    
    init(_ sections: [[Any]],_ cellIndentifier: String,_ cellConfigureClosure: @escaping MOCellConfigureClosure) {
        self.sections = sections
        self.cellIndentifer = cellIndentifier
        self.cellConfigureClosure = cellConfigureClosure
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let cells: [Any] = self.sections[indexPath.section]
        return cells[indexPath.row]
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells: [Any] = self.sections[section]
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIndentifer, for: indexPath)
        let item = self.itemAtIndexPath(indexPath)
        self.cellConfigureClosure(cell, item)
        return cell
    }
    
    // MARK: - 根据String生成ViewController
    func classFromString(_ className: String) -> UIViewController? {
        if className == "MOOCViewController" {
            return MOOCViewController()
        }
        // 项目名称不能包含: 数字 - or 其他一些特殊符号, 否则转换不了
        guard let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String else {
            moPrint(self, #line, "未获取到命名空间")
            return nil
        }
        
        let str = "\(appName).\(className)"
        print(str)
        
        guard let vcClass = NSClassFromString(str) else {
            moPrint(self, #line, "未获取到对应类")
            return nil
        }
        guard let vcType = vcClass as? UIViewController.Type else {
            moPrint(self, #line, "未转换成控制器类")
            return nil
        }
        let vc = vcType.init()
        return vc
    }
}
