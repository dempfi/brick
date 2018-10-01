import UIKit
import CoreData
import CenteredCollectionView
import SnapKit

class ProfilesViewController: UIViewController {
  let CELL_ID = "PROFILE_CELL"
  var collectionView: UICollectionView!
  let layout = CenteredCollectionViewFlowLayout()

  lazy var profilesController = {
    return Store.profilesController(delegate: self)
  }()
  
  var navbar: UINavigationBar? {
    get {
      return navigationController?.navigationBar
    }
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    collectionView = UICollectionView(centeredCollectionViewFlowLayout: layout)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Profiles"
    setupCarousel()
  }
  
  private func setupCarousel() {
    view.addSubview(collectionView)
    
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    collectionView.snp.makeConstraints { (make) -> Void in
      make.width.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }

    collectionView.register(ProfilesCellView.self, forCellWithReuseIdentifier: CELL_ID)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.dataSource = self
    collectionView.delegate = self

    layout.itemSize = CGSize(width: 550, height: 280)
    layout.minimumLineSpacing = 20
  }

  @objc func addProfile(sender: UIButton) {
    let addViewController = AddProfileViewController()
    let addNavigationController = UINavigationController(rootViewController: addViewController)
    navigationController?.modalTransitionStyle = .coverVertical
    navigationController?.present(addNavigationController, animated: true, completion: nil)
  }
}

extension ProfilesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let sections = profilesController.sections else {
      fatalError("No sections in profilesController")
    }
    return sections[section].numberOfObjects
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath)
    return cell
  }
}

extension ProfilesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let profileView = ProfileViewController()
    profileView.profile = profilesController.object(at: indexPath)
    navigationController?.pushViewController(profileView, animated: true)
  }
}

extension ProfilesViewController: NSFetchedResultsControllerDelegate {
}
