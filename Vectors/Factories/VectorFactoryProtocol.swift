import Foundation

protocol VectorFactoryProtocol {
    func produceVectorItemViewModels(entities: [VectorEntity]) -> [VectorItemViewModel]
    
    func produceItemViewModel(entity: VectorEntity) -> VectorItemViewModel
    
    func produceItemViewModel(uuid: UUID, startX: Double, endX: Double, startY: Double, endY: Double, name: String) -> VectorItemViewModel
}
