//
//  CalculatorBrain.swift
//  Calculator
//
//  Updated by Matthew Binshtok on 6/6/17.
//  Copyright © 2017 Matthew Binshtok. 
//  All rights reserved.
//

import Foundation

struct CalculatorBrain
{
    /* Stores the current value of the calculations
     Type is Optional because when CalculatorBrain is initialized,
     accumulator should not have an initial value */
    private var accumulator: Double?
    
    // Sets accumulator to operand
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    /* returns a description of the sequence of operands
     and operations that led to the value returned by result */
    var description: String?
    
    /* Dictionary storing potential operations called with
     String passed by performOperation serving as key
     with a corresponding operation/constant using closures */
    private var operations: Dictionary<String,Operation> = [
        "π"   :   Operation.constant(Double.pi),
        "e"   :   Operation.constant(M_E),
        "√"   :   Operation.unaryOperation(sqrt),
        "x²"  :   Operation.unaryOperation({ $0 * $0 }),
        "sin" :   Operation.unaryOperation(sin),
        "cos" :   Operation.unaryOperation(cos),
        "tan" :   Operation.unaryOperation(tan),
        "±"   :   Operation.unaryOperation({ -$0 }),
        "✕"   :   Operation.binaryOperation({ $0 * $1 }),
        "÷"   :   Operation.binaryOperation({ $0 / $1 }),
        "+"   :   Operation.binaryOperation({ $0 + $1 }),
        "−"   :   Operation.binaryOperation({ $0 - $1 }),
        "="   :   Operation.equals
        
    ]
    
    // all possible operation types
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
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
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    executePendingBinaryOperation()
                    pending = PendingOperation(firstOperand: accumulator!, binaryFunction: function)
                    accumulator = nil
                    isPartialOperation = true
                }
            case .equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    // uses accumulator value as second operand to execute operation stored in PendingOperation
    private mutating func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction( pending!.firstOperand, accumulator!)
            isPartialOperation = false
            pending = nil
        }
    }
    
    // result of calculations
    // accessed by view after performOperation executes
    var result: Double? {
        get {
            return accumulator
        }
    }
}
