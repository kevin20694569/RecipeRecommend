import UIKit



class Advertise : Equatable, GetImageModel {
    static func == (lhs: Advertise, rhs: Advertise) -> Bool {
        lhs.page_url != rhs.page_url
    }
    
    var image: UIImage?
    
    var image_URL: URL?
    
    var page_url : URL?
    
    init(image: UIImage? = nil, image_URL: URL? = nil, page_url: URL? = nil) {
        self.image = image
        self.image_URL = image_URL
        self.page_url = page_url
    }

    
    static let wonderfulfood_examples : [Advertise] = {
        let data : [(String, String)] = [
            ("https://www.wonderfulfood.com.tw/Search/SearchShop?keyword=夜間好康", "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20241011021421452.jpg"),
        ("https://www.wonderfulfood.com.tw/Event/OQ%3D%3D#pdLTag_40"    , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240930102254256.jpg"),
        ("https://www.wonderfulfood.com.tw/Event/MTAx"    , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20241001074403307.jpg"),
        ("https://www.wonderfulfood.com.tw/Search/SearchShop?keyword=天天75折"    , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240816060151650.jpg"),
        ("https://www.wonderfulfood.com.tw/Search/SearchShop?keyword=蘋蘋椪椪"    , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240830102330473.jpg"),
        ("https://www.wonderfulfood.com.tw/Event/OTE%3D"   , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20241004092304850.jpg"),
        ("https://www.wonderfulfood.com.tw/Event/OTA%3D"   , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240830102330473.jpg"),
        ("https://www.wonderfulfood.com.tw/Event/MTg%3D"   , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240830102425544.jpg"),
        ("https://www.wonderfulfood.com.tw/Event/OTQ%3D"   , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240830102234149.jpg"),
        ("https://www.wonderfulfood.com.tw/Subscription"   , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240930102449103.jpg"),
        ("https://www.wonderfulfood.com.tw/NewDetail/MTg1"   , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240930102807253.jpg"),
        ("https://www.wonderfulfood.com.tw/Store/MTA1MQ%3D%3D"    , "https://wonderfulfoodtwcdn.azureedge.net/imgad/B_00001_20240918075823913.jpg")
    ]
        return data.map { page_url, image_url in
            return Advertise(image_URL: URL(string: image_url), page_url: URL(string: page_url))
        }
    }()
    
    static let wonderfulfood_logo : UIImage = UIImage.wonderfulfoodLogo
    
    
}
