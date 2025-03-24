import Swinject

final class CompositionRoot{
    static let shared = CompositionRoot();
    let container: Container
    
    private init(){
        container = Container();
        registerDependencies();
    }
    
    func resolve<T>(_ type: T.Type) -> T{
        guard let dependency = container.resolve(type) else {
            fatalError("Failed to resolve dependency: \(type)")
        }
        return dependency;
    }
    
    private func registerDependencies(){
        container.register(VectorManagerProtocol.self) { _ in VectorManager() }
            .inObjectScope(.container)
        container.register(VectorServiceProtocol.self) { _ in VectorService() }
            .inObjectScope(.container)
        container.register(VectorHandlerProtocol.self) { _ in VectorHandler() }
            .inObjectScope(.container)
        container.register(VectorFactoryProtocol.self) { _ in VectorFactory() }
            .inObjectScope(.container)
    }
}
