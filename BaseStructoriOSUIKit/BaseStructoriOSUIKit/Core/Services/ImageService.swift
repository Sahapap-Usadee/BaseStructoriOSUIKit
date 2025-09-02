//
//  ImageService.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Image Service Protocol
protocol ImageServiceProtocol {
    func loadImage(from url: String) async throws -> UIImage
    func cacheImage(_ image: UIImage, for url: String)
    func getCachedImage(for url: String) -> UIImage?
    func clearCache()
}

// MARK: - Image Service Implementation
class ImageService: ImageServiceProtocol {
    private let cache = NSCache<NSString, UIImage>()
    
    init() {
        setupCache()
    }
    
    private func setupCache() {
        cache.countLimit = 100 // จำกัดจำนวนรูปในแคช
        cache.totalCostLimit = 50 * 1024 * 1024 // จำกัด 50MB
    }
    
    func loadImage(from url: String) async throws -> UIImage {
        // ตรวจสอบแคชก่อน
        if let cachedImage = getCachedImage(for: url) {
            return cachedImage
        }
        
        // ดาวน์โหลดรูปใหม่
        guard let imageURL = URL(string: url) else {
            throw ImageError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidImageData
        }
        
        // เก็บในแคช
        cacheImage(image, for: url)
        
        return image
    }
    
    func cacheImage(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: NSString(string: url))
    }
    
    func getCachedImage(for url: String) -> UIImage? {
        return cache.object(forKey: NSString(string: url))
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

// MARK: - Image Errors
enum ImageError: Error, LocalizedError {
    case invalidURL
    case invalidImageData
    case downloadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL รูปภาพไม่ถูกต้อง"
        case .invalidImageData:
            return "ข้อมูลรูปภาพไม่ถูกต้อง"
        case .downloadFailed:
            return "ไม่สามารถดาวน์โหลดรูปภาพได้"
        }
    }
}
