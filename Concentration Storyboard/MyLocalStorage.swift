// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import Foundation

class MyLocalStorage {
    
    static let HIGH_SCORES_KEY = "KING AVRAHAM"
    
    static func getDataFromLocalStorage() -> [HighScore]{
        
        //load the data from local storage and convert it the list of HighScore
        
        
        //Reset file ofr tests
        //UserDefaults.standard.removePersistentDomain(forName: HIGH_SCORES_KEY)
        
        let highScoresJson = UserDefaults.standard.string(forKey: HIGH_SCORES_KEY)
        
        if let safeHighScoresJson = highScoresJson {
            return Converter.fromJsonToHighScoreList(highScoreJson: safeHighScoresJson)
        }
        
        return [HighScore]()
    }
    
    static func saveHighScoresInLocalStorage(highScores : [HighScore]) {
    
        let highScoresJson: String = Converter.fromHighScoreListToJson(highScores: highScores)
        UserDefaults.standard.set(highScoresJson, forKey: HIGH_SCORES_KEY)
    }
    
    
}
