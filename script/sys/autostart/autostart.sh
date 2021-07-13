#!/bin/bash
# cmd localtion

istart(){
  cd $1 
  ./run.sh restart
}


istart /data/dflc/dev/dev/
istart /data/dflc/dev/city/
istart /data/dflc/dev/workflow/
