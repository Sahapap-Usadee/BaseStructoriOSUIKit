//
//  TodayModels.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Today Card Types
enum TodayCardType {
    case featured          // การ์ดใหญ่แนะนำ
    case story            // เรื่องราวหรือบทความ
    case appOfTheDay      // แอปประจำวัน
    case gameOfTheDay     // เกมส์ประจำวัน
    case collection       // คอลเลคชั่น
}

// MARK: - Today Card Model
struct TodayCard {
    let id: String
    let type: TodayCardType
    let title: String
    let subtitle: String?
    let description: String
    let backgroundImageURL: String?
    let backgroundColor: UIColor
    let textColor: UIColor
    let category: String
    let date: Date
    let isPromoted: Bool
    
    // เฉพาะ App/Game cards
    let appIcon: String?
    let appName: String?
    let rating: Double?
    let price: String?
    
    // เฉพาะ Collection cards
    let items: [TodayCollectionItem]?
}

// MARK: - Collection Item
struct TodayCollectionItem {
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: String
    let appIcon: String?
}

// MARK: - Today Section
struct TodaySection {
    let title: String?
    let cards: [TodayCard]
}

// MARK: - Sample Data
extension TodayCard {
    static let sampleData: [TodayCard] = [
        TodayCard(
            id: "1",
            type: .featured,
            title: "แอปใหม่ที่เราหลงรัก",
            subtitle: "จากนักพัฒนาชั้นนำ",
            description: "ค้นพบแอปพลิเคชันที่น่าตื่นเต้นที่สุดในเดือนนี้",
            backgroundImageURL: nil,
            backgroundColor: .systemBlue,
            textColor: .white,
            category: "แอปแนะนำ",
            date: Date(),
            isPromoted: true,
            appIcon: nil,
            appName: nil,
            rating: nil,
            price: nil,
            items: nil
        ),
        TodayCard(
            id: "2",
            type: .appOfTheDay,
            title: "แอปประจำวัน",
            subtitle: "เครื่องมือสร้างสรรค์",
            description: "ปลดปล่อยศักยภาพความคิดสร้างสรรค์ของคุณ",
            backgroundImageURL: nil,
            backgroundColor: .systemPurple,
            textColor: .white,
            category: "ประสิทธิผล",
            date: Date(),
            isPromoted: false,
            appIcon: "star.fill",
            appName: "Creative Studio",
            rating: 4.8,
            price: "ฟรี",
            items: nil
        ),
        TodayCard(
            id: "3",
            type: .story,
            title: "การออกแบบที่เปลี่ยนโลก",
            subtitle: "เรื่องราวจากนักออกแบบ",
            description: "สำรวจแนวคิดการออกแบบที่เปลี่ยนวิธีการใช้งานเทคโนโลยี",
            backgroundImageURL: nil,
            backgroundColor: .systemOrange,
            textColor: .white,
            category: "เรื่องราว",
            date: Date(),
            isPromoted: false,
            appIcon: nil,
            appName: nil,
            rating: nil,
            price: nil,
            items: nil
        ),
        TodayCard(
            id: "4",
            type: .collection,
            title: "เกมส์ที่ต้องลอง",
            subtitle: "คอลเลคชั่นเกมส์ยอดนิยม",
            description: "รวมเกมส์ที่กำลังฮิตและน่าเล่นที่สุดในขณะนี้",
            backgroundImageURL: nil,
            backgroundColor: .systemGreen,
            textColor: .white,
            category: "เกมส์",
            date: Date(),
            isPromoted: false,
            appIcon: nil,
            appName: nil,
            rating: nil,
            price: nil,
            items: [
                TodayCollectionItem(
                    id: "1",
                    title: "Adventure Quest",
                    subtitle: "RPG ผจญภัย",
                    imageURL: "",
                    appIcon: "gamecontroller.fill"
                ),
                TodayCollectionItem(
                    id: "2", 
                    title: "Puzzle Master",
                    subtitle: "เกมส์ปริศนา",
                    imageURL: "",
                    appIcon: "puzzle"
                )
            ]
        )
    ]
}
