import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = SettingsViewModel();
    
    var body: some View {
        VStack(spacing: 10){
            
            Text("Enter minimal horizontal threshold")
            TextField("0", text: $viewModel.minimalHorizontalThreshold)
                .keyboardType(.numberPad)
                .frame(width: 100, height: nil, alignment: .center)
                .padding(.bottom)
            
            Text("Enter minimal vertical threshold")
            TextField("0", text: $viewModel.minimalVerticalThreshold)
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
