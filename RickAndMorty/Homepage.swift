import URLImage
import SwiftUI

struct Homepage: View {
    
    @ObservedObject private var locationViewModel = LocationViewModel(location: Location(id: 1, name: "Earth", type: "Planet", dimension: "Dimension C-137", residents: ["https://rickandmortyapi.com/api/character/1", "https://rickandmortyapi.com/api/character/2"]))
    @State private var isShowingPreviousPage = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("homepage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer()
                        ScrollView(.horizontal, showsIndicators: false) {
                            Spacer()
                            LazyHStack {
                                ForEach(locationViewModel.locations, id: \.name) { location in
                                    Button(action: {locationViewModel.selectedLocation = location}) {
                                        Text(location.name)
                                            .foregroundColor(.black)
                                            .padding(10)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.black, lineWidth: 1))
                                        
                                    }
                                    .sheet(item: $locationViewModel.selectedLocation) { location in
                                        LocationDetailView(location: location)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                        .onAppear(perform: locationViewModel.fetchLocations)
                        
                        Spacer()
                        
                    }
                }
            }
        }
    }
struct LocationDetailView: View {
    @ObservedObject private var locationViewModel: LocationViewModel
    @State private var selectedCharacter: Character? = nil
    @State private var isShowingPreviousPage = false
    let location: Location
    
    init(location: Location) {
        self.location = location
        self.locationViewModel = LocationViewModel(location: location)
        self.locationViewModel.fetchCharacters()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(locationViewModel.characterNames, id: \.self) { characterName in
                        VStack(spacing: 10) {
                            Button(action: {
                                if let character = locationViewModel.characterByName(characterName) {
                                    selectedCharacter = character
                                }
                            }) {
                                HStack(spacing: 10) {
                                    if let character = locationViewModel.characterByName(characterName) {
                                        URLImage(URL(string: character.image)!) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                        }
                                    }
                                    if let character = locationViewModel.characterByName(characterName) {
                                        ZStack() {
                                            Image(character.genderImage)
                                                .resizable()
                                                .frame(width: 280, height: 100)
                                            Text(characterName)
                                                .font(Font.custom("Avenir-Heavy", size: 22))
                                                .font(.headline)
                                                .foregroundColor(Color.black)
                                                .lineLimit(1)
                                                .truncationMode(.middle)
                                                .padding(.horizontal, 10)
                                        }
                                        
                                    }
                                    Spacer()
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                        .background(Color.white)
                                )
                                .frame(maxWidth: .infinity, minHeight: 130, alignment: .leading)
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    isShowingPreviousPage = true
                }) {
                    Image(systemName: "chevron.left")
                        .font(Font.system(size: 24))
                        .foregroundColor(.black)
                }
            )
        }
        .sheet(item: $selectedCharacter) { character in
            CharacterDetailView(character: character)
        }
        .sheet(isPresented: $isShowingPreviousPage, onDismiss: {
            //
        }) {
            Homepage()
        }
    }
}


struct CharacterDetailView: View {
    let character: Character
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(character.name)
                        .font(Font.custom("Avenir-Heavy", size: 22))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                       
                    URLImage(URL(string: character.image)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 275, height: 275)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Status:")
                                .font(Font.custom("Avenir-Heavy", size: 22))
                            Text(character.status)
                                .font(Font.custom("Avenir", size: 22))
                        
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Species:")
                                .font(Font.custom("Avenir-Heavy", size: 22))
                            Text(character.species)
                                .font(Font.custom("Avenir", size: 22))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Gender:")
                                .font(Font.custom("Avenir-Heavy", size: 22))
                            Text(character.gender)
                                .font(Font.custom("Avenir", size: 22))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Origin:")
                                .font(Font.custom("Avenir-Heavy", size: 22))
                            Text(character.origin.name)
                                .font(Font.custom("Avenir", size: 22))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Location:")
                                .font(Font.custom("Avenir-Heavy", size: 22))
                            Text(character.location.name)
                                .font(Font.custom("Avenir", size: 22))
                        }
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Episodes:")
                                .font(Font.custom("Avenir-Heavy", size: 22))
                            let episodeNumbers = character.episode.map { $0.components(separatedBy: "/").last ?? "" }
                            Text(episodeNumbers.joined(separator: ", "))
                                .font(Font.custom("Avenir", size: 22))
                        }
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                    Text("Created at (in API):")
                        .font(Font.custom("Avenir-Heavy", size: 22))
                         Text(formattedDate(dateString: character.created))
                        .font(Font.custom("Avenir", size: 22))
                        .padding(.top, 20)
                        .frame(height: 20)
                    }
                }
            }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .navigationBarItems(leading: backButton)
            }
        }
    }
        // Back button
        var backButton: some View {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left") // Geri ok simgesi
                    .font(Font.system(size: 24))
                    .foregroundColor(.black)
            })
        }
    
        //Format date
        func formattedDate(dateString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
                return dateFormatter.string(from: date)
            }
            return dateString
        }
    }

struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}
