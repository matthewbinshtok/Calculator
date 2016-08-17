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
    private var accumulator = 0.0
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI
        "e" : Operation.Constant(M_E), //M_E
        "√" : Operation.UnaryOperation(sqrt), //sqrt()
        "cos" : Operation.UnaryOperation(cos), //cos()
        "✕" : Operation.BinaryOperation({ $0 * $1 }), //multiplication
        "÷" : Operation.BinaryOperation({ $0 / $1 }), //division
        "+" : Operation.BinaryOperation({ $0 + $1 }), //addition
        "-" : Operation.BinaryOperation({ $0 - $1 }), //subtraction
        "=" : Operation.Equals
        
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var pending: PendingOperation?
    
    private struct PendingOperation {
        var firstOperand: Double
        var binaryFunction: (Double, Double) -> Double
        
    }
    
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
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction( pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}