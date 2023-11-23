//
//  SwiftUIView.swift
//  PictureThis
//
//  Created by Sossio Murolo on 21/11/23.
//

import SwiftUI
import MapKit

struct keyFactsItem : Identifiable{
    
    var id: UUID = UUID()
    
    var leftText: String
    var rightText: String
}


class keyFactsItemViewModel {
    
    var keyFactsItems = [
        keyFactsItem(leftText: "Toxicity", rightText: "Not toxic to humans and pets"),
        keyFactsItem(leftText: "Weed or not", rightText: "Not reported as a weed"),
        keyFactsItem(leftText: "Invasiveness", rightText: "Not reported as invasive"),
        keyFactsItem(leftText: "Plant Type", rightText: "Shrub"),
        keyFactsItem(leftText: "Lifespan", rightText: "Perennial"),
        keyFactsItem(leftText: "Planting Time", rightText: "Mid spring, Late spring, Ealry summer, Fall, Early winter")
    ]
}

struct keyFactsView: View {
    
    var keyFactsviewModel = keyFactsItemViewModel()
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    
    var body: some View {
        List {
            ForEach(keyFactsviewModel.keyFactsItems.indices, id: \.self) { index in
                HStack {
                    Text(keyFactsviewModel.keyFactsItems[index].leftText)
                        .padding(10)
                        .accessibility(label: Text("Left Text: \(keyFactsviewModel.keyFactsItems[index].leftText)"))

                    
                    Spacer()
                    Text(keyFactsviewModel.keyFactsItems[index].rightText)
                        .fontWeight(.bold)
                        .padding(10)
                        .accessibility(label: Text("Right Text: \(keyFactsviewModel.keyFactsItems[index].rightText)"))

                }
                .listRowBackground(index % 2 == 0 ? Color(.systemGray6) : Color.white) // Cambia i colori a seconda dell'indice
            }
        }
        .frame(width: 350, height: 440)
        .listStyle(PlainListStyle())
    }
}


struct characteristicsItem : Identifiable{
    
    var id: UUID = UUID()
    
    var leftText: String
    var rightText: String
}


class characteristicsItemViewModel {
    
    var characteristicsItems = [
        characteristicsItem(leftText: "Plant Height", rightText: "30 to 61 cm"),
        characteristicsItem(leftText: "Spread", rightText: "61 to 91 cm"),
        characteristicsItem(leftText: "Leaf Color", rightText: "green and orange"),
    ]
}

struct characteristicsView: View {
    
    var characteristicsviewModel = characteristicsItemViewModel()
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    
    var body: some View {
        List {
            ForEach(characteristicsviewModel.characteristicsItems.indices, id: \.self) { index in
                HStack {
                    Text(characteristicsviewModel.characteristicsItems[index].leftText)
                        .padding(10)
                        .accessibility(label: Text("Left Text: \(characteristicsviewModel.characteristicsItems[index].leftText)"))

                    
                    Spacer()
                    Text(characteristicsviewModel.characteristicsItems[index].rightText)
                        .fontWeight(.bold)
                        .padding(10)
                        .accessibility(label: Text("Right Text: \(characteristicsviewModel.characteristicsItems[index].rightText)"))

                }
            }
        }
        .frame(width: 350, height: 200)
        .listStyle(PlainListStyle())
    }
}





struct DetailView: View {
    var capturedImage: UIImage?
    var plantName: String?
    var plantDescription: String?
    
    var onTakeNewPhoto: (() -> Void)?
    
