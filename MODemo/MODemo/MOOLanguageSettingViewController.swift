//
//  MOOLanguageSettingViewController.swift
//  MODemo
//
//  Created by mikimo on 2025/3/6.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

import UIKit

enum LanaguageType {
    case chinese, english
}

class MOOLocalizableManager: NSObject {
    static let shared = MOOLocalizableManager()
    
    func localString(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: "", table: "Localizable")
    }
    
    func updateLanguageType(_ type: LanaguageType) {
        self.lanaguageType = type
        
        var typeStr = ""
        switch type {
        case .chinese:
            typeStr = "zh-Hans"
            UserDefaults.standard.setValue("zh-Hans", forKey: "language")
        case .english:
            typeStr = "en"
            UserDefaults.standard.setValue("en", forKey: "language")
        }
        let path = Bundle.main.path(forResource: typeStr, ofType: "lproj")
        self.bundle = Bundle(path: path!)!
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "languageChanged"), object: nil)
    }
    
    private var lanaguageType: LanaguageType = .chinese
    
    private var bundle: Bundle = Bundle.main

}

class MOOLanguageSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        view.addSubview(tableView)
        refresh()
    }
    
    func refresh() {
        let section0 = [MOCellModel(MOOLocalizableManager.shared.localString("English"), {
            MOOLocalizableManager.shared.updateLanguageType(.english)
            self.refresh()
        }),
                        MOCellModel(MOOLocalizableManager.shared.localString("Chinese"), {
            MOOLocalizableManager.shared.updateLanguageType(.chinese)
            self.refresh()
        })
        ]
        let cellConfigure: MOCellConfigureClosure = { (cell: UITableViewCell, item: Any) in
            guard let it: MOCellModel = item as? MOCellModel else {
                return
            }
            cell.textLabel?.text = it.title
        }
        self.dataSource = MOArrayDataSource([[], section0], "MOCellIndentifier", cellConfigure)
        tableView.dataSource = self.dataSource
        tableView.reloadData()
    }
    
    private var dataSource: MOArrayDataSource?
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIndentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerIndentifier)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        return tableView
    }()

    override func viewSafeAreaInsetsDidChange() {
        let insets: UIEdgeInsets = view.safeAreaInsets
        let frame: CGRect = CGRect(x: insets.left, y: insets.top, width: UIScreen.main.bounds.width - insets.left - insets.right, height: UIScreen.main.bounds.height - insets.top - insets.bottom)
        tableView.frame = frame
        tableView.reloadData()
    }
}

extension MOOLanguageSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item: MOCellModel = self.dataSource?.itemAtIndexPath(indexPath) as! MOCellModel
        
        if indexPath.section == 0 {
            guard let vcName = item.vcName else {
                moPrint(self, #line, "vcName 为空")
                return
            }
            
            guard let vc = self.dataSource?.classFromString(vcName) else {
                moPrint(self, #line, "获取控制器失败")
                return
            }
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if let selected = item.selectedClosure {
                selected()
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIndentifier)
        header?.textLabel?.text = section == 0 ? "跳转" : "执行"
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
