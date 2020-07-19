//
//  GnomeDetailsView.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import SwiftUI

struct GnomeDetailsView: View {
   @State var gnome: GnomeModel
   
   func getHairColor(color: String) -> Color {
      switch color {
         case "Black":
            return Color.secondary
         case "Red":
            return Color.red
         case "Pink":
            return Color.pink.opacity(0.7)
         case "Green":
            return Color.green
         case "Gray":
            return Color.secondary
         default:
            return Color.secondary
      }
   }
   
   func fetchFriends(friend: String) -> GnomeModel {
      return CoredataManager.shared.fetchBy(name: friend) ?? GnomeModel()
   }
   
   var body: some View {
      NavigationView {
         VStack {
            Spacer(minLength: 80)
            VStack {
               ImageFromURLView(urlString: gnome.thumbnail, isDetailView: true)
               Text(gnome.name ?? "").font(.title).fontWeight(.black)
            }
            List{
               Section(header: Text("Physical Attributes").font(.headline).fontWeight(.heavy)
                  .padding(.horizontal, 8).frame(width: UIScreen.main.bounds.width, alignment: .leading).background(Color.clear)) {
                     Text("Is \(gnome.age ?? 0) years old").padding(.leading, 3).foregroundColor(Color.secondary)
                     Text("Stands \(gnome.height ?? 0)m tall").padding(.leading, 3).foregroundColor(Color.secondary)
                     Text("Weighs \(gnome.weight ?? 0) kg").padding(.leading, 3).foregroundColor(Color.secondary)
                     if (gnome.hairColor ?? "") != "" {
                        HStack {
                           Text("Has").foregroundColor(getHairColor(color: ""))
                           
                           Text("\(gnome.hairColor ?? "")")
                              .fontWeight(.bold)
                              .foregroundColor(getHairColor(color: gnome.hairColor ?? ""))
                           
                           Text("hair")
                              .foregroundColor(getHairColor(color: ""))
                        }.padding(.leading, 3)
                     }
               }
               
               Section(header: Text((gnome.professions?.count ?? [String]().count) > 0 ? "Professional capabilities" : "Has no Profession").font(.headline).fontWeight(.heavy)
                  .padding(.horizontal, 8).frame(width: UIScreen.main.bounds.width, alignment: .leading).background(Color.clear)) {
                     ForEach(gnome.professions ?? [String](), id: \.self) { profession in
                        Text(profession).padding(.leading, 3).foregroundColor(Color.secondary)
                     }
               }
               
               Section(header: Text((gnome.friends?.count ?? [String]().count) > 0 ? "Is Friends with" : "Has no Friends").font(.headline).fontWeight(.heavy)
                  .padding(.horizontal, 12).frame(width: UIScreen.main.bounds.width, alignment: .leading).background(Color.clear)) {
                     
                     ForEach(gnome.friends ?? [String](), id: \.self) { friend in
                        GnomeItemView(gnomeModel: self.fetchFriends(friend: friend))
                     }
               }.cornerRadius(25)
            }
            .listStyle(GroupedListStyle())
         }.edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
      }
   }
}

struct GnomeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      GnomeDetailsView(gnome: GnomeModel())
    }
}
