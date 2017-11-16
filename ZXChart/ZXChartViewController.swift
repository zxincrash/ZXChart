//
//  ZXChartViewController.swift
//  ZXChart
//
//  Created by zhaoxin on 2017/11/15.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

import UIKit

class ZXChartViewController: UIViewController {
    var chart:ZXChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.createUI()
    }

    func createUI(){
        self.chart = ZXChartView.createUI(frame: CGRect.init(x: 0, y: 64, width: view.frame.width, height: 180))
        chart.xValues = ["30", "60", "90", "120", "150", "180", "210", "240", "270", "300"]
        chart.yValues = ["35", "5", "40", "50", "13", "50", "75", "25", "100", "64","95", "33", "100"]
        view.addSubview(self.chart)
        
        self.chart.isShowValue = true
        self.chart.isShowPoit = true
        self.chart.isShowPillar = true
        self.chart.isShowLine = true
        
        self.chart.drawChart(lineType: .LineChartType_Curve, pointType: .PointType_Circel)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
