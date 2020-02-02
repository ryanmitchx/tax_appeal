import Shuffle_iOS

class HomeCard: SwipeCard {
    
    override var swipeDirections: [SwipeDirection] {
        return [.left, .right]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        footerHeight = 250
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func overlay(forDirection direction: SwipeDirection) -> UIView? {
        switch direction {
        case .left:
            return SampleCardOverlay.left()
//        case .up:
//            return SampleCardOverlay.up()
        case.right:
            return SampleCardOverlay.right()
        default:
            return nil
        }
    }
    
    func configure(withHome home: Home) {
        downloadImage(from: URL(string: home.image)!)
        footer = SampleCardFooterView(withAddress: "\(home.address)", assessedValue: "\(home.propertyValue)", subtitle: String("\(home.beds) bedrooms, \(home.baths) baths"))
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.content = SampleCardContentView(withImage: UIImage(data: data))
            }
        }
    }
    
}
