//
//  MapMenuView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import SwiftUI
import MapKit

public struct MapMenuView: View {
    
    @Binding var mapItem: MapItemModel?
    @Binding var showingMenu: Bool
    @State var scene: MKLookAroundScene?
    
    public var body: some View {
        VStack{
            HStack{
                Text(mapItem?.mapItem.name ?? "No Name")
                    .font(.headline)
                Text(mapItem?.shelter.info.subType ?? "No Name")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            
                Spacer()
                
                Button {
                    withAnimation{
                        showingMenu = false
                    }
                } label: {
                    Text("Cancel")
                        .frame(width: 70, height: 30)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
            VStack(alignment: .leading, spacing: 16) {
                
                GroupBox(label: Label("About", systemImage: "info.circle")
                            .font(.headline)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(mapItem?.shelter.info.description ?? "No Description")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if mapItem?.shelter.info.subType == "Shelter" {
                    GroupBox(label: Label("Capacity", systemImage: "person.3.fill")
                                .font(.headline)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Available Capacity")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            ProgressView(value: Float(Double((mapItem?.shelter.info.capacity ?? 0) + 1) / 5.0))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                GroupBox(label: Label("Contact Info", systemImage: "phone.fill")
                            .font(.headline)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phone: \(mapItem?.shelter.contact.phone ?? "No Phone")")
                        Text("Email: \(mapItem?.shelter.contact.email ?? "No Email")")
                    }
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                GroupBox(label: Label("Location", systemImage: "mappin.and.ellipse")
                            .font(.headline)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Address: \(mapItem?.shelter.location.address ?? "No Address")")
                        Text("City: \(mapItem?.shelter.location.city ?? "No City")")
                        Text("State: \(mapItem?.shelter.location.state ?? "No State")")
                        Text("Zip: \(mapItem?.shelter.location.zip ?? "No Zip")")
                    }
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking] // Set driving mode

                MKMapItem.openMaps(with: [mapItem!.mapItem], launchOptions: launchOptions)
            }) {
                ZStack {
                    // Background style
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                    
                    // Icon and label
                    VStack {
                        Image(systemName: "arrow.turn.up.right")
                            .foregroundColor(.main)
                        Text("Directions")
                            .foregroundStyle(.main)
                            .fontWeight(.bold)
                    }
                }
            }
            .frame(height: 60)
        }
        .padding([.horizontal, .bottom])
    }
}
