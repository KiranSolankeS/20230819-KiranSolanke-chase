//
//  ImageCache.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 19/08/23.
//

import Foundation
import UIKit

class ImageCache {

    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.totalCostLimit = 50 * 1024 * 1024 // Limit cache size to 50 MB
    }

    func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
        }.resume()
    }
}
