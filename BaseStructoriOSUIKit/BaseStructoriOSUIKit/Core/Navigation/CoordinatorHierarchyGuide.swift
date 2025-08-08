//
//  CoordinatorHierarchyGuide.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//  อธิบาย childCoordinators และ parentCoordinator
//

import UIKit

/*
 🏗️ COORDINATOR HIERARCHY (ลำดับชั้น Coordinator)
 
 เปรียบเทียบเหมือน โครงสร้างบริษัท:
 👑 CEO (AppCoordinator)
    ├── 🏢 แผนก A (MainCoordinator)  
    │   ├── 👨‍💻 พนักงาน 1 (TabOneCoordinator)
    │   ├── 👩‍💻 พนักงาน 2 (TabTwoCoordinator)
    │   └── 👨‍💻 พนักงาน 3 (TabThreeCoordinator)
    └── 🏢 แผนก B (SettingsCoordinator)
        ├── 👨‍💻 พนักงาน 4 (ProfileCoordinator)
        └── 👩‍💻 พนักงาน 5 (PreferencesCoordinator)
*/

// MARK: - 🤔 ทำไมต้องมี childCoordinators และ parentCoordinator?

/*
 ❌ ปัญหาที่เกิดขึ้นถ้าไม่มี:

 1. MEMORY LEAK 💾
    - Coordinator ถูกสร้างแล้วไม่ถูกลบ
    - ViewControllers ค้างอยู่ใน memory
    - แอปช้าลง, กิน RAM เยอะ

 2. NAVIGATION CHAOS 🌪️
    - ไม่รู้ว่า Coordinator ไหนยังทำงานอยู่
    - เปิดหน้าซ้ำซ้อน
    - กดปุ่ม Back แล้วแอปค้าง

 3. DATA INCONSISTENCY 📊
    - ข้อมูลไม่ sync กัน
    - State ของแอปผิดเพี้ยน
*/

