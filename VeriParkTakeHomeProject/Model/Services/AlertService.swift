
import UIKit

class AlertService {
    
    static func showAlert(viewController: UIViewController, title: String, message: String, button: String) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: button, style: .default)
        
        controller.addAction(action)
        
        viewController.present(controller, animated: true)
        
    }
}
