# SwiftUI-Combine-Video

This project only uses SwiftUI, Combine, AVKit and Foundation and KingFisher pod with MVVM UI pattern. Although the project contains KingFisher pod but is not used anywhere in the app and is purely there to showcase my knowledge of Cocoapods. The project contains custom AsyncImage Loader and Caching on Memory, Video Downloading and Caching on Disk, API Data Caching on Disk, Custom implementation of ProgressBarView. 

## Core Concept
Unidirectional Data Flow Architecture based on State, Events and Reducer.

### State
Represents state of system at a given time.

### Event
All possible events that can happen and can cause transition to a new state. Represents a state change.

### Reducer
The only place where the state can change.

### Feedback
Decides which event should take place at a given state.







