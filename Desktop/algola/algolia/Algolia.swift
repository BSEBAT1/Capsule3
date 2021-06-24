import Foundation
import InstantSearchClient

//struct AlgoliaHits: Decodable {
//    let hits: [Listing]
//    let cursor: String?
//}

struct Response: Decodable {
    let hits: [Listing]
    let cursor: String?
}

struct Algolia {
    static let searchTerm = ""
    static let appId = "MNRWEFSS2Q"
    static let listingIndex = "Listing_production"

    static let searchClient = Client(appID: "MNRWEFSS2Q", apiKey: "a3a4de2e05d9e9b463911705fb6323ad")
    static let browseClient = Client(appID: "MNRWEFSS2Q", apiKey: "a1c6338ffe41249d0284a5a1105eafe4")
    static let pageSize: UInt = 20

    static func search(page: UInt, filterString: String, success: @escaping (Response) -> ()) {
        let query = Query(query: searchTerm)
        query.hitsPerPage = pageSize
        query.page = page
        query.filters = filterString

        searchClient.index(withName: listingIndex).search(query) { content, error in
            guard let `content` = content, error == nil else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject:content)
                let response = try JSONDecoder().decode(Response.self, from: jsonData)

                success(response)
            } catch {
                
            }
        }
    }

    static func browse(filterString: String,success: @escaping (Response) -> ()) {
        let query = Query(query: searchTerm)
        query.hitsPerPage = pageSize
        query.filters = filterString

        browseClient.index(withName: listingIndex).browse(query: query) { content, error in
            guard let `content` = content, error == nil else { return }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject:content)
                let response = try JSONDecoder().decode(Response.self, from: jsonData)

                success(response)
            } catch {
                
            }
        }
    }

    static func browseFrom(cursor: String, success: @escaping (Response) -> ()) {
        browseClient.index(withName: listingIndex).browse(from: cursor) { content, error in
            guard let `content` = content, error == nil else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject:content)
                let response = try JSONDecoder().decode(Response.self, from: jsonData)

                success(response)
            } catch {
        
            }
        }
    }
}
