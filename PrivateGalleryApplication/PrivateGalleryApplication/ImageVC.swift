//
//  ImageVC.swift
//  PrivateGalleryApplication
//
//  Created by Andrew on 4/4/21.
//  Copyright © 2021 Andrew. All rights reserved.
//

import UIKit
class ImageVC: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    var selectedIndex: Int = 0
    var imageArr: [MyCustomData] = []
    
    fileprivate let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentMode = .scaleAspectFit
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = .black
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 6
        return sv
    }()
    
    fileprivate let img: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    fileprivate let countlbl: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    fileprivate let closeBtn: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate let deleteBtn: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "ic_delete")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        return button
    }()
    
    
    @objc func closeBtnTapped(){
        self.dismissView()
    }
    
    @objc func deleteBtnTapped(){
        print("removing \(imageArr[selectedIndex])")
        let imgNameToDelete = imageArr[selectedIndex].imageName
        imageArr.remove(at: selectedIndex)
        deleteImageFromDocumentDirectory(nameOfImage: imgNameToDelete)
        self.dismissView()
    }
    
    func deleteImageFromDocumentDirectory(nameOfImage : String) -> Void {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            do {
                try FileManager.default.removeItem(at: imageURL)
            }
            catch {
                print("Unable to find/ delete: \(imageURL)")
            }
        }
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        scrollView.delegate = self
        
        setupGesture()
        setupView()
        setupconstraint()
        loadImage()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupGesture(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapOnScrollView(recognizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnScrollView(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        
        let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:)))
        let leftSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:)))
        
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        
        scrollView.addGestureRecognizer(rightSwipe)
        scrollView.addGestureRecognizer(leftSwipe)
    }
    
    func setupView(){
        view.addSubview(scrollView)
        scrollView.addSubview(img)
        view.addSubview(countlbl)
        view.addSubview(closeBtn)
        view.addSubview(deleteBtn)
    }
    
    func setupconstraint(){
        scrollView.frame = view.bounds
        img.frame = scrollView.bounds

        countlbl.frame = CGRect(x: 20, y: view.frame.height - 50, width: view.frame.width - 40, height: 21)
        closeBtn.frame = CGRect(x: 20, y: (self.navigationController?.navigationBar.frame.size.height)!, width: 25, height: 25)
        deleteBtn.frame = CGRect(x: view.frame.maxX - 50, y: (self.navigationController?.navigationBar.frame.size.height)!, width: 25, height: 25)
    }
    
    func loadImage(){
        img.image = imageArr[selectedIndex].image
        countlbl.text = String(format: "%ld / %ld", selectedIndex + 1, imageArr.count)
    }
    
    @objc func handleSingleTapOnScrollView(recognizer: UITapGestureRecognizer){
        if closeBtn.isHidden {
            closeBtn.isHidden = false
            countlbl.isHidden = false
            deleteBtn.isHidden = false
        }else{
            closeBtn.isHidden = true
            countlbl.isHidden = true
            deleteBtn.isHidden = true
        }
    }
    
    @objc func handleDoubleTapOnScrollView(recognizer: UITapGestureRecognizer){
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
            closeBtn.isHidden = true
            countlbl.isHidden = true
            deleteBtn.isHidden = true
        } else {
            scrollView.setZoomScale(1, animated: true)
            closeBtn.isHidden = false
            countlbl.isHidden = false
            deleteBtn.isHidden = false
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = img.frame.size.height / scale
        zoomRect.size.width  = img.frame.size.width  / scale
        let newCenter = img.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img
    }
    
    @objc func handleSwipeFrom(recognizer: UISwipeGestureRecognizer){
        let direction: UISwipeGestureRecognizer.Direction = recognizer.direction
        
        switch (direction) {
        case UISwipeGestureRecognizer.Direction.right:
            self.selectedIndex -= 1
            
        case UISwipeGestureRecognizer.Direction.left:
            self.selectedIndex += 1
        
        default:
            break
        }
        self.selectedIndex = (self.selectedIndex < 0) ? (self.imageArr.count - 1):
            self.selectedIndex % self.imageArr.count
        
        loadImage()
        
    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer){
        print(recognizer)
        recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
        recognizer.scale = 1
        img.contentMode = .scaleAspectFit
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = img.image {
                let ratioW = img.frame.width / image.size.width
                let ratioH = img.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW:ratioH
                let newWidth = image.size.width*ratio
                let newHeight = image.size.height*ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale > img.frame.width ? (newWidth - img.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > img.frame.height ? (newHeight - img.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
}
