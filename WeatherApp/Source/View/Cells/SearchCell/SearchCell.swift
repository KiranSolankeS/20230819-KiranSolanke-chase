//
//  SearchCell.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import UIKit

final class SearchCell: UITableViewCell {
    static let identifier = "SearchCell"
    var type: CellType = .search {
        didSet {
            switch type {
            case .search:
                headerLabel.text = "Search"
            case .recent:
                headerLabel.text = "Recent Search"
            case .location:
                headerLabel.text = ""
            }
        }
    }
    
    @IBOutlet fileprivate weak var headerLabel: UILabel!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var weatherImageView: UIImageView!
    @IBOutlet fileprivate weak var cityNameLabel: UILabel!
    @IBOutlet fileprivate weak var weatherLabel: UILabel!
    @IBOutlet fileprivate weak var tempLabel: UILabel!
    @IBOutlet fileprivate weak var minMaxLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        containerView.addBorder(color: .lightGray)
        containerView.roundCorners(cornerRadius: 16.0)
        containerView.addShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setWeather(data: WeatherResponse) {
        if let icon = data.weather?.first?.icon,
           let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon).png") {
            ImageCache.shared.getImage(for: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.weatherImageView.image = image
                }
            }
        }
        cityNameLabel.text = data.name ?? ""
        tempLabel.text = data.main?.temp?.temperatureString()
        weatherLabel.text = data.weather?.first?.description
        minMaxLabel.text = "H:\(data.main?.tempMax?.temperatureString() ?? "")  " + "L:\(data.main?.tempMin?.temperatureString() ?? "")"
    }
}
