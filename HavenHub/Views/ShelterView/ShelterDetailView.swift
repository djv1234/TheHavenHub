//
//  ShelterDetailView.swift
//  HavenHub
//
//  Created by Khush Patel on 4/20/25.
//

import SwiftUI
import MapKit

struct ShelterDetailView: View {
    let shelter: MKMapItem
    @State private var cameraPosition: MapCameraPosition
    @State private var showMapOptions = false
    @Environment(\.dismiss) private var dismiss
    
    init(shelter: MKMapItem) {
        self.shelter = shelter
        let coordinate = shelter.placemark.coordinate
        _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }

    var body: some View {
        
        Text(shelter.name ?? "Unnamed Shelter")
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .padding()
        
        // Map with rounded corners
        Map(position: $cameraPosition) {
            Marker(shelter.name ?? "Unknown", coordinate: shelter.placemark.coordinate)
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        
        VStack(alignment: .leading, spacing: 20) {
            Text("To reserve a bed at the shelter, call:")
                .font(.headline)
                .padding(.horizontal)
            
            Button(action: {
                if let phoneURL = URL(string: "tel://6142747000") {
                    UIApplication.shared.open(phoneURL)
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.red)
                        .frame(height: 45)
                    Text("+1 (614) 274-7000")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            
            // Website Button
            if let url = shelter.url {
                Button(action: {
                    UIApplication.shared.open(url)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red)
                            .frame(height: 45)
                        
                        Text(url.absoluteString)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .truncationMode(.tail)
                            .padding(.horizontal, 10)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Website unavailable")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            // Address with Maps options
            if let address = shelter.placemark.title {
                Button(action: {
                    showMapOptions = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red)
                            .frame(height: 45)
                        Text(address)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .truncationMode(.tail)
                            .padding(.horizontal, 10)
                    }
                }
                .padding(.horizontal)
                .confirmationDialog("Open in ...", isPresented: $showMapOptions, titleVisibility: .visible) {
                    Button("Open in Apple Maps") {
                        if let shelterName = shelter.name {
                            let query = "\(shelterName), \(address)"
                            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            if let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    Button("Open in Google Maps") {
                        if let shelterName = shelter.name {
                            let query = "\(shelterName), \(address)"
                            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            if let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encoded)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            } else {
                Text("Address unavailable")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            // General contact info at the bottom
            Divider().padding(.horizontal)
            
            Text("For general purposes, call this number:")
                .font(.headline)
                .padding(.horizontal)
            
            if let phoneNumber = shelter.phoneNumber {
                Button(action: {
                    if let phoneURL = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
                        UIApplication.shared.open(phoneURL)
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red)
                            .frame(height: 45)
                        
                        Text("\(phoneNumber)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Shelter Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the default one
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Dismiss the current view
                    // Assuming you're inside a NavigationStack
                    // If you're using a NavigationLink to present this, use `dismiss()` from the environment
                    dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 36, height: 36)
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
        }
    }
}
