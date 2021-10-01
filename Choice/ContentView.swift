//
//  ContentView.swift
//  Choice
//
//  Created by 橋本周三 on 7/11/21.
//

import SwiftUI
import AVFoundation
import GoogleMobileAds  //admob

struct ContentView: View {
    
    //    @ObservedObject private var setview = SetView()
    
    @State var isHomeActive = false
    @State var showAnime = false
    @State private var showProgress = false
    @State private var degree = 0.0
    @State  var pivotDgree = 0.0
    @State  var count = 0
    @State private var timer: Timer?
    @State var intervaltime: Double  = 0.006
    @State var face: String  = " "
    @State var faceBox = ["ChoiceOK","ChoiceNG","ChoiceYes","ChoiceNo",
                          "Choice許す","Choice許さん"]
    var setmenu = 0
    @State var flag = 0
    @State var flagR = 0
    @State var flagS = 0//受け渡し子
    @State var flagSS = 0
    @State var flagSSC = 0
    @State var timerStop = 0
    @State var stopButton = "運命のSTART"
    @ObservedObject var vmc = SettingViewModel()
    
    let stopTiming = 360
    
    private let dramRoolSound = try! AVAudioPlayer(data: NSDataAsset(name: "dramrool")!.data)  //抽選時のドラムロール音
    private let dramRoolEndSound = try! AVAudioPlayer(data: NSDataAsset(name: "dramroolEnd")!.data)  //抽選時のドラムロールエンド音
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 10.0)
            .repeatForever(autoreverses: false)
    }
    
 
    private func setupTimer() {
        flagSS = vmc.flagS
        timer = Timer.scheduledTimer(withTimeInterval: intervaltime, repeats: true, block: { (input) in
            // ルーレット化
            if degree == 90 {
                if flagSSC == 0 {
                    flagSS += 1
                    flagSSC = 1
                } else {
                    flagSS -= 1
                    flagSSC = 0
                }
                degree = 270   //　裏面を見せない為、90度手前から表示させる
            }
            if degree >= 360 {
                degree = 0
            }
            timerStop += 1
            //     degree += 1
            
            if timerStop < 91 {  //91
                degree += 1
                
            }else if timerStop >= 91 && timerStop < 181{  //91 271
                degree += 2
                
            }else if timerStop >= 181 && timerStop < 361 {  //271 541
                degree += 5
                
            }else if timerStop >= 361 {     //541
                degree += 10
            }
            if timerStop > stopTiming {
                stopButton = "運命のSTOP"
            }
            face = faceBox[flagSS]
            
            
            // SetView.setmenu = 1
        })
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("")
                Spacer()
                Button(action: {
                    if flag == 0 {
                        showAnime = true  // imageを表示に切り替え
                        setupTimer()  //　ルーレット回転アクティブ
                        dramRoolSound.play() //効果音スタート
                        flag = 1
                        stopButton = "wait..."
                    } else if flag == 1 && timerStop > stopTiming {
                        if degree <= 90 {
                            degree = 0
                        } else if degree >= 270 {
                            degree = 0
                        }
                        showAnime = false  // imageを表示に切り替え
                        timer?.invalidate()  //　ルーレット回転STOP
                        dramRoolSound.stop() //効果音STOP
                        dramRoolEndSound.play()
                        flag = 2
                    }
                }, label: {
                    VStack {
                        Spacer()
                        Image(face)
                            .resizable()
                            .frame(width: 300, height: 400, alignment: .center)
                            .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
                        Spacer()
                        if flag < 2 {
                            Text (stopButton)
                                .font(.largeTitle)
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                })
                VStack {
                    Spacer()
                    if flagR < 1 {
                        Button(action: {
                            showAnime = false
                            flag = 0
                            stopButton = "泣きの1回、再スタート"
                            degree = 90
                            timerStop = 0
                            flagR += 1
                            
                        },label:{
                            VStack {
                                Text("reset")
                                    .font(.title)
                                    .foregroundColor(Color.blue)
                            }
                        })
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        //   NavigationLink(destination:SetView(isContentViewActive:$isHomeActive,flagS :$cflagS),isActive:$isHomeActive) {
                        NavigationLink(destination:SetView(isContentViewActive:$isHomeActive, vms : vmc),isActive:$isHomeActive) {
                            
                            Button(action: {
                                self.isHomeActive = true
                            },label:{
                                Text("設定            ")
                                    .foregroundColor(Color.gray)
                            })
                        }
                    }
                }
                AdView()  //admob
            }
        }
    }
}



func adUnitID(key: String) -> String? {
    guard let adUnitIDs = Bundle.main.object(forInfoDictionaryKey: "AdUnitIDs") as? [String: String] else {
        return nil
    }
    return adUnitIDs[key]
}

struct AdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
        banner.adUnitID = adUnitID(key: "banner")
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
