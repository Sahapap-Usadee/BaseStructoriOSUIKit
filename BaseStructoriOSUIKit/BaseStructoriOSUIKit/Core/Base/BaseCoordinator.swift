//
//  BaseCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 4/9/2568 BE.
//

import UIKit

// MARK: - Base Coordinator
class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("Subclasses must implement start method")
    }


    // MARK: - 🛠️ Helper Methods สำหรับการนำทาง

    /// แสดงหน้าจอใหม่แบบ Push (มี back button)
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    /// กลับไปหน้าเดิมแบบ Pop
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    /// กลับไปหน้าแรกสุด
    func popToRootViewController(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }

    /// แสดงหน้าจอแบบ Modal (fullscreen)
    func presentViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }

    /// ปิดหน้าจอ Modal
    func dismissViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    /// เปลี่ยนหน้าจอทั้งหมด (ไม่มี animation กลับ)
    func setRootViewController(_ viewController: UIViewController, animated: Bool = false) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
}

// MARK: - 📱 Navigation Helpers
extension BaseCoordinator {

    /// สร้าง UINavigationController พร้อม style
    func createNavigationController(rootViewController: UIViewController, navigationBarStyle: NavigationBarStyle = .default) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)

        // กำหนด style ตาม parameter
        switch navigationBarStyle {
        case .default:
            navController.navigationBar.prefersLargeTitles = false
        default:
            break
        }

        return navController
    }

    /// Log การนำทางสำหรับ debugging
    func logNavigation(from source: String, to destination: String, action: String = "navigate") {
        print("🚀 [\(type(of: self))] \(action.uppercased()): \(source) → \(destination)")
    }

    /// Log การจัดการ coordinator
    func logCoordinatorAction(_ action: String, _ coordinator: Coordinator, totalChildren: Int) {
        let coordinatorName = String(describing: type(of: coordinator))
        print("👪 [\(type(of: self))] \(action): \(coordinatorName) (รวม \(totalChildren) ลูก)")
    }

    /// หา top-most view controller ปัจจุบันในแอป
    func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }

        var topViewController = window.rootViewController

        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }

        if let navigationController = topViewController as? UINavigationController {
            topViewController = navigationController.topViewController
        }

        if let tabBarController = topViewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                if let navigationController = selectedViewController as? UINavigationController {
                    topViewController = navigationController.topViewController
                } else {
                    topViewController = selectedViewController
                }
            }
        }

        return topViewController
    }
}

// MARK: - 🔍 Debug และ Memory Management Tools
extension BaseCoordinator {

    /// แสดงสถานะ memory ของ coordinator tree
    func debugMemoryStatus() {
        print("🔍 === COORDINATOR MEMORY STATUS ===")
        printCoordinatorTree()
        print("=====================================")
    }

    /// แสดง hierarchy ของ coordinators
    private func printCoordinatorTree(level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        let className = String(describing: type(of: self))
        print("\(indent)📍 \(className)")
        print("\(indent)   👶 Children: \(childCoordinators.count)")
        print("\(indent)   👨‍👩‍👧‍👦 Has Parent: \(parentCoordinator != nil ? "✅" : "❌")")

        for child in childCoordinators {
            if let baseChild = child as? BaseCoordinator {
                baseChild.printCoordinatorTree(level: level + 1)
            }
        }
    }

    /// ตรวจหา memory leaks ที่อาจเกิดขึ้น
    func checkMemoryLeaks() {
        var warnings: [String] = []

        // ตรวจสอบจำนวน children ที่มากเกินไป
        if childCoordinators.count > 5 {
            warnings.append("⚠️ Too many children (\(childCoordinators.count))")
        }

        // ตรวจสอบ strong reference cycles
        for child in childCoordinators {
            if child.parentCoordinator !== self {
                warnings.append("⚠️ Parent reference mismatch")
            }
        }

        if warnings.isEmpty {
            print("✅ \(type(of: self)): No memory issues detected")
        } else {
            print("🚨 \(type(of: self)): Potential issues found:")
            warnings.forEach { print("   \($0)") }
        }
    }

    /// ตรวจสอบว่า coordinator นี้ยังมีชีวิตอยู่หรือไม่
    func isAlive() -> Bool {
        return !childCoordinators.isEmpty || parentCoordinator != nil
    }

    /// แสดงสถิติ coordinator
    func printStats() {
        print("📊 [\(type(of: self))] Stats:")
        print("   👶 Children: \(childCoordinators.count)")
        print("   👨‍👩‍👧‍👦 Has Parent: \(parentCoordinator != nil)")
        print("   💓 Is Alive: \(isAlive())")
    }
}
