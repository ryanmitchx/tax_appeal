import Shuffle_iOS
import KeychainAccess

class HouseViewController: UIViewController {
    
    private let cardStack = SwipeCardStack()
    private let keychain = Keychain(service: "com.brs.TaxAppeal")
    
    private let homes = [
        Home(address: "3131 S Hoover St", beds: 2, baths: 2, propertyValue: 400000, image: "https://specials-images.forbesimg.com/imageserve/1026205392/960x0.jpg"),
        Home(address: "Address2", beds: 3, baths: 2, propertyValue: 400000, image: "https://www.whatever.com/png")
    ]
    
    
    override func viewDidLoad() {
        let userZip = keychain["zip"]
        PropertyRequest().getDetails(zip: userZip ?? "90007") { result in
          switch result {
            case .failure(let error):
                print(error)
            case .success(let properties):
                let myProperty: Property = properties[0]
                PropertyRequest().getProperties(myHouse: myProperty) { result in
                    switch result {
                      case .failure(let error):
                          print(error)
                      case .success(let properties):
                        for prop in properties {
                            print(prop.bathrooms + " " + prop.bedrooms)
                        }
                    }
                }
            }
        }
        
        cardStack.delegate = self
        cardStack.dataSource = self
//        configureNavigationBar()
        layoutCardStackView()
        configureBackgroundGradient()
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
