//
//  GnomeListView.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import SwiftUI

struct GnomeListView: View {
   @ObservedObject var gnomeListVM = GnomeListVM()
    var body: some View {
      NavigationView{
         Group{
            if self.gnomeListVM.loading {
               ActivityIndicator(isAnimating: self.$gnomeListVM.loading, style: .large)
            } else {
               
               if self.gnomeListVM.gnomesFetched.count == 0 {
                  VStack{
                     Text("No Gnomes Found. Refresh")
                  }
               } else {
                  List{
                     ForEach(self.gnomeListVM.gnomesFetched, id: \.self) { (gnome: GnomeModel) in
                        
                        NavigationLink(destination: GnomeDetailsView(gnome: gnome)) {
                           GnomeItemView(gnomeModel: gnome)
                        }
                     }
                  }.onAppear{
                     self.gnomeListVM.loading = false
                  }
               }
            }

         }
      .navigationBarTitle("Brastlewark Crew")
      .navigationBarItems(trailing: RefreshView().environmentObject(self.gnomeListVM))
      }
    }
}

struct GnomeListView_Previews: PreviewProvider {
    static var previews: some View {
        GnomeListView()
    }
}

struct RefreshView: View {
   @EnvironmentObject var gnomeVM: GnomeListVM
   var body: some View {
      Button(action: {
         self.gnomeVM.loading = true
         self.gnomeVM.loadGnomes()
      }) {
         Text("Refresh")
      }
   }
}

struct GnomeItemView: View {
   var gnomeModel: GnomeModel
   
   var body: some View {
      HStack {
         ImageFromURLView(urlString: gnomeModel.thumbnail, isDetailView: false)
         VStack(alignment: .leading) {
            Text("\(gnomeModel.name!)")
               .font(.headline)
            //               HStack {
            //                Text("\(gnomeModel.age ?? 0)")
            //                    .font(.subheadline)
            //                  Text("\(gnomeModel.height ?? 0.0)")
            //                     .font(.subheadline)
            //                  Text("\(gnomeModel.weight ?? 0.0)")
            //                     .font(.subheadline)
            //               }
         }
      }
   }
}
