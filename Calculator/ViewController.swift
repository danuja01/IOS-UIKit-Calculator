//
//  ViewController.swift
//  Calculator
//
//  Created by Danuja Jayasuriya on 2024-03-27.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var displayText: UILabel!
    @IBOutlet var opSymbol: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    private var currentNumber: Double = 0
    private var previousNumber: Double = 0
    private var performingOperation: Bool = false
    private var operation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayText.text = "0"
        opSymbol.text = ""
        
        
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
        for button in buttons {
            button.layer.cornerRadius = 40
            button.clipsToBounds = true
        }
    }
    
    fileprivate func displayValue(of value: Double) {
        if floor(value) == value {
            displayText.text = "\(Int(value))"
        } else {
            displayText.text = "\(value)"
        }
    }
    
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        if performingOperation {
            displayText.text = "\(sender.tag)"
            performingOperation = false
        } else {
            if displayText.text != "0" {
                displayText.text = displayText.text! + "\(sender.tag)"
            } else {
                displayText.text = "\(sender.tag)"
            }
        }
        
        if let number = Double(displayText.text!) {
            currentNumber = number
        }
    }
    
    
    @IBAction func functionButtonTapped(_ sender: UIButton) {
        guard let operationSymbol = sender.titleLabel?.text else {
            return
        }
        
        switch operationSymbol {
        case "Clear":
            currentNumber = 0
            previousNumber = 0
            performingOperation = false
            operation = ""
            displayText.text = "0"
            opSymbol.text = ""
        case ".":
            if !(displayText.text?.contains(".") ?? false) {
                displayText.text = displayText.text! + "."
            }
        case "+/-":
            if let currText = displayText.text, var number = Double(currText) {
                number *= -1
                displayValue(of: number)
            }
        default:
            print(operationSymbol)
        }
    }
    
    @IBAction func calculationButtonTapped(_ sender: UIButton) {
        guard let operationSymbol = sender.titleLabel?.text else {
            return
        }
        
        if operationSymbol == "=" && !performingOperation {
            if operation != "" {
                switch operation {
                case "+":
                    currentNumber = previousNumber + currentNumber
                case "-":
                    currentNumber = previousNumber - currentNumber
                case "x":
                    currentNumber = previousNumber * currentNumber
                case "÷":
                    if currentNumber != 0 {
                        currentNumber = previousNumber / currentNumber
                    } else {
                        displayText.text = "Error"
                        return
                    }
                default:
                    break
                }
                
                displayValue(of: currentNumber)
                operation = ""
                opSymbol.text = ""
                performingOperation = false
            }
        } else if operationSymbol != "=" {
            
            if operationSymbol == "%", var number = Double(displayText.text!) {
                currentNumber = number / 100
                displayValue(of: currentNumber)
                return
            }
            
            if let number = Double(displayText.text!) {
                if performingOperation {
                    previousNumber = currentNumber
                    currentNumber = number
                } else {
                    previousNumber = number
                    performingOperation = true
                }
            }
            
            operation = operationSymbol
            opSymbol.text = operation
        }
    }
    
}

