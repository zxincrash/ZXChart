//
//  ZXChartView.swift
//  ZXChart
//
//  Created by zhaoxin on 2017/11/15.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//

import UIKit

public enum LineChartType {
    case LineChartType_Straight
    case LineChartType_Curve

}

public enum PointType {
    case PointType_Rect
    case PointType_Circel
    
}

class ZXChartView: UIView {
    // x轴值
    var xValues:Array<String>!
    // y轴值
    var yValues:Array<String>!
    // 是否显示方格
    var isShowLine:Bool!
    // 是否显示点
    var isShowPoit:Bool!
    // 是否显示柱状图
    var isShowPillar:Bool!
    // 是否显示数据
    var isShowValue:Bool!
    // x轴值
    let kMargin:CGFloat = 30

    var myFrame:CGRect!
    var count:Int!  // 点个数，x轴格子数
    var yCount:Int!   // y轴格子数
    var everyX:CGFloat!  // x轴每个格子宽度
    var everyY:CGFloat!  // y轴每个格子高度
    var maxX:CGFloat!    //最大的x值
    var maxY:CGFloat!    // 最大的y值
    var allH:CGFloat!    // 整个图表高度
    var allW:CGFloat!    // 整个图表宽度
    
    var bgView:UIView!
    
    class func createUI(frame:CGRect) -> ZXChartView {
        let chartView:ZXChartView = ZXChartView.init(frame: frame)
        
        var rect:CGRect = frame
        rect.origin.x = 0
        rect.origin.y = 0
        chartView.myFrame = rect
        
        chartView.bgView = UIView.init(frame: rect)
        chartView.bgView.backgroundColor = UIColor.lightGray
        chartView.addSubview(chartView.bgView)
        return chartView
    }
    
    func caculateData(){
        if (self.xValues == nil || self.xValues.count == 0 || self.yValues == nil || self.yValues.count == 0) {
            return
        }
        
        // 移除多余的值，计算点个数
        if (self.xValues.count > self.yValues.count) {
            var xArr:Array<String> = self.xValues
            for _ in 0..<(self.xValues.count - self.yValues.count)
            {
                xArr.removeLast()
            }
            self.xValues = xArr
        }else if (self.xValues.count < self.yValues.count){
            var yArr:Array<String> = self.yValues
            for _ in 0..<(self.yValues.count - self.xValues.count)
            {
                yArr.removeLast()
            }
            self.yValues = yArr
        }
        
        count = self.xValues.count
        everyX = (CGFloat(myFrame.width) - kMargin*2)/CGFloat(count)
        maxX = CGFloat.leastNormalMagnitude
        
        yCount = count <= 5 ? count : 5
        everyY = (CGFloat(myFrame.height) - kMargin*2)/CGFloat(yCount)
        maxY = CGFloat.leastNormalMagnitude;

        for i in 0..<count
        {
            
            if (Float(self.xValues[i])! > Float(maxY)) {
                maxX = CGFloat(Float(self.xValues[i])!)
            }
            
        }
        
        for i in 0..<count
        {
            
            if (Float(self.yValues[i])! > Float(maxY)) {
                maxY = CGFloat(Float(self.yValues[i])!)
            }
            
        }
        
        allH = CGFloat(myFrame.height) - kMargin*2
        allW = CGFloat(myFrame.width)  - kMargin*2

    }
    
    
    /// 绘制x y轴
    func drawXYline(){
        let path:UIBezierPath = UIBezierPath()
        path.move(to: CGPoint.init(x: kMargin, y: kMargin/2.0 - 5.0))
        path.addLine(to: CGPoint.init(x: kMargin, y: myFrame.height  - kMargin))
        path.addLine(to: CGPoint.init(x: myFrame.width - kMargin*0.5+5.0, y: myFrame.height - kMargin))
        
        // 加箭头
        path.move(to: CGPoint.init(x: kMargin - 5.0, y: kMargin*0.5 + 4.0))
        path.addLine(to: CGPoint.init(x: kMargin, y: kMargin*0.5 - 4.0))
        path.addLine(to: CGPoint.init(x: kMargin + 5, y: kMargin*0.5 + 4))
        
        path.move(to: CGPoint.init(x: myFrame.width - kMargin*0.5 - 4.0, y: myFrame.height - kMargin - 5.0))
        path.addLine(to: CGPoint.init(x: myFrame.width - kMargin*0.5 + 5.0, y: myFrame.height - kMargin))
        path.addLine(to: CGPoint.init(x: myFrame.width - kMargin*0.5 - 4, y: myFrame.height - kMargin + 5.0))
        
        let layer:CAShapeLayer = CAShapeLayer.init()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.blue.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2.0
        self.bgView.layer.addSublayer(layer)
        
    }
    
