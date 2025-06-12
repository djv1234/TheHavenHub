//
//  HealthModelView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 2/2/25.
//

import SwiftUI
import MapKit
import CoreLocation

enum Destination {
    case healthResources
}

struct HealthModelView: View {
    @StateObject var viewManager: ViewManager
    @Binding var showBottomSheet: Bool
    @Binding var showResources: Bool
    @Binding var resources: [MKMapItem]
    @State var healthModel: HealthModel
    @State private var cameraPosition: MapCameraPosition = .automatic
    @ObservedObject var userLocation: UserLocation
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            viewManager.navigateToHealth()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 36, height: 36)
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                    Spacer()
                }
                
                ScrollView {
                    Text(healthModel.info.title)
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Image(healthModel.image) // Load image from Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                    
                    if healthModel.info.title == "MyProgress" {
                        VStack(alignment: .center, spacing: 16) {
                            Text("Track Your Progress")
                                .font(.title)
                                .bold()

                            Text("Set measurable goals and monitor your journey toward thriving.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            NavigationLink(destination: GoalView()) {
                                Text("Open Goal Tracker")
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                    }
                    
                    if healthModel.type == "Mental Health" || healthModel.type == "Physical Health" || healthModel.info.title == "Mindfulness" || healthModel.info.title == "Hygiene"{
                            Text(healthModel.info.overview)
                                .padding()
                                .font(.headline)
                                .padding(.bottom, 10)
                        
                         if healthModel.info.title == "Nutrition" {
                             Text("Lets take care of your hunger in an affordable way - check out our food bank section!")
                                 .padding()
                                 .padding(.bottom, 10)
                             
                             //Button with navigation for food banks
                             Button(action: {
                                 withAnimation {
                                     if let visibleRegion = userLocation.currentRegion {
                                         let queryWords = ["food bank", "food pantry", "food donation", "soup kitchen"]
                                         performSearch(in: visibleRegion, queryWords: queryWords) { success in
                                             if success {
                                                 // After search completes successfully, navigate to HealthResourcesView
                                                 withAnimation {
                                                     viewManager.navigateToHealthResources(healthModel: healthModel)
                                                 }
                                             } else {
                                                 print("Search failed or returned no results.")
                                             }
                                         }
                                     } else {
                                         print("Visible region is not set. Using default region.")
                                         let defaultRegion = MKCoordinateRegion(
                                             center: CLLocationCoordinate2D(latitude: 40.0061, longitude: -83.0283),
                                             span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                         )
                                         let queryWords = ["food bank", "food pantry", "food donation", "soup kitchen"]
                                         performSearch(in: defaultRegion, queryWords: queryWords) { success in
                                             if success {
                                                 withAnimation {
                                                     viewManager.navigateToHealthResources(healthModel: healthModel)
                                                 }
                                             } else {
                                                 print("Search with default region failed.")
                                             }
                                         }
                                     }
                                 }
                             }) {
                                 ZStack {
                                     RoundedRectangle(cornerRadius: 20)
                                         .fill(LinearGradient(
                                             colors: [.pink, Color.accentColor],
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing
                                         ))
                                         .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                     
                                     VStack(spacing: 8) {
                                         Image(systemName: "fork.knife")
                                             .font(.system(size: 40))
                                             .foregroundColor(.white)
                                             .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                         
                                         Text("See food banks in your area!")
                                             .foregroundColor(.white)
                                             .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                     }
                                     .padding(8)
                                 }
                                 .padding()
                             }
                         }
                        
                        if healthModel.info.title == "Exercise"{
                            VStack(alignment: .leading, spacing: 8) {
                                Text("• Walking is one of the easiest and most accessible ways to exercise, requiring no equipment.")
                                Text("• Bodyweight exercises like squats, push-ups, or lunges can be done anywhere, such as a park or open space, to build strength and stamina.")
                                Text("• Stretching or simple yoga poses, like reaching for the sky or touching your toes, can improve flexibility and relieve tension, needing only a few minutes and a quiet spot.")
                                Text("• Some public parks may have basic fitness equipment like a pull up bar or resistance machines that can help one improve their fitness level.")
                            }
                            .padding()
                        }
                        
                        if healthModel.info.title == "First Aid"{
                            Button(action: {
                                withAnimation {
                                    if let visibleRegion = userLocation.currentRegion {
                                        let queryWords = ["pharmacy", "clinic", "hospital", "medicine", "urgent care", "emergency room"]
                                        performSearch(in: visibleRegion, queryWords: queryWords) { success in
                                            if success {
                                                // After search completes successfully, navigate to HealthResourcesView
                                                withAnimation {
                                                    viewManager.navigateToHealthResources(healthModel: healthModel)
                                                }
                                            } else {
                                                print("Search failed or returned no results.")
                                            }
                                        }
                                    } else {
                                        print("Visible region is not set. Using default region.")
                                        let defaultRegion = MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(latitude: 40.0061, longitude: -83.0283),
                                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                        )
                                        let queryWords = ["pharmacy", "clinic", "hospital", "first aid", "medicine"]
                                        performSearch(in: defaultRegion, queryWords: queryWords) { success in
                                            if success {
                                                withAnimation {
                                                    viewManager.navigateToHealthResources(healthModel: healthModel)
                                                }
                                            } else {
                                                print("Search with default region failed.")
                                            }
                                        }
                                    }
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(LinearGradient(
                                            colors: [.pink, Color.accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "cross.case.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        
                                        Text("See first aid resources in your area!")
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    }
                                    .padding(8)
                                }
                                .padding()
                            }
                        }
                        
                        if healthModel.info.title == "Mindfulness"{
                            VStack(alignment: .leading, spacing: 8) {
                                Text("• Deep Breathing: Take slow, deep breaths, inhaling through your nose for 4 seconds, holding for 4, then exhaling through your mouth for 4, to calm your mind.")
                                Text("• Body Scan: Focus on one part of your body at a time, noticing any tension or sensations, moving from your toes to your head to feel more connected.")
                                Text("• Grounding with Senses: Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste to anchor yourself in the moment.")
                                Text("• Mindful Observation: Pick an object nearby, like a leaf or stone, and study its details—color, texture, shape—for a minute to focus your attention.")
                                Text("• Gratitude Pause: Think of one or two things you’re thankful for, even small ones like a warm day or a kind word, to shift your mindset.")
                            }
                            .padding()
                        }
                        
                        if healthModel.info.title == "Hygiene"{
                            Text("Check out nearby places to better your hygiene: ")
                            Button(action: {
                                withAnimation {
                                    // Perform search based on healthModel.info.title
                                    if let visibleRegion = userLocation.currentRegion {
                                        let queryWords = ["Hygiene", "public bathroom",  "homeless shelter", "community center"]
                                        performSearch(in: visibleRegion, queryWords: queryWords) { success in
                                            if success {
                                                // After search completes successfully, navigate to HealthResourcesView
                                                withAnimation {
                                                    viewManager.navigateToHealthResources(healthModel: healthModel)
                                                }
                                            } else {
                                                print("Search failed or returned no results.")
                                            }
                                        }
                                    } else {
                                        print("Visible region is not set. Using default region.")
                                        let defaultRegion = MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(latitude: 40.0061, longitude: -83.0283),
                                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                        )
                                        let queryWords = ["Hygiene", "public bathroom",  "homeless shelter", "community center", "Porta potty"]
                                        performSearch(in: defaultRegion, queryWords: queryWords) { success in
                                            if success {
                                                withAnimation {
                                                    viewManager.navigateToHealthResources(healthModel: healthModel)
                                                }
                                            } else {
                                                print("Search with default region failed.")
                                            }
                                        }
                                    }
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(LinearGradient(
                                            colors: [.pink, Color.accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "bathtub")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        
                                        Text("Let's get clean!")
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    }
                                    .padding(8)
                                }
                                .padding()
                            }
                        }
                            
                            
                        if healthModel.type == "Mental Health"{
                            Text("Symptoms of " + healthModel.info.title)
                                .font(.headline)
                                .padding(10)
                            
                            if healthModel.type == "Mental Health", let symptoms = healthModel.info.symptoms, !symptoms.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    ForEach(symptoms, id: \.self) { symptom in
                                        Text(symptom)
                                            .padding(.leading, 10)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Text("Resources for managing " + healthModel.info.title)
                                .font(.headline)
                                .padding(10)
                            
                            Text("Let us help you get better - all one click away!")
                                .padding()
                            
                            Button(action: {
                                withAnimation {
                                    // Perform search based on healthModel.info.title
                                    if let visibleRegion = userLocation.currentRegion {
                                        let queryWords = ["\(healthModel.info.title) resource", "counseling for \(healthModel.info.title)", "counseling", "mental health therapy", "mental health support",  "\(healthModel.info.title) health service"]
                                        performSearch(in: visibleRegion, queryWords: queryWords) { success in
                                            if success {
                                                // After search completes successfully, navigate to HealthResourcesView
                                                withAnimation {
                                                    viewManager.navigateToHealthResources(healthModel: healthModel)
                                                }
                                            } else {
                                                print("Search failed or returned no results.")
                                            }
                                        }
                                    } else {
                                        print("Visible region is not set. Using default region.")
                                        let defaultRegion = MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(latitude: 40.0061, longitude: -83.0283),
                                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                        )
                                        let queryWords = ["\(healthModel.info.title) resource", "counseling for \(healthModel.info.title)", "counseling", "mental health therapy", "mental health support",  "\(healthModel.info.title) health service"]
                                        performSearch(in: defaultRegion, queryWords: queryWords) { success in
                                            if success {
                                                withAnimation {
                                                    viewManager.navigateToHealthResources(healthModel: healthModel)
                                                }
                                            } else {
                                                print("Search with default region failed.")
                                            }
                                        }
                                    }
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(LinearGradient(
                                            colors: [.pink, Color.accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "person.line.dotted.person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        
                                        Text("Resources")
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    }
                                    .padding(8)
                                }
                                .padding()
                            }
                        }
                    }
                }
//              .onAppear {
//                    
//                    visibleRegion = MKCoordinateRegion(
//                       center: CLLocationCoordinate2D(latitude: 40.0061, longitude: -83.0283), // Columbus Ohio
//                      span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)                   )
//               }
            }
        }
    }
    
    func findLocations(region: MKCoordinateRegion, searchReq: String, completion: @escaping ([MKMapItem]?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchReq
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let error = error {
                print("Error during search: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let response = response else {
                print("No response received.")
                completion(nil)
                return
            }
            
            completion(response.mapItems)
        }
    }
    
    func performSearch(in region: MKCoordinateRegion, queryWords: [String], completion: @escaping (Bool) -> Void) {
        resources.removeAll()
        var foundItems = false
        
        let dispatchGroup = DispatchGroup()
        
        for keyword in queryWords {
            dispatchGroup.enter()
            findLocations(region: region, searchReq: keyword) { mapItems in
                defer { dispatchGroup.leave() }
                if let mapItems = mapItems, !mapItems.isEmpty {
                    resources.append(contentsOf: mapItems)
                    foundItems = true
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(foundItems)
        }
    }
}
