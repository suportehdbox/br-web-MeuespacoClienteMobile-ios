//
//  LocationMapViewController.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 02/07/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

protocol LocationMapDelegate {

    func hasNewLocation(location: CallingLocation)

}

public class LocationMapViewController: DirectAssistViewController, CLLocationManagerDelegate {

    static let identifier = "LocationMapViewController"
    
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var addressField: UISearchBar!

    var mapView: GMSMapView!
    var didDrag = true
    var location: CallingLocation?
    var delegate: LocationMapDelegate?
    let locationManager = CLLocationManager()
    var flagToMe = false

    @IBOutlet weak var segmented: UISegmentedControl! {
        didSet {
            let segAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
            ]
            segmented.setTitleTextAttributes(segAttributes, for: .selected)
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Localização do veículo"
        
        let textFieldInsideSearchBar = addressField.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = Configuration.grayColor1
        textFieldInsideSearchBar?.font = UIFont(name: "ArialMT", size: 15)
        
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageV.tintColor = Configuration.blueColor1
        
        
        GMSServices.provideAPIKey("AIzaSyAxZslAs9AUz58aizAn6EXjBku4u3oNQY4")
        let camera = GMSCameraPosition.camera(withLatitude: -23.616696, longitude: -46.612050, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: mapContainer.bounds, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        //moveToMe()
        mapContainer.addFill(view: mapView)
        
        if CLLocationManager.locationServicesEnabled() {
            askForLocationService()
        } else {
            let alertController = UIAlertController(title: "Atenção", message: "Serviço de localização não está habilitado.", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(oKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }

    func moveToMe() {
        if let coordinate = locationManager.location?.coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17.0)
            let update = GMSCameraUpdate.setCamera(camera)
            self.mapView.moveCamera(update)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied: break
        case .authorizedAlways, .authorizedWhenInUse:
            //moveToMe()
            break
        }
    }

    func askForLocationService() {
        switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                locationManager.delegate = self
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                break;
        }
    }

    func separateThoroughfare(thoroughfare: String?, number: Bool) -> String? {
        if let tf = thoroughfare {
            var splitAddress: [String] = tf.components(separatedBy: " ")
            if (number){
                return splitAddress[0]
            }
            else{
                var newAddress: String = ""
                for i in 1...splitAddress.count-1{
                    newAddress += splitAddress[i] + " "
                }
                
                return String(newAddress.characters.dropLast(1))
            }
        
        }
            
        return nil
    }
    
    func getAdministrativeArea(state: String?) -> String? {
        if let st = state {
            if (st.contains("State of")){
                return state?.components(separatedBy: "State of ")[1]
            }
        }
        return state
    }
    
    func updateLocal() {
        print("updateLocal")
        self.showLoading {
            let center = self.mapView.camera.target
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(center) { (geocoderResponse, error) in
                if let address = geocoderResponse?.firstResult() {
                    self.location = CallingLocation()
                    self.location?.city = address.locality
                    self.location?.state = self.getAdministrativeArea(state: address.administrativeArea)
                    self.location?.subLocality = address.subLocality
                    self.location?.address = self.separateThoroughfare(thoroughfare: address.thoroughfare, number: false)
                    self.location?.addressNumber = self.separateThoroughfare(thoroughfare: address.thoroughfare, number: true)
                    self.location?.latitude = address.coordinate.latitude
                    self.location?.longitude = address.coordinate.longitude

                    self.updateAddressField()
                }
            }
        }
    }

    func updateAddressField() {
        var addressString = ""
        if let location = location {
            addressString = location.description()
        }
        self.addressField.text = addressString
        self.removeLoading {}
        if (!flagToMe){
            self.flagToMe = true
            self.moveToMe()
        }
    }

    @IBAction func actionConfirmAddress(_ sender: Any) {
        if let location = self.location {
            self.delegate?.hasNewLocation(location: location)
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionSearch(_ sender: Any) {
        let searchViewController = DirectAssistRouter.locationSearchScreen()
        searchViewController.delegate = self
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }

}

extension LocationMapViewController: GMSMapViewDelegate {

    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if didDrag {
            didDrag = false
            updateLocal()
        } else {
            if mapView.camera.target.latitude != self.location?.latitude {
                updateLocal()
            }
        }

    }

    public func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            didDrag = true
        }
    }

}

extension LocationMapViewController: LocationSearchDelegate {

    func selectedMapItem(item: GMSPlace?) {
        self.location = CallingLocation()
        if let components = item?.addressComponents {
            for component in components {
                //print("\(component.type) --- \(component.name)")
                if component.type == "administrative_area_level_2" {
                    self.location?.city = component.name
                }
                if component.type == "administrative_area_level_1" {
                    self.location?.state = component.name
                }
                if component.type == "route" {
                    self.location?.address = component.name
                }
                if component.type == "street_number" {
                    self.location?.addressNumber = component.name
                }
                if component.type == "sublocality_level_1" {
                    self.location?.subLocality = component.name
                }
            }
            if let coordinate = item?.coordinate {
                self.location?.latitude = coordinate.latitude
                self.location?.longitude = coordinate.longitude
                let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17.0)
                let update = GMSCameraUpdate.setCamera(camera)
                self.mapView.moveCamera(update)
            }
        }


        updateAddressField()
    }

}

