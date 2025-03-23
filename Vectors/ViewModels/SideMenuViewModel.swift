import Foundation

class SideMenuViewModel: ObservableObject{
    
    private let vectorService: VectorServiceProtocol = CompositionRoot.shared.resolve(VectorServiceProtocol.self)
    
    @Published var vectors: [VectorItemViewModel] = []
    
    func refreshItems(){
        vectors = vectorService.vectors
    }
}
