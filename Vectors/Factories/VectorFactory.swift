import Foundation
final class VectorFactory: VectorFactoryProtocol{
    func produceVectorItemViewModels(entities: [VectorEntity]) -> [VectorItemViewModel] {
        return entities.map(produceItemViewModel)
    }
    
    func produceItemViewModel(entity: VectorEntity) -> VectorItemViewModel {
        let vector = VectorItemViewModel(
            uuid: entity.uuid,
            startX: entity.startX,
            endX: entity.endX,
            startY: entity.startY,
            endY: entity.endY,
            name: entity.name,
            color: entity.color)
        return vector
    }
    
    func produceItemViewModel(
        uuid: UUID,
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String) -> VectorItemViewModel {
        return VectorItemViewModel(
            uuid: uuid,
            startX: startX,
            endX: endX,
            startY: startY,
            endY: endY,
            name: name)
    }
}
