import Foundation

final class MainViewModel: BaseViewModel {
    public var vectorService: VectorServiceProtocol = CompositionRoot.shared.resolve(VectorServiceProtocol.self)
    
    @Published var vectors: [VectorItemViewModel] = []
    
    override func initialize() {
        vectorService.requestRefreshVectors()
        vectors = vectorService.vectors
    }
}
