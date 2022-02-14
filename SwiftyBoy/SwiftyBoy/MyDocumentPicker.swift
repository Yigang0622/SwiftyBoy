//
//  FileUtil.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/2/12.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

class MyDocumentPicker: NSObject, UIDocumentBrowserViewControllerDelegate, UIDocumentPickerDelegate {
    
    var completion: ((URL?) -> Void)?
    
    func showPicker(fromController: UIViewController, fileType: String, completion: @escaping ((URL?) -> Void)) {
        self.completion = completion
//        let types = UTType.types(tag: fileType, tagClass: UTTagClass.filenameExtension, conformingTo: nil)
//        let documentPickerController = UIDocumentBrowserViewController(forOpening: types)
//        documentPickerController.delegate = self
//        fromController.present(documentPickerController, animated: true, completion: nil)
        print(self)
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.item"], in: UIDocumentPickerMode.import)
        documentPickerController.delegate = self
        fromController.present(documentPickerController, animated: true, completion: nil)

    }
    
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        print("done")
        self.completion?(documentURLs.first)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("done")
        self.completion?(urls.first)
    }
    
}
