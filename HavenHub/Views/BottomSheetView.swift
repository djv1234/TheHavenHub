//
//  BottomSheetView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/11/25.
//
import SwiftUI
import MapKit

struct BottomSheetView: View {
    @Binding var offsetY: CGFloat // Initial position (halfway up)
    @State var lastDragPosition: CGFloat = 0 // Initial position at the top
    @Binding var showTitle: Bool
    @State private var searchText: String = ""
    @Binding var isKeyboardVisible: Bool
    @Binding var cameraPosition: MapCameraPosition
    @Binding var showEmergency: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    // Handle bar
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    TextField("Search...", text: $searchText)
                        .padding(8)
                        .background(.textFeild)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                            offsetY = geometry.size.height * 0.08
                            isKeyboardVisible = true

                            // Add a slight delay before the animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    showTitle = false
                                }
                            }
                        }

                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                isKeyboardVisible = false
        
                        }
                    
                    
                    HStack {
                        Button(action: { }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green)
                                
                                VStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.main)
                                    Text("Favorites")
                                        .foregroundColor(.main)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        
                        Button(action: {
                            withAnimation() {
                                showEmergency = true
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red)
                                
                                VStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.main)
                                    Text("Emergency")
                                        .foregroundStyle(.main)
                                        .fontWeight(.bold)
                                }
                                
                            }
                        }
                        
                        Button(action: {
                            goToUserLocation()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                VStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.main)
                                    Text("Location")
                                        .foregroundStyle(.main)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height + 100)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: 10)
                )
                .offset(y: min(max(offsetY, geometry.size.height * 0.08), geometry.size.height * (4/7))) // Clamp offset between top and screenHeight * 0.666666
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newOffset = lastDragPosition + value.translation.height
                            // Allow dragging only if within the limit
                            if newOffset >= geometry.size.height * 0.08 && newOffset <= geometry.size.height * (4/7) && isKeyboardVisible == false{
                                offsetY = newOffset
                            }
                        }
                        .onEnded { value in
                            let screenHeight = geometry.size.height
                            let middlePoint = screenHeight * 0.4
                            
                            // Snap to closest position
                            if offsetY < middlePoint {
                                offsetY = screenHeight * 0.08 // Snap to top
                                withAnimation {
                                    showTitle = false
                                }
                            } else {
                                offsetY = screenHeight * (4/7) // Snap to bottom
                                withAnimation {
                                    showTitle = true
                                }
                            }
                            lastDragPosition = offsetY
                        }
                )
                .animation(.easeInOut, value: offsetY)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                offsetY = geometry.size.height * (4/7)
            }
        }
    }
    func goToUserLocation() {
        if let currentLocation = CLLocationManager().location {
            let coordinate = currentLocation.coordinate
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.00, longitudeDelta: 0.01)
                )
            )
        } else {
            print("User location not available")
        }
    }
}
