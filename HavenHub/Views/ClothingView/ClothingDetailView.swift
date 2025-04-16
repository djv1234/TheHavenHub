//
//  ClothingDetailView.swift
//  HavenHub
//
//  Created by Khush Patel on 4/16/25.
//

import SwiftUI
import MapKit

struct ClothingDetailView: View {
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
        VStack {
            Text(shelter.name ?? "Unnamed Clothing Drive Resource")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Map with rounded corners
            Map(position: $cameraPosition) {
                Marker(shelter.name ?? "Unknown", coordinate: shelter.placemark.coordinate)
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
            
            // stack for details about clothing drive/donation
            VStack(alignment: .leading, spacing: 10) {
                
                // phone number
                if let phoneNumber = shelter.phoneNumber {
                    Button(action: {
                        if let phoneURL = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
                            UIApplication.shared.open(phoneURL)
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                                .frame(height: 50)

                            Text("Call \(phoneNumber)")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    Text("Phone number unavailable")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // website button
                if let url = shelter.url {
                    Button(action: {
                        UIApplication.shared.open(url)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                                .frame(height: 50)

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
                }
                
                // address with option to open in apple/google maps
                if let address = shelter.placemark.title {
                    Button(action: {
                        showMapOptions = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                                .frame(height: 50)
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
                            if let shelterName = shelter.name, let address = shelter.placemark.title {
                                let query = "\(shelterName), \(address)"
                                let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(encodedQuery)")!
                                UIApplication.shared.open(appleMapsURL)
                            }
                        }
                        Button("Open in Google Maps") {
                            if let shelterName = shelter.name, let address = shelter.placemark.title {
                                let query = "\(shelterName), \(address)"
                                let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                let googleMapsURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)")!
                                UIApplication.shared.open(googleMapsURL)
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                } else {
                    Text("Address unavailable")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .navigationTitle("Clothing Drive Resources Details")
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
