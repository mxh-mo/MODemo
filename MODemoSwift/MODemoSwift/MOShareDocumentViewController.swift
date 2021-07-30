//
//  MOShareDocumentViewController.swift
//  MODemoSwift
//
//  Created by MikiMo on 2020/12/18.
//
// https://www.jianshu.com/p/eb4046478ed6
// https://www.jianshu.com/p/978d38533c5c

import UIKit

class MOShareDocumentViewController: UIViewController {
    
    var url: URL?
    var documentController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 获取 Document/Inbox 里从其他app分享过来的文件
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        var documentUrl = urlForDocument[0] as URL
        documentUrl.appendPathComponent("Inbox", isDirectory: true)
        do {
            let contentsOfPath = try manager.contentsOfDirectory(at: documentUrl,
                                                                 includingPropertiesForKeys: nil,
                                                                 options: .skipsHiddenFiles)
            self.url = contentsOfPath.first // 保存，为了展示分享
            print("contentsOfPath:\n\(contentsOfPath)")
        } catch {
            print("error:\(error)")
        }
        
        let btn = UIButton(type: .custom)
        btn.setTitle("分享", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(clickShare), for: .touchUpInside)
        btn.frame = CGRect(x: 100, y: 200, width: 60, height: 44);
        self.view.addSubview(btn)
        
    }
    
    // MARK: - 点击分享文件
    @objc func clickShare() {
        if let url = self.url {
            documentController = UIDocumentInteractionController(url: url)
            documentController?.presentOptionsMenu(from: self.view.bounds, in: self.view, animated: true)
        }
    }
    
}

/*
 
 <key>CFBundleDocumentTypes</key>
 <array>
 <dict>
 <key>CFBundleTypeName</key>
 <string>OFFICE Document</string>
 <key>LSHandlerRank</key>
 <string>Owner</string>
 <key>LSItemContentTypes</key>
 <array>
 <string>com.adobe.pdf</string>
 </array>
 </dict>
 <dict>
 <key>CFBundleTypeName</key>
 <string>Binary</string>
 <key>LSHandlerRank</key>
 <string>Alternate</string>
 <key>LSItemContentTypes</key>
 <array>
 <string>public.data</string>
 <string>public.executable</string>
 <string>com.apple.mach-o-binary</string>
 <string>com.apple.pef-binary</string>
 </array>
 </dict>
 </array>
 
 */
