//
//  ProfileButton.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/23/25.
//

import SwiftUI

struct ProfileButton: View {
    @StateObject var viewManager: ViewManager
    
    var body: some View {
        Button(action: {
            withAnimation{
                viewManager.navigateToProfile()
            }
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 40, height: 40)
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.primary)
                    .frame(width: 20, height: 20)
            }
        }
    }
}
