//
//  Question Bank.swift
//  Fun Maths
//
//  Created by Jinisha Savani on 10/12/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import Foundation

class QuestionBank {
    
    var listOfQuestion = [Question]()
    var randomIntForQuestion = (arc4random_uniform(9) + 1)
    
    
    init() {

        listOfQuestion.append(Question(text: "Add \(randomIntForQuestion) to the number"))

    }
    
}
