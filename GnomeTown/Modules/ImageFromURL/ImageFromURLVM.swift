//
//  ImageFromURLVM.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import Foundation
import SwiftUI

class ImageFromURLVM: ObservableObject {
   @Published var image: UIImage?
   var urlString: String?
   var imageCache = ImageCache.getImageCache()
   
   init(urlString: String?) {
      self.urlString = urlString
      loadImage()
   }
   
   func loadImage() {
      if loadImageFromCache() {
         print("Cache hit")
         return
      }
      
      print("Cache miss, loading from url")
      loadImageFromUrl()
   }
   
   func loadImageFromCache() -> Bool {
      guard let urlString = urlString else {
         return false
      }
      
      guard let cacheImage = imageCache.get(forKey: urlString) else {
         return false
      }
      
      image = cacheImage
      return true
   }
   
   func loadImageFromUrl() {
      guard let urlString = urlString else {
         return
      }
      
      let url = URL(string: urlString)!
      let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
      task.resume()
   }
   
   
   func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
      guard error == nil else {
         print("Error: \(error!)")
         return
      }
      guard let data = data else {
         print("No data found")
         return
      }
      
      DispatchQueue.main.async {
         guard let loadedImage = UIImage(data: data) else {
            return
         }
         
         self.imageCache.set(forKey: self.urlString!, image: loadedImage)
         self.image = loadedImage
      }
   }
}
