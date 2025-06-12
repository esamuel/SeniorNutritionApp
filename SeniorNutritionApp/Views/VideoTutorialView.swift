import SwiftUI
import AVKit
import Foundation

struct VideoTutorialView: View {
    let videoName: String
    let videoDescription: String
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var isFullScreen = false
    @State private var thumbnail: UIImage?
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(videoName)
                .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
            
            Text(videoDescription)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            
            if let player = player {
                ZStack {
                    VideoPlayer(player: player)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    if !isPlaying, let thumbnail = thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .cornerRadius(12)
                            .overlay(
                                Button(action: {
                                    player.play()
                                    isPlaying = true
                                }) {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                            )
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                isFullScreen = true
                            }) {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(8)
                            }
                            .padding(10)
                        }
                    }
                }
                .frame(height: 220)
                .fullScreenCover(isPresented: $isFullScreen) {
                    VideoPlayer(player: player)
                        .edgesIgnoringSafeArea(.all)
                        .onDisappear {
                            // Resume playback state
                            if isPlaying {
                                player.play()
                            }
                        }
                        .overlay(
                            Button(action: {
                                isFullScreen = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .padding(), alignment: .topTrailing
                        )
                }
            } else {
                // Placeholder when video can't be loaded
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "video.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text(NSLocalizedString("Video not available", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 220)
            }
        }
        .padding()
        .onAppear {
            loadVideo()
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    private func loadVideo() {
        // Try to find the video in multiple locations
        if let videoURL = findVideoURL() {
            let player = AVPlayer(url: videoURL)
            self.player = player
            
            // Generate thumbnail
            generateThumbnail(from: videoURL)
            
            // Add observer for playback status
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                player.seek(to: .zero)
                isPlaying = false
            }
        }
    }
    
    private func findVideoURL() -> URL? {
        // First try to find in bundle
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            return url
        }
        
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mov") {
            return url
        }
        
        // Then try to find in Resources/Videos directory
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let videosDirectory = documentsDirectory.appendingPathComponent("Resources/Videos")
        
        let mp4URL = videosDirectory.appendingPathComponent("\(videoName).mp4")
        if fileManager.fileExists(atPath: mp4URL.path) {
            return mp4URL
        }
        
        let movURL = videosDirectory.appendingPathComponent("\(videoName).mov")
        if fileManager.fileExists(atPath: movURL.path) {
            return movURL
        }
        
        // During development, try to find in the project directory
        #if DEBUG
        let projectDirectory = Bundle.main.bundleURL.deletingLastPathComponent()
        let resourcesDirectory = projectDirectory.appendingPathComponent("Resources/Videos")
        
        let debugMP4URL = resourcesDirectory.appendingPathComponent("\(videoName).mp4")
        if fileManager.fileExists(atPath: debugMP4URL.path) {
            return debugMP4URL
        }
        
        let debugMOVURL = resourcesDirectory.appendingPathComponent("\(videoName).mov")
        if fileManager.fileExists(atPath: debugMOVURL.path) {
            return debugMOVURL
        }
        #endif
        
        return nil
    }
    
    private func generateThumbnail(from videoURL: URL) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        // Get thumbnail at 1 second
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
        }
    }
}

struct VideoTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTutorialView(
            videoName: "Getting Started",
            videoDescription: "Learn how to use the basic features of the app"
        )
        .environmentObject(UserSettings())
    }
}
