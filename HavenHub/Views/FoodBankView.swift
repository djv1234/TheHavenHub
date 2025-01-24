//
//  FoodBank.swift
//  HavenHub
//
//  Created by Khush Patel on 1/23/25.
//

import SwiftUI
import MapKit

struct FoodBankView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var shelters: [MKMapItem]
    @Binding var showBottomSheet: Bool
    @Binding var showFoodBank: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer() // Push the list to the bottom
                
                VStack(spacing: 0) {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    List(shelters, id: \.self) { shelter in
                        VStack(alignment: .leading) {
                            Text(shelter.name ?? "Unnamed Food Bank")
                                .font(.headline)
                            Text("Address: Placeholder Address")
                                .font(.subheadline)
                        }
                        .padding()
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: geometry.size.height * 0.4) // Restrict the list to 40% of the screen height
                    
                    Button(action: {
                        withAnimation {
                            showFoodBank = false
                            showBottomSheet = true
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
                    .padding()
                }
                .background(Color.white.opacity(0.9)) // Make the bottom sheet background slightly opaque
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
    }
}
