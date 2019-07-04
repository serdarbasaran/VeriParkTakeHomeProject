
import Foundation
import Charts

extension BarChartView {
    
    class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var values: [String]
        
        required init (values: [String]) {
            
            self.values = values
            
            super.init()
            
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            
            return values[Int(value)]
            
        }
    }
    
    func setChartValues(xAxisValues: [String], values: [Double], label: String) {
        
        var barChartDataEntries = [BarChartDataEntry]()
        
        for i in 0 ..< values.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            
            barChartDataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(entries: barChartDataEntries, label: label)
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let formatter = BarChartFormatter(values: xAxisValues)
        
        let xAxisObj = XAxis()
        xAxisObj.valueFormatter = formatter
        
        self.xAxis.valueFormatter = xAxisObj.valueFormatter
        self.xAxis.labelPosition = .bottom
        self.xAxis.labelCount = xAxisValues.count
        self.xAxis.drawGridLinesEnabled = false
        
        self.rightAxis.enabled = false
        
        self.doubleTapToZoomEnabled = false
        self.pinchZoomEnabled = false
        self.dragEnabled = false
        self.setScaleEnabled(false)
        
        self.data = chartData
        self.data?.notifyDataChanged()
        self.notifyDataSetChanged()
        
        self.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .linear)
        
    }
}
