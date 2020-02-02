import Shuffle_iOS
import KeychainAccess

class HouseViewController: UIViewController {
    
    private let cardStack = SwipeCardStack()
    private let keychain = Keychain(service: "com.brs.TaxAppeal")
    
    private var homes: [Home] = []
//        Home(address: "3131 S Hoover St", beds: 2, baths: 2, propertyValue: 400000, image: "https://specials-images.forbesimg.com/imageserve/1026205392/960x0.jpg"),
//        Home(address: "Address2", beds: 3, baths: 2, propertyValue: 400000, image: "https://www.whatever.com/png")
    

    struct HomeValues{
        static var totalValue: Int = 0
        static var numHomes: Int = 0
        static var maxValue: Int = 0
        static var minValue: Int = Int.max
    }
    
    override func viewDidLoad() {
        let userZip = keychain["zip"] ?? "90007"
        print(userZip)
        PropertyRequest().getSimilarHomes(zip: String(userZip) ?? "90007", bedrooms: 2, bathrooms: 2) { result in
          switch result {
            case .failure(let error):
                print(error)
            case .success(let properties):
                DispatchQueue.main.async{
                    for prop in properties{
                        let newHome: Home = Home(address: "\(prop.situshouseno) \(prop.situsstreet.upperCamelCase)", beds: Int(prop.bedrooms) ?? 0, baths: Int(prop.bathrooms) ?? 0, propertyValue: Int(prop.nettaxablevalue) ?? 0, image: "https://specials-images.forbesimg.com/imageserve/1026205392/960x0.jpg")
                        self.homes.append(newHome)
                    }
                    self.cardStack.delegate = self
                    self.cardStack.dataSource = self
                    self.layoutCardStackView()
                    self.configureBackgroundGradient()
            }
                
            }
        }
        
    }
    
    private func configureBackgroundGradient() {
        let backgroundGray = UIColor(red: 244/255, green: 247/255, blue: 250/255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, backgroundGray.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    private func layoutCardStackView() {
        view.addSubview(cardStack)
        cardStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    @objc private func handleShift(_ sender: UIButton) {
        cardStack.shift(withDistance: sender.tag == 1 ? -1 : 1, animated: true)
    }
}

extension HouseViewController: SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = HomeCard()
        card.configure(withHome: homes[index])
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return homes.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        print("Swiped all cards!")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        print("Undo \(direction) swipe on \(homes[index].address)")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("Swiped \(direction) on \(homes[index].address)")
        if(direction == .right){
            HomeValues.totalValue += homes[index].propertyValue
            HomeValues.numHomes += 1
            if homes[index].propertyValue > HomeValues.maxValue {
                HomeValues.maxValue = homes[index].propertyValue
            }
            if homes[index].propertyValue < HomeValues.minValue {
                HomeValues.minValue = homes[index].propertyValue
            }
        }
        print(HomeValues.totalValue)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Card tapped")
    }
    
//    func didTapButton(button: TinderButton) {
//        switch button.tag {
//        case 1:
//            cardStack.undoLastSwipe(animated: true)
//        case 2:
//            cardStack.swipe(.left, animated: true)
//        case 3:
//            cardStack.swipe(.up, animated: true)
//        case 4:
//            cardStack.swipe(.right, animated: true)
//        default:
//            break
//        }
//    }
}
