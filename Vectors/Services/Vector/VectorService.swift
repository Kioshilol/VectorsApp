import Foundation

final class VectorService: VectorServiceProtocol {
    private var vectorManager: VectorManagerProtocol = CompositionRoot.shared.resolve(VectorManagerProtocol.self)
    private var vectorFactory: VectorFactoryProtocol = CompositionRoot.shared.resolve(VectorFactoryProtocol.self)
    
    var vectors: [VectorItemViewModel] = []
    var vectorCreated: ((VectorItemViewModel) -> Void)?
    
    func requestRefreshVectors() {
        let entities = vectorManager.fetchVectors()
        vectors = vectorFactory.produceVectorItemViewModels(entities: entities)
    }
    
    func createVector(
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String) -> VectorItemViewModel {
            let uuid = UUID()
            let vector = vectorFactory.produceItemViewModel(
                uuid: uuid,
                startX: startX,
                endX: endX,
                startY: startY,
                endY: endY,
                name: name)
            
            vectorCreated?(vector)
            vectors.append(vector)
            vectorManager.createVector(
                uuid: uuid,
                startX: startX,
                endX: endX,
                startY: startY,
                endY: endY,
                name: name,
                color: vector.color)
        return vector
    }
}
