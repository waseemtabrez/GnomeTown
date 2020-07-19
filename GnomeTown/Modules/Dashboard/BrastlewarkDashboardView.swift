//
//  BrastlewarkDashboardView.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 19/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import SwiftUI

struct BrastlewarkDashboardView: View {
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @EnvironmentObject var gnomeFilterVM: GnomeFilterVM
   @State var showWelcome: Bool = true
    var body: some View {
      NavigationView{
         Group {
            if self.showWelcome {
               VStack{
                  VStack(alignment: .center){
                     Text("Brastlewark!")
                     .fixedSize(horizontal: true, vertical: true)
                        .padding(30)
                  }                     .padding(12)
                  .background(Color(UIColor.orange))
                  .clipShape(Circle())

                  Divider().hidden()
                  VStack{
                     HStack{
                        Text("Our Crew Strength:")
                        Spacer()
                        if self.gnomeListVM.loading {
                           ActivityIndicator(isAnimating: Binding.constant(true), style: .medium)
                        } else {
                           Text("\(self.gnomeListVM.gnomesFetched.count)")
                        }

                     }.padding()
                     HStack{
                        Text("Professions available:")
                        Spacer()
                        if self.gnomeListVM.loading {
                           ActivityIndicator(isAnimating: Binding.constant(true), style: .medium)
                        } else {
                           Text("\(self.gnomeFilterVM.professions.count)")
                        }
                     }.padding()
                     HStack{
                        Text("Diversity in haircolors:")
                        Spacer()
                        if self.gnomeListVM.loading {
                           ActivityIndicator(isAnimating: Binding.constant(true), style: .medium)
                        } else {
                           Text("\(self.gnomeFilterVM.hairColor.count)")
                        }
                     }.padding()
                  }
                  .padding()
                  .background(Color(UIColor.systemGreen))
                  .cornerRadius(30)
                  Spacer()
               }.padding(.horizontal, 45)
            } else {
               
            }
         }
      .navigationBarHidden(true)
      }
    }
}

struct BrastlewarkDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        BrastlewarkDashboardView()
    }
}
