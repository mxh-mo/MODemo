//
//  MOTableViewStyleViewController.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//

import UIKit

class MOTableViewStyleViewController: UITableViewController {
    
    private let dataSource:[String] = ["default", "value1", "value2", "subtitle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableStyle"
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: .grouped)
        // plain：贴边 section间默认无间距
        // grouped：上下间距  section间默认有间距
        // insetGrouped：同grouped 多了圆角 iOS13以上才支持
        tableView.tableFooterView = UIView()
    }
}

extension MOTableViewStyleViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = dataSource[indexPath.row]
        if style == "default" {
            // detailTextLabel 不会显示
            let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = "default"
            cell.detailTextLabel?.text = "detailTextLabel"
            cell.accessoryType = .disclosureIndicator // > (默认灰色)
            return cell
        } else if style == "value1" {
            // textLabel靠左；detailTextLabel靠右 灰色
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
            cell.textLabel?.text = "value1"
            cell.detailTextLabel?.text = "detailTextLabel"
            cell.accessoryType = .checkmark // √ (默认蓝色)
            return cell
        } else if style == "value2" {
            // 默认字号小
            // textLabel 默认蓝色，距离左边很宽的间距
            // detailTextLabel 贴着textLabel
            let cell = UITableViewCell(style: .value2, reuseIdentifier: "value2")
            cell.textLabel?.text = "value2"
            cell.detailTextLabel?.text = "detailTextLabel"
            cell.accessoryType = .detailDisclosureButton // 感叹号按钮+>
            //      cell.accessoryView 可以替换 感叹号按钮
            return cell
        } else {
            // textLabel在上；detailTextLabel在下一行 缩小显示
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
            cell.textLabel?.text = "subtitle"
            cell.detailTextLabel?.text = "detailTextLabel"
            cell.accessoryType = .detailButton // 感叹号按钮
            return cell
        }
    }
}
