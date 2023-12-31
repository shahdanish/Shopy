import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let purchasePrice: Double
    let salePrice: Double
    let dateAdded: Date
    let pId : String
    let isActive : Bool
    let imageURL : String
}