    @State private var selectedTab: Int = 0
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                if let capturedImage = capturedImage {
                    
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .aspectRatio(0.9, contentMode: .fit)
                        .overlay {
                            HStack {
                                Rectangle()
                                    .fill(Color.gray)
                                    .overlay {
                                        Image(uiImage: capturedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .accessibility(label: Text("Captured Image of \(plantName ?? "")"))

                                    }
                                    .clipped()
                                VStack {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .overlay {
                                            Image("rose1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                        .clipped()
                                    Rectangle()
                                        .fill(Color.gray)
                                        .overlay {
                                            Image("rose2")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                        .clipped()
                                }
                            }
                            .padding()
                        }
                }
            
                
                if let plantName = plantName {
                    Text("\(plantName.capitalized), a species of Roses (Rosa)")
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                        .accessibility(label: Text("Plant Name: \(plantName.capitalized)"))

                }
                
                Divider()

                
                // Additional Plant Information
                
                Section(header: Text("Basic Info").font(.title2).bold()) {
                    
                    
                    HStack{
                        Image(systemName: "newspaper")
                        Text("Key facts")
                            .bold()
                        
                        Spacer()
                        
                        Menu {
                            Button {
                                // Azione per l'opzione 1
                            } label: {
                                Label("I Like This Content", systemImage: "heart")
                            }
                            
                            Button {
                                // Azione per l'opzione 2
                            } label: {
                                Label("Error in Content", systemImage: "exclamationmark.triangle")
                            }
                            
                            Button {
                                // Azione per l'opzione 3
                            } label: {
                                Label("Suggestions", systemImage: "square.and.pencil")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    keyFactsView()
                    
                    HStack{
                        Image(systemName: "leaf")
                        Text("Characteristics")
                            .bold()
                        
                        Spacer()
                        
                        Menu {
                            Button {
                                // Azione per l'opzione 1
                            } label: {
                                Label("I Like This Content", systemImage: "heart")
                            }
                            
                            Button {
                                // Azione per l'opzione 2
                            } label: {
                                Label("Error in Content", systemImage: "exclamationmark.triangle")
                            }
                            
                            Button {
                                // Azione per l'opzione 3
                            } label: {
                                Label("Suggestions", systemImage: "square.and.pencil")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    
                    VStack {
                        Picker(selection: $selectedTab, label: Text("")) {
                            Text("Mature Plant").tag(0)
                            
                            Text("Flower").tag(1)
                            
                            Text("Fruit").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        characteristicsView()
                    }
                    
                    
                    
                    HStack{
                        Image(systemName: "book")
                        
                        Text("Description")
                            .bold()
                        
                        Spacer()
                        
                        Menu {
                            Button {
                                // Azione per l'opzione 1
                            } label: {
                                Label("I Like This Content", systemImage: "heart")
                            }
                            
                            Button {
                                // Azione per l'opzione 2
                            } label: {
                                Label("Error in Content", systemImage: "exclamationmark.triangle")
                            }
                            
                            Button {
                                // Azione per l'opzione 3
                            } label: {
                                Label("Suggestions", systemImage: "square.and.pencil")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }
                
                if let plantDescription = plantDescription {
                    Text("The firs tea rose was created in 1867 by Jean-Baptiste Andrè Guillot, who operated his father's nursey in Lyon from the age of 14. The tea rose did not become popular until the Rosa hybrida was cultivated at the beginning of the 1900s in France.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                }
                
                
                HStack{
                    Image(systemName: "map")
                    
                    Text("Distribution")
                        .bold()
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            // Azione per l'opzione 1
                        } label: {
                            Label("I Like This Content", systemImage: "heart")
                        }
                        
                        Button {
                            // Azione per l'opzione 2
                        } label: {
                            Label("Error in Content", systemImage: "exclamationmark.triangle")
                        }
                        
                        Button {
                            // Azione per l'opzione 3
                        } label: {
                            Label("Suggestions", systemImage: "square.and.pencil")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                
                PlantDistributionMapView()
                
                
                // Button to take a new photo
                VStack{
                    Button(action: {
                        onTakeNewPhoto?()
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(15)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .accessibility(label: Text("Take a New Photo"))

                            
                            Text("New Photo")
                                .foregroundColor(.black)
                                .font(.body)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .accessibility(identifier: "newPhotoButton")

                }
                .padding()
            }
            .padding()
            .navigationBarTitle("Plant Details", displayMode: .inline)
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            capturedImage: UIImage(named: "plants"),
            plantName: "Sample Plant",
            plantDescription: "This is a sample plant description."
        )
    }
}




struct PlantDistributionMapView: View {
    @State private var annotations: [PlantAnnotation] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 180.0, longitudeDelta: 360.0)
    )
    @State private var selectedPlant: PlantAnnotation?
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: annotations) { annotation in
                    MapPin(coordinate: annotation.coordinate, tint: annotation.color)
                }
                .edgesIgnoringSafeArea(.all)
                .frame(height: 300)
                .onAppear {
                    // Center the map on the first annotation
                    if let firstAnnotation = annotations.first {
                        region.center = firstAnnotation.coordinate
                    }
                }
                
                ForEach(annotations) { annotation in
                    AnnotationView(annotation: annotation, onTap: {
                        // Handle tap on the annotation
                        self.selectedPlant = annotation
                    })
                }
                
                Spacer()
                
                if let selectedPlant = selectedPlant {
                    Text("Selected plant: \(selectedPlant.title ?? "")")
                        .foregroundColor(.black)
                        .padding()
                } else {
                    Text("Tap on a plant distribution to see details")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .background(Color(.systemGray6))
            .onAppear {
                // Center the map on the first annotation
                if let firstAnnotation = annotations.first {
                    region.center = firstAnnotation.coordinate
                }
            }
        }
        .onAppear {
            // Add sample plant distributions
            addPlantDistribution(name: "Plant A", latitude: 37.7749, longitude: -122.4194, color: .green)
            addPlantDistribution(name: "Plant B", latitude: 40.7128, longitude: -74.0060, color: .red)
            // Add more plant distributions as needed
        }
    }
    
    private func addPlantDistribution(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, color: Color) {
        let annotation = PlantAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: name, color: color)
        annotations.append(annotation)
    }
}

struct PlantAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let color: Color
}
struct AnnotationView: View {
    let annotation: PlantAnnotation
    let onTap: () -> Void
    
    @State private var coordinateSpace: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: onTap) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(annotation.color)
                    .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 30)
            .position(getPositionForCoordinate(annotation.coordinate, in: geometry.size))
        }
        .onAppear {
            // Save the coordinate space size
            coordinateSpace = .zero
        }
    }
    
    private func getPositionForCoordinate(_ coordinate: CLLocationCoordinate2D, in size: CGSize) -> CGPoint {
        let coordinatePoint = CGPoint(
            x: size.width * ((coordinate.longitude + 180) / 360),
            y: size.height * (1 - (coordinate.latitude + 90) / 180)
        )
        
        return coordinatePoint
    }
}
