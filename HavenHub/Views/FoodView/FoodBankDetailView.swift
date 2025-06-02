//
//  FoodBankDetailView.swift
//  HavenHub
//
//  Created by Khush Patel on 1/29/25.
//

import SwiftUI
import MapKit

struct FoodBankDetailView: View {
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
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack {
                    Capsule()
                        .frame(width: 38, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)
                    Text("Swipe down to close")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 3)
                    Text(resource.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if let coordinate = resource.coordinate {
                        Map(position: $cameraPosition) {
                            Marker(resource.name, coordinate: coordinate)
                        }
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                    } else {
                        Text("Please contact the resource to get address and other information!")
                            .frame(height: 50)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if let services = resource.services, !services.isEmpty {
                            Text("Services: \(services)")
                                .font(.headline)
                                .padding()
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                        }
                        
                        if let hours = resource.hours, !hours.isEmpty {
                            Text("Hours: \(hours)")
                                .font(.headline)
                                .lineLimit(nil)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
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
                                    HStack(spacing: 8) {
                                        Image(systemName: "phone.fill")
                                        Text("Call \(phone)")
                                            .fontWeight(.bold)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        if let url = resource.url {
                            Button(action: {
                                UIApplication.shared.open(url)
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.red)
                                        .frame(height: 50)
                                    HStack(spacing: 8) {
                                        Image(systemName: "safari.fill")
                                        Text("Visit \(url.absoluteString)")
                                            .fontWeight(.bold)
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        if let address = resource.address, !address.isEmpty {
                            Button(action: {
                                showMapOptions = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.accentColor)
                                        .frame(height: 50)
                                    HStack(spacing: 8) {
                                        Image(systemName: "globe.americas.fill")
                                        Text("Navigate to \(address)")
                                            .fontWeight(.bold)
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                }
                            }
                            .padding(.horizontal)
                            .confirmationDialog("Open in ...", isPresented: $showMapOptions, titleVisibility: .visible) {
                                Button("Open in Apple Maps") {
                                    let query = "\(resource.name), \(address)"
                                    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                    let url = URL(string: "http://maps.apple.com/?q=\(encodedQuery)")!
                                    UIApplication.shared.open(url)
                                }
                                Button("Open in Google Maps") {
                                    let query = "\(resource.name), \(address)"
                                    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                    let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)")!
                                    UIApplication.shared.open(url)
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                        } 
                    }
                    Spacer()
                }
            }
            Button(action: {
                                dismiss()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.8))
                                        .frame(width: 24, height: 24)
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                }
                            }
                            .padding(.trailing, 16)
                            .padding(.top, 16)
                            .accessibilityLabel("Close details")
//        .navigationTitle("Free Meal Resource Details")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    dismiss()
//                }) {
//                    ZStack {
//                        Circle()
//                            .fill(Color.red)
//                            .frame(width: 36, height: 36)
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.white)
//                            .font(.system(size: 16, weight: .bold))
//                    }
//                }
//            }
 //       }
    }
    }
}
