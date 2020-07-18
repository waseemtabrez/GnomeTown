//
//  GnomeFilterView.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import SwiftUI

struct ColorFilterView: View {
   @ObservedObject var gnomeFilterVM = GenomeFilterVM()
   @Binding var showColorFilter: Bool
   @State var showColors = false
   @EnvironmentObject var gnomeListVM : GnomeListVM
   
   func getHairColor(color: String) -> Color {
      switch color {
         case "Black":
            return Color.black
         case "Red":
            return Color.red
         case "Pink":
            return Color.pink.opacity(0.7)
         case "Green":
            return Color.green
         case "Gray":
            return Color.gray
         default:
            return Color.secondary
      }
   }
   var body: some View {
      VStack {
         Spacer(minLength: 5)
            Button(action: {
               self.showColors.toggle()
            }) {
               Text("Filter by Color")
            }
            if self.showColors {
            ZStack(alignment: .top){
               HStack(alignment: .center) {
                  ForEach(self.gnomeFilterVM.hairColor, id: \.self) { type in
                     
                     Button(action: {
                        self.self.gnomeFilterVM.selectedHairColor = type
                        self.showColorFilter.toggle()
                     }, label: {
                        HStack {
                           Text(LocalizedStringKey(type))
                              .fixedSize(horizontal: true, vertical: false)
                              .padding()
                              .background(self.getHairColor(color: type))
                              .foregroundColor(Color(UIColor.white))
                              .font(.footnote)
                              .tag(type)
                        }
                           //                     .onTapGesture {
                           //                        self.self.gnomeFilterVM.selectedProfessions.append(type)
                           //                        self.showFilterTransaction.toggle()
                           //                     }
                           .background(Color(UIColor.systemGray6))
                           .clipShape(Capsule())
                     })
                  }
               }
               }
            .padding()
            .background(Color(UIColor.systemGray6))
            .clipShape(Rectangle())
            .cornerRadius(25)
         }
         Spacer()
      }
   }
}

struct GnomeFilterView_Previews: PreviewProvider {
    static var previews: some View {
      ColorFilterView(showColorFilter: Binding.constant(true)).environmentObject(GnomeListVM())
    }
}
