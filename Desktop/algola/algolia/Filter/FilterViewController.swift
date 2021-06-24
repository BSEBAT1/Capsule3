import UIKit

class FilterViewController: UIViewController {

    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(beginSearch), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    private var viewModel = FeedViewModel() {
        didSet {
            viewModel.resetStatus()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        title = "Filter"
        view.addSubview(tableView)
        view.addSubview(applyButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor),
        ])
    }
    
    @objc func beginSearch(sender:UIButton) {
        viewModel.search()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setFilterModel(model:FeedViewModel) {
        
        self.viewModel = model
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        cell.textLabel?.text = viewModel.dataforCellAtIndexPath(section: indexPath.section, row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Categories"
        } else if section == 1 {
            return "Top Sizes"
        } else if section == 2 {
            return "Accessory Sizes"
        } else {
            fatalError("Did not expect another section")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(indexPath.section == viewModel.bannedPaths()) {            viewModel.assembleSearchString(section: indexPath.section, row: indexPath.row)
            if indexPath.section == 0 {
                guard let paths = tableView.indexPathsForSelectedRows else {return}
                for path in paths {
                    if path.section == indexPath.section {
                        if path.row != indexPath.row {
                            tableView.deselectRow(at: path, animated: true)
                        }
                    }
                }
            }
        } else {
            guard let paths = tableView.indexPathsForSelectedRows else {return}
            for path in paths {
                if path.section == viewModel.bannedPaths() {
                    tableView.deselectRow(at: path, animated: true)
                }
            }
        }
    }
}
