//
//  MOSecondViewController.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/11/6.
//

import UIKit

class MOSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        view.addSubview(self.button)
        moPrint(self, #line, "secondView: \(view)")
    }
    
    // MARK: - Private Methods

    @objc func didClickDismissButton() {
        dismiss(animated: true)
    }
    
    // MARK: - Getter Methods
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 66, height: 44))
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(didClickDismissButton), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }()
}
