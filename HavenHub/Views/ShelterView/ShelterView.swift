//
//  ShelterView.swift
//  HavenHub
//
//  Created by Khush Patel on 4/20/25.
//

import SwiftUI
import MapKit

struct SheltersView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var shelters: [Resource]
    @Binding var showBottomSheet: Bool
    @Binding var showShelter: Bool
    @Binding var showTitle: Bool
    @State private var isKeyboardVisible: Bool = false
    @State var offsetY: CGFloat = 540
    @State var lastDragPosition: CGFloat = 0
    @Binding var selectedResource: Resource?
    @Binding var isShowingDetail: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer() // Push the list to the bottom
                
                VStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Capsule()
                            .frame(width: 40, height: 6)
                            .foregroundColor(.gray)
                            .padding(.top, 10)

                        Text("Shelters & housing resources")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 6)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.sub)
                            .shadow(radius: 10)
                    )
                    
                    // List without Section Header
                    List {
                        ForEach(shelters) { resource in
                            Button(action: {
                                withAnimation {
                                    selectedResource = resource
                                }
                            }) {
                                VStack(alignment: .leading) {
                                    Text(resource.name)
                                        .font(.headline)
                                    Text(resource.address ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: geometry.size.height * 0.4)
                    
                    Button(action: {
                        withAnimation {
                            shelters.removeAll()
                            showShelter = false
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
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: 10)
                )
            }
        }
    }
}
