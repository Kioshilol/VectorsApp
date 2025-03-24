import Foundation

final class MainViewModel: ObservableObject {
    
    private var vectorManager: VectorManagerProtocol = CompositionRoot.shared.resolve(VectorManagerProtocol.self)
    private var vectorFactory: VectorFactoryProtocol = CompositionRoot.shared.resolve(VectorFactoryProtocol.self)
    
    @Published var vectors: [VectorItemViewModel] = []
    
    init(){
        produceVectors()
    }
    
    private func produceVectors(){
        var entities = vectorManager.fetchVectors()
        vectors = vectorFactory.produceVectorItemViewModels(entities: entities)
    }
}
