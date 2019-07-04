
import UIKit

class NetworkService: NSObject {
    
    var hisselerFetchedArray = [HisseModel]()
    var hisseObj: HisseModel?
    
    var graphsFetchedarray = [GraphModel]()
    var graphObj: GraphModel?
    
    var requestKeyValue: String?
    var requestKeyValueFound = false
    
    var symbolValueFound = false
    var priceValueFound = false
    var differenceValueFound = false
    var volumeValueFound = false
    var buyingValueFound = false
    var sellingValueFound = false
    var hourValueFound = false
    var dayPeakPriceValueFound = false
    var dayLowestPriceValueFound = false
    var totalValueFound = false
    
    var graphPriceValueFound = false
    var graphDateValueFound = false
    
    var hisseModelDelegate: HisseModelDelegate?
    var graphModelDelegate: GraphModelDelegate?
    
    var isParsingForRequestKey = false
    var isParsingForValues = false
    var isParsingForGraphValues = false
    
    func fetchData() {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd:MM:yyyy HH:mm"
        
        let requestDate = formatter.string(from: Date())
        
        let soapRequest = """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
            <soap:Body>
                <Encrypt xmlns="http://tempuri.org/">
                    <request>RequestIsValid\(requestDate)</request>
                </Encrypt>
            </soap:Body>
        </soap:Envelope>
        """
        
        guard let url = URL(string: "http://mobileexam.veripark.com/mobileforeks/service.asmx") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.addValue("\(soapRequest.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = soapRequest.data(using: .utf8, allowLossyConversion: false)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            guard response != nil else { return }
            guard error == nil else { return }
            
            self.isParsingForRequestKey = true
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
            guard let requestKey = self.requestKeyValue else { return }
            
            self.fetchDataDetails(requestKey: requestKey)
            
        }.resume()
    }
    
    func fetchDataDetails(requestKey: String) {
        
        let soapRequest = """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetForexStocksandIndexesInfo>
                        <tem:request>
                            <tem:IsIPAD>true</tem:IsIPAD>
                            <tem:DeviceID>test</tem:DeviceID>
                            <tem:DeviceType>ipad</tem:DeviceType>
                            <tem:RequestKey>\(requestKey)</tem:RequestKey>
                            <tem:Period>Day</tem:Period>
                        </tem:request>
                    </tem:GetForexStocksandIndexesInfo>
                </soapenv:Body>
        </soapenv:Envelope>
        """
        
        guard let url = URL(string: "http://mobileexam.veripark.com/mobileforeks/service.asmx") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.addValue("\(soapRequest.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = soapRequest.data(using: .utf8, allowLossyConversion: false)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            guard response != nil else { return }
            guard error == nil else { return }
            
            self.isParsingForValues = true
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        }.resume()
    }
    
    func fetchGraphDetails(for symbolName: String, requestKey: String?) {
        
        guard let requestKey = requestKey else { return }
        
        let soapRequest = """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetForexStocksandIndexesInfo>
                        <tem:request>
                            <tem:IsIPAD>true</tem:IsIPAD>
                            <tem:DeviceID>test</tem:DeviceID>
                            <tem:DeviceType>ipad</tem:DeviceType>
                            <tem:RequestKey>\(requestKey)</tem:RequestKey>
                            <tem:RequestedSymbol>\(symbolName)</tem:RequestedSymbol>
                            <tem:Period>Month</tem:Period>
                        </tem:request>
                    </tem:GetForexStocksandIndexesInfo>
                </soapenv:Body>
        </soapenv:Envelope>
        """
        
        guard let url = URL(string: "http://mobileexam.veripark.com/mobileforeks/service.asmx") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.addValue("\(soapRequest.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = soapRequest.data(using: .utf8, allowLossyConversion: false)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            guard response != nil else { return }
            guard error == nil else { return }
            
            self.isParsingForGraphValues = true
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        }.resume()
    }
}

extension NetworkService: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if isParsingForRequestKey {
            
