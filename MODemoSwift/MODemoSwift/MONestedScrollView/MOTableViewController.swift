//
//  MOTableViewController.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/8/17.
//

import UIKit

class MOTableViewController: UITableViewController, MOSubScrollViewProtocol {

    // MARK: - MOSubScrollViewProtocol
    var willBeginDragging: MOSubScrollWillBeginDragging?
    var didScroll: MOSubScrollDidScroll?
    var scrollView: UIScrollView {
        get {
            return self.tableView
        }
    }
    
    // MARK: - UIScrollViewDelegate

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let willBeginDragging = self.willBeginDragging else {
            return
        }
        willBeginDragging(scrollView)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let didScroll = self.didScroll else {
            return
        }
        didScroll(scrollView)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = String(format: "%ld", indexPath.row)
        return cell
    }
}
