//
//  LocationVC.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/10/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import MapKit

protocol LocationVCDelegate: AnyObject {
    func didSelect(location: String, VC: LocationVC)
    func didScroll(VC: LocationVC)
}

class LocationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var completerResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self 
        searchCompleter.delegate = self
    }
    
    weak var delegate: LocationVCDelegate?
}

extension LocationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        let aLocation = completerResults[indexPath.row]
        cell.textLabel?.text = aLocation.title
        cell.detailTextLabel?.text = aLocation.subtitle
        return cell
    }
}

extension LocationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aLocation = completerResults[indexPath.row]
        let addressString = aLocation.title 
        self.delegate?.didSelect(location: addressString, VC: self)
        dismiss(animated: true)
    }
}

extension LocationVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
}

extension LocationVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as? NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

extension LocationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(VC: self)
    }
}
