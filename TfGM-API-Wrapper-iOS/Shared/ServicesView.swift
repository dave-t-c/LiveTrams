//
//  ServicesView.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import SwiftUI

struct ServicesView: View {
    
    var stop: Stop
    
    @StateObject private var viewModel = ServicesViewModel()
    
    init(stop: Stop) {
        self.stop = stop
    }
    
    var body: some View {
        List {
            ForEach(self.viewModel.getDestinationsAlphabetical(), id: \.self) {
                destination in
                    DestinationView(destination: destination, trams: self.viewModel.services.destinations[destination]!)
            }
            ForEach(self.viewModel.services.messages, id: \.self) {
                message in
                HStack {
                    Spacer()
                    Label(message, systemImage: "message.fill")
                    Spacer()
                }
            }
            HStack {
                Spacer()
                Text("Contains Transport for Greater Manchester data")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Spacer()
            }
        }
        .navigationTitle("Live Services")
        .onAppear {
            self.viewModel.stop = stop
            Task {
                await self.viewModel.refreshServices()
            }
        }
        .refreshable {
            await self.viewModel.refreshServices()
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
            .font(.title2)
            .fontWeight(.semibold)
        VStack {
            ForEach(trams) {
                tram in
                HStack {
                    Text(tram.carriages)
                        .padding(.bottom)
                    Spacer()
                    if tram.wait == "0" {
                        Text("\(tram.status)")
                            .padding()
                    } else {
                        Text("\(tram.wait) mins")
                            .padding()
                    }
                    
                }
                
            }
        }
        .padding()
    }
}
