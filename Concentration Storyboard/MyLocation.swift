// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import Foundation

class MyLocation : Codable {
    
    var lat : Double?
    var lng : Double?
    
    init(lat : Double, lng : Double) {
        self.lat = lat
        self.lng = lng
    }
}
