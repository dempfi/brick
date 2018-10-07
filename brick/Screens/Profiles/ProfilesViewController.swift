import UIKit
import CoreData
import SnapKit

class ProfilesViewController: UIViewController {
  let cellId = "PROFILE_CELL"
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ProfilesCollectionLayout())
  var sbrickManager: SBrickManager!

  lazy var profilesController = {
    return Store.profilesController(delegate: self)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Profiles"
    setupCollectionView()
    setupNavigation()
  }

  private func setupCollectionView() {
    view.addSubview(collectionView)

    collectionView.snp.makeConstraints { (make) -> Void in
      make.width.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }

    collectionView.register(ProfilesCellView.self, forCellWithReuseIdentifier: cellId)
    collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  private func setupNavigation() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProfile))
    navigationController?.navigationBar.topItem?.rightBarButtonItem = addButton
  }

  @objc private func addProfile(sender: UIButton) {
    let addViewController = AddProfileViewController()
    let addNavigationController = UINavigationController(rootViewController: addViewController)
    navigationController?.modalTransitionStyle = .coverVertical
    navigationController?.present(addNavigationController, animated: true, completion: nil)
  }
}

extension ProfilesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let sections = profilesController.sections else { return 0 }
    return sections[section].numberOfObjects
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let reausableCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let cell = reausableCell as? ProfilesCellView else { return reausableCell }
    cell.profile = profilesController.object(at: indexPath)
    return cell
  }
}

extension ProfilesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let profile = profilesController.object(at: indexPath)
    let view = ProfileViewController(profile: profile, manager: self.sbrickManager)
    navigationController?.pushViewController(view, animated: true)
  }
}

extension ProfilesViewController: NSFetchedResultsControllerDelegate {
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?
  ) {

    switch type {
    case .insert:
      if let indexPath = newIndexPath {
        collectionView.insertItems(at: [indexPath])
      }

    case .delete:
      if let indexPath = indexPath {
        collectionView.deleteItems(at: [indexPath])
      }

    default: break
    }
  }
}
