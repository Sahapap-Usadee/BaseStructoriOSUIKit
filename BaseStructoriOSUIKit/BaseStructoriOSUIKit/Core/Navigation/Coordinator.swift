//
//  Coordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

/*
 🎯 COORDINATOR PATTERN
 
 Coordinator = ตัวจัดการการนำทาง ที่ทำหน้าที่:
 ✅ เปิดหน้าจอใหม่ (Push, Present, Modal)
 ✅ ปิดหน้าจอเก่า (Pop, Dismiss)
 ✅ ส่งข้อมูลระหว่างหน้า
 ✅ จัดการ Flow การทำงานทั้งแอป
 
 📱 ตัวอย่าง: 
 AppCoordinator → LoadingCoordinator → MainCoordinator → TabCoordinators
*/

// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    /// เริ่มต้น coordinator และแสดงหน้าจอแรก
    func start()
    
    /// ลบ child coordinator เมื่อทำงานเสร็จ
    func childDidFinish(_ child: Coordinator)
    
    /// ตัวเลือก: ทำความสะอาดก่อน coordinator จะถูกปิด
    func finish()
}

// MARK: - Default Implementation
extension Coordinator {
    
    /// ลบ child coordinator ออกจาก memory
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    /// เพิ่ม child coordinator และกำหนด parent
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    /// ลบตัวเองออกจาก parent coordinator
    func removeFromParent() {
        parentCoordinator?.childDidFinish(self)
    }
    
    /// ปิด coordinator และลบออกจาก parent
    func finish() {
        // ปิด child coordinators ทั้งหมดก่อน
        childCoordinators.forEach { $0.finish() }
        childCoordinators.removeAll()
        
        // ลบตัวเองออกจาก parent
        removeFromParent()
    }
}

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
    
    /// ตรวจสอบว่าสามารถไปหน้าที่ต้องการได้หรือไม่
    func canNavigate(to destination: String) -> Bool {
        // ตัวอย่าง: ตรวจสอบ authorization, network, etc.
        print("🧭 Checking navigation to: \(destination)")
        return true
    }
    
    /// Log การนำทางสำหรับ debugging
    func logNavigation(from source: String, to destination: String, action: String = "navigate") {
        print("🚀 [\(type(of: self))] \(action.uppercased()): \(source) → \(destination)")
    }
    
    /// Log การจัดการ coordinator
    private func logCoordinatorAction(_ action: String, _ coordinator: Coordinator, totalChildren: Int) {
        let coordinatorName = String(describing: type(of: coordinator))
        print("👪 [\(type(of: self))] \(action): \(coordinatorName) (รวม \(totalChildren) ลูก)")
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
