import UIKit

class GeneratedRecipeSummaryDisplayController : RecipeSummaryDisplayController {
    
    var isLoadingNewRecipes : Bool = false
    
    
    func navItemSetup() {
        self.navigationItem.title = "過往該菜色所生成的食譜"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItemSetup()
    }
    
    override func registerCell() {
        super.registerCell()
        tableView.register(GeneratedSummaryRecipeTableCell.self, forCellReuseIdentifier: "GeneratedSummaryRecipeTableCell")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneratedSummaryRecipeTableCell", for: indexPath) as! GeneratedSummaryRecipeTableCell
        cell.summaryDishTableCellDelegate = self
        cell.configure(recipe: recipe)
        return cell
    }
    
    func pushNewRecipes(newRecipes : [Recipe]) {
        
        let newIndexPaths = (recipes.count...recipes.count + newRecipes.count - 1).compactMap { index in
            return IndexPath(row: index, section: 0)
        }
        self.recipes.insert(contentsOf: newRecipes, at: self.recipes.count)
        
        tableView.beginUpdates()
        tableView.insertRows(at: newIndexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SummaryRecipeTableCell {
            cell.tagCollectionView.reloadSections([0])
        }
        
        guard !isLoadingNewRecipes else {
            return
        }
        
        
        
        guard self.recipes.count - indexPath.row == 10 else {
            return
        }
        guard let created_time = self.recipes.last?.created_time else {
            return
        }
        isLoadingNewRecipes = true
        Task {
            defer {
                isLoadingNewRecipes = false
            }
            
            let newRecipes = try await RecipeManager.shared.getHistoryGeneratedRecipesByDateThreshold(user_id: self.user_id, dateThreshold: created_time)
            guard newRecipes.count > 0 else {
                return
            }
            pushNewRecipes(newRecipes: newRecipes)
            
        }
        
    }
    
    override func buttonSetup() {
        navBarRightButton.isHidden = true
    }
}
