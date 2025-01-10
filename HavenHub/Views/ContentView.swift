//
//  ContentView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/7/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var offsetY: CGFloat = 540
    @State var showTitle: Bool = true
    var locations: [Location] = Bundle.main.decode("LocationData.json")
    @State private var isKeyboardVisible = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            GeometryReader { geometry in
                Map{
                    ForEach(locations.filter { $0.type == "Homeless Shelter" }, id: \.self) { location in
                        Marker(location.title, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                            .tint(Color.brown)
                    }
                    ForEach(locations.filter { $0.type == "Resource Center" }, id: \.self) { location in
                        Marker(location.title, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                            .tint(Color.green)
                    }
                    ForEach(locations.filter { $0.type == "Food Bank" || $0.type == "Food Pantry" }, id: \.self) { location in
                        Marker(location.title, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                            .tint(Color.blue)
                    }
                    ForEach(locations.filter { $0.type == "Community Center" }, id: \.self) { location in
                        Marker(location.title, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                            .tint(Color.yellow)
                    }
                    
                    UserAnnotation()
                }
                .mapControls {
                    MapCompass()
                        .mapControlVisibility(.hidden)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.495)
                .ignoresSafeArea(.keyboard)
                .safeAreaPadding(.bottom, 50)
                
                
                
            }
            HStack{
                Text("HavenHub")
                    .frame(width: 160, height: 50)
                    .font(.title)
                    .foregroundColor(.primary)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    ZStack{
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                        Image(systemName: "person.circle")
                            .resizable()
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .padding(.horizontal)
            .opacity(showTitle ? 1 : 0)
            
            BottomSheetView(offsetY: $offsetY, showTitle: $showTitle, isKeyboardVisible: $isKeyboardVisible)
        }
        .ignoresSafeArea(.keyboard)
        
    }
}

struct BottomSheetView: View {
    @Binding var offsetY: CGFloat // Initial position (halfway up)
    @State var lastDragPosition: CGFloat = 0 // Initial position at the top
    @Binding var showTitle: Bool
    @State private var searchText: String = ""
    @Binding var isKeyboardVisible: Bool
    
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
                        
                        Button(action: { }) {
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
                        
                        Button(action: { }) {
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
}