            if elementName == "EncryptResult" {
                
                requestKeyValueFound = true
                
            }
            
        }else if isParsingForValues {
            
            switch elementName {
                
            case "StockandIndex":
                hisseObj = HisseModel()
                
            case "Symbol":
                symbolValueFound = true
                
            case "Price":
                priceValueFound = true
                
            case "Difference":
                differenceValueFound = true
                
            case "Volume":
                volumeValueFound = true
                
            case "Buying":
                buyingValueFound = true
                
            case "Selling":
                sellingValueFound = true
                
            case "Hour":
                hourValueFound = true
                
            case "DayPeakPrice":
                dayPeakPriceValueFound = true
                
            case "DayLowestPrice":
                dayLowestPriceValueFound = true
                
            case "Total":
                totalValueFound = true
                
            default:
                print("Gerekli Tag elemanı aranıyor...")
                
            }
            
        }else if isParsingForGraphValues {
            
            switch elementName {
                
            case "StockandIndexGraphic":
                graphObj = GraphModel()
                
            case "Price":
                graphPriceValueFound = true
                
            case "Date":
                graphDateValueFound = true
                
            default:
                print("Gerekli Tag elemanı aranıyor...")
                
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if requestKeyValueFound {
            
            requestKeyValue = string
            
        }
        
        if symbolValueFound {
            
            hisseObj?.symbol = string
            
        }
        
        if priceValueFound {
            
            if let priceValue = Double(string) {
                
                hisseObj?.price = priceValue
                
            }
        }
        
        if differenceValueFound {
            
            if let differenceValue = Double(string) {
                
                hisseObj?.difference = differenceValue
                
            }
        }
        
        if volumeValueFound {
            
            if let volumeValue = Double(string) {
                
                hisseObj?.volume = volumeValue
                
            }
        }
        
        if buyingValueFound {
            
            if let buyingValue = Double(string) {
                
                hisseObj?.buying = buyingValue
                
            }
        }
        
        if sellingValueFound {
            
            if let sellingValue = Double(string) {
                
                hisseObj?.selling = sellingValue
                
            }
        }
        
        if hourValueFound {
            
            if let hourValue = Int(string) {
                
                hisseObj?.hour = hourValue
                
            }
        }
        
        if dayPeakPriceValueFound {
            
            if let dayPeakPriceValue = Double(string) {
                
                hisseObj?.dayPeakPrice = dayPeakPriceValue
                
            }
        }
        
        if dayLowestPriceValueFound {
            
            if let dayLowestPriceValue = Double(string) {
                
                hisseObj?.dayLowestPrice = dayLowestPriceValue
                
            }
        }
        
        if totalValueFound {
            
            if let totalValue = Int(string) {
                
                hisseObj?.total = totalValue
                
            }
        }
        
        if graphPriceValueFound {
            
            if let graphPriceValue = Double(string) {
                
                graphObj?.price = graphPriceValue
                
            }
        }
        
        if graphDateValueFound {
            
            graphObj?.date = string
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        requestKeyValueFound = false
        
        symbolValueFound = false
        priceValueFound = false
        differenceValueFound = false
        volumeValueFound = false
        buyingValueFound = false
        sellingValueFound = false
        hourValueFound = false
        dayPeakPriceValueFound = false
        dayLowestPriceValueFound = false
        totalValueFound = false
        
        graphPriceValueFound = false
        graphDateValueFound = false
        
        if elementName == "StockandIndex" {
            
            guard let hisseObj = hisseObj else { return }
            
            hisselerFetchedArray.append(hisseObj)
            
        }else if elementName == "StockandIndexGraphic" {
            
            guard let graphObj = graphObj else { return }
            
            graphsFetchedarray.append(graphObj)
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        if isParsingForRequestKey {
            
            isParsingForRequestKey = false
            
        }else if isParsingForValues {
            
            hisseModelDelegate?.dataIsReadyForHisseModel(data: hisselerFetchedArray, requestKey: requestKeyValue)
            isParsingForValues = false
            
        }else if isParsingForGraphValues {
            
            graphModelDelegate?.dataIsReadyForGraphModel(data: graphsFetchedarray)
            isParsingForGraphValues = false
            
        }
    }
}
