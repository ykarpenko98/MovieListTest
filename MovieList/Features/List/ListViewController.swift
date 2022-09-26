import UIKit

final class ListViewController: BaseViewController {
    
    private enum Constants {
        static let rowHeight: CGFloat = 120
        static let loadNextPageOffset: Int = 3
    }

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let searchBar = UISearchBar()
    private let viewModel: ListViewModelType

    private var dataSource: UITableViewDiffableDataSource<ListSection, ListSectionItem>!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupUI()
        viewModel.didLoad()
    }
}

private extension ListViewController {

    func setup() {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .film(let movie):
                let cell = tableView.dequeue(reusable: ListViewCell.self, for: indexPath)
                cell.configure(with: movie)
                return cell
            }
        })
    }

    func setupUI() {
        title = "🍿 Movies"

        setupSearchBar()
        setupTableView()
    }

    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = .lightGray
        searchBar.barTintColor = .black
        searchBar.searchBarStyle = .default
        searchBar.searchTextField.textColor = .lightGray
        searchBar.placeholder = "Search"
        searchBar.delegate = self

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    func setupTableView() {
        tableView.register(class: ListViewCell.self)
        tableView.separatorColor = .gray
        tableView.backgroundColor = .black
        tableView.clipsToBounds = true
        tableView.separatorInset = .init(top: .zero, left: 16, bottom: .zero, right: 16)
        tableView.delegate = self
        tableView.rowHeight = Constants.rowHeight

        view.insertSubview(tableView, belowSubview: searchBar)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: -32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ListViewController: ListViewModelDelegate {
    func setLoadingState(_ isLoading: Bool) {
        if isLoading {
            view.isUserInteractionEnabled = false
            startLoading()
        } else {
            view.isUserInteractionEnabled = true
            stopLoading()
        }
    }

    func updateWithSnapshot(_ snapshot: ListViewSnapshot) {
        dataSource.apply(snapshot)
    }

    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

extension ListViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let itemsCount = dataSource.snapshot().numberOfItems(inSection: section)
        if itemsCount < indexPath.row + Constants.loadNextPageOffset {
            viewModel.loadNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        viewModel.search(string: searchText)
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.discardSearch()
        }
    }
}
