import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = SettingsViewModel();
    
    var body: some View {
        VStack(spacing: 10){
            
            Text("Enter horizontal threshold")
            TextField("0", text: $viewModel.horizontalThreshold)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
                .padding(.bottom)
            
            Text("Enter vertical threshold")
            TextField("0", text: $viewModel.verticalThreshold)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
                .padding(.bottom)
            
            Text("Enter stick threshold")
            TextField("0", text: $viewModel.stickThreshold)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
                .padding(.bottom)
            
            Text("Enter right angle threshold")
            TextField("0", text: $viewModel.rightAngleThreshold)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
                .padding(.bottom)
            
            Button(action : saveSettings){
                    Text("Save")
                }
            
            Text(viewModel.errorText)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.red)
        }
    }
    
    //TODO: dont like it IMRPOVE cus of i have no custom navigation i did it (move logic to viewmodel)
    func saveSettings(){
        let isSaved = viewModel.trySaveSettings()
        if (!isSaved){
           return
        }
        
       
        self.presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    SettingsView()
}
