import Foundation
import UIKit

final class DetailsImageViewCell: UITableViewCell {
    private let posterImageView = UIImageView()
    private let resourceService = ResourceService()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with posterImagePath: String?) {
        guard let posterImagePath = posterImagePath else {
            return
        }
        resourceService.getImagePoster(imagePath: posterImagePath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.posterImageView.image = image
            case .failure:
                self?.posterImageView.image = UIImage(systemName: "xmark")
            }
        }
    }

    private func setup() {
        selectionStyle = .none

        posterImageView.tintColor = .lightGray
        posterImageView.backgroundColor = .black
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.4)
        ])
    }
}
