//
//  ViewController.swift
//  PrivateGalleryApplication
//
//  Created by Andrew on 4/4/21.
//  Copyright © 2021 Andrew. All rights reserved.
//

import UIKit

struct  MyCustomData {
    var image: UIImage
    var imageName: String
}

class ViewController: UIViewController {
    
    fileprivate var data: [MyCustomData] = []
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MyCustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallery"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add New",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        
        checkIfPasswordExists()
        promptLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        // reload data
        loadAllImagesToData()
        setupView()
        setupconstraint()
        
    }
    
    @objc private func didTapAdd() {
        presentPhotoActionSheet()
    }
    
    func setupView(){
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupconstraint(){
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func checkIfPasswordExists() {
        if UserDefaults().value(forKey: "password") == nil {
            let vc = RegisterViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    private func promptLogin() {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    func saveImageToDocumentDirectory(image: UIImage ) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let now = Date()
            let formatter = ISO8601DateFormatter()
            var datetime = formatter.string(from: now)
            datetime = datetime.replacingOccurrences(of: ":", with: "_")
            let fileName = "img" + datetime // name of the image to be saved
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
                do {
                    try data.write(to: fileURL)
                    print("file saved")
                } catch {
                    print("error saving file:", error)
                }
            }
        }
        
    func loadAllImagesToData() -> Void {
        data = loadAllImagesFromDocumentDirectory()
        collectionView.reloadData()
        return
    }
    
    func loadAllImagesFromDocumentDirectory() -> [MyCustomData] {
        var dataArray:[MyCustomData] = []
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let fm = FileManager.default
            do {
                let items = try fm.contentsOfDirectory(atPath: dirPath)
                for item in items {
                    let itemUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(item)
                    if let img = UIImage(contentsOfFile: itemUrl.path) {
                        dataArray.append(MyCustomData(image: img, imageName: item))
                    }
                }
            } catch {}
        }
        return dataArray
    }
        
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Add Picture to Private App",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCustomCell

        cell.data = data[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var Width: CGFloat = collectionView.frame.width/4 - 1
        if UIDevice.current.orientation.isLandscape {
            Width = collectionView.frame.width/6 - 1
        }
        return CGSize(width: Width, height: Width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageVC()
        vc.selectedIndex = indexPath.row
        vc.imageArr = data
        pushView(viewController: vc)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        saveImageToDocumentDirectory(image: selectedImage)
        loadAllImagesToData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



