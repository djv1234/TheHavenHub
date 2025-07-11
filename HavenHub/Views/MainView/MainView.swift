//
//  MainView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI
import MapKit

struct MainView: View {
    @StateObject var viewManager: ViewManager
//    @StateObject var authViewModel: AuthViewModel
    
    @State var offsetY: CGFloat = 540
    @State var showTitle: Bool = true
    @State private var isKeyboardVisible = false
    @State private var showingMenu = false
    @State var cameraPosition: MapCameraPosition = .automatic
    @Binding var visibleRegion: MKCoordinateRegion?
    @State private var mapItems: [MapItemModel] = []
    @State private var currentItem: MapItemModel?
    @State var showEmergency: Bool = false
    @State var route: MKRoute?
    @State var searchTerms: [String] = ["Homeless Shelters"]
    @State var showFoodBank: Bool = false
    @State var showClothing: Bool = false
    @State var showShelter: Bool = false
    @State var showWork: Bool = false
    @State var showFavorites: Bool = false
    @State var showBottomSheet: Bool = true
    @State var shelters: [Resource] = []
    @State var selectedResult: MKMapItem?
    @State var isSheetPresented: Bool = false
    @Binding var selectedResource: Resource? // Added for navigation
    @Binding var isShowingDetail: Bool // Added for sheet control
    @ObservedObject var userLocation: UserLocation
    let routeCalc = RouteCalculator()
    let distanceCalc = DistanceCalculator()
    
    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .top) {
                MainMapView(cameraPosition: $cameraPosition,
                            route: $route,
                            currentItem: $currentItem,
                            showingMenu: $showingMenu,
                            visibleRegion: $visibleRegion,
                            shelters: $shelters,
                            selectedResult: $selectedResult,
                            selectedResource: $selectedResource,
                            isShowingDetail: .constant(false),
                            userLocation: userLocation,
                            distanceCalc: distanceCalc,
                            routeCalc: routeCalc
                )
                
                MapOverlayView(showTitle: $showTitle, route: $route, cameraPosition: $cameraPosition, locationSearch: userLocation, searchTerms: $searchTerms, showSheet: $isSheetPresented, routeCalc: routeCalc, userLocation: userLocation, viewManager: viewManager)
                    .shadow(radius: 5)
                
                if (showBottomSheet) {
                    BottomSheetView(
                        showWork: $showWork,
                        offsetY: $offsetY,
                        isKeyboardVisible: $isKeyboardVisible,
                        cameraPosition: $cameraPosition,
                        showEmergency: $showEmergency,
                        mapItems: $mapItems,
                        region: $visibleRegion,
                        currentItem: $currentItem,
                        showTitle: $showTitle,
                        showingMenu: $showingMenu,
                        route: $route,
                        shelters: $shelters,
                        showBottomSheet: $showBottomSheet,
                        showFoodBank: $showFoodBank,
                        showClothing: $showClothing,
                        showShelter: $showShelter,
                        showFavorites: $showFavorites,
                        
                        
                        userLocation: MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        ), searchTerms: $searchTerms, userLocationStruct: userLocation, distanceCalc: distanceCalc, routeCalc: routeCalc, viewManager: viewManager
                    )
                }
                
                if (showFoodBank){
                    FoodBankView(cameraPosition: $cameraPosition, visibleRegion: $visibleRegion, shelters: $shelters, showBottomSheet: $showBottomSheet, showFoodBank: $showFoodBank, showTitle: $showTitle, selectedResource: $selectedResource)
                }
                
                if (showClothing){
                    ClothingView(cameraPosition: $cameraPosition, visibleRegion: $visibleRegion, shelters: $shelters, showBottomSheet: $showBottomSheet, showClothing: $showClothing, showTitle: $showTitle, selectedResource: $selectedResource)
                }
                
                if (showShelter){
                    SheltersView(cameraPosition: $cameraPosition, visibleRegion: $visibleRegion, shelters: $shelters, showBottomSheet: $showBottomSheet, showShelter: $showShelter, showTitle: $showTitle, selectedResource: $selectedResource)
                }
                
                if (showWork){
                    WorkView(cameraPosition: $cameraPosition, visibleRegion: $visibleRegion, shelters: $shelters, showBottomSheet: $showBottomSheet, showWork: $showWork, showTitle: $showTitle, selectedResource: $selectedResource)
                }
        
                
     //           FavoritesView(showFavorites: $showFavorites)
     //               .opacity(showFavorites ? 1 : 0)
                
                EmergencyView(showEmergency: $showEmergency)
                    .opacity(showEmergency ? 1 : 0)
            }
            
            .ignoresSafeArea(.keyboard)
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isShowingDetail) {
                            if let resource = selectedResource {
                                switch resource.type {
                                case "Shelter":
                                    ShelterDetailView(resource: resource)
                                case "FoodBank":
                                    FoodBankDetailView(resource: resource)
                                case "Clothing":
                                    ClothingDetailView(resource: resource)
                                case "Work":
                                    WorkDetailView(resource: resource)
                                default:
                                    Text("Unknown resource type")
                                }
                            }
                        }
        }
    }
}
