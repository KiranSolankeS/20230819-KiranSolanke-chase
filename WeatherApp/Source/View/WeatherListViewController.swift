//
//  WeatherListViewController.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import UIKit

enum ViewState {
    case content
    case loading
    case error(String)
}

class WeatherListViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherTableView: UITableView!
    
    private let searchBarDelegate = SearchBarDelegate()
    private let tableDataSource = WeatherTableDataSource()
    
    var viewModel: WeatherViewModel?
    
    private var viewState: ViewState = .loading {
        didSet {
            updateViewState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = searchBarDelegate
        
        weatherTableView.delegate = tableDataSource
        weatherTableView.dataSource = tableDataSource
        
        registerCells()
        viewState = .loading
        viewModel = WeatherViewModel(weatherService: APIService(), locationService: LocationService())
        setObservers()
    }
    
    private func registerCells() {
        let searchCellNib = UINib(nibName: "SearchCell", bundle: nil)
        weatherTableView.register(searchCellNib, forCellReuseIdentifier: SearchCell.identifier)
        
        let locationCellNib = UINib(nibName: "LocationCell", bundle: nil)
        weatherTableView.register(locationCellNib, forCellReuseIdentifier: LocationCell.identifier)
    }
    
    private func updateViewState() {
        switch viewState {
        case .loading:
            loadingView.isHidden = false
            contentStackView.isHidden = true
            activityIndicatorView.startAnimating()
        case .content:
            activityIndicatorView.stopAnimating()
            loadingView.isHidden = true
            contentStackView.isHidden = false
        case .error(let error):
            activityIndicatorView.stopAnimating()
            loadingView.isHidden = true
            showAlert(with: error)
        }
    }
    
    private func setObservers() {
        viewModel?.weatherResponse = { [weak self] data in
            guard let self = self else { return }
            self.viewState = .content
            self.tableDataSource.data = data
            self.weatherTableView.reloadData()
        }
        viewModel?.viewState = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.viewState = state
            }
        }
        searchBarDelegate.fetchWeatherFor = { [weak self] name in
            guard let cityName = name,
            let self = self else { return }
            UserDefaults.lastSearchedCity = cityName
            self.viewModel?.fetchWeatherData(cityName: cityName, cellType: .search)
        }
    }
    
    private func showAlert(with error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
