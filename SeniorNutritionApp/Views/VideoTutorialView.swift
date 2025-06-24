import SwiftUI
import AVKit

struct VideoTutorialView: View {
    let videoName: String
    let videoType: String
    @State private var player: AVPlayer?
    @State private var thumbnail: UIImage?
    @State private var isPlaying = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(playButton, alignment: .center)
                    .onAppear {
                        if !isPlaying {
                            player.pause()
                        }
                    }
            } else if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(playButton, alignment: .center)
            } else {
                placeholderView
            }
        }
        .onAppear(perform: setupPlayer)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Video Not Found"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    @ViewBuilder
    private var playButton: some View {
        if !isPlaying {
            Button(action: {
                if player != nil {
                    isPlaying = true
                    player?.play()
                } else {
                    setupPlayer()
                    if player != nil {
                        isPlaying = true
                        player?.play()
                    }
                }
            }) {
                Image(systemName: "play.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }

    private var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.5)
            VStack {
                Image(systemName: "video.slash.fill")
                    .font(.largeTitle)
                Text("Video not available")
            }
            .foregroundColor(.white)
        }
        .frame(height: 200)
        .cornerRadius(12)
    }

    private func setupPlayer() {
        guard let videoURL = findVideoURL() else {
            self.alertMessage = "The video file '\(videoName).\(videoType)' could not be found."
            self.showingAlert = true
            return
        }
        
        self.player = AVPlayer(url: videoURL)
        generateThumbnail(for: videoURL)
    }

    private func findVideoURL() -> URL? {
        // Check main bundle
        if let url = Bundle.main.url(forResource: videoName, withExtension: videoType) {
            return url
        }
        
        // Check in a specific 'Resources/Videos' directory relative to the file
        let fileManager = FileManager.default
        let projectDir = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let videosDir = projectDir.appendingPathComponent("Resources/Videos")
        let potentialURL = videosDir.appendingPathComponent("\(videoName).\(videoType)")
        
        if fileManager.fileExists(atPath: potentialURL.path) {
            return potentialURL
        }
        
        return nil
    }

    private func generateThumbnail(for url: URL) {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, _, _ in
            if let cgImage = image {
                DispatchQueue.main.async {
                    self.thumbnail = UIImage(cgImage: cgImage)
                }
            }
        }
    }
}
