//
//  MOMultiDelegateViewController.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//

import UIKit

class MOMultiDelegateViewController: UIViewController {
    
    private let first: MOOneViewController = MOOneViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let updateBtn = UIButton(type: .custom)
        updateBtn.frame = CGRect(x: 50, y: 80, width: 200, height: 50)
        updateBtn.setTitle("UpdateLocation", for: .normal)
        updateBtn.setTitleColor(.red, for: .normal)
        updateBtn.addTarget(self, action: #selector(clickUpdateBtn), for: .touchUpInside)
        view.addSubview(updateBtn)
        
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: 50, y: 150, width: 200, height: 50)
        addBtn.setTitle("addDelegate", for: .normal)
        addBtn.setTitleColor(.red, for: .normal)
        addBtn.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
        view.addSubview(addBtn)
        
        let removeBtn = UIButton(type: .custom)
        removeBtn.frame = CGRect(x: 50, y: 220, width: 200, height: 50)
        removeBtn.setTitle("removeDelegate", for: .normal)
        removeBtn.setTitleColor(.red, for: .normal)
        removeBtn.addTarget(self, action: #selector(clickRemoveBtn), for: .touchUpInside)
        view.addSubview(removeBtn)
        
        let removeAllBtn = UIButton(type: .custom)
        removeAllBtn.frame = CGRect(x: 50, y: 290, width: 200, height: 50)
        removeAllBtn.setTitle("removeAllDelegate", for: .normal)
        removeAllBtn.setTitleColor(.red, for: .normal)
        removeAllBtn.addTarget(self, action: #selector(clickRemoveAllBtn), for: .touchUpInside)
        view.addSubview(removeAllBtn)
        
        MOLocationManager.shared.add(self)
    }
    
    @objc func clickUpdateBtn() {
        MOLocationManager.shared.locationUpdate()
    }
    
    @objc func clickAddBtn() {
        MOLocationManager.shared.add(self.first)
    }
    
    @objc func clickRemoveBtn() {
        MOLocationManager.shared.remove(self)
    }
    
    @objc func clickRemoveAllBtn() {
        MOLocationManager.shared.removeAll()
    }
}

extension MOMultiDelegateViewController: MOLocationManagerDelegate {
    func locationUpdate(_ locs: [String]) {
        moPrint(self, #line, "ViewController: \(locs)")
    }
}
