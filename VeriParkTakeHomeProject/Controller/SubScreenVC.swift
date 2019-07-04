
import UIKit

class SubScreenVC: UIViewController {
    
    @IBOutlet weak var subButton1: UIButton!
    @IBOutlet weak var subButton2: UIButton!
    @IBOutlet weak var subButton3: UIButton!
    @IBOutlet weak var subButton4: UIButton!
    
    override func viewDidLoad() { super.viewDidLoad()
        
        subButton1.layer.cornerRadius = subButton1.frame.height / 2
        subButton2.layer.cornerRadius = subButton2.frame.height / 2
        subButton3.layer.cornerRadius = subButton3.frame.height / 2
        subButton4.layer.cornerRadius = subButton4.frame.height / 2
        
    }
    
    @IBAction func geriButtonTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func subButtonTapped(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 1:
            guard let listScreenVC = storyboard?.instantiateViewController(withIdentifier: "ListScreenVCID") as? ListScreenVC else { return }
            
            listScreenVC.navBarTitle = "Hisse ve Endeksler"
            
            navigationController?.pushViewController(listScreenVC, animated: true)
            
        case 2:
            guard let listScreenVC = storyboard?.instantiateViewController(withIdentifier: "ListScreenVCID") as? ListScreenVC else { return }
            
            listScreenVC.comingFromYukselenler = true
            listScreenVC.navBarTitle = "Yükselenler"
            
            navigationController?.pushViewController(listScreenVC, animated: true)
            
        case 3:
            guard let listScreenVC = storyboard?.instantiateViewController(withIdentifier: "ListScreenVCID") as? ListScreenVC else { return }
            
            listScreenVC.comingFromDusenler = true
            listScreenVC.navBarTitle = "Düşenler"
            
            navigationController?.pushViewController(listScreenVC, animated: true)
            
        case 4:
            guard let subVolumeScreenVC = storyboard?.instantiateViewController(withIdentifier: "SubVolumeScreenVCID") as? SubVolumeScreenVC else { return }
            
            navigationController?.pushViewController(subVolumeScreenVC, animated: true)
            
        default:
            AlertService.showAlert(viewController: self, title: "Hata Oluştu",
                                   message: "Lütfen tekrar deneyiniz.",
                                   button: "Tamam")
            
        }
    }
}
