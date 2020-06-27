// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import Foundation

class Converter {
    
    static func fromJsonToHighScoreList(highScoreJson: String) ->[HighScore]{
        
        let decoder = JSONDecoder()
        let data = Data(highScoreJson.utf8)
        do {
            return try decoder.decode([HighScore].self, from: data)
        } catch {
            print("ERROR with fromJsonToHighScoreList")
        }
        return [HighScore]()
    }
    
    static func fromHighScoreListToJson(highScores : [HighScore]) -> String{
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(highScores)
        let highScoresJson: String = String(data: data, encoding: .utf8)!
        return highScoresJson
    }
    
    
}
