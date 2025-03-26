import SwiftUI

struct SideMenuView: View {
    
    @StateObject private var viewModel = SideMenuViewModel();
    
    @Binding var isShow: Bool
    
    var vectorAction: ((UUID, VectorAction) -> Void)?
    
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
                    
                    HStack {
                        List {
                            ForEach(viewModel.vectors) { (vector: VectorItemViewModel) in
            
                                HStack {
                                    
                                    VStack {
                                        Text(vector.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .multilineTextAlignment(.center)
                                        Text("Start")
                                            .font(.system(size: 16))
                                            .multilineTextAlignment(.center)
                                        Text("""
                                             x: \(vector.startX)
                                             y: \(vector.startY)
                                            """)
                                            .font(.system(size: 12))
                                        Text("End")
                                            .font(.system(size: 16))
                                            .multilineTextAlignment(.center)
                                        Text("""
                                             x: \(vector.endX)
                                             y: \(vector.endY)
                                            """)
                                            .font(.system(size: 12))
                                        Text("Distance")
                                            .font(.system(size: 16))
                                            .multilineTextAlignment(.center)
                                        Text(vector.distance)
                                            .font(.system(size: 12))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "trash")
                                        .padding(4)
                                        .onTapGesture(perform: {
                                            viewModel.deleteVector(uuid: vector.uuid)
                                            vectorAction?(vector.uuid, .delete)
                                    })
                                }
                                .onTapGesture(perform: {
                                    isShow.toggle()
                                    vectorAction?(vector.uuid, .select)
                                })
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                            }
                        }
                        .background(Color.white)
                        //I made width 1/2.1 of screen becouse 1/3 of screen too low
                        .frame(width: geometry.size.width / 2.1, alignment: .leading)
                        .listRowSpacing(16)
                        
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
