//
//  HealthResourcesView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 3/3/25.
//

import SwiftUI
import MapKit

struct HealthResourcesView: View {
    var healthModel: HealthModel
    @Binding var cameraPosition: MapCameraPosition
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var resources: [MKMapItem]
    @Binding var showBottomSheet: Bool
    @Binding var showResources: Bool
    @Binding var showTitle: Bool
    @State private var isKeyboardVisible: Bool = false
    @State var offsetY: CGFloat = 0
    @State var lastDragPosition: CGFloat = 0
    @ObservedObject var viewManager: ViewManager

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Back button to navigate to HealthModelView
                HStack {
                    Button(action: {
                        withAnimation {
                            viewManager.navigateToHealthModel(healthModel: healthModel)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.accentColor)
                            Text("Back")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                    Spacer()
                }
                
                Text(healthModel.info.title + " Resources")
                    .font(.title)
                    .padding()

                // Map view at the top
                Map(position: $cameraPosition) {
                    ForEach(resources, id: \.self) { resource in
                        Annotation(resource.name ?? "Unknown", coordinate: resource.placemark.coordinate) {
                            Button(action: {
                                withAnimation {
                                    viewManager.navigateToHealthDetail(mapItem: resource, healthModel: healthModel)
                                }
                            }) {
                                Image(systemName: "mappin")
                                    .padding(6)
                                    .background(Color.accentColor.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.50) // 50% of screen for map
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()

                // Bottom sheet with drag gesture
                                VStack(spacing: 0) {
                                    Capsule()
                                        .frame(width: 40, height: 6)
                                        .foregroundColor(.gray)
                                        .padding(10)
                                    
                                    List(resources, id: \.self) { resource in
                                        Button {
                                            withAnimation {
                                                viewManager.navigateToHealthDetail(mapItem: resource, healthModel: healthModel)
                                            }
                                        } label: {
                                            VStack(alignment: .leading) {
                                                Text(resource.name ?? "Unnamed Resource")
                                                    .font(.headline)
                                                Text(resource.placemark.title ?? "Address unavailable")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            .padding()
                                        }
                                    }
                                    .listStyle(PlainListStyle())
                                    
                                }
                                .frame(height: geometry.size.height) // Allows sheet to go over the map
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.background)
                                        .shadow(radius: 10)
                                )
                                .offset(y: offsetY)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            // Calculate new offset based on drag
                                            let newOffset = lastDragPosition + value.translation.height
                                            // Restrict offset to prevent dragging too far up or down
                                            let maxOffsetUp: CGFloat = -geometry.size.height * 0.55 // allow sheet to go over map
                                            let maxOffsetDown: CGFloat = 0 // Minimized (45% of screen)
                                            offsetY = min(max(newOffset, maxOffsetUp), maxOffsetDown)
                                        }
                                        .onEnded { value in
                                            // Update last drag position to the final offset
                                            lastDragPosition = offsetY
                                        }
                                )
                                .animation(.interactiveSpring(), value: offsetY)
            }
        }
    }
}


