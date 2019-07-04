
import UIKit
import Charts

class DetailScreenVC: UIViewController, GraphModelDelegate {
    
    @IBOutlet weak var symbolValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var dayPeakPriceValueLabel: UILabel!
    @IBOutlet weak var dayLowestPriceValueLabel: UILabel!
    @IBOutlet weak var finalPriceValueLabel: UILabel!
    @IBOutlet weak var volumeValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var detailNavigationBar: UINavigationBar!
    
    @IBOutlet weak var graphView: BarChartView!
    
    var graphPriceValuesArray = [Double]()
    var graphMonthTitlesArray = [String]()
    
    var symbolLabel: String?
    var priceLabel: String?
    var differenceLabel: String?
    var differenceValue: Double?
    var dayPeakPriceLabel: String?
    var dayLowestPriceLabel: String?
    var volumeLabel: String?
    var totalLabel: String?
    
    var navBarTitle: String?
    
    var networkObj = NetworkService()
    var sentRequestKey: String?
    
    var graphDataArray = [GraphModel]()
    
    override func viewDidLoad() { super.viewDidLoad()
        
        symbolValueLabel.text = symbolLabel ?? ""
        priceValueLabel.text = priceLabel ?? ""
        differenceValueLabel.text = differenceLabel ?? ""
        
        if let differenceDouble = differenceValue {
            
            if differenceDouble < 0 {
                
                differenceValueLabel.textColor = .red
                
            }else if differenceDouble > 0 {
                
                differenceValueLabel.textColor = UIColor(red: 0, green: 172/255, blue: 4/255, alpha: 1)
                
            }
            
        }
        
        dayPeakPriceValueLabel.text = dayPeakPriceLabel ?? ""
        dayLowestPriceValueLabel.text = dayLowestPriceLabel ?? ""
        
        volumeValueLabel.text = volumeLabel ?? ""
        totalValueLabel.text = totalLabel ?? ""
        
        detailNavigationBar.topItem?.title = navBarTitle
        
        if InternetService.isConnected() {
            
            networkObj.graphModelDelegate = self
            
            let symbolName = symbolLabel ?? ""
            networkObj.fetchGraphDetails(for: symbolName, requestKey: sentRequestKey)
            
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
    
    func dataIsReadyForGraphModel(data: [GraphModel]) {
        
        graphDataArray = data
        
        if graphDataArray.count > 0 {
            
            if let finalPriceText = graphDataArray[0].price {
                
                DispatchQueue.main.async {
                    
                    self.finalPriceValueLabel.text = "\(finalPriceText)"
                    
                }
            }
            
            for i in graphDataArray {
                
                if let elementPrice = i.price {
                    
                    graphPriceValuesArray.append(elementPrice)
                    
                }else{
                    
                    graphPriceValuesArray.append(0)
                    
                }
                
                if let elementDate = i.date {
                    
                    let newElementDate = NSString(string: elementDate)
                    
                    var month = NSString(string: newElementDate.substring(from: 5)).substring(to: 2)
                    
                    switch month {
                        
                    case "01":
                        month = "Oca"
                        
                    case "02":
                        month = "Şub"
                        
                    case "03":
                        month = "Mar"
                        
                    case "04":
                        month = "Nis"
                        
                    case "05":
                        month = "May"
                        
                    case "06":
                        month = "Haz"
                        
                    case "07":
                        month = "Tem"
                        
                    case "08":
                        month = "Ağu"
                        
                    case "09":
                        month = "Eyl"
                        
                    case "10":
                        month = "Eki"
                        
                    case "11":
                        month = "Kas"
                        
                    case "12":
                        month = "Ara"
                        
                    default:
                        month = ""
                        
                    }
                    
                    graphMonthTitlesArray.append(month)
                    
                }else{
                    
                    graphMonthTitlesArray.append("")
                    
                }
            }
            
            graphPriceValuesArray = graphPriceValuesArray.reversed()
            graphMonthTitlesArray = graphMonthTitlesArray.reversed()
            
            DispatchQueue.main.async {
                
                self.graphView.setChartValues(xAxisValues: self.graphMonthTitlesArray,
                                              values: self.graphPriceValuesArray,
                                              label: "Fiyatlar")
                
            }
            
        }else{
            
            DispatchQueue.main.async {
                
                self.finalPriceValueLabel.text = ""
                
            }
        }
    }
}
