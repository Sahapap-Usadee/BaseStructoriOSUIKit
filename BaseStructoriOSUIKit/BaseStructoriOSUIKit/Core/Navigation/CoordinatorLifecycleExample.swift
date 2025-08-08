//
//  CoordinatorLifecycleExample.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//  ตัวอย่างการจัดการ Lifecycle ในโครงการจริง
//

import UIKit
import Combine

/*
 🎬 REAL EXAMPLE: ในโครงการของเรา

 AppCoordinator (รากหลัก)
    ├── LoadingCoordinator (โหลดเริ่มต้น)
    └── MainCoordinator (หน้าหลัก)
        ├── TabOneCoordinator (Tab แรก)
        ├── TabTwoCoordinator (Tab สอง)
        └── TabThreeCoordinator (Tab สาม)
*/

// MARK: - 🔄 การทำงานจริงใน AppCoordinator

//class RealLifeAppCoordinator: ReactiveCoordinator {
//    
//    override func start() {
//        print("🚀 AppCoordinator เริ่มทำงาน")
//        showLoadingScreen()
//    }
//    
//    private func showLoadingScreen() {
//        print("📱 สร้าง LoadingCoordinator")
//        
//        // 1. สร้าง LoadingCoordinator
//        let loadingCoordinator = LoadingCoordinator(navigationController: navigationController)
//        
//        // 2. เพิ่มเป็น child (สำคัญมาก!)
//        addChildCoordinator(loadingCoordinator)
//        print("👶 LoadingCoordinator เพิ่มเป็น child แล้ว (children count: \(childCoordinators.count))")
//        
//        // 3. Subscribe เพื่อรอการโหลดเสร็จ
//        loadingCoordinator.loadingCompleted
//            .sink { [weak self] in
//                print("✅ LoadingCoordinator แจ้งว่าโหลดเสร็จแล้ว")
//                self?.onLoadingCompleted()
//            }
//            .store(in: &cancellables)
//        
//        // 4. เริ่มทำงาน
//        loadingCoordinator.start()
//    }
//    
//    private func onLoadingCompleted() {
//        print("🔄 กำลังเปลี่ยนจาก Loading → Main")
//        
//        // 1. ลบ LoadingCoordinator ออก (ไม่ต้องใช้แล้ว)
//        removeLoadingCoordinator()
//        
//        // 2. แสดงหน้าหลัก
//        showMainApp()
//    }
//    
//    private func removeLoadingCoordinator() {
//        // หา LoadingCoordinator และลบออก
//        if let loadingCoordinator = childCoordinators.first(where: { $0 is LoadingCoordinator }) {
//            childDidFinish(loadingCoordinator)
//            print("🗑️ LoadingCoordinator ถูกลบแล้ว (children count: \(childCoordinators.count))")
//        }
//    }
//    
//    private func showMainApp() {
//        print("📱 สร้าง MainCoordinator")
//        
//        let mainCoordinator = MainCoordinator(navigationController: navigationController)
//        addChildCoordinator(mainCoordinator)
//        print("👶 MainCoordinator เพิ่มเป็น child แล้ว (children count: \(childCoordinators.count))")
//        
//        mainCoordinator.start()
//    }
//    
//    // MARK: - 🧹 Memory Management
//    
//    override func finish() {
//        print("🧹 AppCoordinator กำลังทำความสะอาด...")
//        print("   Children ที่ต้องปิด: \(childCoordinators.count)")
//        
//        // ปิด child coordinators ทั้งหมด
//        super.finish()
//        
//        print("✅ AppCoordinator ทำความสะอาดเสร็จ")
//    }
//}
//
//// MARK: - 🎯 การทำงานใน MainCoordinator
//
//class RealLifeMainCoordinator: ReactiveCoordinator {
//    
//    override func start() {
//        print("🏠 MainCoordinator เริ่มทำงาน")
//        showMainTabBar()
//    }
//    
//    private func showMainTabBar() {
//        let mainTabBarController = MainTabBarController()
//        mainTabBarController.coordinator = self
//        setRootViewController(mainTabBarController)
//    }
//    
//    // เมื่อผู้ใช้กดดูรายละเอียดใน Tab One
//    func showTabOneDetail() {
//        print("📱 สร้าง TabOneCoordinator สำหรับดูรายละเอียด")
//        
//        let tabOneCoordinator = TabOneCoordinator(navigationController: navigationController)
//        addChildCoordinator(tabOneCoordinator)
//        print("👶 TabOneCoordinator เพิ่มเป็น child (children: \(childCoordinators.count))")
//        
//        // Subscribe เพื่อรอการปิดหน้ารายละเอียด
//        tabOneCoordinator.detailClosed
//            .sink { [weak self] in
//                print("✅ TabOneCoordinator แจ้งว่าปิดหน้ารายละเอียดแล้ว")
//                self?.onTabOneDetailClosed(tabOneCoordinator)
//            }
//            .store(in: &cancellables)
//        
//        tabOneCoordinator.showDetail()
//    }
//    
//    private func onTabOneDetailClosed(_ coordinator: TabOneCoordinator) {
//        print("🗑️ กำลังลบ TabOneCoordinator...")
//        childDidFinish(coordinator)
//        print("✅ TabOneCoordinator ถูกลบแล้ว (children: \(childCoordinators.count))")
//    }
//    
//    // เมื่อผู้ใช้กดแสดง Modal ใน Tab Two
//    func showModalFromTabTwo() {
//        print("📱 สร้าง TabTwoCoordinator สำหรับ Modal")
//        
//        let tabTwoCoordinator = TabTwoCoordinator(navigationController: UINavigationController())
//        addChildCoordinator(tabTwoCoordinator)
//        print("👶 TabTwoCoordinator เพิ่มเป็น child (children: \(childCoordinators.count))")
//        
//        // Subscribe เพื่อรอการปิด Modal
//        tabTwoCoordinator.modalClosed
//            .sink { [weak self] in
//                print("✅ TabTwoCoordinator แจ้งว่าปิด Modal แล้ว")
//                self?.onTabTwoModalClosed(tabTwoCoordinator)
//            }
//            .store(in: &cancellables)
//        
//        // แสดง Modal
//        navigationController.present(tabTwoCoordinator.navigationController, animated: true)
//        tabTwoCoordinator.showModal()
//    }
//    
//    private func onTabTwoModalClosed(_ coordinator: TabTwoCoordinator) {
//        print("🗑️ กำลังลบ TabTwoCoordinator...")
//        childDidFinish(coordinator)
//        print("✅ TabTwoCoordinator ถูกลบแล้ว (children: \(childCoordinators.count))")
//    }
//}
//
//// MARK: - 🔄 Enhanced Coordinators พร้อม Publishers
//
//extension TabOneCoordinator {
//    private let detailClosedSubject = PassthroughSubject<Void, Never>()
//    
//    var detailClosed: AnyPublisher<Void, Never> {
//        detailClosedSubject.eraseToAnyPublisher()
//    }
//    
//    func detailDidClose() {
//        detailClosedSubject.send()
//    }
//}
//
//extension TabTwoCoordinator {
//    private let modalClosedSubject = PassthroughSubject<Void, Never>()
//    
//    var modalClosed: AnyPublisher<Void, Never> {
//        modalClosedSubject.eraseToAnyPublisher()
//    }
//    
//    func modalDidClose() {
//        modalClosedSubject.send()
//    }
//}
//
//// MARK: - 🐛 Debug Tools
//
//extension BaseCoordinator {
//    
//    /// แสดงสถานะ memory ของ coordinator tree
//    func debugMemoryStatus() {
//        print("🔍 === COORDINATOR MEMORY STATUS ===")
//        printCoordinatorTree()
//        print("=====================================")
//    }
//    
//    private func printCoordinatorTree(level: Int = 0) {
//        let indent = String(repeating: "  ", count: level)
//        let className = String(describing: type(of: self))
//        print("\(indent)📍 \(className)")
//        print("\(indent)   👶 Children: \(childCoordinators.count)")
//        print("\(indent)   👨‍👩‍👧‍👦 Has Parent: \(parentCoordinator != nil ? "✅" : "❌")")
//        
//        for child in childCoordinators {
//            if let baseChild = child as? BaseCoordinator {
//                baseChild.printCoordinatorTree(level: level + 1)
//            }
//        }
//    }
//    
//    /// ตรวจหา memory leaks ที่อาจเกิดขึ้น
//    func checkMemoryLeaks() {
//        var warnings: [String] = []
//        
//        // ตรวจสอบจำนวน children ที่มากเกินไป
//        if childCoordinators.count > 5 {
//            warnings.append("⚠️ Too many children (\(childCoordinators.count))")
//        }
//        
//        // ตรวจสอบ strong reference cycles
//        for child in childCoordinators {
//            if child.parentCoordinator !== self {
//                warnings.append("⚠️ Parent reference mismatch")
//            }
//        }
//        
//        if warnings.isEmpty {
//            print("✅ \(type(of: self)): No memory issues detected")
//        } else {
//            print("🚨 \(type(of: self)): Potential issues found:")
//            warnings.forEach { print("   \($0)") }
//        }
//    }
//}
//
///*
// 📋 สรุป childCoordinators และ parentCoordinator:
//
// 🎯 childCoordinators = เด็กๆ ที่อยู่ใต้การดูแล
// - เก็บ coordinator ลูกไว้ไม่ให้หาย (strong reference)
// - จัดการ lifecycle ของลูกทั้งหมด
// - ปิดลูกทั้งหมดเมื่อตัวเองปิด
//
// 🎯 parentCoordinator = พ่อแม่ที่ดูแลเรา
// - อ้างอิงไปยังผู้ดูแล (weak reference)
// - แจ้งพ่อแม่เมื่อทำงานเสร็จ
// - ได้รับการป้องกันไม่ให้หายไปก่อนเวลา
//
// 💡 กฎสำคัญ:
// ✅ สร้าง child → addChildCoordinator()
// ✅ เสร็จงาน child → removeFromParent()
// ✅ ใช้ weak สำหรับ parent
// ✅ ใช้ strong สำหรับ children
//
// 🎪 ตัวอย่างการไหล:
// 1. AppCoordinator สร้าง LoadingCoordinator
// 2. LoadingCoordinator ทำงานเสร็จ → แจ้ง AppCoordinator
// 3. AppCoordinator ลบ LoadingCoordinator → สร้าง MainCoordinator
// 4. MainCoordinator สร้าง TabCoordinator ตามต้องการ
// 5. TabCoordinator ทำงานเสร็จ → แจ้ง MainCoordinator → ถูกลบ
//*/
