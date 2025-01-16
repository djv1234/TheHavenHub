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
    @State private var isKeyboardVisible = false
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State var visibleRegion: MKCoordinateRegion?
    @State var selectedResult: MKMapItem?
    @State private var mapItems: [MKMapItem] = []
    @State var showEmergency: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            GeometryReader { geometry in
                
                Map(position: $cameraPosition, selection: $selectedResult){
                    
                    ForEach(mapItems, id: \.self) {location in
                        Marker(location.name!, coordinate: location.placemark.coordinate)
                            .tint(Color.blue)
                    }
                    
                    UserAnnotation()
                }
                .onMapCameraChange { context in
                    visibleRegion = context.region
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
            
            BottomSheetView(offsetY: $offsetY, showTitle: $showTitle, isKeyboardVisible: $isKeyboardVisible, cameraPosition: $cameraPosition, showEmergency: $showEmergency, mapItems: $mapItems, region: $visibleRegion, userLocation: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
            
            
            EmergencyView(showEmergency: $showEmergency)
                .opacity(showEmergency ? 1 : 0)
            
        }
        .ignoresSafeArea(.keyboard)
    }

    
}
