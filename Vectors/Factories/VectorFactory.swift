import Foundation

final class VectorFactory: VectorFactoryProtocol{
    func produceVectorItemViewModels(entities: [VectorEntity]) -> [VectorItemViewModel] {
        return entities.map(produceItemViewModelInternal)
        
        func produceItemViewModelInternal(entity: VectorEntity) -> VectorItemViewModel {
            let vector = produceItemViewModel(entity: entity)
            if let existingStickEntity = entities.first(where: { $0.uuid == entity.stickedVectorUuid }) {
                vector.stickedVector = VectorToStick(
                    stickedVectorPosition: VectorPosition(rawValue: existingStickEntity.stickedVectorPosition) ?? .none,
                    position: VectorPosition(rawValue: existingStickEntity.stickedPosition) ?? .none,
                    vector: produceItemViewModel(entity: existingStickEntity))
            }
           
            return vector
        }
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
