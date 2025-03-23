import SwiftUI
import SpriteKit

struct MainView: View {
    
    private var vectorService: VectorServiceProtocol = CompositionRoot.shared.resolve(VectorServiceProtocol.self)
    
    @State private var menuVisible = false
    
    private let vectorsScene = VectorsScene()
    
    init() {
        vectorService.vectorCreated = vectorsScene.drawVector
        
        setupScene()
    }
    
    var body: some View {
        NavigationView(){
        
            GeometryReader{ geometry in
                
                SpriteView(scene: vectorsScene);
                
                SideMenuView(
                    isShow: $menuVisible,
                    vectorSelected: vectorsScene.selectVector)
                
                NavigationLink(destination: AddVectorView()){
                    
                    Image(systemName: "plus")
                        .resizable()
                        .padding(16)
                        .foregroundColor(.white)
                        .background(.blue)
                        .tint(Color.blue)
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .position(x: geometry.size.width - 50, y: geometry.size.height - 20)
                
                Button(action: {
                    menuVisible.toggle()
                }, label: {
                    Image(systemName: "line.3.horizontal")
                        .padding()
                })
                .opacity(menuVisible ? 0 : 1)
            }
        }
    }
    
    private func setupScene(){
        vectorsScene.size = CGSize(width: 500, height: 1000)
        vectorsScene.scaleMode = .fill
    }
}

#Preview {
    MainView()
}
