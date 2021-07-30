//
//  MOFirstViewController.swift
//  09_MultiDelegate_Swift
//
//  Created by MikiMo on 2019/9/4.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit

class MOFirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MOFirstViewController: MOLocationManagerDelegate {
    func locationUpdate(_ locs: [String]) {
        print("MOFirstViewController: \(locs)")
    }
}
