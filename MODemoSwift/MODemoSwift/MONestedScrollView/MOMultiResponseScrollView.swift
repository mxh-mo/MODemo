//
//  MOMultiResponseScrollView.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/8/17.
//

import UIKit

class MOMultiResponseScrollView: UIScrollView, UIGestureRecognizerDelegate {

    /// 是否同时相应 这俩手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
