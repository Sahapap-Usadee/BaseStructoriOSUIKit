//
//  Kingfisher+Extensions.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//
import UIKit
import Kingfisher

extension UIImageView {
    
    /// Load Pokemon image with optimized settings
    func loadPokemonImage(from urlString: String?, placeholder: UIImage? = UIImage(systemName: "photo")) {
        guard let urlString = urlString, !urlString.isEmpty,
              let url = URL(string: urlString) else {
            self.image = UIImage(systemName: "questionmark.circle")
            return
        }
        
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage,
                .scaleFactor(UIScreen.main.scale),
                .processor(DownsamplingImageProcessor(size: self.bounds.size)),
                .keepCurrentImageWhileLoading
            ]
        ) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                DispatchQueue.main.async {
                    self.image = UIImage(systemName: "exclamationmark.circle")
                }
            }
        }
    }
    
    /// Load Pokemon image by ID
    func loadPokemonImage(by id: Int?, placeholder: UIImage? = UIImage(systemName: "photo")) {
        guard let id = id else {
            self.image = UIImage(systemName: "questionmark.circle")
            return
        }
        
        let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        loadPokemonImage(from: imageURL, placeholder: placeholder)
    }
}
