//
//  QuestionViewController.swift
//  Personality Quiz App
//
//  Created by Hamit Sehjal on 2024-03-25.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var SingleStackView: UIStackView!
    @IBOutlet weak var singleButton1: UIButton!
    @IBOutlet weak var singleButton2: UIButton!
    @IBOutlet weak var singleButton3: UIButton!
    @IBOutlet weak var singleButton4: UIButton!
    
    @IBOutlet weak var MultipleStackView: UIStackView!
    @IBOutlet weak var multipleLabel1: UILabel!
    @IBOutlet weak var multipleLabel2: UILabel!
    @IBOutlet weak var multipleLabel3: UILabel!
    @IBOutlet weak var multipleLabel4: UILabel!
    
    @IBOutlet weak var RangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    
    var questions:[Question]=[
        
        Question(
            text: "Which food do you like the most?",
            type: .single,
            answers: [
                Answer(text: "Steak", type: .dog),
                Answer(text: "Fish", type: .cat),
                Answer(text: "Carrot", type: .rabbit),
                Answer(text: "Corn", type: .turtle),
        ]),
        Question(
            text: "Which activities do you enjoy?",
            type: .multiple,
            answers: [
                Answer(text: "Swimming", type: .turtle),
                Answer(text: "Sleeping", type: .cat),
                Answer(text: "Cuddling", type: .rabbit),
                Answer(text: "Eating", type: .dog),
        ]),
        Question(
            text: "How much do you enjoy car rides?",
            type: .ranged,
            answers: [
                Answer(text: "I dislike them", type: .cat),
                Answer(text: "I get litte nervous", type: .rabbit),
                Answer(text: "I barely notice them", type: .turtle),
                Answer(text: "I love them", type: .dog),
        ]),
        Question(
            text: "How much do you like water?",
            type: .ranged,
            answers: [
                Answer(text: "I dislike them", type: .cat),
                Answer(text: "I get litte nervous", type: .rabbit),
                Answer(text: "I barely notice them", type: .turtle),
                Answer(text: "I love them", type: .dog),
        ]),
    ]
    
    var questionIndex:Int=0
    
    var answersChosen:[Answer]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers=questions[questionIndex].answers
        
        switch sender{
        case singleButton1:
            answersChosen.append(currentAnswers[0])
        case singleButton2:
            answersChosen.append(currentAnswers[1])
        case singleButton3:
            answersChosen.append(currentAnswers[2])
        case singleButton4:
            answersChosen.append(currentAnswers[3])
        default:
            break
        }
    nextQuestion()
    }
    
    @IBOutlet weak var multipleSwitch1: UISwitch!
    @IBOutlet weak var multipleSwitch2: UISwitch!
    @IBOutlet weak var multipleSwitch3: UISwitch!
    @IBOutlet weak var multipleSwitch4: UISwitch!
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswers=questions[questionIndex].answers
        
        if multipleSwitch1.isOn{
            answersChosen.append(currentAnswers[0])
        }
        
        if multipleSwitch2.isOn{
            answersChosen.append(currentAnswers[1])
        }
        
        if multipleSwitch3.isOn{
            answersChosen.append(currentAnswers[2])
        }
        
        if multipleSwitch4.isOn{
            answersChosen.append(currentAnswers[3])
        }
        
        nextQuestion()
    }
    
    @IBOutlet weak var rangedSlider: UISlider!
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers=questions[questionIndex].answers
        let index=Int(round(rangedSlider.value*Float(currentAnswers.count-1)))
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
        
    }
    
    func updateUI(){
        SingleStackView.isHidden=true
        MultipleStackView.isHidden=true
        RangedStackView.isHidden=true
        
        
        
        let currentQuestion=questions[questionIndex]
        let currentAnswers=currentQuestion.answers
        let totalProgress=Float(questionIndex)/Float(questions.count)
        
        // navigation bar title
        navigationItem.title="Question #\(questionIndex+1)"
        // label for current question
        questionLabel.text=currentQuestion.text
        // progress bar
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type{
        case .single:
            updateSingleStack(using: currentAnswers)
        case .multiple:
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            updateRangedStack(using: currentAnswers)
        }
           
    }
    
    // update button for the single stack view
    func updateSingleStack(using answers:[Answer]){
        SingleStackView.isHidden=false
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
    }
    
    // update labels for the multiple stack view
    func updateMultipleStack(using answers:[Answer]){
        MultipleStackView.isHidden=false
        multipleSwitch1.isOn=false
        multipleSwitch2.isOn=false
        multipleSwitch3.isOn=false
        multipleSwitch4.isOn=false
        multipleLabel1.text=answers[0].text
        multipleLabel2.text=answers[1].text
        multipleLabel3.text=answers[2].text
        multipleLabel4.text=answers[3].text
    }
    
    // update labels for the ranged stack view
    func updateRangedStack(using answers:[Answer]){
        RangedStackView.isHidden=false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text=answers[0].text
        rangedLabel2.text=answers[3].text
    }
    @IBSegueAction func showResults(_ coder: NSCoder) -> ResultsViewController? {
        return ResultsViewController(coder: coder,responses: answersChosen)
    }
    
    func nextQuestion(){
        questionIndex+=1
        if questionIndex<questions.count{
            updateUI()
        }
        else{
            performSegue(withIdentifier: "Results", sender: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
