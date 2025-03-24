final class VectorService: VectorServiceProtocol {
    private lazy var vectorManager: VectorManagerProtocol = CompositionRoot.shared.resolve(VectorManagerProtocol.self)
    
    var vectors: [VectorItemViewModel] = []
    var vectorCreated: ((VectorItemViewModel) -> Void)?
    
    func createVector(
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String) -> VectorItemViewModel {
        let vector = VectorItemViewModel(
            startX: startX,
            endX: endX,
            startY: startY,
            endY: endY,
            name: name)
            
        vectorCreated?(vector)
        vectors.append(vector)
        vectorManager.saveVector(
            startX: startX,
            endX: endX,
            startY: startY,
            endY: endY,
            name: name,
            color: vector.color)
        return vector
    }
}
