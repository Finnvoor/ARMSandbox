//
//  Lesson.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 10/03/2021.
//

import UIKit

struct Lesson {
    let title: String
    let image: UIImage
    let instructions: String
    let numberCount: Int
    let outputVerifier: String
    
    static let allLessons = [Lesson.introduction, Lesson.arithmetic, Lesson.booleanAlgebra, Lesson.loops, Lesson.branches]
    
    static let introduction = Lesson(
        title: "Introduction",
        image: UIImage(named: "Introduction")!,
        instructions: "Take numbers from the input and place them in the output\nCall swi #1 to pickup a number from the input\nCall swi #4 to place a number in the output",
        numberCount: 1,
        outputVerifier: """
        verify = (input, output) => {
            return input == output
        }
        """
    )
    
    static let arithmetic = Lesson(
        title: "Arithmetic",
        image: UIImage(named: "Arithmetic")!,
        instructions: "Take numbers from the input, add 10 to them, and place them in the output\nCall swi #1 to pickup a number from the input\nCall swi #2 to place a number in the memory slot\nCall swi #3 to pickup a number from the memory slot\nCall swi #4 to place a number in the output",
        numberCount: 1,
        outputVerifier: """
        verify = (input, output) => {
            return (input + 10) == output
        }
        """
    )

    static let booleanAlgebra = Lesson(
        title: "Boolean Algebra",
        image: UIImage(named: "Boolean Algebra")!,
        instructions: "Use the AND instruction to take numbers from the input, AND them with 100, and place them in the output.",
        numberCount: 1,
        outputVerifier: """
        verify = (input, output) => {
            return (input & 100) == output
        }
        """
    )
    
    static let loops = Lesson(
        title: "Loops",
        image: UIImage(named: "Loops")!,
        instructions: "Take numbers from the input, add 10 to them, and place them in the output.\nRepeat this with 5 numbers by using a loop. Hint:\n\nloop:\n\t// action\n\tb loop",
        numberCount: 5,
        outputVerifier: """
        verify = (input, output) => {
            return (input + 10) == output
        }
        """
    )
    
    static let branches = Lesson(
        title: "Branches",
        image: UIImage(named: "Branches")!,
        instructions: "Branches let you conditionally execute instructions based on various conditions.\nAdd 20 to input numbers less than 80, and add 10 to any other number.\nPlace these in the ouptut. Hint:\n\nUse the BLT instruction to branch if the left hand side of a CMP instruction is less than the right hand side.",
        numberCount: 1,
        outputVerifier: """
        verify = (input, output) => {
            if (input < 80) {
                return output == (input + 20)
            } else {
                return output == (input + 10)
            }
        }
        """
    )
}
