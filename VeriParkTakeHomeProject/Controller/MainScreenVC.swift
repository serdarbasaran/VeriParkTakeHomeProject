
import UIKit

class MainScreenVC: UIViewController {
    
    @IBOutlet weak var mainButton: UIButton!
    
    override func viewDidLoad() { super.viewDidLoad()
        
        mainButton.layer.cornerRadius = mainButton.frame.height / 2
        
    }
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        
        guard let subScreenVC = storyboard?.instantiateViewController(withIdentifier: "SubScreenVCID") as? SubScreenVC else { return }
        
        navigationController?.pushViewController(subScreenVC, animated: true)
        
    }
}
