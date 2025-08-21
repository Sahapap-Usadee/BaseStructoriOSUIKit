# เอกสารข้อกำหนดผลิตภัณฑ์: BaseStructoriOSUIKit

## 1. ภาพรวมโปรเจกต์
BaseStructoriOSUIKit คือโปรเจกต์แอป iOS แบบโมดูลาร์ที่ใช้ UIKit, สถาปัตยกรรม MVVM-C (Model-View-ViewModel-Coordinator) และ Dependency Injection ออกแบบมาเพื่อรองรับการขยาย ดูแล และทดสอบได้ง่าย เหมาะกับแอประดับองค์กรที่มีหลายโมดูลและหลายสภาพแวดล้อม

## 2. ฟีเจอร์หลัก

- โครงสร้างแบบโมดูล: Home, List, Loading, Main, Settings
- สถาปัตยกรรม MVVM-C พร้อม Coordinator pattern
- ใช้ Dependency Injection ผ่าน DIContainer
- ระบบนำทางแบบกำหนดเอง (NavigationManager, NavigationConfiguration)
- Flow โหลดข้อมูลด้วย LoadingCoordinator
- Flow หลักด้วย MainCoordinator และ TabBar
- รองรับหลายสภาพแวดล้อม (Debug, Dev, PreProd, Release, UAT)
- จัดการ Asset (Assets.xcassets)

## 3. โครงสร้างโปรเจกต์
```
BaseStructoriOSUIKit/
├── Application/
│   ├── AppCoordinator.swift
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Core/
│   ├── DI/
│   │   └── DIContainer.swift
│   ├── Extensions/
│   ├── Models/
│   ├── Navigation/
│   │   ├── Coordinator.swift
│   │   ├── NavigationConfiguration.swift
│   │   └── NavigationManager.swift
│   └── Services/
├── Modules/
│   ├── Home/
│   │   ├── DI/
│   │   ├── Navigation/
│   │   └── Presentation/
│   ├── List/
│   │   ├── DI/
│   │   ├── Navigation/
│   │   └── Presentation/
│   ├── Loading/
│   │   ├── Navigation/
│   │   │   └── LoadingCoordinator.swift
│   │   └── Presentation/
│   │       ├── LoadingViewController.swift
│   │       └── LoadingViewModel.swift
│   ├── Main/
│   │   ├── MainCoordinator.swift
│   │   └── MainTabBarController.swift
│   └── Settings/
│       ├── DI/
│       ├── Navigation/
│       └── Presentation/
├── Assets.xcassets/
├── Info.plist
```

## 4. สภาพแวดล้อม (Environments)

- Debug
- Dev
- PreProd
- Release
- UAT

## 5. การตั้งค่า Build

- Product Module Name: BaseStructorDGA
- Product Name: BaseStructorDGA
- ทุกสภาพแวดล้อมใช้ชื่อ module และ product name เดียวกัน

## 6. ระบบนำทางและ Flow

- แอปเริ่มต้นด้วย AppCoordinator
- แสดง LoadingCoordinator (ใช้ closure/callback ไม่ใช้ delegate)
- หลังโหลดเสร็จ แสดง MainCoordinator (TabBar: Home, List, Settings)
- MainCoordinator จัดการ sign out โดยย้อนกลับไป LoadingCoordinator

## 7. มาตรฐานการเขียนโค้ด

- ใช้ UIKit เท่านั้น (ไม่ใช้ SwiftUI)
- MVVM-C pattern
- ทุก service และ module ต้อง Inject ผ่าน DIContainer
- ห้ามมี business logic ใน ViewController
- การนำทางทั้งหมดต้องผ่าน Coordinator
- ห้ามใช้ global singleton ยกเว้น DIContainer

## 8. Localization & Assets

- ใช้ Assets.xcassets สำหรับรูปภาพ สี และไอคอน

## 9. ขอบเขตที่ไม่รวม (Out of Scope)

- ห้ามเพิ่มฟีเจอร์ โมดูล หรือไลบรารีใด ๆ ที่นอกเหนือจากที่มีในโปรเจกต์นี้
- ไม่ใช้ SwiftUI, Combine หรือ third-party framework ใด ๆ เว้นแต่มีอยู่แล้ว

---

**เอกสารนี้เป็นแหล่งข้อมูลหลักสำหรับ AI agent ในการสร้าง ดูแล หรือขยายโครงสร้างและโค้ดของโปรเจกต์นี้ ห้ามเพิ่มหรือลดฟีเจอร์ใด ๆ ที่นอกเหนือจากที่ระบุไว้ในเอกสารนี้**
