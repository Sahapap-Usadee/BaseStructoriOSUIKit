//
//  CoordinatorGuide.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//  📖 คู่มือการใช้งาน Coordinator Pattern อย่างสมบูรณ์
//

import UIKit
import Combine

/*
 🎯 COORDINATOR PATTERN คืออะไร?
 
 Coordinator = "ผู้จัดการการนำทาง" ที่มีหน้าที่:
 ✅ เปิดหน้าจอใหม่ (Push, Present, Modal)
 ✅ ปิดหน้าจอเก่า (Pop, Dismiss)
 ✅ ส่งข้อมูลระหว่างหน้า
 ✅ จัดการ Flow การทำงานทั้งแอป
 ✅ จัดการ Memory Management
 
 📱 เปรียบเทียบกับชีวิตจริง:
 - เหมือน "เมนเซอร์ในร้านอาหาร" → นำลูกค้าไปโต๊ะ, บอกเมนู, นำไปชำระเงิน
 - เหมือน "ผู้กำกับหนัง" → บอก Scene ไหนต่อ Scene ไหน
 - เหมือน "GPS" → บอกเส้นทาง, เลี้ยวซ้าย-ขวา, ถึงจุดหมาย
 
 🏗️ โครงสร้างแบบ Hierarchy:
 AppCoordinator (รากหลัก)
    ├── LoadingCoordinator (โหลดเริ่มต้น)
    └── MainCoordinator (หน้าหลัก)
        ├── TabOneCoordinator (Tab 1)
        ├── TabTwoCoordinator (Tab 2)
        └── SettingsCoordinator (การตั้งค่า)
*/

// MARK: - 📚 1. โครงสร้างพื้นฐาน

/**
 🏗️ BaseCoordinator: คลาสหลักที่ Coordinator ทุกตัวจะสืบทอด
 */
