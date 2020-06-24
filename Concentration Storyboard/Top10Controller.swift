// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import CoreLocation
import UIKit
import MapKit

class Top10Controller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scores_LST_scores: UITableView!
    @IBOutlet weak var scores_BTN_back: UIButton!
    @IBOutlet weak var scores_MAPVIEW_map: MKMapView!
    
    var animalsImages =  [#imageLiteral(resourceName: "ic_emoji_ethiopian_man"),#imageLiteral(resourceName: "ic_emoji_exploding_head"),#imageLiteral(resourceName: "ic_emoji_monkey"),#imageLiteral(resourceName: "ic_emoji__cat_face_with_eart_eyes"),#imageLiteral(resourceName: "ic_emoji_vomiting"),#imageLiteral(resourceName: "ic_emoji_devil"),#imageLiteral(resourceName: "ic_emoji_laugh"),#imageLiteral(resourceName: "ic_emoji_no_mouth")]
    var highScores : [HighScore]!
    let cellReuseIdentifier = "score_cell"
    var newCamera: MKMapCamera!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Read from local storage the highscores
        scores_MAPVIEW_map.showsUserLocation = true
        //Set the corner of the map to be rounded.
        scores_MAPVIEW_map.layer.cornerRadius = 25.0
        highScores = MyLocalStorage.getDataFromLocalStorage()
        addAnnotationPoints()
        setupList()
        
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func addAnnotationPoints(){
        
            
        for highScore in highScores{
            
            
            let point = MKPointAnnotation()
            
            let pointlatitude = Double(highScore.location.lat!)
            let pointlongitude = Double(highScore.location.lng!)
            point.title = highScore.name
            
            point.coordinate = CLLocationCoordinate2DMake(pointlatitude ,pointlongitude)
            scores_MAPVIEW_map.addAnnotation(point)
            
            
        }
        
    }
    
    func showAnotation(index : Int){
        

        newCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: highScores[index].location.lat!, longitude: highScores[index].location.lng!), fromDistance: 500.0, pitch: 90.0, heading: 180.0)
        self.scores_MAPVIEW_map.setCamera(newCamera, animated: true)
    
    }
    
    func setupList(){
        
        scores_LST_scores.delegate = self
        scores_LST_scores.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MyCustomCell? = self.scores_LST_scores.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? MyCustomCell
        
        print(String(self.highScores[indexPath.row].time))
        print(String(self.highScores[indexPath.row].name))
        print("\(self.highScores[indexPath.row].date)")
        
        cell?.cell_LBL_score?.text = String(self.highScores[indexPath.row].time)
        cell?.cell_LBL_name?.text = String(self.highScores[indexPath.row].name).lowercased()
        cell?.cell_LBL_date.text = "\(self.highScores[indexPath.row].date)"
        cell?.cell_IMG_scoreImage?.image = animalsImages[indexPath.row % animalsImages.count]
    
        
        if(cell == nil){
            cell = MyCustomCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellReuseIdentifier)
        }
        
        return cell!
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAnotation(index: indexPath.row)
    }
    
}

