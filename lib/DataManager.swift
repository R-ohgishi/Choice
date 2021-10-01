//
//  DataManager.swift
//  Choice
//
//  Created by 橋本周三 on 9/17/21.
//

import Foundation
import RealmSwift


//データ構造
class Setting:Object {
    @objc dynamic var tag = 0
    @objc dynamic var faceString_front = ""
    @objc dynamic var faceString_back = ""
}

//realm から読み込む関数
class  DataManager{
    // realmに書き込む
    static func add(faceString_front:String,faceString_back:String){
        let setting = Setting()
        
        do{
            let realm = try Realm()
            
            //realmに追加して
            try realm.write{
                setting.faceString_front = faceString_front
                setting.faceString_back = faceString_back
                realm.add(setting)
            }
        }catch{
            //エラ〜が起こった時に何をするか書く
        }
    }
    
    
    // raalmからデータ読み込む
    static func read(setting:inout Setting){
        do{
            let realm = try Realm()
            setting = realm.objects(Setting.self).last!
            
        }catch{
            
        }
        
    }
    //アップデートする
    static func updata(faceString_front:String,faceString_back:String){
        var setting = Setting()
        
        do{
            let realm = try Realm()
            //realmから読み込む
            read(setting:&setting)
            
            //realmに書き込む
            try realm.write{
                setting.faceString_front = faceString_back
                setting.faceString_back = faceString_back
                
            }
        }catch{
            //エラ〜が起こった時に何をするか書く
        }
        
    }
}
