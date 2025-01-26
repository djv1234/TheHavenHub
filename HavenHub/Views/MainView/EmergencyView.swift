//
//  EmergencyView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/11/25.
//

import SwiftUI

struct EmergencyView: View {
    
    @Binding var showEmergency: Bool // Binding to control the visibility of the emergency view
    
    var body: some View {
        ZStack {
            // Background overlay
            Rectangle()
                .fill(.ultraThinMaterial) // Semi-transparent background for focus
                .ignoresSafeArea() // Extend the background to the edges of the screen
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Full screen coverage

            VStack {
                // Emergency title
                Text("Emergency")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .foregroundColor(Color.red) // Highlight the title in red
                    .padding()
                
                Spacer() // Spacer to create vertical spacing between the title and buttons
                
                // Emergency contact buttons
                HStack {
                    // 911 - Police Emergency Button
                    Button(action: {
                        // Open the phone app to call 911
                        UIApplication.shared.open(URL(string: "tel://911")!)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red) // Red background for urgency
                            
                            VStack {
                                Text("911 - Police")
                                    .foregroundColor(.main) // Use the main color for text
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(height: 75) // Set consistent height for the button
                    }
                    
                    // 988 - Suicide Hotline Button
                    Button(action: {
                        // Open the phone app to call 988
                        UIApplication.shared.open(URL(string: "tel://988")!)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red) // Red background for urgency
                            
                            VStack {
                                Text("988 - Suicide Hotline")
                                    .foregroundColor(.main) // Use the main color for text
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(height: 75) // Set consistent height for the button
                    }
                }
                .frame(maxWidth: .infinity) // Make buttons stretch horizontally
                .padding() // Add padding around the buttons
                .background(.ultraThinMaterial) // Semi-transparent background for the button container
                .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners for the button container
                
                Spacer() // Spacer to create vertical spacing between buttons and the close button
                
                // Close button
                Button(action: {
                    // Close the emergency view with animation
                    withAnimation {
                        showEmergency = false
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial) // Semi-transparent circular background
                            .frame(width: 70, height: 70) // Size of the button
                        
                        Text("X")
                            .font(.system(size: 25)) // Font size for the close symbol
                            .foregroundStyle(Color.primary) // Color for the text
                    }
                }
                .padding() // Add padding around the close button
            }
            .padding() // Add padding to the entire content
        }
    }
}
