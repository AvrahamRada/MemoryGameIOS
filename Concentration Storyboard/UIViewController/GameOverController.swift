// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import UIKit

class GameOverController: UIViewController {
    
    
    @IBOutlet weak var gameover_BTN_newGame: UIButton!
    @IBOutlet weak var gameover_BTN_restart: UIButton!
    @IBOutlet weak var gameover_LBL_moves: UILabel!
    @IBOutlet weak var gameover_LBL_time: UILabel!
    
    let RESTART : String = "Restart"
    let NEW_GAME : String = "New Game"
    
    
    var moves : Int!
    var time : Int!
    var lastGameNumOfRows: Int!;
    var lastGameNumOfCardsPerRow: Int!;
    var chosenOption : String!
    var timerHelper : TimerHelper!
    var name : String!
    var myLocation : MyLocation!
    var highScores = [HighScore]()
    var userHighScore : HighScore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerHelper = TimerHelper()
        gameover_LBL_time.text = timerHelper.buildClockVishion(timePassed: time)
        gameover_LBL_moves.text = (String(moves))
        highScores = MyLocalStorage.getDataFromLocalStorage()
        insertNewHighScoreToHighScores()
        MyLocalStorage.saveHighScoresInLocalStorage(highScores: highScores)
    }
    
    @IBAction func onOptionButtonPressed(_ sender: UIButton) {
        
        chosenOption = sender.titleLabel!.text!
        if(chosenOption == RESTART){
            self.performSegue(withIdentifier: "goToGameView", sender: self)
        } else if(chosenOption == NEW_GAME){
            self.performSegue(withIdentifier: "goToOpeningView", sender: self)
        }
    }
    
    func insertNewHighScoreToHighScores(){
        if(highScores.isEmpty){
            highScores.append(userHighScore)
            return
        }
        
//        print("not empty")
//        print("size is \(highScores.count)")
        
        if(!insertToListByTime() && highScores.count < 10){
            highScores.insert(userHighScore, at: highScores.count)

        }
        
        if(highScores.count > 10){
            //DELETE the last highscore
            highScores.remove(at: highScores.count - 1)
        }
    }
    
    func insertToListByTime() -> Bool{
        for i in  0 ..< highScores.count {
            if(userHighScore.time < highScores[i].time){
                highScores.insert(userHighScore, at: i)
                return true
            }
        }
        return false
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToGameView"){
            let game = segue.destination as! GameController
            game.numOfRows = lastGameNumOfRows
            game.numOfCardsPerRow = lastGameNumOfCardsPerRow
            game.name = userHighScore.name
            game.myLocation = userHighScore.location
            } else if(segue.identifier == "goToOpeningView"){
            _ = segue.destination as! OpeningViewController
        }
    }
}
