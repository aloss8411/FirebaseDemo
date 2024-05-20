//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Wei Ran Wang on 2024/5/16.
//

import UIKit
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseFirestoreSwift
import FirebaseFirestore

struct TestModel: Codable, Identifiable {
    @DocumentID var id: String?
    var reportID: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        appendItem()
//        loadItem()
    }
    
    func loadItem() {
        let db = Firestore.firestore()
        db.collection("DataTestModel").getDocuments { snapshot, error in
            guard let snapshot else { return }
            
            let models = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: TestModel.self)
            }
            

            for item in models {
                print(item.reportID)
            }
            
        }
    }
    
    func fetchItems() {
        let db = Firestore.firestore()
        db.collection("DataTestModel").order(by: "reportID").getDocuments { snapshot, error in
            guard let snapshot else { return }
            
            let models = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: TestModel.self)
            }
        }
    }
    
    func fetchSpecficItem() {
        let db = Firestore.firestore()
        db.collection("DataTestModel").whereField("reportID", isEqualTo: "Upload from IOS APP").getDocuments { snapshot, error in
           
        }
    }
    
    func fetchLimitItems() {
        let db = Firestore.firestore()
        db.collection("DataTestModel").order(by: "reportID").limit(to: 2).getDocuments { snapshot, error in
           
        }
    }
    
//    讀取某個 document 下的 collection 的 documents
    func loadDeepItem() {
        let db = Firestore.firestore()
        db.collection("DataTestModel").document("reportID").collection("albums").getDocuments { querySnapshot, error in
           
        }
    }
    
    func appendItem() {
        let db = Firestore.firestore()
        
        let model = TestModel(reportID: "Upload from IOS APP")
        do {
            let documentReference = try db.collection("DataTestModel").addDocument(from: model)
            print(documentReference.documentID)
        } catch {
            print("[ViewController] apppen item error, \(error)")
        }
    }

    func deleteItem() {
        let db = Firestore.firestore()
        let documentReference = db.collection("DataTestModel").document("Test")
        documentReference.delete()
    }
    
    func editItems() {
        let db = Firestore.firestore()
        let documentReference =
        db.collection("DataTestModel").document("Test")
        documentReference.getDocument { document, error in
            
            guard let document,
                  document.exists,
                  var model = try? document.data(as: TestModel.self)
            else {
                return
            }
            
            model.reportID = "New Test Model"
            do {
                try documentReference.setData(from: model)
            } catch {
                print(error)
            }
            
        }
    }
}

