//
//  MOPresentationController.swift
//  MODemo
//
//  Created by mikimo on 2022/11/6.
//

import UIKit

class MOPresentationController: UIPresentationController {
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.moDimmingView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            moPrint(self, #line, "frameOfPresentedViewInContainerView")
                        
            let containerBounds: CGRect = self.containerView?.bounds ?? .zero
            let width = CGFloat(floorf(Float(containerBounds.size.width) / 2.0))
            let height = containerBounds.size.height
            let originX = containerBounds.size.width - width
                               
            return CGRect(x: originX, y: 0.0, width: width, height: height)
        }
    }
    
    // MARK: - present 动画
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        moPrint(self, #line, "presentationTransitionWillBegin")
        
        guard let containerView = containerView else { return }
        
        self.moDimmingView.frame = containerView.bounds
        self.moDimmingView.alpha = 0.0
        
        containerView.insertSubview(self.moDimmingView, at: 0)
    
        
        guard let transitionCoordinator = self.presentedViewController.transitionCoordinator else {
            self.moDimmingView.alpha = 1.0
            return
        }

        transitionCoordinator.animateAlongsideTransition(in: self.presentedView) { context in
            self.moDimmingView.alpha = 1.0
        }
    }
        
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        moPrint(self, #line, "presentationTransitionDidEnd")
        
        if !completed {
            self.moDimmingView.removeFromSuperview()
        }
    }
    
    
    // MARK: - dismiss 动画
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        moPrint(self, #line, "dismissalTransitionWillBegin")
        
        guard let transitionCoordinator = self.presentedViewController.transitionCoordinator else {
            self.moDimmingView.alpha = 0.0
            return
        }

        transitionCoordinator.animateAlongsideTransition(in: self.presentedView) { context in
            self.moDimmingView.alpha = 0.0
        }
    }
        
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        moPrint(self, #line, "dismissalTransitionDidEnd")
        
        if completed {
            self.moDimmingView.removeFromSuperview()
        }
    }
    
    lazy var moDimmingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        view.alpha = 0.0
        return view
    }()
}
