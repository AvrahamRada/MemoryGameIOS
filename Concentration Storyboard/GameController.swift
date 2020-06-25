// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import UIKit
import AVFoundation

class GameController: UIViewController {
    
    // MARK:IBOutlet
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_STACKVIEW_cardsHolder: UIStackView!
    @IBOutlet weak var game_BTN_back: UIButton!
    
    // MARK:Variables
    var numOfRows : Int!
    var numOfCardsPerRow : Int!
    var numOfCards : Int!
    var cards = [Card]()
    var firstCard : Card?
    var raffle : Bool = true
    var isClickable : Bool = true
    var moves : Int = 0
    var timePassed : Int = 0
    var timePassedText : String! = "0"
    var timerHelper : TimerHelper!
    var name : String!
    var myLocation : MyLocation!
    let PAIR :Int = 2
    
    // MARK: onCreate()
    override func viewDidLoad() {
        super.viewDidLoad();
        
        timerHelper = TimerHelper()
        initCards(numOfRows: numOfRows, numOfCardsPerRow: numOfCardsPerRow);
        raffleCards()
        startTimer()
        
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
       if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func flip(_ sender: Card) {
        if(!isClickable){
            // Player can't click a card - waiting for other cards to flip
            return
        }

        if(sender.isFlipped){
            //Some card has been clicked.
            return
        }
        handleCard(sender: sender);
    }

    // MARK: initCards()
    func initCards(numOfRows : Int, numOfCardsPerRow : Int){

        numOfCards = numOfRows * numOfCardsPerRow;

        for _ in 0 ..< numOfRows {
            let row : UIStackView = createRow()
            for _ in 0 ..< numOfCardsPerRow {
                let newCard : Card = createCard()
                //Adding newCard to row Stackview
                row.addArrangedSubview(newCard)
                //Adding newCard to cards Array ref
                cards.append(newCard)
            }
            game_STACKVIEW_cardsHolder.addArrangedSubview(row);
        }
    }

    // MARK: createCard()
    func createCard () -> Card {

        let newCard : Card = Card()
        newCard.addTarget(self, action: #selector(flip), for: .touchUpInside);

        return newCard;
    }

    // MARK: createRow()
    func createRow () -> UIStackView {

        let SPACING: CGFloat = 10
        let row = UIStackView()

        row.axis = .horizontal
        row.alignment = .fill
        row.distribution = .fillEqually
        row.spacing = SPACING
        row.contentMode = .scaleToFill
        row.translatesAutoresizingMaskIntoConstraints = false

        return row;
    }

    func raffleCards()  {
        var images = [#imageLiteral(resourceName: "ic_emoji_ethiopian_man"),#imageLiteral(resourceName: "ic_emoji_exploding_head"),#imageLiteral(resourceName: "ic_emoji_monkey"),#imageLiteral(resourceName: "ic_emoji__cat_face_with_eart_eyes"),#imageLiteral(resourceName: "ic_emoji_vomiting"),#imageLiteral(resourceName: "ic_emoji_devil"),#imageLiteral(resourceName: "ic_emoji_laugh"),#imageLiteral(resourceName: "ic_emoji_no_mouth")]
        
        //        availableThemes[0] = ["🧥", "🥼", "👚", "👕", "👖", "🧵", "🧶", "👔", "👗", "👙", "👘", "🧢", "🧦", "👡", "👠", "🎩"]
        //        availableThemes[1] = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵"]
        //        availableThemes[2] = ["🐙", "🦑", "🦐", "🦞", "🐡", "🐠", "🐟", "🐋", "🦈", "🐊", "🐳", "🐢", "🐍", "🦎", "🐸", "🦀"]
        //        availableThemes[3] = ["🌵", "🌲", "🌳", "🌴", "🌱", "🌿", "☘", "🎍", "🎋", "🍃", "🍂", "🍁", "🍄", "🌾", "🎄", "🍀"]
        //        availableThemes[4] = ["🍏", "🍎", "🍐", "🍋", "🍌", "🍇", "🍓", "🍈", "🍒", "🥭", "🍍", "🥥", "🥝", "🍅", "🍑", "🍉"]
        
        var size = numOfCards / 2
        var slots = [Int](repeating: 0, count: size)
        var randomIndex : Int


        for card in cards{

            while(raffle){

                randomIndex = Int.random(in: 0 ..< size);

                if(slots[randomIndex] < PAIR){
                    raffle = false;
                    slots[randomIndex] += 1
                    card.front = images[randomIndex]
                } else {
                    // The same card has already asign twice
                    images.remove(at: randomIndex)
                    slots.remove(at: randomIndex)
                    size -= 1

                }
            }
            // Reset for next round.
            raffle = true;
        }

    }

    func addMove() {

        moves += 1;
        game_LBL_moves.text  = String(moves)

    }

    func handleCard(sender : Card){

        if(firstCard == nil){
            //flip the first card
            sender.flip()

            firstCard = sender

            //flip first card to reveal his image.

        } else {

            //flip second card to reveal his image.
            sender.flip()

            isClickable = false;

            checkForMatches(sender: sender)

        }
    }

    func checkForMatches(sender : Card){

        if(sender.front == firstCard!.front){
            playerGuessedRight(sender: sender)
        } else {
            playerGuessedWrong(sender: sender)
        }
    }

    func playerGuessedRight(sender : Card){
        sender.remove()
        firstCard?.remove()
        addMove()
        firstCard = nil
        if(isVictory()){
            self.performSegue(withIdentifier: "goToGameOverView", sender: self)
        }

        //player can now guess again.
        isClickable = true;

    }


    func playerGuessedWrong(sender : Card) {

        addMove()
        //Delay for 2 seconds when revealing the second card.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2 ) {

            // flip the cards back
            self.firstCard!.flip()
            sender.flip()

            // Player can guess again
            self.isClickable = true

            // Reset first card
            self.firstCard = nil

        }
    }

    func startTimer() {

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in

            self.timePassed += 1
            self.timePassedText =  self.timerHelper.convertTimeToMinutesAndSeconds(timePassed: self.timePassed)
            self.game_LBL_timer.text = self.timePassedText


        }

    }





    func isVictory() -> Bool {

        for card in cards {
            if(!card.isFlipped){
                return false
            }
        }
        return true
    }


    func newGame () {

        resertCards()
        resetMoves()
        resetTimer()
        resetFliped()
        raffleCards()
    }

    func resertCards() {

        for card in cards {

            card.flip()
            card.add()
        }
    }

    func resetFliped() {
        for card in cards {
            card.isFlipped = false;
        }
    }

    func resetMoves() {

        moves = 0
        game_LBL_moves.text  = String(moves)

    }

    func resetTimer() {

        timePassed = 0
        game_LBL_timer.text  = String(timePassed)

    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToGameOverView"){
            let gameOverPage = segue.destination as! GameOverController
            //Set the game parameters
            gameOverPage.time = timePassed
            gameOverPage.moves = moves
            gameOverPage.lastGameNumOfRows = numOfRows
            gameOverPage.lastGameNumOfCardsPerRow = numOfCardsPerRow
            print(Date())
            print(timePassed)
            print(myLocation)
            gameOverPage.userHighScore = HighScore(name: name, time: timePassed, location: myLocation,date: Date())
        }
    }


}

