# wallpaper-pauser
A simple script to pause the wallpaper slideshow on Windows, and reactivate it when taxing processes quit.

## Motivation
Apparently the GPU in my laptop is kinda crap (who could have guessed) so when my desktop wallpaper changes in any even moderately taxing game, it causes frame drops for a good couple seconds. This is very annoying.

## Requirements
* An Nvidia graphics card, with the nvidia-smi utility (this should be installed by default with most modern drivers.)
* A Windows PC running a vaguely modern version of Powershell? idk man, if you try run this on Vista or some shit, you deserve what you get
* A sufficient disregard for the stability of your system to run some random script I wrote in an evening

## How to use
1. Launch the taxing game/application/whatever
2. Run the utility - if this is the first time you've run the utility against this application, it'll prompt you to save it
3. Wallpaper rotation will be paused until the application quits, at which point, the rotation will be set back to its original interval, and the utility will quit

## Future improvements
Honestly, this could probably be written just as easily (or easier) to be a permanent daemon in the background, but as an interim measure, I liked the expliciteness and visiblity of having to launch something that then went away when it was done, and only activated on certain applications.
