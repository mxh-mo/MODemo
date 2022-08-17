//
//  MOSubScrollViewProtocol.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/8/17.
//

import UIKit

typealias MOSubScrollWillBeginDragging = (UIScrollView) -> ()
typealias MOSubScrollDidScroll = (UIScrollView) -> ()

protocol MOSubScrollViewProtocol: NSObjectProtocol {
    
    var willBeginDragging: MOSubScrollWillBeginDragging? { get set }
    var didScroll: MOSubScrollDidScroll? { get set }
    
}
