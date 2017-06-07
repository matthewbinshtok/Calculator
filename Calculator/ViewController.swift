//
//  ViewController.swift
//  Calculator
//
//  Updated by Matthew Binshtok on 6/6/17.
//  Copyright © 2017 Matthew Binshtok.
//  All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBOutlet weak var display: UILabel!
    
    // button pressed is a number or decimal point
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            //handle floating point
            if digit == "." && textCurrentlyInDisplay.range(of: ".") == nil {
                display.text = textCurrentlyInDisplay + digit
            } else if digit != "." {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    // button pressed is an operation
    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    // button pressed is the clear button
    @IBAction func clearOperation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false;
        display.text = "0";
        brain.setOperand(0.0)
    }
}

