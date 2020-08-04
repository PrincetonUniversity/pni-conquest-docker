# Implementation of Conquest Dicom Transfer Server inside Docker

This is a re-Implementation of the conquest server deployed by the PNI inside docker to allow more flexibility in where the software lives and less reliance on a bespoke system dedicated to the task.

## Configuration
The PNI install of conquest is built around using it in 'sink' mode, there is no database used as a backend, the webserver is not exposed to individuals for browsing the data. It's simply a transfer service that injests transmissions from our MRI machines and writes them to disk in a predictable manner.

## Legacy Notes:
Some decisions on this implementation will be carried forward from older installs; many or all of these can be changed in the future but for now we'll just be carrying them forward:

### Networking Config
* Port: 5678

### User ID and UID
* user: `conquest`
* uid: `10000`
* group: `conquest`
* gid: `10000`

*note:* The data folders are owned by this UID with world read enabled to allow labs access to their data without the ability to alter the data stored 

### Structured File Layout
* FileNameSyntax = %V0008,1090-%callingae/%V0008,1030[0,5]/%studydate[0,3]/%id-%studydate[4,7]-%V0040,0245[0,3]/dcm/%seriesid-%imagenum-%V0018,0086.dcm
#current layout: modelname-AEtitle/<first six characters of study description (normalized labnames)>/<year>/<monthday-minutessecond>/dcm/seriesid-imagenumber-echonumber.dcm

### PACS Device Name
* PNICONQUEST
