# iTerm2-borderless

![iTerm2-borderless](https://github.com/jasonwoodland/iTerm2-borderless/blob/master/Preview.png?raw=true)

My custom iTerm2 patch and build. Consistently updated. (Build 3.2.20180526)

* Hides the window title bar
* Hides the tab bar
* Fixes window title rendering
* New window title which displays either the title *or* the job name
* New advanced options found under *Preferences > Advanced*: (Search for *&ldquo;borderless&rdquo;*)
  * ***Standard window buttons horizontal/vertical offset:*** Change the position of the window buttons and title bar.
  * ***Window title format:*** Set a custom title format
  * ***Set cursor foreground color:*** Set whether to change the cursor foreground color
  * ***Duration before cursor starts blinking:*** Set a duration for when the cursor should start blinking after it has moved
    
  * ~~***Vertical cursor width***~~ You can now change the cursor width by setting *Vertical bar cursor width*
* ~~Extra window padding~~ You can now change the margins in *Preferences > Advanced > General*
* ~~Reverted to slightly bolder font smoothing~~ Set *Preferences > Profiles > Text > Use thin strokes for anti-aliased text* to *Never*

Download the [latest release](https://github.com/jasonwoodland/iTerm2-borderless/releases/latest) and copy `iTerm2.app` to `/Applications`, or apply the patch yourself. (Open an issue if it fails patching so I can fix it)
## Patch it yourself

### 1. Get iTerm2 and iTerm2-borderless

```
git clone https://github.com/gnachman/iTerm2.git
git clone https://github.com/jasonwoodland/iTerm2-borderless.git
```

### 2. Patch

```
cd iTerm2
patch -p1 < ../iTerm2-borderless/iTerm2-borderless.patch
```

### 3. Build

You might need to set the development team in Xcode before building. Open the Xcode project file with the open command below, and change the team under *General > Signing > Team*

```
open iTerm2.xcodeproj
```

Build for deployment with `xcodebuild` and show it in the Finder

```
xcodebuild -project iTerm2.xcodeproj -configuration Deployment -target iTerm2 -parallelizeTargets
open build/Deployment
```

Drag the app to `/Applications`

### 4. Set preferences

In the patched build, go to *Preferences > Appearance* and disable *Show line under title bar when the tab bar is not visible*

Next, go to *Preferences > Advanced*

#### Set the terminal margins

* Height of top and bottom margins in terminal panes
* Width of left and right margins in terminal panes

#### Set the title bar margins

* Standard window buttons horizontal offset
* Standard window buttons vertical offset

## To do

- [ ] The title bar drag area needs increasing
- [ ] Override preferences which break the patch for people (also override margin: 0)
