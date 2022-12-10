//
//  InterfaceController.swift
//  NoPonto WatchKit Extension
//
//  Created by Matheus Lopes on 10/12/22.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var buttonTimer: WKInterfaceButton!
    @IBOutlet weak var labelWeight: WKInterfaceLabel!
    @IBOutlet weak var labelCook: WKInterfaceLabel!
    @IBOutlet weak var groupText: WKInterfaceGroup!
    @IBOutlet weak var groupImage: WKInterfaceGroup!
    @IBOutlet weak var sliderCook: WKInterfaceSlider!
    @IBOutlet weak var pickerWeight: WKInterfacePicker!
    @IBOutlet weak var pickerCook: WKInterfacePicker!
    @IBOutlet weak var labelCook2: WKInterfaceLabel!
    
    private var kg: Double = 0.1
    private var meatTemperature: MeatTemperature = .rare
    private let increment = 0.1
    private var timerIsRunning = false
    private let maxKg = 2.0
    
    override func awake(withContext context: Any?) {
        groupImage.setHidden(true)
        setupPickers()
        updateConfiguration()
    }
    
    private func setupPickers() {
        // Picker de quantidade
        var weightItems: [WKPickerItem] = []
        for weight in stride(from: 0.1, through: maxKg, by: increment) {
            let item = WKPickerItem()
            item.title = String(format: "%.1f", weight)
            weightItems.append(item)
        }
        pickerWeight.setItems(weightItems)
        pickerWeight.setSelectedItemIndex(0)
        
        // Picker do ponto da carne
        var cookItems: [WKPickerItem] = []
        for imageIndex in 1...4 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "temp-\(imageIndex)")
            cookItems.append(item)
        }
        pickerCook.setItems(cookItems)
        pickerCook.setSelectedItemIndex(0)
    }
    
    private func updateConfiguration() {
        let kgString = String(format: "%.1f", kg)
        labelWeight.setText("Total: \(kgString) kg")
        labelCook.setText(meatTemperature.stringValue)
        sliderCook.setValue(Float(meatTemperature.rawValue))
        let index = Int(kg * 10 - 1)
        pickerWeight.setSelectedItemIndex(index)
        labelCook2.setText(meatTemperature.stringValue)
        pickerCook.setSelectedItemIndex(meatTemperature.rawValue)
    }
    
    @IBAction func toggleTimer() {
        if timerIsRunning {
            timer.setDate(Date())
            timer.stop()
            buttonTimer.setTitle("Iniciar timer")
        } else {
            let time = meatTemperature.cookTimeForKg(kg)
            timer.setDate(Date(timeIntervalSinceNow: time))
            timer.start()
            buttonTimer.setTitle("Parar timer")
        }
        timerIsRunning.toggle()
    }
    
    @IBAction func minus() {
        if kg > 0.1 {
            kg -= increment
            updateConfiguration()
        }
    }
    
    @IBAction func plus() {
        if kg < maxKg {
            kg += increment
            updateConfiguration()
        }
    }
    
    @IBAction func onSliderChange(_ value: Float) {
        let intValue = Int(value)
        if let meatTemperature = MeatTemperature(rawValue: intValue) {
            self.meatTemperature = meatTemperature
            updateConfiguration()
        }
    }
    
    
    @IBAction func onWeightPickerChange(_ value: Int) {
        kg = Double(value + 1) * increment
        updateConfiguration()
    }
    
    @IBAction func onCookPickerChange(_ value: Int) {
        if let meatTemperature = MeatTemperature(rawValue: value) {
            self.meatTemperature = meatTemperature
            updateConfiguration()
        }
    }
    
    @IBAction func onModeChange(_ value: Bool) {
        groupText.setHidden(value)
        groupImage.setHidden(!value)
    }
}
