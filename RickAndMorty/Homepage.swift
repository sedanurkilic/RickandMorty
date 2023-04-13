import URLImage
import SwiftUI

struct Homepage: View {

    @ObservedObject private var locationViewModel = LocationViewModel(location: Location(id: 1, name: "Earth", type: "Planet", dimension: "Dimension C-137", residents: ["https://rickandmortyapi.com/api/character/1", "https://rickandmortyapi.com/api/character/2"]))

    var body: some View {
        NavigationView {
            ZStack {
                Image("homepage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(locationViewModel.locations, id: \.name) { location in
                            Button(action: {locationViewModel.selectedLocation = location}) {
                                Text(location.name)
                                    .foregroundColor(.black)
                                    .padding()
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

struct LocationDetailView: View {
    @ObservedObject private var locationViewModel: LocationViewModel
    @State private var selectedCharacter: Character? = nil
    let location: Location
    
    init(location: Location) {
        self.location = location
        self.locationViewModel = LocationViewModel(location: location)
        self.locationViewModel.fetchCharacters()
    }
    
    var body: some View {
        VStack {
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
        }
        .sheet(item: $selectedCharacter) { character in
            CharacterDetailView(character: character)
        }
    }
}

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(character.name)
                    .font(Font.custom("Avenir-Heavy", size: 22))
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
                        Text("Status:")
                            .font(Font.custom("Avenir-Heavy", size: 22))
                        Text(character.status)
                            .font(Font.custom("Avenir", size: 22))
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Species:")
                            .font(Font.custom("Avenir-Heavy", size: 22))
                        Text(character.species)
                            .font(Font.custom("Avenir", size: 22))
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Gender:")
                            .font(Font.custom("Avenir-Heavy", size: 22))
                        Text(character.gender)
                            .font(Font.custom("Avenir", size: 22))
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Origin:")
                            .font(Font.custom("Avenir-Heavy", size: 22))
                        Text(character.origin.name)
                            .font(Font.custom("Avenir", size: 22))
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Location:")
                            .font(Font.custom("Avenir-Heavy", size: 22))
                        Text(character.location.name)
                            .font(Font.custom("Avenir", size: 22))
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Episodes:")
                        .font(Font.custom("Avenir-Heavy", size: 22))
                    ForEach(character.episode, id: \.self) { episode in
                        HStack {
                            Text("\(episode)")
                                .font(Font.custom("Avenir", size: 22))
                        }
                    }
                }

                Text("Created at: \(formattedDate(dateString: character.created))")
                    .font(Font.custom("Avenir", size: 22))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 20)

                Spacer()
                    .frame(height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .navigationBarTitle(character.name)
            
        }
    }
    
    //Format date
    func formattedDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
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
