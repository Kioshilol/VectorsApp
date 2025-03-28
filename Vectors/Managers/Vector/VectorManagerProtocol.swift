import UIKit

protocol VectorManagerProtocol {
    func createVector(uuid: UUID, startX: Double, endX: Double, startY: Double, endY: Double, name: String, color: UIColor)
    
    func fetchVectors() -> [VectorEntity]
    
    func updateVector(uuid: UUID, updateAction: ((VectorEntity) -> Void)?)
    
    func deleteVector(uuid: UUID)
}
