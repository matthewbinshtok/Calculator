//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Matthew Binshtok on 8/17/16.
//  Copyright © 2016 Matthew Binshtok. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    // accumulator
    private var accumulator = 0.0
    
    // set first operand
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    /* returns a description of the sequence of operands
     and operations that led to the value returned by result */
    var description: String?
    
    /* Dictionary storing potential operations called with
     String passed by performOperation serving as key
     with a corresponding operation/constant using closures */
    private var operations: Dictionary<String,Operation> = [
        "π"   :   Operation.Constant(M_PI), //M_PI
        "e"   :   Operation.Constant(M_E), //M_E
        "√"   :   Operation.UnaryOperation(sqrt),
        "x²"  :   Operation.UnaryOperation({ $0 * $0 }),
        "sin" :   Operation.UnaryOperation(sin),
        "cos" :   Operation.UnaryOperation(cos),
        "tan" :   Operation.UnaryOperation(tan),
        "✕"   :   Operation.BinaryOperation({ $0 * $1 }),
        "÷"   :   Operation.BinaryOperation({ $0 / $1 }),
        "+"   :   Operation.BinaryOperation({ $0 + $1 }),
        "−"   :   Operation.BinaryOperation({ $0 - $1 }),
        "="   :   Operation.Equals
        
    ]
    
    // all possible operation types
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    // returns whether there is a binary operation pending
    private var isPartialOperation: Bool = false
    
    // stores pending binary operation
    private var pending: PendingOperation?
    
    // pending binary operation data structure
    // stores operation type and first operand
    private struct PendingOperation {
        var firstOperand: Double
        var binaryFunction: (Double, Double) -> Double
        
    }
    
    /* uses switch and Operation struct to determine how to
     perform requested operation based on symbol passed from button */
    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingOperation(firstOperand: accumulator, binaryFunction: function)
                isPartialOperation = true;
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    // uses accumulator value as second operand to execute operation stored in PendingOperation
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction( pending!.firstOperand, accumulator)
            isPartialOperation = false;
            pending = nil
        }
    }
    
    // result of calculations
    // accessed by view after performOperation executes
    var result: Double {
        get {
            return accumulator
        }
    }
}