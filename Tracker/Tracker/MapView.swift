//
//  MapView.swift
//  Tracker
//
//  Created by Josiah Uwanaka on 7/21/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: $userTrackingMode)
            .accentColor(Color(.systemBlue))
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902,
                                                                              longitude: -95.7129),
                                               span: MKCoordinateSpan(latitudeDelta: 15,
                                                                      longitudeDelta: 15))
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager?.startUpdatingLocation()
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Make Location Services Available")
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is rescricted likely due to parental controls")
            case .denied:
                print("you have denied the location permission, go into setting to allow permission")
            case .authorizedAlways, .authorizedWhenInUse:
            if  let location = locationManager.location {
                region = MKCoordinateRegion(center: location.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

