import Foundation
import UIKit

final class DetailsViewController: BaseViewController {

    private let tableView = UITableView()
    private let barButtonItem = UIBarButtonItem()
    private let viewModel: DetailsViewModelType

    private var dataSource: UITableViewDiffableDataSource<DetailsSection, DetailsSectionItem>!

    init(viewModel: DetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupUI()
        viewModel.didLoad()
    }
}

private extension DetailsViewController {

    func setup() {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, _, itemIdentifier in
            switch itemIdentifier {
            case .text(let title, let description):
                let cell = tableView.dequeue(reusable: DetailsTextViewCell.self)
                cell.configure(with: title, description: description)
                return cell
            case .image(let imagePath):
                let cell = tableView.dequeue(reusable: DetailsImageViewCell.self)
                cell.configure(with: imagePath)
                return cell
            }
        })
    }

    func setupUI() {
        navigationItem.setRightBarButton(barButtonItem, animated: true)

        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.register(class: DetailsTextViewCell.self)
        tableView.register(class: DetailsImageViewCell.self)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension DetailsViewController: DetailsViewModelDelegate {
    func updateWithSnapshot(snapshot: DetailsViewSnapshot, title: String, rateTitle: String) {
        self.title = title
        barButtonItem.title = rateTitle
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.snapshot.sectionIdentifiers[indexPath.section]
        let identifier = viewModel.snapshot.itemIdentifiers(inSection: section)[indexPath.row]
        switch identifier {
        case .image:
            return view.frame.width * 1.4
        case .text:
            return UITableView.automaticDimension
        }
    }
}