// MARK: - 🎯 วิธีการทำงาน
//
//class ExampleAppCoordinator: BaseCoordinator {
//    
//    // MARK: - 👶 การสร้าง Child Coordinator
//    override func start() {
//        showMainScreen()
//    }
//    
//    func showMainScreen() {
//        // 1. สร้าง MainCoordinator
//        let mainCoordinator = ExampleMainCoordinator(navigationController: navigationController)
//        
//        // 2. เพิ่มเป็น child ← สำคัญมาก!
//        addChildCoordinator(mainCoordinator)
//        /*
//         การทำ addChildCoordinator ทำให้:
//         ✅ mainCoordinator ถูกเก็บไว้ใน childCoordinators array
//         ✅ mainCoordinator.parentCoordinator = self (AppCoordinator)
//         ✅ ป้องกัน mainCoordinator ถูกลบโดย ARC
//         */
//        
//        // 3. เริ่มทำงาน
//        mainCoordinator.start()
//    }
//    
//    func showSettings() {
//        let settingsCoordinator = ExampleSettingsCoordinator(navigationController: UINavigationController())
//        addChildCoordinator(settingsCoordinator)
//        
//        // แสดงแบบ Modal
//        navigationController.present(settingsCoordinator.navigationController, animated: true)
//        settingsCoordinator.start()
//    }
//}
//
//class ExampleMainCoordinator: BaseCoordinator {
//    
//    func showProfile() {
//        // สร้าง child coordinator สำหรับ Profile
//        let profileCoordinator = ExampleProfileCoordinator(navigationController: navigationController)
//        addChildCoordinator(profileCoordinator)
//        profileCoordinator.start()
//    }
//    
//    func showShoppingCart() {
//        let cartCoordinator = ExampleCartCoordinator(navigationController: UINavigationController())
//        addChildCoordinator(cartCoordinator)
//        
//        // แสดงแบบ Modal
//        navigationController.present(cartCoordinator.navigationController, animated: true)
//        cartCoordinator.start()
//    }
//}
//
//class ExampleProfileCoordinator: BaseCoordinator {
//    
//    override func start() {
//        let profileVC = ExampleProfileViewController()
//        profileVC.coordinator = self
//        pushViewController(profileVC)
//    }
//    
//    func editProfile() {
//        let editVC = ExampleEditProfileViewController()
//        editVC.coordinator = self
//        pushViewController(editVC)
//    }
//    
//    // เมื่อผู้ใช้เสร็จสิ้นการแก้ไขโปรไฟล์
//    func profileEditCompleted() {
//        // ลบตัวเองออกจาก parent
//        removeFromParent()
//        /*
//         การทำ removeFromParent() ทำให้:
//         ✅ ลบตัวเองออกจาก parent.childCoordinators
//         ✅ ทำให้ ARC สามารถลบ coordinator นี้ได้
//         ✅ ป้องกัน memory leak
//         */
//    }
//}
//
//class ExampleCartCoordinator: BaseCoordinator {
//    
//    override func start() {
//        let cartVC = ExampleCartViewController()
//        cartVC.coordinator = self
//        setRootViewController(cartVC)
//    }
//    
//    func checkout() {
//        let checkoutCoordinator = ExampleCheckoutCoordinator(navigationController: navigationController)
//        addChildCoordinator(checkoutCoordinator)
//        checkoutCoordinator.start()
//    }
//    
//    func closeCart() {
//        // ปิด Modal และลบตัวเอง
//        dismissViewController { [weak self] in
//            self?.removeFromParent()
//        }
//    }
//}
//
//class ExampleCheckoutCoordinator: BaseCoordinator {
//    
//    func paymentCompleted() {
//        // เมื่อชำระเงินเสร็จ ปิดทั้ง Cart flow
//        if let cartCoordinator = parentCoordinator as? ExampleCartCoordinator {
//            cartCoordinator.closeCart()
//        }
//        removeFromParent()
//    }
//}
//
//class ExampleSettingsCoordinator: BaseCoordinator {
//    
//    override func start() {
//        let settingsVC = ExampleSettingsViewController()
//        settingsVC.coordinator = self
//        setRootViewController(settingsVC)
//    }
//    
//    func closeSettings() {
//        dismissViewController { [weak self] in
//            self?.removeFromParent()
//        }
//    }
//}
//
//// MARK: - 📱 Example ViewControllers
//
//class ExampleProfileViewController: UIViewController {
//    weak var coordinator: ExampleProfileCoordinator?
//    
//    @IBAction func editButtonTapped() {
//        coordinator?.editProfile()
//    }
//}
//
//class ExampleEditProfileViewController: UIViewController {
//    weak var coordinator: ExampleProfileCoordinator?
//    
//    @IBAction func saveButtonTapped() {
//        // บันทึกข้อมูล
//        saveProfileData()
//        coordinator?.profileEditCompleted()
//    }
//    
//    private func saveProfileData() {
//        // Logic การบันทึก
//    }
//}
//
//class ExampleCartViewController: UIViewController {
//    weak var coordinator: ExampleCartCoordinator?
//    
//    @IBAction func checkoutTapped() {
//        coordinator?.checkout()
//    }
//    
//    @IBAction func closeTapped() {
//        coordinator?.closeCart()
//    }
//}
//
//class ExampleSettingsViewController: UIViewController {
//    weak var coordinator: ExampleSettingsCoordinator?
//    
//    @IBAction func closeTapped() {
//        coordinator?.closeSettings()
//    }
//}
//
//// MARK: - 🔍 การตรวจสอบ Memory Management
//
//extension BaseCoordinator {
//    
//    /// Debug method: แสดง hierarchy ของ coordinators
//    func printCoordinatorTree(level: Int = 0) {
//        let indent = String(repeating: "  ", count: level)
//        print("\(indent)📍 \(type(of: self)) (\(childCoordinators.count) children)")
//        
//        for child in childCoordinators {
//            if let baseChild = child as? BaseCoordinator {
//                baseChild.printCoordinatorTree(level: level + 1)
//            }
//        }
//    }
//    
//    /// ตรวจสอบว่ามี memory leaks หรือไม่
//    func checkForMemoryLeaks() {
//        print("🔍 Memory Check for \(type(of: self)):")
//        print("   👶 Children: \(childCoordinators.count)")
//        print("   👨‍👩‍👧‍👦 Parent: \(parentCoordinator != nil ? "✅" : "❌")")
//        
//        if childCoordinators.count > 10 {
//            print("   ⚠️ Warning: Too many child coordinators!")
//        }
//    }
//}
//
///*
// 📋 สรุป childCoordinators และ parentCoordinator:
//
// 🎯 childCoordinators ใช้เพื่อ:
// ✅ เก็บรายการ coordinator ลูก
// ✅ ป้องกัน coordinator ลูกถูกลบโดย ARC
// ✅ จัดการ lifecycle ของ coordinator ลูก
// ✅ ปิด coordinator ลูกทั้งหมดเมื่อ parent ถูกปิด
//
// 🎯 parentCoordinator ใช้เพื่อ:
// ✅ อ้างอิงไปยัง coordinator แม่
// ✅ ลบตัวเองออกจาก parent เมื่อทำงานเสร็จ
// ✅ ส่งข้อมูลกลับไปยัง parent
// ✅ ปิด flow ทั้งหมดจาก parent
//
// 💡 แนวทางปฏิบัติที่ดี:
// ✅ เสมอ addChildCoordinator เมื่อสร้าง child
// ✅ เสมอ removeFromParent เมื่อ child ทำงานเสร็จ
// ✅ ใช้ weak reference สำหรับ parentCoordinator
// ✅ ตรวจสอบ memory leaks เป็นระยะ
//
// 🚨 สิ่งที่ต้องระวัง:
// ❌ ห้าม strong reference cycle
// ❌ ห้ามลืม removeFromParent
// ❌ ห้ามเก็บ coordinator ไว้เกินจำเป็น
//*/
