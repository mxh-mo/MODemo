//
//  MOPushOrPresentAnimator.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/11/26.
//

import UIKit

class MOPushOrPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        moPrint(self, #line, "transitionDuration")
        return 0.5
    }
    
    /// 转场动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        moPrint(self, #line, "animateTransition")
        
        // Get the set of relevant objects.
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            moPrint(self, #line, "toVC is nil")
            return
        }
        guard let toView = transitionContext.view(forKey: .to)else {
            moPrint(self, #line, "toView is nil")
            return
        }
        
        // Set up some variables for the animation.
        let containerFrame = containerView.frame;
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        
        toViewStartFrame.origin.x = containerFrame.size.width;
        toViewStartFrame.origin.y = containerFrame.size.height;

        containerView.addSubview(toView)
        toView.frame = toViewStartFrame;
        
        /// 执行动画
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            toView.frame = toViewFinalFrame

        } completion: { finish in
            let success = !transitionContext.transitionWasCancelled
            if !success {   // After a failed presentation, remove the view.
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        moPrint(self, #line, "animationEnded completed: \(transitionCompleted)")
    }
}
