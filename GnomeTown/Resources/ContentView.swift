//
//  ContentView.swift
//  GnomeTown
//
//  Created by 837676 on 15/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      GnomeListView().environmentObject(GnomeListVM())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
