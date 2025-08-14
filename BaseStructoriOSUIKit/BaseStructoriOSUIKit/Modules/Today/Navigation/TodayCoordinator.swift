//
//  TodayCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

class TodayCoordinator: BaseCoordinator {
    
    private let container: TodayDIContainer
    
    init(navigationController: UINavigationController, container: TodayDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showTodayScreen()
    }
    
    private func showTodayScreen() {
        let todayViewController = container.makeTodayViewController()
        todayViewController.coordinator = self
        navigationController.setViewControllers([todayViewController], animated: false)
    }
    
    // MARK: - Navigation Methods
    func showCardDetail(_ card: TodayCard) {
        print("🔍 TodayCoordinator: showCardDetail called for card: \(card.title)")
        
        let detailViewController = container.makeTodayDetailViewController(card: card)
        detailViewController.coordinator = self
        
        print("🔍 TodayCoordinator: Created detail ViewController: \(detailViewController)")
        
        // ✅ กลับไปใช้ custom transition เหมือน App Store
        let transition = TodayCardTransition()
        detailViewController.transitioningDelegate = transition
        detailViewController.modalPresentationStyle = .custom
        
        print("🔍 TodayCoordinator: About to present detail ViewController")
        navigationController.present(detailViewController, animated: true) {
            print("🔍 TodayCoordinator: Detail ViewController presented successfully")
        }
    }
    
    func showProfile() {
        // Navigate to profile or settings
        print("🔍 TodayCoordinator: Show profile tapped")
        // Could coordinate with MainCoordinator to switch to Settings tab
    }
    
    func dismissDetail() {
        navigationController.dismiss(animated: true)
    }
}

// MARK: - Custom Transition (like App Store)
class TodayCardTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TodayCardPresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TodayCardDismissTransition()
    }
}

// MARK: - Present Transition
class TodayCardPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        // Initial state
        toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Animate
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                toViewController.view.alpha = 1
                toViewController.view.transform = .identity
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
        )
    }
}

// MARK: - Dismiss Transition
class TodayCardDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // Animate
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                fromViewController.view.alpha = 0
                fromViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
        )
    }
}
