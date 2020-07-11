//
//  ContentView.swift
//  HelloSwiftUI
//
//  Created by 이재은 on 2020/07/08.
//  Copyright © 2020 이재은. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var a = 0
    
    var body: some View {
        VStack {
            Text("Hello, SwiftUI!!!")
                .font(.largeTitle)
                .foregroundColor(Color.purple)
                .background(Color.yellow)
            
        Text("Have a nice day :)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
