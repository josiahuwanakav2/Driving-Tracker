//
//  ContentView.swift
//  Tracker
//
//  Created by Josiah Uwanaka on 7/21/22.
//

import SwiftUI
import MapKit
import CoreMotion

struct ContentView: View {
    @State private var trackSensors = false
    @StateObject private var viewModel = MapViewModel()
    @ObservedObject private var locationManager = LocationManager()
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
   
    @State private var x = Double.zero
    @State private var y = Double.zero
    @State private var z = Double.zero
    

    
    var body: some View {
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        VStack {
            MapView()
                //.ignoresSafeArea(edges: .top)
                .blur(radius: trackSensors ? 0 : 20)
            VStack{
                HStack{
                    Label("Location", systemImage: "location.circle")
                        .labelStyle(.iconOnly)
                    Text("Track Movement")
                        .foregroundColor(trackSensors ? .green : .gray)
                }
                Toggle("Track", isOn: $trackSensors)
                    .labelsHidden()
            }.padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 3)
                    .foregroundColor(trackSensors ? .green : .gray))
            Text("Coordinates")
                .bold()
            Text(trackSensors ? "\(coordinate.latitude), \(coordinate.longitude)" : "--, --")
            VStack{
                Text("Acceleration Data")
                    .bold()
                if trackSensors{
                    Text("X: \(x)")
                    Text("Y: \(y)")
                    Text("Z: \(z)")

                }
            }
            .padding()
            .onAppear {
                self.motionManager.deviceMotionUpdateInterval = 0.1
                self.motionManager.startDeviceMotionUpdates(to: self.queue) {(data: CMDeviceMotion?, error: Error?) in
                    guard let data = data else {
                        return
                    }
                    let acceleration: CMAcceleration = data.userAcceleration
                    
                    DispatchQueue.main.async {
                        self.x = acceleration.x
                        self.y = acceleration.y
                        self.z = acceleration.z
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

