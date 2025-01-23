//
//  MapMenuView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import SwiftUI
import MapKit

public struct MapMenuView: View {
    
    @Binding var mapItem: MKMapItem?
    @Binding var showingMenu: Bool
    @State var scene: MKLookAroundScene?
    
    public var body: some View {
        VStack{
            HStack{
                Text(mapItem?.name ?? "No Name")
                    .font(.headline)
            
                Spacer()
                
                Button {
                    withAnimation{
                        showingMenu = false
                    }
                } label: {
                    Text("Cancel")
                        .frame(width: 60, height: 30)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }

            }
        }
        .padding([.horizontal, .bottom])
    }
}
