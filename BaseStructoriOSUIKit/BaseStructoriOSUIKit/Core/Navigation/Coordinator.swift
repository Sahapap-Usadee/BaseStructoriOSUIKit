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
