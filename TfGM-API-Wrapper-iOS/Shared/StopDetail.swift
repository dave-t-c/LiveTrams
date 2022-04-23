//
//  StopDetail.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import SwiftUI
import MapKit

struct StopDetail: View {
    
    var stop: Stop
    @State private var zoomed = false
    
    var body: some View {
        VStack (alignment: .leading) {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
                .aspectRatio(contentMode: zoomed ? .fill: .fit)
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }
            if (!zoomed) {
                Label(stop.street, systemImage: "car")
                    .padding()
                Label("Stop Zone: \(stop.stopZone)", systemImage: "tram")
                    .padding()
                Spacer()
            }
        }
            .navigationTitle(stop.stopName)
            .edgesIgnoringSafeArea(.bottom)
            .padding(.all)
    }
}

struct StopDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                StopDetail(stop: testData[2])
            }
            NavigationView{
                StopDetail(stop: testData[3])
            }
        }
        
    }
}
