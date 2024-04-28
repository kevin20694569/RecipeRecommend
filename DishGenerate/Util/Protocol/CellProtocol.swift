import UIKit

protocol DishTableCell : UITableViewCell {
    func configure(dish : Dish)
}
