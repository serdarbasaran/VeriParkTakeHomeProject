
import UIKit

class ListScreenVC: UIViewController, HisseModelDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listSearchBar: UISearchBar!
    @IBOutlet weak var titlesTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var listNavigationBar: UINavigationBar!
    
    var hisselerListArray = [HisseModel]()
    var hisselerSearchArray = [HisseModel]()
    
    var networkObj = NetworkService()
    var fetchedRequestKey: String?
    
    var comingFromYukselenler = false
    var comingFromDusenler = false
    var comingFromHacmeGore30 = false
    var comingFromHacmeGore50 = false
    var comingFromHacmeGore100 = false
    
    var navBarTitle: String?
    
    var searchBarIsHidden = true
    
    override func viewDidLoad() { super.viewDidLoad()
        
        listSearchBar.delegate = self
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        if searchBarIsHidden {
            
            listSearchBar.isHidden = true
            titlesTopConstraint.constant = -56
            
        }
        
        listNavigationBar.topItem?.title = navBarTitle
        
        if InternetService.isConnected() {
            
            networkObj.hisseModelDelegate = self
            networkObj.fetchData()
            
        }else{
            
            AlertService.showAlert(viewController: self,
                                   title: "Bağlantı Hatası",
                                   message: "Lütfen internet bağlantınızı kontrol edip tekrar deneyiniz.",
                                   button: "Tamam")
            
        }
    }
    
    @IBAction func geriButtonTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func dataIsReadyForHisseModel(data: [HisseModel], requestKey: String?) {
        
        hisselerListArray = data
        
        fetchedRequestKey = requestKey
        
        if comingFromYukselenler {
            
            hisselerSearchArray = hisselerListArray.filter({ (arrayElement) -> Bool in
                
                guard let differenceValue = arrayElement.difference else { return false }
                
                if differenceValue > 0 {
                    
                    return true
                    
                }else{
                    
                    return false
                    
                }
            })
            
        }else if comingFromDusenler {
            
            hisselerSearchArray = hisselerListArray.filter({ (arrayElement) -> Bool in
                
                guard let differenceValue = arrayElement.difference else { return false }
                
                if differenceValue < 0 {
                    
                    return true
                    
                }else{
                    
                    return false
                    
                }
            })
            
        }else if comingFromHacmeGore30 {
            
            hisselerSearchArray = hisselerListArray.filter({ (arrayElement) -> Bool in
                
                guard let volumeValue = arrayElement.volume else { return false }
                
                if volumeValue <= 30000 {
                    
                    return true
                    
                }else{
                    
                    return false
                    
                }
            })
            
        }else if comingFromHacmeGore50 {
            
            hisselerSearchArray = hisselerListArray.filter({ (arrayElement) -> Bool in
                
                guard let volumeValue = arrayElement.volume else { return false }
                
                if volumeValue <= 50000 {
                    
                    return true
                    
                }else{
                    
                    return false
                    
                }
            })
            
        }else if comingFromHacmeGore100 {
            
            hisselerSearchArray = hisselerListArray.filter({ (arrayElement) -> Bool in
                
                guard let volumeValue = arrayElement.volume else { return false }
                
                if volumeValue <= 100000 {
                    
                    return true
                    
                }else{
                    
                    return false
                    
                }
            })
            
        }else{
            
            hisselerSearchArray = hisselerListArray
            
        }
        
        DispatchQueue.main.async {
            
            self.listTableView.reloadData()
            
        }
    }
}

