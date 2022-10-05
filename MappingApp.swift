//
//  MappingApp.swift
//  Mapping
//
//  Created by Shivangi on 05/10/22.
//

import Foundation
import MapKit

struct Address: Codable{
    let data: [Datum]
}

struct Datum: Codable{
    let latitude, longitude: Double
    let name: String?
    
}

struct Location: Identifiable{
    let id = UUID()
    let name: String?
    let coordinate = CLLocationCoordinate2D()
}



class MapAPI: ObservableObject {
    private let BASE_URL = "https://api.positionstack.com/v1/forward"
    private let API_KEY = "a6dc3409a87212cc60438c45108b815a"
    
    @Published var region: MKCoordinateRegion
    @Published var coordinates = []
    @Published var locations: [Location] = []
    
    init(){
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:51.50 , longitude: -0.1275), span:
            MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        
        self.locations.insert(Location(name: "pin"), at:0)
                                            
    }
    
    func getLocation (address: String, delta: Double){
        let pAddress = address.replacingOccurrences(of: "", with: "%20")
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)"
        
        guard let url = URL(string: url_string) else{
            print("Invalied URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else{
            print(error!.localizedDescription)
                return
        }
            
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }
            
            if newCoordinates.data.isEmpty {
                print("could not find the address!")
                return
            }
            
            DispatchQueue.main.async{
                let details = newCoordinates.data[0]
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                
                self.coordinates = [lat, lon]
                self.region = MKCoordinateRegion(center : CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                
                let newLocation = Location(name: name ??  "Pin");
                self.locations.removeAll()
                self.locations.insert(newLocation, at: 0)
                
                print("Succesfully loaded the location!")

                }
        }
        .resume()
    }
    
}
