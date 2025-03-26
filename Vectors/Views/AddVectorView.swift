import SwiftUI

struct AddVectorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = AddVectorViewModel();
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text("Enter name")
            TextField("0", text: $viewModel.name)
                .frame(width: 100, height: nil, alignment: .center)
                .padding(.bottom)
            
            Text("Enter start X")
            TextField("0", text: $viewModel.startX)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
            
            Text("Enter start Y")
            TextField("0", text: $viewModel.startY)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
            
            Text("Enter end X")
            TextField("0", text: $viewModel.endX)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
            
            Text("Enter end Y")
            TextField("0", text: $viewModel.endY)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
            
            Button(action : createButtonAction){
                    Text("Create")
                }
            
            Text(viewModel.errorText)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.red)
        }
    }
    
    //TODO: dont like it IMRPOVE cus of i have no custom navigation i did it (move logic to viewmodel)
    func createButtonAction(){
        let isCreated = viewModel.tryCreateVector()
        if(!isCreated){
           return
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
}


#Preview {
    AddVectorView()
}
