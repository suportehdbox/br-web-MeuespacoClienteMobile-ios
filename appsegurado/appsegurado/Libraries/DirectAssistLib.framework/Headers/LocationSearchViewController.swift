//
//  LocationSearchViewController.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 30/07/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import UIKit
import GooglePlaces

protocol LocationSearchDelegate {

    func selectedMapItem(item: GMSPlace?)
    
}

public class LocationSearchViewController: DirectAssistViewController {

    static let identifier = "LocationSearchViewController"

    var items: [SearchViewModel]?

    var delegate: LocationSearchDelegate?

    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    let placesClient: GMSPlacesClient = GMSPlacesClient.shared()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pesquisar Localização"
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = Configuration.grayColor1
        textFieldInsideSearchBar?.font = UIFont(name: "ArialMT", size: 15)
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageV.tintColor = Configuration.blueColor1
        
        
        searchBar.becomeFirstResponder()
    }

    func updateSearch(_ text: String) {
        DispatchQueue.global().async {
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            filter.country = "BR"
            self.placesClient.autocompleteQuery(text, bounds: nil, filter: filter, callback: {(results, error) -> Void in
                if let error = error {
                    print("Autocomplete error \(error)")
                    self.showError(description: Configuration.errorDefault)
                    self.resultsDidChange(items: nil)
                }
                if let results = results {
                    self.resultsDidChange(items: results)
                }
            })
        }
    }

    func placeFor(autocomplete: GMSAutocompletePrediction) {
        self.placesClient.lookUpPlaceID(autocomplete.placeID!) { (place, error) in
            DispatchQueue.main.async {
                self.result(result: place)
            }
        }
    }

    func result(result: GMSPlace?) {
//        self.dismiss(animated: true, completion: {
            self.delegate?.selectedMapItem(item: result)
            let _ = self.navigationController?.popViewController(animated: true)
//        })
    }

    func resultsDidChange(items: [GMSAutocompletePrediction]?) {
        if let items = items {
            self.items = []
            for item in items {
                self.items?.append( SearchViewModel(autcomplete: item) )
            }
            if items.count > 0 {
                self.resultsTable.isHidden = false
            } else {
                self.resultsTable.isHidden = true
            }
        } else {
            self.items = nil
            self.resultsTable.isHidden = true
        }
        self.resultsTable.reloadData()
    }

}

extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items {
            return items.count
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")!
        cell.textLabel?.text = items![indexPath.row].title
        cell.detailTextLabel?.text = items![indexPath.row].subtitle
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.present(self.loading, animated: true) {
            let item = self.items![indexPath.row].autcomplete!
            self.placeFor(autocomplete: item)
//        }

    }

}

extension LocationSearchViewController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateSearch(searchText)
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
