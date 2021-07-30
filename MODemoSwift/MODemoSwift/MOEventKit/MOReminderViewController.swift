//
//  MOReminderViewController.swift
//  08_EventKit
//
//  Created by MikiMo on 2019/8/26.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit
import EventKit
// Privacy - Reminders Usage Description
// 提醒事件：增 删 改 查
class MOReminderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkReminder()
        
    }
    
    private func checkReminder() {
        // .reminder 提醒
        // 1.检查授权
        store.requestAccess(to: .reminder) { (granted, error) in
            if granted { // 已授权
                print("已授权")
                self.inquireReminder()
            } else { // 未授权：需要request
                print("未授权, 若需使用此功能，需要提醒用户去系统设置页面开启提醒权限")
                // TODO Alert
            }
        }
    }
    // MARK: 2.查询提醒事件
    private func inquireReminder() {
        // 1).使用谓词
        // starting = nil 表示从最开始查找
        // ending = nil 表示查找到最后
        // 查找未完成的提醒
        var predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
        
        // 查找完成的提醒
        predicate = store.predicateForCompletedReminders(withCompletionDateStarting: nil, ending: nil, calendars: nil)
        
        // 查找所有提醒
        predicate = store.predicateForReminders(in: nil)
        
        
        store.fetchReminders(matching: predicate) { [weak self] (reminders) in
            guard (reminders != nil) else {
                return
            }
            self?.reminders = reminders
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            for reminder in reminders! {
                // 与日历事件不同的是，该方法为异步回调，不需要另外开线程
                // 如果想要停止获取的操作，return cancelFetchRequest
                print("reminder: \(reminder)")
                print("alarm: \(reminder.alarms?.first)")
                // TODO 公司需求: 获取下一次提醒时间
                //        print("下一次提醒时间： \(MOTool().nextAlertTime(reminder: reminder))")
                
            }
        }
        // 2).使用identifer查找
        store.calendarItem(withIdentifier: "")
    }
    // MARK: - 3.创建
    @objc private func addReminder() {
        let reminder: EKReminder = EKReminder(eventStore: store)
        reminder.calendar = store.defaultCalendarForNewReminders()
        reminder.title = "提醒你哦~"
        reminder.priority = 1 // 优先级: 1-4:high 5:medium 6-9:low
        let alarm = EKAlarm(absoluteDate: Date(timeIntervalSinceNow: 20))
        reminder.addAlarm(alarm)
        do {
            try store.save(reminder, commit: true)
        } catch {
            print("save reminder error: \(error)")
        }
        DispatchQueue.main.async {
            self.inquireReminder() // 重新查询，并刷新列表
        }
    }
    // MARK: - 一些没用的UI
    private func setupView() {
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 16, y: 30, width: 50, height: 50)
        backBtn.setTitle("Back", for: .normal)
        backBtn.setTitleColor(.red, for: .normal)
        backBtn.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.addSubview(backBtn)
        
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: 80, y: 30, width: 50, height: 50)
        addBtn.setTitle("Add", for: .normal)
        addBtn.setTitleColor(.red, for: .normal)
        addBtn.addTarget(self, action: #selector(addReminder), for: .touchUpInside)
        view.addSubview(addBtn)
        
        view.backgroundColor = .white
        tableView = UITableView(frame: CGRect(x: 0, y: 80, width: self.view.frame.size.width, height: self.view.frame.size.height - 80), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(tableView)
    }
    @objc private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    private var store: EKEventStore = EKEventStore() // 初始化和释放时间比较长，建议写成单例
    private var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private var reminders: [EKReminder]?
}

extension MOReminderViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - 4.修改，在点击方法里做了些默认的修改
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder: EKReminder = reminders![indexPath.row]
        reminder.title = "修改后的 提醒你哦~"
        reminder.addAlarm(EKAlarm(absoluteDate: Date().addingTimeInterval(20)))
        do {
            try store.save(reminder, commit: true)
        } catch {
            print("remove error: \(error)")
        }
        DispatchQueue.main.async {
            self.inquireReminder() // 重新查询，并刷新列表
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    // MARK: - 5.删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let reminder: EKReminder = reminders![indexPath.row]
        do {
            try store.remove(reminder, commit: true)
        } catch {
            print("remove error: \(error)")
        }
        DispatchQueue.main.async {
            self.inquireReminder() // 重新查询，并刷新列表
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let reminder: EKReminder = reminders![indexPath.row]
        cell.textLabel?.text = reminder.title
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders?.count ?? 0
    }
}
