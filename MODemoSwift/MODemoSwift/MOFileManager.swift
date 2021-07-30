//
//  MOFileManager.swift
//  MODemoSwift
//
//  Created by MikiMo on 2020/1/9.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

import UIKit

struct MOFileManager {
    static let shareInstance = MOFileManager()
    
    init () {
        let urls: [URL] = manager.urls(for: .documentDirectory, in: .userDomainMask)
        // .libraryDirectory、.cachesDirectory ...
        self.documentURL = urls.first!
    }
    
    // MARK: - 创建文件夹
    func creatFolder(_ name: String) {
        print("\n创建文件夹:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        print("url:\(url)")
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        print("isDirectory:\(isDirectory) isExist:\(isExist)")
        if !isExist {
            do {
                try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("createDirectory error:\(error)")
            }
        }
    }
    // MARK: - 创建文件, 并写入内容
    func createFile(_ name: String) {
        print("\n创建文件, 并写入内容:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        print("file:\(url)")
        let string = "moxiaoyan"
        do {
            try string.write(to: url, atomically: true, encoding: .utf8)
            // Data、Array、Dictionary、Image 都可以write
        } catch {
            print("write string error:\(error)")
        }
    }
    // MARK: - 文件夹/文件 信息
    func enableFile(_ name: String) {
        print("\n文件信息:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        print("file:\(url)")
        
        // 可读、可写、可执行、可删除
        let readable = manager.isReadableFile(atPath: url.path)
        let writeable = manager.isWritableFile(atPath: url.path)
        let executable = manager.isExecutableFile(atPath: url.path)
        let deleteable = manager.isDeletableFile(atPath: url.path)
        print("readable:\(readable) writeable:\(writeable) executable:\(executable) deleteable:\(deleteable)")
        
        // NSFileCreationDate:创建时间、NSFileSize:文件大小、NSFileType:文件类型...
        do {
            let attributes: Dictionary = try manager.attributesOfItem(atPath: url.path)
            print("attributes\(attributes)")
            let fileSize = attributes[FileAttributeKey.size] as! Int
            print("fileSize:\(fileSize)")
        } catch {
            print("attributes error: \(error)")
        }
    }
    // MARK: - 删除 文件夹/文件
    func deleteFile(_ name: String) {
        print("\n删除文件夹/文件:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        print("url:\(url)")
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        print("isDirectory:\(isDirectory) isExist:\(isExist)")
        if isExist {
            do {
                try manager.removeItem(at: url) // 删除文件
                //        try manager.removeItem(atPath: url.path) // 删除文件路径
            } catch {
                print("removeItem error:\(error)")
            }
        }
    }
    // MARK: - 清空文件夹
    func clearFolder(_ name: String) {
        // 删除文件夹里的所有文件，而不删除文件夹
        print("\n清空文件夹:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        print("file:\(url)")
        // 方法1：删除，再创建
        //    self.deleteFile(name)
        //    self.createFile(name)
        
        // 方法2：遍历文件删除
        let files = manager.subpaths(atPath: url.path)
        for file in files ?? [] {
            do {
                try manager.removeItem(atPath: url.path + "/\(file)") // 需要拼接路径！！
            } catch {
                print("remove item:\(file)\n error:\(error)")
            }
        }
    }
    // MARK: - 遍历文件夹
    func traversals(_ name: String) {
        print("\n遍历文件夹:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        print("file:\(url)")
        
        // 1.1 浅遍历：只有 文件夹/文件 名
        do {
            let contentsOfDirectory = try manager.contentsOfDirectory(atPath: url.path)
            print("contentsOfDirectory:\(contentsOfDirectory)")
        } catch {
            print("1.1 浅遍历 error:\(error)")
        }
        // 1.2 浅遍历：包含完整路径
        do {
            let contentsOfDirectory = try manager.contentsOfDirectory(at: url,
                                                                      includingPropertiesForKeys: nil,
                                                                      options: .skipsHiddenFiles)
            print("skipsHiddenFiles:\(contentsOfDirectory)")
        } catch {
            print("1.2 浅遍历 error:\(error)")
        }
        
        // 2.1 深度遍历：只有当前文件夹下的路径
        let enumberatorAtPath = manager.enumerator(atPath: url.path)
        print("2.1 深度遍历：\(String(describing: enumberatorAtPath?.allObjects))")
        // 2.2 深度遍历：包含完整路径
        let enumberatorAtURL = manager.enumerator(at: url,
                                                  includingPropertiesForKeys: nil,
                                                  options: .skipsHiddenFiles,
                                                  errorHandler: nil)
        print("2.2 深度遍历：\(String(describing: enumberatorAtURL?.allObjects))")
    }
    // MARK: - 文件写入数据
    func write(_ fileName: String, string: String) {
        print("\n写入数据:")
        let url = self.documentURL.appendingPathComponent(fileName, isDirectory: true)
        print("file:\(url)")
        
        guard let data = string.data(using: .utf8, allowLossyConversion: true) else {
            return
        }
        // 1.写在结尾
        do {
            let writeHandler = try FileHandle(forWritingTo: url)
            writeHandler.seekToEndOfFile()
            writeHandler.write(data)
        } catch {
            print("writeHandler error:\(error)")
        }
        // 2.从第n个字符开始覆盖
        do {
            let writeHandler = try FileHandle(forWritingTo: url)
            do {
                try writeHandler.seek(toOffset: 1)
            } catch {
                print("writeHandler.seek error:\(error)")
            }
            writeHandler.write(data)
        } catch {
            print("writeHandler error:\(error)")
        }
        // 3.只保留前n个字符
        do {
            let writeHandler = try FileHandle(forWritingTo: url)
            do {
                try writeHandler.truncate(atOffset: 1)
            } catch {
                print("writeHandler.truncate error:\(error)")
            }
            writeHandler.write(data)
        } catch {
            print("writeHandler error:\(error)")
        }
        // 4.只保留前n个字符:(n超过原字符长度，则并接在结尾)
        do {
            let writeHandler = try FileHandle(forWritingTo: url)
            writeHandler.truncateFile(atOffset: 12)
            writeHandler.write(data)
        } catch {
            print("writeHandler error:\(error)")
        }
    }
    // MARK: - 读取文件内容
    func readFile(_ name: String) {
        print("\n读取文件:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        print("file:\(url)")
        
        // 方法1:
        guard let data = manager.contents(atPath: url.path) else {
            return
        }
        let readString = String(data: data, encoding: .utf8)
        print("方法1：\(readString ?? "")")
        // 方法2:
        guard let readHandler = FileHandle(forReadingAtPath: url.path) else {
            return
        }
        let data2: Data = readHandler.readDataToEndOfFile()
        let readString2 = String(data: data2, encoding: .utf8)
        print("方法2：\(readString2 ?? "")")
    }
    // MARK: - 复制文件
    func copyFile() {
        print("\n复制文件:")
        let file1 = self.documentURL.appendingPathComponent("moxiaoyan/test1.txt")
        let file2 = self.documentURL.appendingPathComponent("moxiaoyan/test2.txt")
        do {
            //      try manager.copyItem(at: file1, to: file2) // 直接复制文件
            try manager.copyItem(atPath: file1.path, toPath: file2.path) // 复制文件内容
        } catch {
            print("copyItem error:\(error)")
        }
    }
    // MARK: - 移动文件
    func moveFile(_ name: String, to: String) {
        print("\n移动文件:")
        let url = self.documentURL.appendingPathComponent(name, isDirectory: true)
        let file1 = url.appendingPathComponent(name)
        print("文件1:\(file1)")
        let file2 = url.appendingPathComponent(to + "/test1.txt")
        print("文件2:\(file2)")
        do {
            //      try manager.moveItem(atPath: file1.path, toPath: file2.path) // 直接拷贝文件
            try manager.moveItem(at: file1, to: file2) // 拷贝文件内容
        } catch {
            print("moveItem error:\(error)")
        }
    }
    // MARK: - 比较文件
    func equal(_ name1: String, _ name2: String) {
        print("\n比较文件:")
        let file1 = self.documentURL.appendingPathComponent(name1)
        let file2 = self.documentURL.appendingPathComponent(name2)
        // 参数必须的是路径（相同字符串false）
        let equal = manager.contentsEqual(atPath: file1.path, andPath: file2.path)
        print("file1:\(file1)")
        print("file2:\(file2)")
        print("equal:\(equal)")
    }
    private let manager = FileManager.default
    private let documentURL: URL
}
