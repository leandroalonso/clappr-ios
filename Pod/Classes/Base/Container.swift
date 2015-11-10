public class Container: UIBaseObject {
    public internal(set) var playback: Playback
    
    public init (playback: Playback) {
        self.playback = playback
        super.init(frame: CGRect.zero)
        self.addSubview(playback)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(playback: Playback) instead")
    }
    
    public func destroy() {
        stopListening()
        playback.destroy()
        
        removeFromSuperview()
    }
    
    public func play() {
        playback.play()
    }
    
    public func pause() {
        playback.pause()
    }
    
    public func stop() {
        playback.stop()
    }
    
    public func seekTo(timeInterval: NSTimeInterval) {
        playback.seekTo(timeInterval)
    }
}