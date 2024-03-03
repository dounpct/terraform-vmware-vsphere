#!/bin/bash

free -m 

swapoff  -v /dev/vg00/swap

lvextend -L +6G /dev/vg00/swap

mkswap /dev/vg00/swap

swapon  -v /dev/vg00/swap

free -m