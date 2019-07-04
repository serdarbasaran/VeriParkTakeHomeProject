
import UIKit

class SubVolumeScreenVC: UIViewController {
    
    @IBOutlet weak var subVolumeButton1: UIButton!
    @IBOutlet weak var subVolumeButton2: UIButton!
    @IBOutlet weak var subVolumeButton3: UIButton!
    
    override func viewDidLoad() { super.viewDidLoad()
        
        subVolumeButton1.layer.cornerRadius = subVolumeButton1.frame.height / 2
        subVolumeButton2.layer.cornerRadius = subVolumeButton2.frame.height / 2
        subVolumeButton3.layer.cornerRadius = subVolumeButton3.frame.height / 2
        
    }
    
    @IBAction func geriButtonTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func subVolumeButtonTapped(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 1:
            guard let listScreenVC = storyboard?.instantiateViewController(withIdentifier: "ListScreenVCID") as? ListScreenVC else { return }
            
            listScreenVC.comingFromHacmeGore30 = true
            listScreenVC.navBarTitle = "IMKB - 30"
            
            navigationController?.pushViewController(listScreenVC, animated: true)
            
        case 2:
            guard let listScreenVC = storyboard?.instantiateViewController(withIdentifier: "ListScreenVCID") as? ListScreenVC else { return }
            
            listScreenVC.comingFromHacmeGore50 = true
            listScreenVC.navBarTitle = "IMKB - 50"
            
            navigationController?.pushViewController(listScreenVC, animated: true)
            
        case 3:
            guard let listScreenVC = storyboard?.instantiateViewController(withIdentifier: "ListScreenVCID") as? ListScreenVC else { return }
            
            listScreenVC.comingFromHacmeGore100 = true
            listScreenVC.navBarTitle = "IMKB - 100"
            listScreenVC.searchBarIsHidden = false
            
            navigationController?.pushViewController(listScreenVC, animated: true)
            
        default:
            AlertService.showAlert(viewController: self, title: "Hata Oluştu",
                                   message: "Lütfen tekrar deneyiniz.",
                                   button: "Tamam")
            
        }
    }
}
