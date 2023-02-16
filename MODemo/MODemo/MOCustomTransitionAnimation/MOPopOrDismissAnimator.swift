//
//  MOPopOrDismissAnimator.swift
//  MODemo
//
//  Created by mikimo on 2022/11/26.
//

import UIKit

class MOPopOrDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            moPrint(self, #line, "fromVC is nil")
            return
        }
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            moPrint(self, #line, "toVC is nil")
            return
        }
        guard let fromView = transitionContext.view(forKey: .from)else {
            moPrint(self, #line, "fromView is nil")
            return
        }
        // push 时能拿到 toView
//        guard let toView = transitionContext.view(forKey: .to)else {
//            moPrint(self, #line, "toView is nil")
//            return
//        }
        // dismiss 时拿不到 toView
        let toView: UIView = transitionContext.view(forKey: .to) ?? UIView(frame: .zero)
        
        moPrint(self, #line, "fromView: \(fromView), toView: \(toView)")
        
        // Set up some variables for the animation.
        let containerFrame = containerView.frame;
        let toViewStartFrame = transitionContext.initialFrame(for: toVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        
        fromViewFinalFrame = CGRect(x: CGRectGetWidth(containerFrame),
                                    y: CGRectGetHeight(containerFrame),
                                    width: CGRectGetWidth(fromView.frame),
                                    height: CGRectGetHeight(fromView.frame))
        
        containerView.addSubview(toView)
        toView.frame = toViewStartFrame;
        
        /// 执行动画
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            fromView.frame = fromViewFinalFrame

        } completion: { finish in
            let success = !transitionContext.transitionWasCancelled
            if success {    // After successful dismissal, remove the view.
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        moPrint(self, #line, "animationEnded completed: \(transitionCompleted)")
    }
}
