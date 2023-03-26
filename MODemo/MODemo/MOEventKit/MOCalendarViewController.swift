//
//  MOCalendarViewController.swift
//  08_EventKit
//
//  Created by MikiMo on 2019/8/26.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit
import EventKit
// Privacy - Calendars Usage Description
// 日历事件：增 删 改 查
class MOCalendarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkCalender()
    }
    
    func checkCalender() {
        // .event 日历
        // 1.检查授权
        store.requestAccess(to: .event) { (granted, error) in
            if granted { // 已授权
                moPrint(self, #line, "已授权")
                self.inquireCalender()
            } else { // 未授权：需要request
                moPrint(self, #line, "未授权, 若需使用此功能，需要提醒用户去系统设置页面开启日历权限")
                // TODO Alert
            }
        }
    }
    
    // MARK: 查询日历事件
    func inquireCalender() {
        // 1.使用谓词
        let calendar = NSCalendar.current
        // 开始时间
        var startComponents = DateComponents()
        startComponents.day = 0
        let startDate:Date = calendar.date(byAdding: startComponents, to: Date()) ?? Date()
        moPrint(self, #line, "onDateAgo: \(startDate)")
        // 结束时间
        var endComponents = DateComponents()
        endComponents.month = 3
        let endDate:Date = calendar.date(byAdding: endComponents, to: Date()) ?? Date()
        moPrint(self, #line, "onDateAgo: \(endDate)")
        
        // 参数calendars是一个calendar的集合，如果为nil，表示所有用户的calendars
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        // 该方法为同步方法，最好放在工作线程里做
        let events = store.events(matching: predicate)
        
        // sort 按时间排序
        //    var stortedEvents = Array<EKEvent>()
        //    stortedEvents = events.sorted { (event1, event2) -> Bool in
        //      return event1.startDate.compare(event2.startDate) == .orderedAscending
        //    }
        moPrint(self, #line, "events: \(events)")
        self.events = events
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        // 2.使用identifier获取
        //    store.event(withIdentifier: "")
    }
    // MARK: - 创建
    @objc private func addCalendar() {
        // 3.创建
        let event = EKEvent(eventStore: store)
        event.title = "私人课"
        event.startDate = Date()
        event.endDate = Date().addingTimeInterval(1000)
        let alarm = EKAlarm(absoluteDate: Date().addingTimeInterval(500))
        event.addAlarm(alarm)
        event.calendar = store.defaultCalendarForNewEvents
        // 重复 EKRecurrenceRule
        // 如果你提供了多种参数组合，则只会执行days的方式
        let weekDays = [EKRecurrenceDayOfWeek(.monday), EKRecurrenceDayOfWeek(.friday)]
        let recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: weekDays, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        event.addRecurrenceRule(recurrenceRule)
        do {
            try store.save(event, span: .futureEvents, commit: true)
        } catch {
            moPrint(self, #line, "save calendar error:\(error)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.inquireCalender() // 重新查询，并刷新列表
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
        addBtn.addTarget(self, action: #selector(addCalendar), for: .touchUpInside)
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
    private var events: [EKEvent]?
}

extension MOCalendarViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - 修改，在点击方法里做了些默认的修改
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 5.修改
        let event: EKEvent = events![indexPath.row]
        event.title = "修改后的 私人课~"
        do {
            try store.save(event, span: .futureEvents, commit: true)
        } catch {
            moPrint(self, #line, "remove error: \(error)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.inquireCalender() // 重新查询，并刷新列表
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    // MARK: - 删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 4.删除
        let event: EKEvent = events![indexPath.row]
        do {
            try store.remove(event, span: .futureEvents, commit: true)
        } catch {
            moPrint(self, #line, "remove error: \(error)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.inquireCalender() // 重新查询，并刷新列表
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let event: EKEvent = events![indexPath.row]
        cell.textLabel?.text = event.title
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
}
