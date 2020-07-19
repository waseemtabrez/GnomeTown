//
//  ImageCache.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 17/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import Foundation
import UIKit

struct ImageCache {
   var cache = NSCache<NSString, UIImage>()
   
   func get(forKey: String) -> UIImage? {
      return cache.object(forKey: NSString(string: forKey))
   }
   
   func set(forKey: String, image: UIImage) {
      cache.setObject(image, forKey: NSString(string: forKey))
   }
}

extension ImageCache {
   private static var imageCache = ImageCache()
   static func getImageCache() -> ImageCache {
      return imageCache
   }
}
