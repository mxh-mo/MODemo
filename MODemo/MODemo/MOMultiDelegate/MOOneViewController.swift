//
//  MOOneViewController.swift
//  09_MultiDelegate_Swift
//
//  Created by MikiMo on 2019/9/4.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit

class MOOneViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MOOneViewController: MOLocationManagerDelegate {
    func locationUpdate(_ locs: [String]) {
        print("MOOneViewController: \(locs)")
    }
}
