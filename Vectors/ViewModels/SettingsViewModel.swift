import Foundation

final class SettingsViewModel: BaseViewModel {
    private var vectorHandler: VectorHelperProtocol = CompositionRoot.shared.resolve(VectorHelperProtocol.self)
    
    @Published var horizontalThreshold: String = "";
    @Published var verticalThreshold: String = "";
    @Published var stickThreshold: String = "";
    @Published var rightAngleThreshold: String = "";
    @Published var errorText: String = "";
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    override func initialize() {
        verticalThreshold = String(describing: userDefaults.value(
            forKey: Constants.UserDefaultKeys.verticalThresholdKey) as? Int ?? 0)
        horizontalThreshold = String(describing: userDefaults.value(
            forKey: Constants.UserDefaultKeys.horizontalThresholdKey) as? Int ?? 0)
        stickThreshold = String(describing: userDefaults.value(
            forKey: Constants.UserDefaultKeys.stickThresholdKey) as? Int ?? 0)
        rightAngleThreshold = String(describing: userDefaults.value(
            forKey: Constants.UserDefaultKeys.rightAngleThresholdKey) as? Int ?? 0)
    }
    
    func trySaveSettings() -> Bool {
        errorText = ""
        
        guard let horizontalThresholdValue = Double(horizontalThreshold) else {
            errorText = "Wrong horizontal threshold"
            return false
        }
        
        guard let verticalThresholdValue = Double(verticalThreshold) else {
            errorText = "Wrong vertical threshold"
            return false
        }
        
        guard let stickThresholdValue = Double(stickThreshold) else {
            errorText = "Wrong stick threshold"
            return false
        }
        
        guard let rightAngleThresholdValue = Double(rightAngleThreshold) else {
            errorText = "Wrong right angle threshold"
            return false
        }
        
        let userDefault = UserDefaults.standard
        userDefault.set(
            horizontalThresholdValue,
            forKey: Constants.UserDefaultKeys.horizontalThresholdKey)
        
        userDefault.set(
            verticalThresholdValue,
            forKey: Constants.UserDefaultKeys.verticalThresholdKey)
        
        userDefault.set(
            stickThresholdValue,
            forKey: Constants.UserDefaultKeys.stickThresholdKey)
        
        userDefault.set(
            rightAngleThresholdValue,
            forKey: Constants.UserDefaultKeys.rightAngleThresholdKey)
        
        //TODO: imrpove, i did it becouse dont fetch minimal values from userdefault everytime when user move vector
        vectorHandler.requestUpdateVectorSettings()
        
        return true
    }
}
