//
//  EmergencyView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/11/25.
//

import SwiftUI

struct EmergencyView: View {
    
    @Binding var showEmergency: Bool
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial) // Use .fill instead of .background for a shape
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack{
                Text("Emergency")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .foregroundColor(Color.red)
                    .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        UIApplication.shared.open(URL(string: "tel://911")!)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                            
                            VStack {
                                Text("911 - Police")
                                    .foregroundColor(.main)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    Button(action: {
                        UIApplication.shared.open(URL(string: "tel://988")!)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                            
                            VStack {
                                Text("988 - Suicide Hotline")
                                    .foregroundColor(.main)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 75)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.buttonBorder)
                
                Spacer()
                
                Button(action: {
                    withAnimation() {
                        showEmergency = false
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 70, height: 70)
                        
                        Text("X")
                            .font(.system(size: 25))
                            .foregroundStyle(Color.primary)
                    }
                }
                
            }
            .padding()
        }
    }
}
