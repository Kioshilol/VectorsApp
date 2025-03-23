import SwiftUI

struct SideMenuView: View {
    
    @StateObject private var viewModel = SideMenuViewModel();
    
    @Binding var isShow: Bool
    
    var vectorSelected: ((ObjectIdentifier) -> Void)?
    
    var body: some View {
        
        GeometryReader{ geometry in
            
            ZStack{
                if isShow {
                    Rectangle()
                        .opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isShow.toggle()
                        }
                    
                    HStack{
                        List{
                            ForEach(viewModel.vectors) { (vector: VectorItemViewModel) in
                                
                                Button(vector.name, action: {
                                    isShow.toggle()
                                    vectorSelected?(vector.id)
                                })
                            }
                        }
                        .background(Color.white)
                        .frame(width: geometry.size.width / 3, alignment: .leading)
                        .listRowSpacing(10)
                        
                        Spacer()
                    }
                    .transition(.move(edge: .leading))
                }
            }
        }
        .transition(.move(edge: .leading))
        .animation(.easeInOut, value: isShow)
        .onAppear(){
            viewModel.refreshItems()
        }
    }
}

#Preview {
    SideMenuView(isShow: .constant(true))
}
