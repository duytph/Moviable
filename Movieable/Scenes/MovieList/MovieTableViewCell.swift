//
//  MovieTableViewCell.swift
//  Movieable
//
//  Created by Duy Tran on 10/4/20.
//

import Kingfisher
import Reusable
import UIKit

final class MovieTableViewCell: UITableViewCell, NibReusable {

    // MARK: - UIs
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var popularityContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    // MARK: - Dependencies
    
    var imageURLFactory: ImageURLFactory = DefaultImageURLFactory()
    var numberFormatter: NumberFormatter = .decimal
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 8
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = Asset.placeholder.image
        popularityLabel.text = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        overviewLabel.text = nil
    }
    
    // MARK: - Public
    
    func configure(withMovie movie: Movie) {
        titleLabel.text = movie.title
        popularityLabel.text = movie.popularity.flatMap { numberFormatter.string(from: NSNumber(value: $0)) }
        releaseDateLabel.text = movie.releaseDate
        overviewLabel.text = movie.overview
        
        let posterURL = movie.posterPath.flatMap {
            imageURLFactory.make(
                isSecure: true,
                imageSize: .medium,
                in: \Images.posterSizes,
                path: $0)
        }
        posterImageView.kf.setImage(
            with: posterURL,
            placeholder: Asset.placeholder.image)
    }
}
