// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import UIKit
import CoreLocation

class OpeningViewController: UIViewController {

    //  MARK: Variables
    var name : String!
    var myLocation : MyLocation!
    var locationManager: CLLocationManager!
    var mode : Int!
    let SOFT_MODE = 4
    let KILLER_MODE = 6
    
    //  MARK: IBOutlet
    @IBOutlet weak var name_TEXTFIELD_nameHolder: UITextField!
    @IBOutlet weak var opening_BTN_soft: UIButton!
    @IBOutlet weak var opening_BTN_killer: UIButton!
    
    // MARK: onCreate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mode = KILLER_MODE
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    // MARK: onClick_01()
    @IBAction func onPlayButtonPressed(_ sender: UIButton) {
        self.name = name_TEXTFIELD_nameHolder.text
        if(self.name.isEmpty){
            self.name = "DEMO PLAYER"
        }
        self.performSegue(withIdentifier: "goToGameView", sender: self)
    }
    
    // MARK: onClick_02()
    @IBAction func BtnRadioAction(_ sender: UIButton) {
        if(sender.tag == 1){
            opening_BTN_killer.isSelected = true
            opening_BTN_soft.isSelected = false
            self.mode = KILLER_MODE
        }
        else{
            opening_BTN_killer.isSelected = false
            opening_BTN_soft.isSelected = true
            self.mode = SOFT_MODE

        }
    }
    // MARK: onClick_03()
    @IBAction func onTop10ButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToTop10View", sender: self)
    }
    
    //MARK: Navigation == Intent(Android)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToGameView"){
            let gameView = segue.destination as! GameController
            gameView.name = self.name
            gameView.myLocation = self.myLocation
            gameView.mode = self.mode
            gameView.numOfRows = self.mode
            gameView.numOfCardsPerRow = self.mode
            
        } else if(segue.identifier == "goToTop10View"){
            _ = segue.destination as! Top10Controller
        }
    }
}

//  MARK: Extension
extension OpeningViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.myLocation = MyLocation(lat:location.coordinate.latitude, lng: location.coordinate.latitude)
            print("got Location: \(String(describing: myLocation.lat)) \(String(describing: myLocation.lng))")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error=\(error)")
        // Default location - in case of an ERROR
        self.myLocation = MyLocation(lat:31.92933, lng: 34.79868)
    }
}
