import Foundation
import SwiftUI

struct Location: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    
}
struct LocationsResponse: Codable {
    let results: [Location]
}
struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
    let origin: CharacterLocation
    let location: CharacterLocation
    var imageURL: String {
        return imageDictionary["original"] ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case episode
        case url
        case created
        case image = "image"
        case origin
        case location
    }
    
    private var imageDictionary: [String: String] {
        return (try? JSONDecoder().decode([String: String].self, from: Data(image.utf8))) ?? [:]
    }

    var genderImage: String {
        switch gender {
        case "Male":
            return "male"
        case "Female":
            return "female"
        case "Genderless":
            return "genderless"
        case "Unknown":
            return "unknown"
        default:
            return "unknown"
        }
    }
}

struct CharacterLocation: Codable {
    let name: String
    let url: String
}

struct CharactersResponse: Codable {
    let results: [Character]
}

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var characters: [Character] = []
    @Published var location: Location
    @Published var selectedLocation: Location?

    
    init(location: Location) {
        self.location = location
        fetchCharacters()
    }

    var characterNames: [String] {
        return location.residents.compactMap { urlString -> String? in
            guard let character = characters.first(where: { $0.url == urlString }) else {
                return nil
            }
            return character.name
        }
    }
    
    func characterByName(_ name: String) -> Character? {
            return characters.first { $0.name == name }
        }

    func fetchLocations() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/location") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Failed to retrieve data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let locationsResponse = try JSONDecoder().decode(LocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.locations = locationsResponse.results
                }
            } catch {
                print("Failed to decode data: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchCharacters() {
        for characterURL in location.residents {
            guard let url = URL(string: characterURL) else {
                print("Invalid URL")
                continue
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let character = try JSONDecoder().decode(Character.self, from: data)
                        DispatchQueue.main.async {
                            self.characters.append(character)
                            if self.characters.count == self.location.residents.count {
                                self.objectWillChange.send()
                            }
                        }
                    } catch {
                        print("Error decoding character: \(error.localizedDescription)")
                    }
                } else if let error = error {
                    print("Error fetching character: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
}





