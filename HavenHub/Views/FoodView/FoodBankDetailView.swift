//
//  FoodBankDetailView.swift
//  HavenHub
//
//  Created by Khush Patel on 1/29/25.
//
import SwiftUI
import MapKit

struct FoodBankDetailView: View {
    let shelter: MKMapItem
    @State private var cameraPosition: MapCameraPosition
    @State private var showMapOptions = false
    
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
            Text(shelter.name ?? "Unnamed Food Bank")
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
            
            // stack for details about food bank
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
                                .fill(Color.blue)
                                .frame(height: 50)

                            Text("Call \(phoneNumber)")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
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
                                .fill(Color.blue)
                                .frame(height: 50)

                            Text(url.absoluteString)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .truncationMode(.tail)
                                .padding(.horizontal, 10)
                        }
                    }
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
                                .fill(Color.blue)
                                .frame(height: 50)

                            Text(address)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .truncationMode(.tail)
                                .padding(.horizontal, 10)
                        }
                    }
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
        .navigationTitle("Food Bank Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
