//
//  ImageFromUrlView.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 17/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import SwiftUI

struct ImageFromURLView: View {
   @ObservedObject var urlImageModel: ImageFromURLVM
   var isDetailView: Bool = false
   
   init(urlString: String?, isDetailView: Bool?) {
      urlImageModel = ImageFromURLVM(urlString: urlString)
      self.isDetailView = isDetailView ?? false
   }
   
   func getScreenSize() -> Bool {
      var isSmallDevice: Bool = false
      if UIDevice().userInterfaceIdiom == .phone {
         switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208, 2436, 2688, 1792:
               isSmallDevice = false
            default:
               isSmallDevice = true
         }
      }
      return isSmallDevice
   }
   var body: some View {
      ZStack{
         if urlImageModel.image == nil {
            ActivityIndicator(isAnimating: Binding.constant(true), style: .medium)
         }
         Image(uiImage: urlImageModel.image ?? ImageFromURLView.defaultImage!)
         .resizable()
         .frame(width: self.isDetailView ? 200 : 40, height: self.isDetailView ? 200 : 40)
         .cornerRadius(self.isDetailView ? 100 : 20)
         .aspectRatio(contentMode: .fit)
      }
   }
   
   static var defaultImage = UIImage(systemName: "person.crop.circle")
}

struct UrlImageView_Previews: PreviewProvider {
   static var previews: some View {
      ImageFromURLView(urlString: nil, isDetailView: false)
   }
}
