import SwiftUI
import SpriteKit

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = MainViewModel();
    
    @State private var menuVisible = false
    
    private let vectorsScene = VectorsScene()
    
    var body: some View {
        NavigationView() {
        
            GeometryReader{ geometry in
                
                SpriteView(scene: vectorsScene);
                
                SideMenuView(
                    isShow: $menuVisible,
                    vectorAction: vectorsScene.vectorAction)
                
                NavigationLink(destination: AddVectorView()){
                    
                    Image(systemName: "plus")
                        .resizable()
                        .padding(16)
                        .foregroundColor(.white)
                        .background(.blue)
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .position(x: geometry.size.width - 50, y: geometry.size.height - 20)
                
                
                HStack {
                    Button(action: {
                        menuVisible.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .padding()
                    })
                    .opacity(menuVisible ? 0 : 1)
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .padding()
                    }
                }
 
            }
        }
        .onAppear() {
            //TODO: dont like it IMRPOVE
            viewModel.vectorService.vectorCreated = vectorsScene.drawVector
            
            vectorsScene.size = CGSize(width: 500, height: 1000)
            vectorsScene.scaleMode = .fill
            
            vectorsScene.initializeVectors(vectors: viewModel.vectors)
        }
    }
}

#Preview {
    MainView()
}
