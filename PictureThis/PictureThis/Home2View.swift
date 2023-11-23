import SwiftUI
import Foundation


//LOCATION PICKER
struct LocationPickerView: View {
    @Binding var selectedLocation: String
    @Binding var isPickerPresented: Bool
    
    let locations = ["Current Location", "Location 1", "Location 2"]
    
    var body: some View {
        VStack {
            Picker("Select Location", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .padding()
            
            Button(action: {
                isPickerPresented = false
            }) {
                Text("Confirm")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .accessibility(label: Text("Confirm selection"))

        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
}


//SEARCHBAR
struct SearchBar: View {
    @State private var searchText = ""
    
    var body: some View {
        
        VStack {
            TextField("", text: $searchText)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color.white)
                )
                .overlay(
                    HStack(alignment: .center) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        Text("Search plants")
                            .foregroundColor(.gray)
                    }
                )
                .padding(.horizontal, 8)
                .textFieldStyle(PlainTextFieldStyle()) // Nasconde il cursore
                .padding(10)
                .accessibility(label: Text("Search for plants"))
        }
        .padding(.top)
    }
}

//QUATTRO PULSANTI SOTTO LA SEARCHBAR
struct SquareView: View {
    var imageName: String
    var text: String
    var colorName: Color = .white
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(colorName)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                )
                //.accessibility(label: Text(text))

            Text(text)
                .foregroundColor(.black)
                .font(.custom("San Francisco", size: 15))
        }
        .frame(width: 85)
    }
}




//IL PRIMO SCROLL ORIZZONTALE CON LE SCHEDE
struct Item : Identifiable{
    
    var id: UUID = UUID()
    
    var imageName: String
    var description: String
    var tagText: String?
}



class ItemViewModel {
    
    var items = [
        Item(imageName: "rose", description: "China rose", tagText: "🔥 Superhot"),
        Item(imageName: "plants", description: "Northern red oak", tagText: "Hot"),
        Item(imageName: "flower", description: "Japanese maple", tagText: "Hot"),
        Item(imageName: "pot", description: "Chinese Hibiscus"),
        Item(imageName: "weeds", description: "Sweetgum")
        
    ]
}

struct OrizzontaleScrollableView: View {
    var text: String
    var viewModel = ItemViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(text)
                    .bold()
                    .padding()
                    .font(.title2)
                    .accessibility(addTraits: .isHeader)
                
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
            .accessibilityElement(children: .ignore)
            //.accessibility(label: Text("Trending in Italy"))
            .accessibility(addTraits: .isHeader)
            
            
            ScrollView(.horizontal) {
                HStack(spacing: -20) {
                    ForEach(viewModel.items) { item in
                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 135, height: 135)
                                .overlay(
                                    Image(item.imageName)
                                        .resizable()
                                        .cornerRadius(20)
                                )
                                .clipped()
                                .accessibility(label: Text(item.description))

                            
                            Text(item.description)
                                .padding(.top, 5)
                        }
                        .overlay(
                            
                            HStack {
                                item.tagText.map { tagText in //serve per la scelta opzionale del tag (hot o superhot)
                                    Text(tagText)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(Color(.systemRed)))
                                }
                            }
                                .padding(8)
                                .frame(width: 135, height: 135, alignment: .topLeading),
                            alignment: .topLeading
                        )
                        .padding()
                    }
                    NavigationLink(destination: AnotherPage()) {
                        VStack {
                            Image(systemName: "arrow.right.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(.systemGreen))
                            Text("View All")
                                .foregroundColor(Color(.systemGreen))
                        }
                        .padding()
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Trending items"))
    }
}





//SECONDO SCROLL ORIZZONTALE CON SCHEDE E SCRITTA SOPRA
struct Item2 : Identifiable{
    
    var id: UUID = UUID()
    
    var imageName: String
    var category: String
}


class Item2ViewModel {
    
    var items2 = [
        Item2(imageName: "rose", category: "Native Plants"),
        Item2(imageName: "plants", category: "Toxic Plants"),
        Item2(imageName: "flower", category: "Flowers"),
        Item2(imageName: "pot", category: "House Plants"),
        Item2(imageName: "weeds", category: "Weeds"),
    ]
}



struct OrizzontaleScrollable2View: View {
    
    var text: String
    var viewModel2 = Item2ViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(text)
                    .bold()
                    .padding()
                    .font(.title2)
                    .accessibility(addTraits: .isHeader)
                
                
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
            .accessibilityElement(children: .ignore)
            .accessibility(addTraits: .isHeader)
            