    func drawLabels(){
        for i in 0..<yCount{
            let lab:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: kMargin  + everyY*CGFloat(i) - everyY*0.5, width: kMargin - 1, height: everyY))
            lab.textColor = .white
            lab.font = UIFont.systemFont(ofSize: 12)
            lab.textAlignment = NSTextAlignment.right
            lab.text = String(Int(Int(maxY) / yCount * (yCount - i)))
            self.bgView.addSubview(lab)
        }

        for i in 0..<count{
            let lab:UILabel = UILabel.init(frame: CGRect.init(x: kMargin + everyX*CGFloat(i+1) - everyX*0.5, y: myFrame.height - kMargin, width: everyX, height: kMargin))
            lab.textColor = .white
            lab.font = UIFont.systemFont(ofSize: 12)
            lab.textAlignment = NSTextAlignment.center
            lab.text = self.xValues[i]
            self.bgView.addSubview(lab)
        }
    }
    
    //画网格
    func drawLines(){
        let path:UIBezierPath = UIBezierPath()
        //横线
        for i in 0..<yCount{
            path.move(to: CGPoint.init(x: kMargin, y: kMargin + everyY*CGFloat(i)))
            path.addLine(to: CGPoint.init(x: kMargin + allW, y: kMargin + everyY*CGFloat(i)))
        }
        
        for i in 1..<count+1{
            path.move(to: CGPoint.init(x: kMargin+everyX*CGFloat(i), y: kMargin))
            path.addLine(to: CGPoint.init(x: kMargin+everyX*CGFloat(i), y: kMargin+allH))
        }
        
        let layer:CAShapeLayer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 0.5
        self.bgView.layer.addSublayer(layer)
        
    }
    
    
    /// 画点
    ///
    /// - Parameter pointType: 点类型
    func drawPointsWithPointType(pointType:PointType){
    // 画点
        switch pointType {
        case .PointType_Rect:
            for i in 0..<count{
                let xValue:CGFloat = CGFloat(Float(self.xValues[i])!)
                let yValue:CGFloat = CGFloat(Float(self.yValues[i])!)
                
                let point:CGPoint = CGPoint.init(x: kMargin + xValue*allW/maxX, y: kMargin + (1.0 - yValue/maxY)*allH)
                
                let layer:CAShapeLayer = CAShapeLayer()
                layer.frame = CGRect.init(x: point.x-2.5, y: point.y, width: 5, height: 5)
                layer.backgroundColor = UIColor.red.cgColor
                self.bgView.layer.addSublayer(layer)
            }
            break
        case .PointType_Circel:
            for i in 0..<count{
                let xValue:CGFloat = CGFloat(Float(self.xValues[i])!)
                let yValue:CGFloat = CGFloat(Float(self.yValues[i])!)

                let point:CGPoint = CGPoint.init(x: kMargin + xValue*allW/maxX, y: kMargin + (1.0 - yValue/maxY)*allH)
//                let path:UIBezierPath = UIBezierPath.init(arcCenter: CGPoint.init(x: point.x - 2.5, y: point.y - 2.5), radius: 2.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
                
                let path:UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: point.x-2.5, y: point.y-2.5, width: 5, height: 5), cornerRadius: 2.5)
                
                let layer:CAShapeLayer = CAShapeLayer()
                layer.path = path.cgPath
                layer.strokeColor = UIColor.red.cgColor
                layer.fillColor = UIColor.red.cgColor
                self.bgView.layer.addSublayer(layer)
            }
            break
        default:
            break
        }
    }
    
    //画柱状图
    func drawPillar(){
        
        for i in 0..<count{
            let xValue:CGFloat = CGFloat(Float(self.xValues[i])!)
            let yValue:CGFloat = CGFloat(Float(self.yValues[i])!)

            let point:CGPoint = CGPoint.init(x: kMargin + xValue*allW/maxX, y: kMargin + (1 - yValue/maxY)*allH)
            let width:CGFloat = everyX <= 20 ? 10 : 20
            
            let rect:CGRect = CGRect.init(x: point.x - width*0.5, y: point.y, width: width, height: myFrame.height - kMargin - point.y)
            
            let path:UIBezierPath = UIBezierPath.init(rect: rect)
            
            let layer:CAShapeLayer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = UIColor.white.cgColor
            layer.fillColor = UIColor.yellow.cgColor
            self.bgView.layer.addSublayer(layer)
            
            
        }
        
    }
    
    //画折线
    func drawFoldLine(type:LineChartType) {
        let path:UIBezierPath = UIBezierPath()
        
        let firstxValue:CGFloat = CGFloat(Float(self.xValues[0])!)
        let firstyYalue:CGFloat = CGFloat(Float(self.yValues[0])!)
        
        
        path.move(to: CGPoint.init(x: kMargin + firstxValue, y: kMargin + (1 - firstyYalue/maxY)*allH))
        switch type {
        case .LineChartType_Straight:
            for i in 1..<count{
                let xValue:CGFloat = CGFloat(Float(self.xValues[i])!)
                let yValue:CGFloat = CGFloat(Float(self.yValues[i])!)

                path.addLine(to: CGPoint.init(x: kMargin + xValue*allW/maxX, y: kMargin + (1 - yValue/maxY)*allH))
            }
            break
        case .LineChartType_Curve:
            for i in 1..<count{
                let prexValue:CGFloat = CGFloat(Float(self.xValues[i-1])!)
                let preyValue:CGFloat = CGFloat(Float(self.yValues[i-1])!)

                
                let xValue:CGFloat = CGFloat(Float(self.xValues[i])!)
                let yValue:CGFloat = CGFloat(Float(self.yValues[i])!)
                
                let prePoint:CGPoint = CGPoint.init(x: kMargin + prexValue*allW/maxX, y: kMargin + (1 - preyValue/maxY)*allH)
                let nowPoint:CGPoint = CGPoint.init(x: kMargin + xValue*allW/maxX, y: kMargin + (1 - yValue/maxY)*allH)

                let controlPoint1:CGPoint = CGPoint.init(x: (nowPoint.x+prePoint.x)/2,y: prePoint.y)
                let controlPoint2:CGPoint = CGPoint.init(x: (nowPoint.x+prePoint.x)/2,y: nowPoint.y)

                path.addCurve(to: nowPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
            break
        default:
            break
        }
        let layer:CAShapeLayer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.bgView.layer.addSublayer(layer)
    }
    
    //显示数据
    func drawValues(){
        for i in 0..<count{
            let xValue:CGFloat = CGFloat(Float(self.xValues[i])!)
            let yValue:CGFloat = CGFloat(Float(self.yValues[i])!)
            let nowPoint:CGPoint = CGPoint.init(x: kMargin + xValue*allW/maxX, y: kMargin + (1 - yValue/maxY)*allH)

            let lab:UILabel = UILabel.init(frame: CGRect.init(x: nowPoint.x  - 5, y: nowPoint.y - 20, width: 30, height: 20))
            lab.textColor = .gray
            lab.textAlignment = NSTextAlignment.center
            lab.text = String(describing: yValue)
            lab.font = UIFont.systemFont(ofSize: 14)
            lab.adjustsFontSizeToFitWidth = true
            self.bgView.addSubview(lab)
            
            
        }
    
    }
    
    //画图表
    
    func drawChart(lineType:LineChartType, pointType:PointType){
        self.caculateData()
        
        //柱状图
        if self.isShowPillar{
            self.drawPillar()
        }
        
        // 画网格线
        if (self.isShowLine) {
            self.drawLines();
        }
        
        //画x y轴
        self.drawXYline()
        
        //添加文字
        self.drawLabels()
        
        //画折线
        self.drawFoldLine(type: lineType)
        
        //画点
        if self.isShowPoit{
            self.drawPointsWithPointType(pointType: pointType)
        }
        
        //显示数据
        if self.isShowValue {
            self.drawValues()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
    }

}
