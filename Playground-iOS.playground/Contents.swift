// Differific iOS Playground

import UIKit
import Differific
import PlaygroundSupport

final class CollectionViewHandler: NSObject, UICollectionViewDataSource {
    
    var values = ["Foo", "Bar"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        let value = values[indexPath.row]
        cell.label.text = value
        return cell
    }
}

final class MyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CellID"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.text = "Foo"
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MyViewController : UIViewController {
    
    private let handler = CollectionViewHandler()
    
    private let collectionView = UICollectionView(frame: CGRect(origin: .zero, size: .init(width: 379, height: 450)), collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.dataSource = handler
        view.addSubview(collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sleep(2)
        
        let new = ["Foo", "Bar", "Baz"]
        let changes = DiffManager().diff(handler.values, new)
        collectionView.reload(with: changes, updateDataSource: {
            handler.values = new
        })
    }
}

PlaygroundPage.current.liveView = MyViewController()
