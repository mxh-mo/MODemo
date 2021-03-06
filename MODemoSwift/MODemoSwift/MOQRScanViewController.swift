//
//  MOQRScanViewController.swift
//  07_QRScan
//
//  Created by MikiMo on 2019/7/19.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
// request 权限
// Privacy - Camera Usage Description
// Privacy - Photo Library Usage Description

class MOQRScanViewController: UIViewController {
    
    deinit {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫描二维码"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: .done, target: self, action: #selector(clickPhoto))
        // scanView
        view.addSubview(scanView)
        scanView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appEnterForeground() {
        checkAuthorzation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAuthorzation()
    }
    
    // MARK: - 检查授权
    func checkAuthorzation() {
        if MOAuthorizationManager().authorizeFactory(type: .camera).status() != .authorized {
            MOAuthorizationManager().requestAuthoriza(type: .camera) { (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.loadScanView()
                        self.captureSession.startRunning()
                    }
                } else { // 没有权限
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            self.loadScanView()
            self.captureSession.startRunning()
        }
    }
    
    func loadScanView() {
        if isLoadScanView { return }
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("device error")
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            print("input error")
            return
        }
        // 或者这样写
        //    let input: AVCaptureDeviceInput
        //    do {
        //      input = try AVCaptureDeviceInput(device: device)
        //    } catch {
        //      print("input error")
        //      return
        //    }
        let output = AVCaptureMetadataOutput()
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            print("session can't add input")
            return
        }
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output) // addOutput 必须放在设置output之前
            guard output.availableMetadataObjectTypes.contains(.qr) else {
                print("session can't contains qr")
                return
            }
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) // AVCaptureMetadataOutputObjectsDelegate
            output.metadataObjectTypes = [.qr]
        } else {
            print("session can't add output")
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scanView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scanView.layer.addSublayer(previewLayer)
        
        let scanBoxView = UIImageView()
        scanBoxView.image = UIImage(named: "icon_scan_box")
        scanView.addSubview(scanBoxView)
        scanBoxView.frame = CGRect(x: 0, y: 0, width: 270, height: 270)
        scanBoxView.center = scanView.center
        
        output.rectOfInterest = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        isLoadScanView = true
    }
    
    @objc func clickPhoto() {
        if MOAuthorizationManager().authorizeFactory(type: .photo).status() != .authorized {
            MOAuthorizationManager().requestAuthoriza(type: .photo) { (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.presentPhotoLabrary()
                    }
                }
            }
        } else {
            presentPhotoLabrary()
        }
    }
    func presentPhotoLabrary() {
        let picker = UIImagePickerController()
        picker.title = "照片"
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.navigationBar.barStyle = .default
        self.present(picker, animated: true, completion: nil)
    }
    
    private var isLoadScanView = false
    private var scanView = UIView()
    private lazy var captureSession: AVCaptureSession = {
        AVCaptureSession()
    }()
}

extension MOQRScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                print("as? AVMetadataMachineReadableCodeObject faliue")
                return
            }
            guard let stringValue = readableObject.stringValue else {
                print("stringValue faliue")
                return
            }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print(stringValue)
        }
        captureSession.stopRunning()
    }
}

extension MOQRScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage,
              let cgImage = image.cgImage else {
            print("提取图片失败")
            return
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        guard let features = detector?.features(in: CIImage(cgImage: cgImage)),
              features.count > 0,
              let qrcodeFeature = features[0] as? CIQRCodeFeature,
              let messageString = qrcodeFeature.messageString else {
            print("无法识别图片中的二维码")
            return
        }
        print(messageString)
    }
}
