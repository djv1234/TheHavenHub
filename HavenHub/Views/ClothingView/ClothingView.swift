//
//  ClothingView.swift
//  HavenHub
//
//  Created by Khush Patel on 4/16/25.
//

import SwiftUI
import MapKit
import UIKit

struct ClothingView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var shelters: [Resource]
    @Binding var showBottomSheet: Bool
    @Binding var showClothing: Bool
    @Binding var showTitle: Bool
    @State private var isKeyboardVisible: Bool = false
    @State private var visibleHeight: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var initialDragHeight: CGFloat? = nil // For throttling updates
    @Binding var selectedResource: Resource?
    
    // Precompute constants
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    private let minHeight: CGFloat = UIScreen.main.bounds.height * 0.55
    private let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.9
    
    var body: some View {
        GeometryReader { geometry in
            // Use precomputed constants for consistency
            let localScreenHeight = geometry.size.height
            let localMinHeight = localScreenHeight * 0.55
            let localMaxHeight = localScreenHeight * 0.9
            
            ZStack(alignment: .bottom) {
                // Main content (header and list)
                VStack(spacing: 0) {
                    // Capsule + Custom Header (draggable area)
                    VStack(spacing: 4) {
                        Capsule()
                            .frame(width: 40, height: 6)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        
                        Text("Free & affordable clothing")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 6)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.sub)
                            .shadow(radius: isDragging ? 0 : 3) // Disable shadow during drag
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if initialDragHeight == nil {
                                    initialDragHeight = visibleHeight
                                    isDragging = true
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.prepare()
                                    impact.impactOccurred()
                                }
                                let proposedHeight = initialDragHeight! - gesture.translation.height
                                visibleHeight = max(localMinHeight, min(localMaxHeight, proposedHeight))
                            }
                            .onEnded { _ in
                                isDragging = false
                                let delta = visibleHeight - localMinHeight
                                let totalDelta = localMaxHeight - localMinHeight
                                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.5)) {
                                    if delta < totalDelta / 2 {
                                        visibleHeight = localMinHeight
                                    } else {
                                        visibleHeight = localMaxHeight
                                    }
                                }
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.prepare()
                                impact.impactOccurred()
                                initialDragHeight = nil
                            }
                    )
                    
                    // Scrollable List
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
                                .padding(9)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.bottom, 100) // Space for the dismiss button
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: isDragging ? 0 : 3) // Disable shadow during drag
                )
                .frame(width: geometry.size.width, height: visibleHeight)
                
                // Dismiss Button 
                Button(action: {
                    withAnimation {
                        shelters.removeAll()
                        showClothing = false
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
            .frame(width: geometry.size.width, height: visibleHeight)
            .offset(y: localScreenHeight - visibleHeight)
            .onAppear {
                visibleHeight = localMinHeight
            }
        }
    }
}