extension ListScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hisselerSearchArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as? CustomCell else { return UITableViewCell() }
        
        let rowObject = hisselerSearchArray[indexPath.row]
        
        cell.label1.text = rowObject.symbol
        
        if let priceText = rowObject.price {
            
            cell.label2.text = "\(priceText)"
            
        }else{
            
            cell.label2.text = ""
            
        }
        
        if let differenceText = rowObject.difference {
            
            cell.label3.text = "\(differenceText)"
            
            if differenceText < 0 {
                
                cell.label3.textColor = .red
                
            }else if differenceText > 0 {
                
                cell.label3.textColor = UIColor(red: 0, green: 172/255, blue: 4/255, alpha: 1)
                
            }else{
                
                cell.label3.textColor = .black
                
            }
            
        }else{
            
            cell.label3.text = ""
            
        }
        
        if let volumeText = rowObject.volume {
            
            cell.label4.text = "\(volumeText)"
            
        }else{
            
            cell.label4.text = ""
            
        }
        
        if let buyingText = rowObject.buying {
            
            cell.label5.text = "\(buyingText)"
            
        }else{
            
            cell.label5.text = ""
            
        }
        
        if let sellingText = rowObject.selling {
            
            cell.label6.text = "\(sellingText)"
            
        }else{
            
            cell.label6.text = ""
            
        }
        
        if let hourText = rowObject.hour {
            
            cell.label7.text = "\(hourText)"
            
            let hourString = "\(hourText)"
            
            if hourString.count == 6 {
                
                let newHourText = NSString(string: hourString)
                
                let hour = newHourText.substring(to: 2)
                let minute = NSString(string: newHourText.substring(from: 2)).substring(to: 2)
                let second = NSString(string: newHourText.substring(from: 4)).substring(to: 2)
                
                cell.label7.text = "\(hour):\(minute):\(second)"
                
            }else{
                
                cell.label7.text = ""
                
            }
            
        }else{
            
            cell.label7.text = ""
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailScreenVC = storyboard?.instantiateViewController(withIdentifier: "DetailScreenVCID") as? DetailScreenVC else { return }
        
        detailScreenVC.sentRequestKey = fetchedRequestKey
        
        let selectedObject = hisselerSearchArray[indexPath.row]
        
        detailScreenVC.symbolLabel = selectedObject.symbol ?? ""
        
        if let priceText = selectedObject.price {
            
            detailScreenVC.priceLabel = "\(priceText)"
            
        }else{
            
            detailScreenVC.priceLabel = ""
            
        }
        
        if let differenceTextAndValue = selectedObject.difference {
            
            detailScreenVC.differenceLabel = "\(differenceTextAndValue)"
            detailScreenVC.differenceValue = differenceTextAndValue
            
        }else{
            
            detailScreenVC.differenceLabel = ""
            detailScreenVC.differenceValue = 0
            
        }
        
        if let dayPeakPriceText = selectedObject.dayPeakPrice {
            
            detailScreenVC.dayPeakPriceLabel = "\(dayPeakPriceText)"
            
        }else{
            
            detailScreenVC.dayPeakPriceLabel = ""
            
        }
        
        if let dayLowestPriceText = selectedObject.dayLowestPrice {
            
            detailScreenVC.dayLowestPriceLabel = "\(dayLowestPriceText)"
            
        }else{
            
            detailScreenVC.dayLowestPriceLabel = ""
            
        }
        
        if let volumeText = selectedObject.volume {
            
            detailScreenVC.volumeLabel = "\(volumeText)"
            
        }else{
            
            detailScreenVC.volumeLabel = ""
            
        }
        
        if let totalText = selectedObject.total {
            
            detailScreenVC.totalLabel = "\(totalText)"
            
        }else{
            
            detailScreenVC.totalLabel = ""
            
        }
        
        let navBarTitleToShow = selectedObject.symbol ?? "Sembol"
        detailScreenVC.navBarTitle = "\(navBarTitleToShow) Detay"
        
        navigationController?.pushViewController(detailScreenVC, animated: true)
        
    }
}

extension ListScreenVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            
            hisselerSearchArray = hisselerListArray
            
            listTableView.reloadData()
            
            return
            
        }
        
        hisselerSearchArray = hisselerListArray.filter { (arrayElement) -> Bool in
            
            guard let symbolTitle = arrayElement.symbol else { return false }
            
            if symbolTitle.uppercased().contains(searchText.uppercased()) {
                
                return true
                
            }else{
                
                return false
                
            }
        }
        
        listTableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
    }
}
