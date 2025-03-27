import Foundation

final class SettingsViewModel: BaseViewModel {
    private var vectorHandler: VectorHelperProtocol = CompositionRoot.shared.resolve(VectorHelperProtocol.self)
    
    @Published var minimalHorizontalThreshold: String = "";
    @Published var minimalVerticalThreshold: String = "";
    @Published var minimalStickThreshold: String = "";
    @Published var errorText: String = "";
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    override func initialize() {
        minimalVerticalThreshold = String(describing: userDefaults.value(
            forKey: Constants.UserDefaultKeys.minimalVerticalThresholdKey) as? Int ?? 0)
        minimalHorizontalThreshold = String(describing: userDefaults.value(
            forKey: Constants.UserDefaultKeys.minimalHorizontalThresholdKey) as? Int ?? 0)
        minimalStickThreshold = String(describing: userDefaults.value(
            forKey: Constants.UserDefaultKeys.minimalStickThresholdKey) as? Int ?? 0)
    }
    
    func trySaveSettings() -> Bool {
        errorText = ""
        
        guard let minimalHorizontalThresholdValue = Double(minimalHorizontalThreshold) else {
            errorText = "Wrong minimal horizontal threshold"
            return false
        }
        
        guard let minimalVerticalThresholdValue = Double(minimalVerticalThreshold) else {
            errorText = "Wrong minimal vertical threshold"
            return false
        }
        
        guard let minimalStickThresholdValue = Double(minimalStickThreshold) else {
            errorText = "Wrong minimal stick threshold"
            return false
        }
        
        let userDefault = UserDefaults.standard
        userDefault.set(
            minimalHorizontalThresholdValue,
            forKey: Constants.UserDefaultKeys.minimalHorizontalThresholdKey)
        
        userDefault.set(
            minimalVerticalThresholdValue,
            forKey: Constants.UserDefaultKeys.minimalVerticalThresholdKey)
        
        userDefault.set(
            minimalStickThresholdValue,
            forKey: Constants.UserDefaultKeys.minimalStickThresholdKey)
        
        //TODO: imrpove, i did it becouse dont fetch minimal values from userdefault everytime when user move vector
        vectorHandler.requestUpdateVectorSettings()
        
        return true
    }
}
