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
   @State var showGnomeList = false
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
         .sheet(isPresented: self.$showGnomeList, content: {
            ColorFilterView(showColorFilter: self.$showGnomeList).environmentObject(self.gnomeListVM)
         })
      .navigationBarTitle("Brastlewark Crew")
      .navigationBarItems(leading: RefreshView().environmentObject(self.gnomeListVM), trailing: ShowFilterButton(gnomeVM: self.$showGnomeList))
//      .navigationBarItems(leading: RefreshView().environmentObject(self.gnomeListVM))
//            .navigationBarItems(trailing: ShowFilterButton(gnomeVM: self.$showGnomeList))//.environmentObject(self.gnomeListVM))
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


struct ShowFilterButton: View {
   @Binding var gnomeVM: Bool
   var body: some View {
      Button(action: {
         self.gnomeVM.toggle()
//         self.gnomeVM.loadGnomes()
      }) {
         Text("Filter")
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
