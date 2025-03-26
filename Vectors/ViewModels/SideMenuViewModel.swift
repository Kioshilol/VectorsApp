import Foundation

final class SideMenuViewModel: BaseViewModel {
    private let vectorService: VectorServiceProtocol = CompositionRoot.shared.resolve(VectorServiceProtocol.self)
    private var vectorManager: VectorManagerProtocol = CompositionRoot.shared.resolve(VectorManagerProtocol.self)
    
    @Published private(set) var vectors: [VectorItemViewModel] = []
    
    func refreshItems() {
        vectors = vectorService.vectors
    }
    
    func deleteVector(uuid: UUID) {
        vectors = vectors.filter({ $0.uuid != uuid })
        vectorManager.deleteVector(uuid: uuid)
    }
}
