import UIKit

class CorrectIngredientViewController : InputPhotoIngredientViewController {
    
    var photoInputedIngredient : [PhotoInputedIngredient] = []
    
    init(photoInputedIngredients : [PhotoInputedIngredient]) {
        super.init(nibName: nil, bundle: nil)
        self.photoInputedIngredient = photoInputedIngredients
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return photoInputedIngredient.isEmpty ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let bounds = UIScreen.main.bounds

        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IndicatorTableCell", for: indexPath) as! IndicatorTableCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
            cell.configure(highlightIndex: 1)
            return cell
        }
        if !photoInputedIngredient.isEmpty {
            if section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetectedPhotoTableCell", for: indexPath) as! DetectedPhotoTableCell
                cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.width / 2, bottom: 0, right: bounds.width / 2)
                cell.configure(photoInputedIngredients: self.photoInputedIngredient)
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableCell", for: indexPath)
        return cell
    }
    
    override func registerCell() {
        super.registerCell()
        tableView.register(DetectedPhotoTableCell.self, forCellReuseIdentifier: "DetectedPhotoTableCell")
    }
    
    override func nextTapButtonTapped(_ button: UIButton) {
        showDetailOptionController()
    }
    
    func showDetailOptionController() {
        
    }
    
}
