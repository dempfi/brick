import UIKit
import SnapKit

let cellId = "PROFILE_CELL"

class ProfilesViewController: UICollectionViewController {
  var displayProfiles = [Profile]()
  var presenter: ProfilesPresenter?

  init() {
    super.init(collectionViewLayout: CarouselCollectionLayout())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavbar()
    configureView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.updateView()
  }

  func showProfiles(profiles: [Profile]) {
    displayProfiles = profiles
    collectionView.reloadData()
  }

  func configureView() {
    collectionView.register(ProfilesViewCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  func configureNavbar() {
    title = "Profiles"
    let addButton = BarButton(.add, onTap: presenter?.addProfile)
    navigationController?.navigationBar.topItem?.rightBarButtonItem = addButton
  }
}

extension ProfilesViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return displayProfiles.count
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let reausableCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    guard let cell = reausableCell as? ProfilesViewCell else { return reausableCell }
    cell.profile = displayProfiles[indexPath.row]
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter?.showProfile(profile: displayProfiles[indexPath.row])
  }
}
