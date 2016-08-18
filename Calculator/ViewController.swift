//
//  ViewController.swift
//  Calculator
//
//  Created by Matthew Binshtok on 8/16/16.
//  Copyright © 2016 Matthew Binshtok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBOutlet private weak var display: UILabel!
    
    // button pressed is a number
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            //handling floating point
            if digit == "." && textCurrentlyInDisplay.rangeOfString(".") == nil {
                display.text = textCurrentlyInDisplay + digit
            } else if digit != "." {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    // button pressed is an operation
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    // button pressed is the clear button
    @IBAction func clearOperation(sender: UIButton) {
        userIsInTheMiddleOfTyping = false;
        display.text = "0";
        brain.setOperand(0.0)
    }
}

