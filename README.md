# Implementation of Conquest Dicom Transfer Server inside Docker

This is a re-Implementation of the conquest server deployed by the PNI inside docker to allow more flexibility in where the software lives and less reliance on a bespoke system dedicated to the task.

## Configuration
The PNI install of conquest is built around using it in 'sink' mode, there is no database used as a backend, the webserver is not exposed to individuals for browsing the data. It's simply a transfer service that injests transmissions from our MRI machines and writes them to disk in a predictable manner.

## Legacy Notes:
Some decisions on this implementation will be carried forward from older installs; many or all of these can be changed in the future but for now we'll just be carrying them forward:

### Networking Config
* Port: `5678`

### User ID and UID
* user: `conquest`
* uid: `10000`
* group: `conquest`
* gid: `10000`

*note:* The data folders are owned by this UID with world read enabled to allow labs access to their data without the ability to alter the data stored

### Structured File Layout
```
FileNameSyntax = %V0008,1090-%callingae/%V0008,1030[0,5]/%studydate[0,3]/%id-%studydate[4,7]-%V0040,0245[0,3]/dcm/%seriesid-%imagenum-%V0018,0086.dcm
```
current layout: `modelname-AEtitle/<first six characters of study description (normalized labnames)>/<year>/<monthday-minutessecond>/dcm/seriesid-imagenumber-echonumber.dcm`

While verbose this naming structure

### PACS Device Name
* PNICONQUEST


## Test-GUI
It's possible to bring up a GinkgoCADx interface to test connections to the backend service, this is a WIP meant for testing and is not meant to be used as part of the deployed platform.  This is only expected to work on a linux deskop (due to display access variance in windows/osx). Simply run the `runGui.sh` command in a second terminal and you'll get a GinkgoCADx screen. The container will terminate when the application is closed.


# Checked out version in current tagged release:

commit a5d312ded0fc7ec03cc19e5ccfe99dcd96408734
Merge: d95bb9e f11829e
Author: marcelvanherk <marcelvanherk@users.noreply.github.com>
Date:   Sat Jun 20 21:35:31 2020 +0100

    Merge branch 'master' of https://github.com/marcelvanherk/Conquest-DICOM-Server

commit d95bb9e3b8377c6614ecef08a8122941e1bdfd55
Author: marcelvanherk <marcelvanherk@users.noreply.github.com>
Date:   Sat Jun 20 21:31:46 2020 +0100

    1.5.0a changes
    
    20200617        mvh     Replaced UNIX version of SendBinary with luasocket inspired waiting code
    20200618        mvh     Made send() timeout ~20s by increasingly longer nanosleep
    20200316        mvh Added dogloballua: servercommand - runs in global context in critical section
                        Also added critical section for nightly, background and dgate.lua
    20200528        mvh Version to 1.5.0a; changed truncation of AnyPageExceptions from 255 to 511
                            Use single DB per folder in LoadAndDeleteDir
    20200528        mvh     Fixed Pivoglot reported use of GetAtoi instead of GetUINT16 to read bitsperpixel


