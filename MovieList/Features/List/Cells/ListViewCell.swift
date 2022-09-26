import Foundation
import UIKit

final class ListViewCell: UITableViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let rateView = RateView()
    private let rateLabel = UILabel()
    private let chevronRightImageView = UIImageView()

    private let resourceService = ResourceService()

    private var loadingPosterImagePath: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        posterImageView.image = nil
    }

    func configure(with model: MovieViewModel) {
        titleLabel.text = model.title
        genreLabel.text = model.genres
        rateLabel.text = String(model.rate)
        rateView.setRateValue(rate: model.rate)
        loadingPosterImagePath = model.posterImagePath
        if let posterImagePath = model.posterImagePath {
            resourceService.getImagePoster(imagePath: posterImagePath) { [weak self] result in
                guard let self = self, model.posterImagePath == self.loadingPosterImagePath else {
                    return
                }
                switch result {
                case .success(let image):
                    self.posterImageView.image = image
                case .failure:
                    self.posterImageView.image = UIImage(systemName: "xmark")
                }
            }
        } else {
            self.posterImageView.image = UIImage(systemName: "xmark")
        }
    }
}

private extension ListViewCell {
    func setupUI() {
        autoresizesSubviews = true
        contentView.backgroundColor = #colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)
        backgroundColor = .black
        selectionStyle = .none

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white

        genreLabel.font = .systemFont(ofSize: 10)
        genreLabel.textColor = .gray

        chevronRightImageView.image = .init(systemName: "chevron.right")
        chevronRightImageView.tintColor = .gray
        chevronRightImageView.contentMode = .scaleAspectFill

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.tintColor = .gray

        rateView.backgroundColor = .gray

        rateLabel.textColor = .gray
        rateLabel.font = .systemFont(ofSize: 19)
        setupConstraints()
    }

    func setupConstraints() {
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120)
        ])

        contentView.addSubview(chevronRightImageView)
        chevronRightImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronRightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            chevronRightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronRightImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronRightImageView.heightAnchor.constraint(equalToConstant: 16)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        contentView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        contentView.addSubview(rateLabel)
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            rateLabel.trailingAnchor.constraint(equalTo: chevronRightImageView.leadingAnchor, constant: -16)
        ])

        contentView.addSubview(rateView)
        rateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rateView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            rateView.trailingAnchor.constraint(equalTo: rateLabel.leadingAnchor, constant: -16),
            rateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            rateView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}