//class GuideBaseCoordinator {
//    var navigationController: UINavigationController
//    var childCoordinators: [GuideBaseCoordinator] = []  // 👶 รายชื่อลูก
//    weak var parentCoordinator: GuideBaseCoordinator?   // 👨‍👩‍👧‍👦 พ่อแม่
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        // Subclass จะ override ตรงนี้
//        fatalError("Subclasses must implement start method")
//    }
//    
//    // MARK: - 👪 จัดการ Child Coordinators
//    
//    /// เพิ่ม child coordinator (เหมือนมีลูกใหม่)
//    func addChild(_ coordinator: GuideBaseCoordinator) {
//        childCoordinators.append(coordinator)
//        coordinator.parentCoordinator = self
//        print("👶 เพิ่มลูก: \(type(of: coordinator)) (รวม \(childCoordinators.count) คน)")
//    }
//    
//    /// ลบ child coordinator (เหมือนลูกย้ายออกไป)
//    func removeChild(_ coordinator: GuideBaseCoordinator) {
//        childCoordinators.removeAll { $0 === coordinator }
//        print("🗑️ ลบลูก: \(type(of: coordinator)) (เหลือ \(childCoordinators.count) คน)")
//    }
//    
//    /// ลบตัวเองออกจาก parent (เหมือนย้ายออกจากบ้าน)
//    func removeFromParent() {
//        parentCoordinator?.removeChild(self)
//    }
//    
//    // MARK: - 🛠️ Helper Methods สำหรับการนำทาง
//    
//    func pushViewController(_ vc: UIViewController) {
//        navigationController.pushViewController(vc, animated: true)
//    }
//    
//    func popViewController() {
//        navigationController.popViewController(animated: true)
//    }
//    
//    func presentViewController(_ vc: UIViewController) {
//        navigationController.present(vc, animated: true)
//    }
//    
//    func dismissViewController() {
//        navigationController.dismiss(animated: true)
//    }
//}
//
//// MARK: - 📱 2. ตัวอย่างแอปร้านอาหาร (Restaurant App)
//
///*
// �️ SCENARIO: แอปร้านอาหาร
// Flow: เข้าแอป → ดูเมนู → เลือกอาหาร → ใส่รถเข็น → สั่งซื้อ → เสร็จสิ้น
//*/
//
///// 🏢 App Coordinator (ผู้จัดการใหญ่)
//class RestaurantAppCoordinator: GuideBaseCoordinator {
//    
//    override func start() {
//        print("🚀 เปิดแอปร้านอาหาร")
//        showWelcomeScreen()
//    }
//    
//    /// แสดงหน้าต้อนรับ
//    private func showWelcomeScreen() {
//        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
//        addChild(welcomeCoordinator)
//        
//        // รอการต้อนรับเสร็จ
//        welcomeCoordinator.onWelcomeCompleted = { [weak self] in
//            self?.removeChild(welcomeCoordinator)
//            self?.showMainMenu()
//        }
//        
//        welcomeCoordinator.start()
//    }
//    
//    /// แสดงเมนูหลัก
//    private func showMainMenu() {
//        let menuCoordinator = MenuCoordinator(navigationController: navigationController)
//        addChild(menuCoordinator)
//        menuCoordinator.start()
//    }
//}
//
///// 👋 Welcome Coordinator (การต้อนรับ)
//class WelcomeCoordinator: GuideBaseCoordinator {
//    var onWelcomeCompleted: (() -> Void)?
//    
//    override func start() {
//        let welcomeVC = WelcomeViewController()
//        welcomeVC.coordinator = self
//        navigationController.setViewControllers([welcomeVC], animated: false)
//    }
//    
//    func welcomeFinished() {
//        print("✅ การต้อนรับเสร็จสิ้น")
//        onWelcomeCompleted?()
//    }
//}
//
///// 🍽️ Menu Coordinator (จัดการเมนู)
//class MenuCoordinator: GuideBaseCoordinator {
//    private var selectedItems: [MenuItem] = []
//    
//    override func start() {
//        showMenuList()
//    }
//    
//    /// 1. แสดงรายการเมนู
//    func showMenuList() {
//        let menuVC = MenuListViewController()
//        menuVC.coordinator = self
//        navigationController.setViewControllers([menuVC], animated: true)
//    }
//    
//    /// 2. แสดงรายละเอียดอาหาร
//    func showFoodDetail(_ food: MenuItem) {
//        print("🍜 ดูรายละเอียด: \(food.name)")
//        
//        let detailVC = FoodDetailViewController()
//        detailVC.coordinator = self
//        detailVC.configure(with: food)
//        pushViewController(detailVC)
//    }
//    
//    /// 3. เพิ่มอาหารลงรถเข็น
//    func addToCart(_ item: MenuItem) {
//        selectedItems.append(item)
//        print("🛒 เพิ่ม \(item.name) ลงรถเข็น (รวม \(selectedItems.count) รายการ)")
//        popViewController() // กลับไปหน้าเมนู
//    }
//    
//    /// 4. แสดงรถเข็น
//    func showCart() {
//        guard !selectedItems.isEmpty else {
//            showAlert(message: "รถเข็นว่างเปล่า 🛒")
//            return
//        }
//        
//        let cartCoordinator = CartCoordinator(navigationController: UINavigationController())
//        cartCoordinator.parentCoordinator = self
//        cartCoordinator.configure(with: selectedItems)
//        
//        addChild(cartCoordinator)
//        presentViewController(cartCoordinator.navigationController)
//        cartCoordinator.start()
//    }
//    
//    /// 5. เมื่อสั่งซื้อเสร็จ
//    func orderCompleted() {
//        selectedItems.removeAll()
//        showAlert(message: "สั่งอาหารเรียบร้อยแล้ว! 🎉")
//    }
//    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: "แจ้งเตือน", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
//        navigationController.present(alert, animated: true)
//    }
//}
//
///// 🛒 Cart Coordinator (จัดการรถเข็น)
//class CartCoordinator: GuideBaseCoordinator {
//    private var cartItems: [MenuItem] = []
//    
//    func configure(with items: [MenuItem]) {
//        self.cartItems = items
//    }
//    
//    override func start() {
//        let cartVC = CartViewController()
//        cartVC.coordinator = self
//        cartVC.configure(with: cartItems)
//        navigationController.setViewControllers([cartVC], animated: false)
//    }
//    
//    /// ไปหน้าชำระเงิน
//    func proceedToCheckout() {
//        let checkoutVC = CheckoutViewController()
//        checkoutVC.coordinator = self
//        pushViewController(checkoutVC)
//    }
//    
//    /// ชำระเงินเสร็จ
//    func paymentCompleted() {
//        dismissViewController()
//        
//        // แจ้ง parent ว่าสั่งซื้อเสร็จแล้ว
//        if let menuCoordinator = parentCoordinator as? MenuCoordinator {
//            menuCoordinator.orderCompleted()
//        }
//        
//        removeFromParent()
//    }
//    
//    /// ปิดรถเข็น
//    func closeCart() {
//        dismissViewController()
//        removeFromParent()
//    }
//}
//
//// MARK: - 📱 3. View Controllers
//
//class WelcomeViewController: UIViewController {
//    weak var coordinator: WelcomeCoordinator?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "ยินดีต้อนรับ"
//        view.backgroundColor = .systemBackground
//        
//        // จำลองการโหลด 2 วินาที
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.coordinator?.welcomeFinished()
//        }
//    }
//}
//
//class MenuListViewController: UIViewController {
//    weak var coordinator: MenuCoordinator?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "เมนูอาหาร"
//        setupNavigationBar()
//    }
//    
//    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "cart"),
//            style: .plain,
//            target: self,
//            action: #selector(cartTapped)
//        )
//    }
//    
//    @objc private func cartTapped() {
//        coordinator?.showCart()
//    }
//    
//    // จำลองการกดอาหาร
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // แสดง action sheet เลือกอาหาร
//        let alert = UIAlertController(title: "เลือกเมนู", message: nil, preferredStyle: .actionSheet)
//        
//        alert.addAction(UIAlertAction(title: "ผัดไทย (60฿)", style: .default) { _ in
//            let food = MenuItem(id: 1, name: "ผัดไทย", price: 60)
//            self.coordinator?.showFoodDetail(food)
//        })
//        
//        alert.addAction(UIAlertAction(title: "ต้มยำกุ้ง (80฿)", style: .default) { _ in
//            let food = MenuItem(id: 2, name: "ต้มยำกุ้ง", price: 80)
//            self.coordinator?.showFoodDetail(food)
//        })
//        
//        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
//        
//        present(alert, animated: true)
//    }
//}
//
//class FoodDetailViewController: UIViewController {
//    weak var coordinator: MenuCoordinator?
//    private var foodItem: MenuItem?
//    
//    func configure(with item: MenuItem) {
//        self.foodItem = item
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = foodItem?.name
//        view.backgroundColor = .systemBackground
//        setupUI()
//    }
//    
//    private func setupUI() {
//        let addButton = UIButton(type: .system)
//        addButton.setTitle("เพิ่มลงรถเข็น", for: .normal)
//        addButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
//        
//        view.addSubview(addButton)
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    @objc private func addToCartTapped() {
//        guard let food = foodItem else { return }
//        coordinator?.addToCart(food)
//    }
//}
//
//class CartViewController: UIViewController {
//    weak var coordinator: CartCoordinator?
//    private var cartItems: [MenuItem] = []
//    
//    func configure(with items: [MenuItem]) {
//        self.cartItems = items
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "รถเข็น (\(cartItems.count) รายการ)"
//        view.backgroundColor = .systemBackground
//        setupNavigationBar()
//        setupUI()
//    }
//    
//    private func setupNavigationBar() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            title: "ปิด",
//            style: .plain,
//            target: self,
//            action: #selector(closeTapped)
//        )
//    }
//    
//    private func setupUI() {
//        let checkoutButton = UIButton(type: .system)
//        checkoutButton.setTitle("สั่งซื้อ", for: .normal)
//        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
//        
//        view.addSubview(checkoutButton)
//        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            checkoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    @objc private func checkoutTapped() {
//        coordinator?.proceedToCheckout()
//    }
//    
//    @objc private func closeTapped() {
//        coordinator?.closeCart()
//    }
//}
//
//class CheckoutViewController: UIViewController {
//    weak var coordinator: CartCoordinator?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "ชำระเงิน"
//        view.backgroundColor = .systemBackground
//        setupUI()
//    }
//    
//    private func setupUI() {
//        let payButton = UIButton(type: .system)
//        payButton.setTitle("จ่ายเงิน", for: .normal)
//        payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
//        
//        view.addSubview(payButton)
//        payButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            payButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    @objc private func payTapped() {
//        // จำลองการชำระเงิน
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.coordinator?.paymentCompleted()
//        }
//    }
//}
//
//// MARK: - 📊 4. Data Models
//
//struct MenuItem {
//    let id: Int
//    let name: String
//    let price: Double
//}
//
//// MARK: - 🔍 5. Memory Management & childCoordinators/parentCoordinator
//
///*
// 🎯 childCoordinators และ parentCoordinator ทำอะไร?
//
// 📊 เปรียบเทียบกับครอบครัว:
// 👨‍👩‍👧‍👦 ครอบครัว = Coordinator Hierarchy
// ├── 👨 พ่อ (AppCoordinator)
// │   └── childCoordinators = [ลูก1, ลูก2]
// ├── 👧 ลูก1 (MenuCoordinator)
// │   └── parentCoordinator = พ่อ
// └── 👦 ลูก2 (CartCoordinator)
//     └── parentCoordinator = พ่อ
//
// 🎯 childCoordinators (array) = รายชื่อลูก
// - เก็บ coordinator ลูกไว้ใน memory (strong reference)
// - ป้องกันลูกหายไปโดยไม่ตั้งใจ
// - จัดการ lifecycle ของลูกทั้งหมด
//
// 🎯 parentCoordinator (weak) = ผู้ปกครอง
// - อ้างอิงไปยัง coordinator แม่ (weak reference)
// - แจ้งแม่เมื่อทำงานเสร็จ
// - ได้รับข้อมูลจากแม่
//
// 🔄 วงจรการทำงาน:
// 1. 👨 พ่อสร้างลูก: addChild(ลูก)
// 2. 👧 ลูกทำงาน: ลูก.start()
// 3. 👧 ลูกเสร็จงาน: removeFromParent()
// 4. 👨 พ่อลบลูก: removeChild(ลูก)
//
// ⚠️ ปัญหาถ้าไม่มี:
// ❌ Memory Leak: coordinator สะสมใน memory
// ❌ Navigation Chaos: ไม่รู้ว่า coordinator ไหนทำงานอยู่
// ❌ Data Loss: ข้อมูลหายระหว่างการนำทาง
//*/
//
//extension GuideBaseCoordinator {
//    
//    /// แสดงสถานะ memory ของ coordinator tree
//    func debugMemoryStatus() {
//        print("🔍 === COORDINATOR MEMORY STATUS ===")
//        printCoordinatorTree()
//        print("===================================")
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
//            child.printCoordinatorTree(level: level + 1)
//        }
//    }
//    
//    /// ตรวจหา memory leaks ที่อาจเกิดขึ้น
//    func checkMemoryLeaks() {
//        var warnings: [String] = []
//        
//        if childCoordinators.count > 5 {
//            warnings.append("⚠️ Too many children (\(childCoordinators.count))")
//        }
//        
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
// 📋 สรุปคู่มือ Coordinator Pattern:
//
// 🎯 ประโยชน์:
// ✅ ViewController ไม่ต้องรู้จักกัน
// ✅ ง่ายต่อการเปลี่ยน Flow
// ✅ สามารถส่งข้อมูลระหว่างหน้าได้
// ✅ ทดสอบได้ง่าย
// ✅ จัดการ Memory ได้ดี
//
// 💡 กฎทอง:
// ✅ สร้างลูก → addChild()
// ✅ เสร็จงาน → removeFromParent()
// ✅ ใช้ weak สำหรับ parent
// ✅ ใช้ strong สำหรับ children
//
// 🚀 เริ่มต้นใช้งาน:
// 1. สร้าง AppCoordinator เป็นรากหลัก
// 2. แยก Coordinator ตาม Feature
// 3. ใช้ Combine สำหรับ Reactive Programming
// 4. ตรวจสอบ Memory Leaks เป็นระยะ
//
// 🎪 Pattern Flow:
// 👤 ผู้ใช้กดปุ่ม → 📱 ViewController บอก Coordinator → 🎬 Coordinator ตัดสินใจ → 🚀 เปิดหน้าใหม่
//*/
//
//// MARK: - 🎬 ตัวอย่าง: Shopping App Flow
//
///**
// 🛍️ หน้า Product List (รายการสินค้า)
// */
//class ProductListViewController: UIViewController {
//    weak var coordinator: ShoppingCoordinator?
//    
//    @IBAction func productTapped() {
//        // บอก coordinator ว่าผู้ใช้กดสินค้า
//        coordinator?.showProductDetail(productId: 123)
//    }
//    
//    @IBAction func cartTapped() {
//        // บอก coordinator ว่าผู้ใช้กดรถเข็น
//        coordinator?.showCart()
//    }
//}
//
///**
// 🛒 หน้า Product Detail (รายละเอียดสินค้า)
// */
//class ProductDetailViewController: UIViewController {
//    weak var coordinator: ShoppingCoordinator?
//    
//    @IBAction func addToCartTapped() {
//        // เพิ่มสินค้าเข้ารถเข็น แล้วกลับหน้าเดิม
//        addProductToCart()
//        coordinator?.dismissProductDetail()
//    }
//    
//    @IBAction func buyNowTapped() {
//        // ซื้อเลย ไปหน้า checkout
//        coordinator?.showCheckout()
//    }
//    
//    private func addProductToCart() {
//        // logic เพิ่มสินค้า
//    }
//}
//
///**
// 💳 หน้า Checkout (ชำระเงิน)
// */
//class CheckoutViewController: UIViewController {
//    weak var coordinator: ShoppingCoordinator?
//    
//    @IBAction func paymentCompleteTapped() {
//        // ชำระเงินเสร็จ ไปหน้า success
//        coordinator?.showPaymentSuccess()
//    }
//    
//    @IBAction func cancelTapped() {
//        // ยกเลิก กลับไปหน้า product detail
//        coordinator?.dismissCheckout()
//    }
//}
//
///**
// ✅ หน้า Payment Success (ชำระเงินสำเร็จ)
// */
//class PaymentSuccessViewController: UIViewController {
//    weak var coordinator: ShoppingCoordinator?
//    
//    @IBAction func backToHomeTapped() {
//        // กลับไปหน้าแรก
//        coordinator?.backToProductList()
//    }
//}
//
//// MARK: - 🎮 ShoppingCoordinator: ตัวจัดการทั้งหมด
//
//class ShoppingCoordinator: ExampleBaseCoordinator {
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - 🚀 เริ่มต้น Flow
//    override func start() {
//        showProductList()
//    }
//    
//    // MARK: - 📱 การจัดการหน้าจอต่างๆ
//    
//    /// แสดงหน้ารายการสินค้า (หน้าแรก)
//    func showProductList() {
//        let productListVC = ProductListViewController()
//        productListVC.coordinator = self
//        navigationController.setViewControllers([productListVC], animated: false)
//    }
//    
//    /// เปิดหน้ารายละเอียดสินค้า
//    func showProductDetail(productId: Int) {
//        let productDetailVC = ProductDetailViewController()
//        productDetailVC.coordinator = self
//        // ส่งข้อมูล productId ไปให้หน้า detail
//        navigationController.pushViewController(productDetailVC, animated: true)
//    }
//    
//    /// ปิดหน้ารายละเอียดสินค้า (กลับไปหน้าเดิม)
//    func dismissProductDetail() {
//        navigationController.popViewController(animated: true)
//    }
//    
//    /// เปิดหน้ารถเข็น (Modal)
//    func showCart() {
//        let cartVC = CartViewController()
//        cartVC.coordinator = self
//        let cartNav = UINavigationController(rootViewController: cartVC)
//        navigationController.present(cartNav, animated: true)
//    }
//    
//    /// เปิดหน้า Checkout
//    func showCheckout() {
//        let checkoutVC = CheckoutViewController()
//        checkoutVC.coordinator = self
//        navigationController.pushViewController(checkoutVC, animated: true)
//    }
//    
//    /// ปิดหน้า Checkout
//    func dismissCheckout() {
//        navigationController.popViewController(animated: true)
//    }
//    
//    /// เปิดหน้าชำระเงินสำเร็จ
//    func showPaymentSuccess() {
//        let successVC = PaymentSuccessViewController()
//        successVC.coordinator = self
//        navigationController.pushViewController(successVC, animated: true)
//    }
//    
//    /// กลับไปหน้าแรกสุด (ล้าง stack ทั้งหมด)
//    func backToProductList() {
//        showProductList()
//    }
//}
//
//class CartViewController: UIViewController {
//    weak var coordinator: ShoppingCoordinator?
//    
//    @IBAction func dismissTapped() {
//        dismiss(animated: true)
//    }
//}
//
//// MARK: - 🌟 การใช้งานขั้นสูง: ส่งข้อมูลระหว่างหน้า
//
///**
// 📊 ตัวอย่างการส่งข้อมูลที่ซับซ้อน
// */
//class AdvancedShoppingCoordinator: ExampleBaseCoordinator {
//    
//    // เก็บข้อมูลสำคัญใน coordinator
//    private var selectedProduct: Product?
//    private var cartItems: [CartItem] = []
//    private var userProfile: UserProfile?
//    
//    /// เปิดหน้า detail พร้อมส่งข้อมูลสินค้า
//    func showProductDetail(product: Product) {
//        selectedProduct = product
//        
//        let productDetailVC = ProductDetailViewController()
//        productDetailVC.coordinator = self
//        // ส่งข้อมูลไปให้ ViewController
//        // productDetailVC.configure(with: product)
//        
//        navigationController.pushViewController(productDetailVC, animated: true)
//    }
//    
//    /// เปิดหน้า checkout พร้อมข้อมูลรถเข็น
//    func showCheckout() {
//        guard !cartItems.isEmpty else {
//            showAlert(message: "รถเข็นว่างเปล่า")
//            return
//        }
//        
//        let checkoutVC = CheckoutViewController()
//        checkoutVC.coordinator = self
//        // ส่งข้อมูลรถเข็นไปให้หน้า checkout
//        // checkoutVC.configure(with: cartItems, user: userProfile)
//        
//        navigationController.pushViewController(checkoutVC, animated: true)
//    }
//    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: "แจ้งเตือน", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
//        navigationController.present(alert, animated: true)
//    }
//}
//
//// MARK: - 📝 Data Models
//struct Product {
//    let id: Int
//    let name: String
//    let price: Double
//}
//
//struct CartItem {
//    let product: Product
//    let quantity: Int
//}
//
//struct UserProfile {
//    let name: String
//    let email: String
//}
//
//// MARK: - 💡 เทคนิคขั้นสูง: Combine + Coordinator
//
///**
// 🔄 การใช้ Combine กับ Coordinator สำหรับ Reactive Programming
// */
//class ReactiveShoppingCoordinator: ExampleBaseCoordinator {
//    private var cancellables = Set<AnyCancellable>()
//    
//    // Publishers สำหรับติดตาม state
//    @Published private var cartItemCount: Int = 0
//    @Published private var isUserLoggedIn: Bool = false
//    
//    override func start() {
//        setupBindings()
//        showProductList()
//    }
//    
//    private func setupBindings() {
//        // ติดตาม cart item count
//        $cartItemCount
//            .sink { count in
//                print("🛒 Cart items: \(count)")
//                // อัพเดท badge บน tab bar
//            }
//            .store(in: &cancellables)
//        
//        // ติดตาม login status
//        $isUserLoggedIn
//            .sink { [weak self] isLoggedIn in
//                if !isLoggedIn {
//                    self?.showLogin()
//                }
//            }
//            .store(in: &cancellables)
//    }
//    
//    func showLogin() {
//        // แสดงหน้า login
//    }
//}
//
///*
// 📋 สรุปประโยชน์ของ Coordinator:
// 
// ✅ 1. แยกเรื่องการนำทางออกจาก ViewController
// ✅ 2. ง่ายต่อการทดสอบ Flow การทำงาน
// ✅ 3. สามารถส่งข้อมูลระหว่างหน้าได้ง่าย
// ✅ 4. จัดการ Deep Link ได้ดี
// ✅ 5. ควบคุม Authorization ได้ (ต้อง login ก่อนไหม?)
// ✅ 6. รองรับ Universal Link และ URL Scheme
// 
// 🎯 แนวทางปฏิบัติที่ดี:
// 
// - ViewController ไม่ควรรู้จัก ViewController อื่น
// - ViewController บอก Coordinator เมื่อผู้ใช้กดปุ่ม
// - Coordinator ตัดสินใจว่าจะไปหน้าไหน
// - ใช้ Combine สำหรับ async operations
// - แยก Coordinator ตาม Feature (Shopping, Profile, Chat)
// */
