import UIKit

class FeedViewController: UITableViewController {
    let viewModel = FeedViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.performSearch()
        viewModel.didUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @IBAction func didTapFilterButton(_ sender: UIBarButtonItem) {
        let filterViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        filterViewController.setFilterModel(model: viewModel)
        navigationController?.pushViewController(filterViewController, animated: true)

        /// Call this method when we want to trigger a new filter request
//        viewModel.didReceiveNewFilterString(filterString: exampleFilter)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listingsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        cell.configure(listing: viewModel.listing(at: indexPath))
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.listingsCount - 2 {
            viewModel.performSearch()
        }
    }
}