            ScrollView(.horizontal) {
                
                LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())], spacing: 1)  {
                    
                    ForEach(viewModel2.items2) { item2 in
                        
                        ZStack{
                            Image(item2.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .frame(width: 180, height: 125)
                                .accessibility(label: Text(item2.category))
                            
                            
                            LinearGradient(colors: [.clear, .black.opacity(0.7)],
                                           startPoint: .top,
                                           endPoint: .bottom)
                            Text(item2.category)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 180, height: 125)
                        .padding(.leading)
                        .padding(.bottom)
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Explore items in Italy"))
    }
}




//TERZO ELEMENTO SENZA SCROLL SOLO SCHEDE
struct Item3 : Identifiable{
    
    var id: UUID = UUID()
    
    var imageName: String
    var title: String
    var description: String
}


class Item3ViewModel {
    
    var items3 = [
        Item3(imageName: "rose", title: "Weeds ID & Control", description: "Weed your garden like a pro"),
        Item3(imageName: "plants", title: "Stay Safe From Toxic Plants", description: "Protect curios kids and pets"),
        Item3(imageName: "flower", title: "Allergy-proof Your Home", description: "Enjoy sneeze-free gardening")
    ]
}

struct RectangleView: View {
    
    var viewModel3 = Item3ViewModel()
    
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(text)
                    .bold()
                    .padding()
                    .font(.title2)
                    .accessibility(addTraits: .isHeader)

                
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
            .accessibilityElement(children: .ignore)
            .accessibility(addTraits: .isHeader)

            
            
            LazyVStack(spacing: 20) {
                ForEach(viewModel3.items3) { item3 in
                    HStack {
                        Image(item3.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibility(label: Text(item3.title))

                        
                        VStack(alignment: .leading) {
                            Text(item3.title)
                                .font(.headline)
                                .bold()
                            
                            Text(item3.description)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Azione del pulsante
                        }) {
                            Image(systemName: "chevron.forward")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .foregroundColor(Color.gray.opacity(0.5))
                                .padding(8)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Read more about \(item3.title)"))

                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 350, height: 180))
                }
            }
            .padding()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Protect Your Garden & Family"))
    }
}













struct Home2View: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var isLocationPickerPresented = false
    @State private var selectedLocation: String = "Current Location"
    
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            NavigationStack{
                ScrollView(.vertical){
                    VStack {
                        VStack{
                            HStack {
                                Button(action: {
                                    isLocationPickerPresented.toggle()
                                }) {
                                    Image(systemName: "location.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(.systemGreen))
                                    Text("Italy")
                                        .foregroundColor(.black)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                    
                                }
                                .padding(.leading)
                                .padding(.top)
                                .padding(.bottom, -17)
                                .accessibility(label: Text("Select Location"))
                                .accessibility(hint: Text("Current Location, Italy"))
                                
                                Spacer()
                                
                            }
                            .sheet(isPresented: $isLocationPickerPresented, content: {
                                LocationPickerView(selectedLocation: $selectedLocation, isPickerPresented: $isLocationPickerPresented)
                            })
                            
                            SearchBar()
                            
                            
                            LazyHStack(spacing: 10){
                                NavigationLink(destination: ContentView()                .toolbar(.hidden, for: .tabBar)) {
                                    SquareView(imageName: "camera.fill", text: "Identify", colorName: Color(.systemGreen))
                                        //.accessibility(label: Text("Identify plants"))

                                }
                                
                                
                                
                                SquareView(imageName: "cross.case.fill", text: "Diagnose", colorName: Color(.systemOrange))
                                    .accessibility(label: Text("Diagnose plant issues"))

                                
                                SquareView(imageName: "alarm.fill", text: "Reminders", colorName: Color(.systemPurple))
                                    .accessibility(label: Text("Plant care reminders"))

                                
                                SquareView(imageName: "leaf.fill", text: "My Garden", colorName: Color(.systemGreen))
                                    .accessibility(label: Text("My Garden"))

                            }
                            .padding()
                        }
                        .background(Color.white)
                        
                        
                        
                        OrizzontaleScrollableView(text: "Trending in Italy")
                            .background(Color.white)
                            //.accessibility(label: Text("Trending items in Italy"))

                        
                        OrizzontaleScrollable2View(text: "Explore in Italy")
                            .background(Color.white)
                            //.accessibility(label: Text("Explore plant categories in Italy"))

                        
                        RectangleView(
                            text: "Protect Your Garden & Family")
                        .background(Color.white)
                        //.accessibility(label: Text("Gardening tips to protect your garden and family"))

                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Seconda scheda con un'altra vista di scorrimento orizzontale
            VStack {
                Text("Contenuto della scheda 2")
            }
            .tabItem {
                Image(systemName: "cross.case.fill")
                Text("Diagnose")
            }
            .tag(1)
            
            // Terza scheda con un'altra vista di scorrimento orizzontale
            VStack {
                Text("Contenuto della scheda 3")
            }
            .tabItem {
                Image(systemName: "leaf.fill")
                Text("My Plants")
            }
            .tag(2)
            
            // Quarta scheda con un'altra vista di scorrimento orizzontale
            VStack {
                Text("Contenuto della scheda 4")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("More")
            }
            .tag(3)
        }
    }
}


struct Home2View_Previews: PreviewProvider {
    static var previews: some View {
        Home2View()
    }
}












struct AnotherPage: View {
    var body: some View {
        Text("Another Page")
    }
}
