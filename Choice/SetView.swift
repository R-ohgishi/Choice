//
//  SetView.swift
//  Choice
//
//  Created by 橋本周三 on 8/15/21.
//

import Foundation
import SwiftUI
import UIKit

struct SetView: View {
    @Binding var isContentViewActive: Bool
//    @Binding var flagS:Int
    @State var flagS = 0
    @State var flagR = 1
    
    @State var faceBox = ["ChoiceOK","ChoiceNG","ChoiceYes","ChoiceNo",
                          "Choice許す","Choice許さん"]
    var setmenu = 0
    @ObservedObject var vms  = SettingViewModel()
    
    var body: some View {
        VStack {
            Text("使い方")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.gray)
            Text("")
            Text("１. スタートボタンでスタート")
            Text("２.貴方の運命を念じSTOPボタンを押す")
            Text("３.そこに出た表示が貴方がとるべき選択です")
        }
        VStack {
            Text("")
            Text("")
            Text("下のボタンを押して好きな組み合わせを選んでね")
                .foregroundColor(.gray)
                .font(.subheadline)
            Text("選んだら、左上の「Back」ボタンで戻って下さい")
                .foregroundColor(.gray)
                .font(.subheadline)
            Text("")
            Text("")
            Button(action: {
                vms.flagS += 2
                if vms.flagS > 5 {
                    vms.flagS = 0
                }
            }, label: {
                VStack{
                    Text("Choiceの種類選択ボタン")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.green)
                    
                }
            })
            
            HStack {
                Image(faceBox[vms.flagS])
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                Text ("／")
                Image(faceBox[vms.flagS + 1])
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
            }
            Spacer()
            VStack {
                Text("占う回数")
                    .font(.title)
                    .foregroundColor(.black)
            HStack {
                Button(action: {
                    self.flagR += 1
                }, label: {
                    VStack{
                        Text("          +")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                })
                Text ("  ")
                Button(action: {
                    self.flagR -= 1
                }, label: {
                    VStack{
                        Text("-")
                            .font(.title)
                            .foregroundColor(.green)
                        
                    }
                    Text("    ")
                    Text(String(flagR))
                        .font(.largeTitle)
                })
            }
        }
        }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
