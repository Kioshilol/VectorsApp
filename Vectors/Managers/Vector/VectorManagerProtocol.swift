import UIKit

protocol VectorManagerProtocol {
    func saveVector(startX: Double, endX: Double, startY: Double, endY: Double, name: String, color: UIColor)
    
    func fetchVectors() -> [Vector]
}
