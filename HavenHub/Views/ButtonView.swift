//
//  ButtonView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/15/25.
//
import SwiftUI
import MapKit

struct ButtonView: View {
    @Binding var showEmergency: Bool
    var geometry: GeometryProxy
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        
        VStack{
            HStack {
                Button(action: { }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green)
                        
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.main)
                            Text("Favorites")
                                .foregroundColor(.main)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Button(action: {
                    withAnimation() {
                        showEmergency = true
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red)
                        
                        VStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.main)
                            Text("Emergency")
                                .foregroundStyle(.main)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Button(action: {
                    let locationSearch = UserLocation(cameraPosition: $cameraPosition)
                    locationSearch.goToUserLocation()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue)
                        VStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.main)
                            Text("Location")
                                .foregroundStyle(.main)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding([.horizontal])
            .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
            
            HStack {
                Button(action: {
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                        Image(systemName: "fork.knife")
                            .foregroundColor(Color.yellow)
                    }
                }
                
                
                Button(action: {
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                        Image(systemName: "house.fill")
                            .foregroundColor(Color.brown)
                    }
                }
                
                Button(action: {
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                        
                        Image(systemName: "cross.fill")
                            .foregroundColor(Color.red)
                    }
                }
                
                Button(action: {
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                        
                        Image(systemName: "hanger")
                            .foregroundColor(Color.purple)
                    }
                }
                
            }
            .padding([.horizontal])
            .frame(width: geometry.size.width, height: geometry.size.height * 0.10)
        }
    }
}
