//
//  FavoritesView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 4/30/25.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var showFavorites: Bool // Binding var to indicate whether to show favorites
    var body: some View {
        ZStack{
            // Background overlay
            Rectangle()
                .fill(.ultraThinMaterial) // Semi-transparent background for focus
                .ignoresSafeArea() // Extend the background to the edges of the screen
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Full screen coverage
            
            VStack {
                            Spacer() // Push content to the center or top

                            Text("Coming soon!")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(.primary)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))

                            Spacer()

                            // Close button at bottom
                            Button(action: {
                                withAnimation {
                                    showFavorites = false
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 70, height: 70)

                                    Text("X")
                                        .font(.system(size: 25))
                                        .foregroundStyle(.primary)
                                }
                            }
                            .padding(.bottom, 30) // Adjust spacing from bottom
                        }
                        .padding()

        }
    }
}
