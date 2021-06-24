import Foundation

struct Listing: Decodable {
    let id: Int
    let title: String
    let photo: Photo

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case photo = "cover_photo"
    }
}
