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
    private let networkService: NetworkServiceProtocol
    private let cache = NSCache<NSString, UIImage>()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
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
        let imageData = try await networkService.downloadImage(from: url)
        
        guard let image = UIImage(data: imageData) else {
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
    case invalidImageData
    case downloadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidImageData:
            return "ข้อมูลรูปภาพไม่ถูกต้อง"
        case .downloadFailed:
            return "ไม่สามารถดาวน์โหลดรูปภาพได้"
        }
    }
}
