//
//  ButtonView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/15/25.
//
import SwiftUI
import MapKit

struct ButtonView: View {
    // Bindings for shared states and view properties
    @Binding var showEmergency: Bool // Controls whether the emergency view is shown
    var geometry: GeometryProxy // Provides the size and dimensions of the parent view
    @Binding var cameraPosition: MapCameraPosition // Tracks the current position of the map camera
    @StateObject var viewManager: ViewManager
    
    var body: some View {
        VStack {
            // First row of buttons
            HStack {
                // Favorites Button
                Button(action: {
                    // Action for the Favorites button (placeholder)
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green)
                        
                        // Icon and label
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.main) // Custom main color
                            Text("Favorites")
                                .foregroundColor(.main)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                // Emergency Button
                Button(action: {
                    withAnimation() {
                        showEmergency = true // Show the emergency screen
                    }
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red)
                        
                        // Icon and label
                        VStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.main)
                            Text("Emergency")
                                .foregroundStyle(.main)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .padding([.horizontal]) // Horizontal padding for the button row
            .frame(width: geometry.size.width, height: geometry.size.height * 0.15) // Row height relative to screen size
            
            // Second row of buttons
            HStack {
                // Food Button
                Button(action: {
                    // Action for the Food button (placeholder)
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main) // Custom main color
                            .shadow(radius: 4) // Shadow for depth
                        Image(systemName: "fork.knife")
                            .foregroundColor(Color.yellow)
                    }
                }
                
                // Shelter Button
                Button(action: {
                    // Action for the Shelter button (placeholder)
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                            .shadow(radius: 4)
                        Image(systemName: "house.fill")
                            .foregroundColor(Color.brown)
                    }
                }
                
                    Button(action: {
                        viewManager.navigateToHealth()
                    }) {
                        ZStack {
                            // Background style
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.main)
                                .shadow(radius: 4)
                            
                            Image(systemName: "cross.fill")
                                .foregroundColor(Color.red)
                        }
                    }
                
    
                // Clothing Button
                Button(action: {
                    // Action for the Clothing button (placeholder)
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                            .shadow(radius: 4)
                        
                        Image(systemName: "hanger")
                            .foregroundColor(Color.purple)
                    }
                }
            }
            .padding([.horizontal]) // Horizontal padding for the button row
            .frame(width: geometry.size.width, height: geometry.size.height * 0.10) // Row height relative to screen size
        }
    }
}
