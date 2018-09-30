import UIKit
import SBrick

class ProfilesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "PROFILE_CELL"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profiles"
        
        guard let navbar = navigationController?.navigationBar else { return }
        navbar.prefersLargeTitles = true
        navbar.barStyle = .black
        navbar.isTranslucent = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
}


extension ProfilesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}
