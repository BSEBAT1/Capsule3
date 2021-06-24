import Foundation

class FeedViewModel {

    var didUpdate: (() -> ()) = {}

    private var listings: [Listing] = [] {
        didSet {
            didUpdate()
        }
    }

    private var isLoading = false
    private var currentPage: UInt = 0
    private var cursor: String?
    private var filterString: String {
       return catString+pathString
    }
    private let category = ["tops", "accessories"]
    private let topsSizes = ["tops.s", "tops.m", "tops.l"]
    private let accessorySizes = ["accessories.one_size", "accessories.26", "accessories.28"]
    private let exampleFilter = "(category:tops OR category:accessories) AND (category_path_root_size: tops.l)"
    private let filterData = [
        ["tops", "accessories"],
        ["tops.s", "tops.m", "tops.l"],
        ["accessories.one_size", "accessories.26", "accessories.28"]
    ]
    private var catString = ""
    private var pathString = ""

    var listingsCount: Int {
        return listings.count
    }
    
    func listing(at indexPath: IndexPath) -> Listing {
        return listings[indexPath.row]
    }

    /// Call this method when we receive a new filter string from the filtering screen
private func didReceiveNewFilterString(filterString: String) {
        listings = []
        currentPage = 0
        cursor = nil
        performSearch()
    }

private func appendListings(from response: Response) {
        self.cursor = response.cursor
        
        if response.hits.count > 0 {
            self.listings.append(contentsOf: response.hits)
        }
        self.isLoading = false
    }

  func performSearch() {
        if self.isLoading { return }
        self.isLoading = true

        print("performing filter with string --> \"\(filterString)\"")

        guard let cursor = cursor else {
            switch currentPage {
            case 0..<5:
                Algolia.search(page: currentPage, filterString: filterString) {  response in
                    self.currentPage += 1
                    self.appendListings(from: response)
                }
            default:
                Algolia.browse(filterString: filterString) { response in
                    self.appendListings(from: response)
                }
            }

            return
        }

        Algolia.browseFrom(cursor: cursor) { response in
            self.appendListings(from: response)
        }
    }
    
    func search() {
        didReceiveNewFilterString(filterString: filterString)
    }
}

extension FeedViewModel {
    
    func numberOfSections() -> Int {
        return filterData.count
    }
    
    func numberOfRowsInSection(section:Int) -> Int {
        return filterData[section].count
    }
    func dataforCellAtIndexPath(section:Int,row:Int) -> String {
        return filterData[section][row]
    }
    
    func assembleSearchString(section:Int,row:Int) {
        let selectedString = filterData[section][row]
        if section == 0 {
            if catString.count > 0 {
                self.resetStatus()
            }
            catString.append("(category:\(selectedString))")
        } else {
            pathString.append(" AND (category_path_root_size:\(selectedString))")
        }
    }
    
    func bannedPaths() -> Int {
        
        if catString.contains("tops") {
            return 2
        } else if catString.contains("accessories") {
            return 1
        } else {
            return 3
        }
    }
    
    
    
    func resetStatus() {
        catString = ""
        pathString = ""
    }
}
