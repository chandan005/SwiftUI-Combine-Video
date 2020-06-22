//
//  CircularProgressView.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import SwiftUI

struct CircularProgressView: View {
    @Environment(\.presentationMode) private var presentation
    @Binding var currentProgress: String
    @Binding var percentage: Float
    @Binding var didFinishDownload: Bool
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                ZStack {
                    Pulsation()
                    ProgressBarTrack()
                    ProgressBarLabel(currentProgress: currentProgress)
                    ProgressBarOutline(percentage: CGFloat(percentage))
                }
                Spacer()
                HStack {
                    didFinishDownload ?
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "checkmark.circle.fill").resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                        Text("Download Complete / Go Back").font(.system(size: 12)).fontWeight(.light).foregroundColor(.white)
                    }
                    :
                    Button(action: {
                         self.presentation.wrappedValue.dismiss()
                     }) {
                         Image(systemName: "xmark.circle.fill").resizable()
                             .frame(width: 40, height: 40)
                             .foregroundColor(.white)
                             .aspectRatio(contentMode: .fit)
                        Text("Cancel Download").font(.system(size: 12)).fontWeight(.light).foregroundColor(.white)
                     }
                }
            }
        }
    }

}

struct ProgressBarOutline: View {
    var percentage: CGFloat = 0
    var currentProgress: String = ""
    var colors: [Color] = [Color.outlineColor]
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .frame(width: 250, height: 250)
            .overlay(
                Circle()
                    .trim(from: 0, to: percentage * 0.01)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .fill(AngularGradient(gradient: .init(colors: colors), center: .center, startAngle: .zero, endAngle: .init(degrees: 360))
                ).animation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0))
            )
        }
    }
    
}

struct ProgressBarTrack: View {
    var colors: [Color] = [Color.trackColor]
    
    var body: some View {
        ZStack {
             Circle()
                .fill(Color.backgroundColor)
                .frame(width: 250, height: 250)
                .overlay(
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20))
                    .fill(AngularGradient(gradient: .init(colors: colors), center: .center))
            )
        }
    }
    

}

struct ProgressBarLabel: View {
    var currentProgress: String = ""
    var body: some View {
        ZStack {
            Text(currentProgress).font(.system(size: 20)).fontWeight(.heavy).foregroundColor(.white)
        }
    }
}

struct Pulsation: View {
    @State private var pulsate = false
    var colors: [Color] = [Color.trackColor]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.pulsatingColor)
                .frame(width: 245, height: 245)
                .scaleEffect(pulsate ? 1.3 : 1.1)
                .animation(Animation.easeInOut(duration: 1.1).repeatForever(autoreverses: true))
                .onAppear {
                    self.pulsate.toggle()
            }
        }
    }
}
