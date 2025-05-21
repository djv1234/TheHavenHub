//
//  ClothingDetailView.swift
//  HavenHub
//
//  Created by Khush Patel on 4/16/25.
//

import SwiftUI
import MapKit

struct ClothingDetailView: View {
    let resource: Resource
    @State private var cameraPosition: MapCameraPosition
    @State private var showMapOptions = false
    @Environment(\.dismiss) private var dismiss
    
    init(resource: Resource) {
        self.resource = resource
        let coordinate = resource.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }

    var body: some View {
        VStack {
            Text(resource.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()

            if let coordinate = resource.coordinate {
                Map(position: $cameraPosition) {
                    Marker(resource.name, coordinate: coordinate)
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            } else {
                Text("Map not available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                if let services = resource.services, !services.isEmpty {
                    Text("Services: \(services)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                } else {
                    Text("Services unavailable")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let hours = resource.hours, !hours.isEmpty {
                    Text("Hours: \(hours)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                } else {
                    Text("Hours unavailable")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let phone = resource.phone {
                    Button(action: {
                        if let phoneURL = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
                            UIApplication.shared.open(phoneURL)
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                                .frame(height: 50)
                            Text("Call \(phone)")
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
                
                if let url = resource.url {
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
                
                if resource.coordinate != nil || resource.address != nil {
                    Button(action: {
                        showMapOptions = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                                .frame(height: 50)
                            Text(resource.address ?? resource.name)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .truncationMode(.tail)
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding(.horizontal)
                    .confirmationDialog("Open in ...", isPresented: $showMapOptions, titleVisibility: .visible) {
                        if let coordinate = resource.coordinate {
                            Button("Open in Apple Maps") {
                                let url = URL(string: "http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)")!
                                UIApplication.shared.open(url)
                            }
                            Button("Open in Google Maps") {
                                let url = URL(string: "https://www.google.com/maps/@?api=1&map_action=map&center=\(coordinate.latitude),\(coordinate.longitude)&zoom=15")!
                                UIApplication.shared.open(url)
                            }
                        } else if let address = resource.address {
                            Button("Search in Apple Maps") {
                                let query = "\(resource.name), \(address)"
                                let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                let url = URL(string: "http://maps.apple.com/?q=\(encodedQuery)")!
                                UIApplication.shared.open(url)
                            }
                            Button("Search in Google Maps") {
                                let query = "\(resource.name), \(address)"
                                let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)")!
                                UIApplication.shared.open(url)
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
        .navigationTitle("Affordable Clothing Resource Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
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
