#! /bin/bash

## this is a quick shim for launching ginkgocadx as a gui tool while launching conquest as a standard

docker build -f ginkgocadx.Dockerfile -t ginkgocadx-gui .

docker run --rm -it --net=host -e DISPLAY -v $HOME/.Xauthority:/root/.Xauthority -v $PWD/conquest-ref-data:/mnt/data ginkgocadx-gui
