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
                stop in
                
                DestinationView(destination: stop, trams: self.viewModel.services.destinations[stop]!)
            }
            
            if(self.viewModel.services.destinations.count == 0){
                VStack {
                    HStack {
                        Spacer()
                        Text("No Service information available")
                        Spacer()
                    }.padding()
                    
                    HStack {
                        Spacer()
                        Link("Please check TfGM.com for first and last tram times", destination: URL(string: "https://tfgm.com/public-transport/tram/tram-schedule")!)
                        Spacer()
                    }.padding()
                }
            }
            
            
            if (!self.viewModel.services.messages.isEmpty){
                Section(header: Text("Service Updates")){
                    ForEach(self.viewModel.services.messages, id: \.self) {
                        message in
                        HStack {
                            Spacer()
                            Label(message, systemImage: "message.fill")
                            Spacer()
                        }
                    }
                }.headerProminence(.increased)
            }
            Section {
                HStack {
                        Spacer()
                        Text("Contains Transport for Greater Manchester data")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                        Spacer()
                    }
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

struct DestinationView: View {
    var destination: String
    var trams: [Tram]
    var body: some View {
        Section (header: Text(destination)) {
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
        .headerProminence(.increased)
    }
}
