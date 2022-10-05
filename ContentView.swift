//
//  ContentView.swift
//  Mapping
//
//  Created by Shivangi on 05/10/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var mapAPI = MapAPI()
    @State private var text = ""
    
    var body: some View {
        VStack{
            TextField("Find Location",text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button ("Find Location"){
                mapAPI.getLocation(address: text, delta: 0.5)
            }
            Map(coordinateRegion: $mapAPI.region, annotationItems: mapAPI.locations){ Location in
                MapMarker(coordinate: Location.coordinate, tint:  .blue)
                
            }
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
