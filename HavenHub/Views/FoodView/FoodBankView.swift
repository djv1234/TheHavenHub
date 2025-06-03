import SwiftUI
import MapKit

struct FoodBankView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var shelters: [Resource]
    @Binding var showBottomSheet: Bool
    @Binding var showFoodBank: Bool
    @Binding var showTitle: Bool
    @State private var isKeyboardVisible: Bool = false
    @State var offsetY: CGFloat = 540
    @State var lastDragPosition: CGFloat = 0
    @Binding var selectedResource: Resource?
    @Binding var isShowingDetail: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer() // Push the list to the bottom
                
                VStack(spacing: 0) {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .padding(.bottom, 4)
                    
                    List {
                        Section(header: Text("Hot meals & food pantries")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, -10)) {
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
                                    .padding()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: geometry.size.height * 0.4)
                    
                    Button(action: {
                        withAnimation {
                            shelters.removeAll()
                            showFoodBank = false
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
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: 10)
                )
            }
        }
    }
}
