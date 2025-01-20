//
//  SearchResultsView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import SwiftUI
import MapKit

struct SearchResultsView: View {
    @Binding var searchText: String
    @Binding var mapItems: [MKMapItem]
    @Binding var currentItem: MKMapItem?
    @Binding var keyboardHeight: CGFloat
    @FocusState.Binding var nameIsFocused: Bool
    @Binding var route: MKRoute?
    
    let distanceCalc = DistanceCalculator()
    let userLocation = UserLocation()
    
    var body: some View {
        GeometryReader { geometry in
            SearchResultsListView(
                searchText: searchText,
                sortedItems: mapItems.sortedBySearchText(searchText),
                currentItem: $currentItem,
                nameIsFocused: $nameIsFocused, route: $route,
                distanceCalc: distanceCalc,
                userLocation: userLocation
            )
            .frame(width: geometry.size.width, height: geometry.size.height - keyboardHeight - 60)
        }
    }
}

// MARK: - Search Results List
struct SearchResultsListView: View {
    let searchText: String
    let sortedItems: [MKMapItem]
    @Binding var currentItem: MKMapItem?
    @FocusState.Binding var nameIsFocused: Bool
    @Binding var route: MKRoute?
    
    let distanceCalc: DistanceCalculator
    let userLocation: UserLocation
    let routeBuild = Route()

    var body: some View {
        List {
            if searchText.isEmpty {
                EmptyStateView()
            } else {
                ForEach(sortedItems, id: \.self) { item in
                    
                    Button(action: {
                        currentItem = item
                        nameIsFocused = false

                        routeBuild.calculateRoute(from: userLocation.getUserLocation().center, to: item.placemark.coordinate) { route in
                            if let route = route {
                                print("Route distance: \(route.distance) meters")
                                self.route = route
                                // Use route.polyline to display on the map
                            } else {
                                print("Failed to get route")
                            }
                        }
                    }) {
                        SearchResultRow(
                            item: item,
                            distanceCalc: distanceCalc,
                            userLocation: userLocation
                        )
                    }

                }
            }
        }
        .listStyle(.inset)
    }
}

// MARK: - Single Search Result Row
struct SearchResultRow: View {
    let item: MKMapItem
    let distanceCalc: DistanceCalculator
    let userLocation: UserLocation
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name ?? "Unknown Place")
                .font(.headline)

            Text("\(distanceCalc.distanceInMiles(coordinate1: item.placemark.coordinate, coordinate2: userLocation.getUserLocation().center)) mi - " + getPostalAddress(from: item))
                .font(.subheadline)
        }
    }
    
    func getPostalAddress(from mapItem: MKMapItem) -> String {
        let placemark = mapItem.placemark
        
        // Use MKPlacemark properties to construct an address
        var addressComponents: [String] = []
        
        if let subThoroughfare = placemark.subThoroughfare { addressComponents.append(subThoroughfare) }
        if let thoroughfare = placemark.thoroughfare { addressComponents.append(thoroughfare) }
        if let locality = placemark.locality { addressComponents.append(locality) }
        if let administrativeArea = placemark.administrativeArea { addressComponents.append(administrativeArea) }

        return addressComponents.joined(separator: ", ")
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Type Your Favorite Spot!")
            Spacer()
        }
    }
}

// MARK: - Sorting Extension
extension Array where Element == MKMapItem {
    func sortedBySearchText(_ searchText: String) -> [MKMapItem] {
        let lowerSearchText = searchText.lowercased()
        return self.sorted { a, b in
            let aValue = a.name?.lowercased() ?? ""
            let bValue = b.name?.lowercased() ?? ""
            
            // Exact matches first
            if aValue == lowerSearchText { return true }
            if bValue == lowerSearchText { return false }
            
            // Starts with the search text
            let aStartsWith = aValue.hasPrefix(lowerSearchText)
            let bStartsWith = bValue.hasPrefix(lowerSearchText)
            if aStartsWith && !bStartsWith { return true }
            if !aStartsWith && bStartsWith { return false }
            
            // Contains the search text
            let aContains = aValue.contains(lowerSearchText)
            let bContains = bValue.contains(lowerSearchText)
            if aContains && !bContains { return true }
            if !aContains && bContains { return false }
            
            return false
        }
    }
}
