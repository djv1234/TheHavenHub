//
//  Untitled.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewManager: ViewManager
    
    var body: some View {
        Button {
            withAnimation(){
                viewManager.navigateToMain()
            }
        } label: {
            Text("Click me to go back to the main view")
        }

    }
}
