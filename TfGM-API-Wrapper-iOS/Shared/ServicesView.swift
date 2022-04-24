//
//  ServicesView.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import SwiftUI

struct ServicesView: View {
    @State var services: FormattedServices = FormattedServices(destinations: [:], messages:[])
    var stop: Stop
    
    var body: some View {
        List { 
            ForEach(Array(services.destinations.keys), id: \.self) {
                destination in
                DestinationView(destination: destination, trams: services.destinations[destination]!)
            }
            ForEach(services.messages, id: \.self) {
                message in
                HStack {
                    Spacer()
                    Label(message, systemImage: "message.fill")
                    Spacer()
                }
                
                    
            }
        }
        .onAppear {
            ServicesRequest().requestServices(tlaref: stop.tlaref) { services in
                self.services = services
            }
            
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ServicesView(stop: testData[0])
            }
        }
        
    }
}

struct DestinationView: View {
    var destination: String
    var trams: [Tram]
    var body: some View {
        Text(destination)
            .font(.headline)
        VStack {
            ForEach(trams) {
                tram in
                HStack {
                    Text(tram.carriages)
                        .padding(.bottom)
                    Spacer()
                    Text("\(tram.wait) mins")
                        .padding()
                }
                
            }
        }
    }
}
