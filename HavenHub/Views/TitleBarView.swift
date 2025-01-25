//
//  TitleBarView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/23/25.
//

import SwiftUI
import MapKit

struct TitleBarView: View {
    @Binding var showTitle: Bool
    @Binding var route: MKRoute?
    @Binding var cameraPosition: MapCameraPosition
    let locationSearch: UserLocation
    
    var body: some View {
        HStack {
            Text("HavenHub")
                .frame(width: 160, height: 40)
                .font(.title)
                .foregroundColor(.primary)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                .fontWeight(.bold)

            Spacer()

            LocationButton(route: $route, cameraPosition: $cameraPosition, locationSearch: locationSearch)

            ProfileButton()
        }
        .padding(.horizontal)
        .opacity(showTitle ? 1 : 0)
    }
}
