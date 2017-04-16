#!/bin/sh

basedir=$(cd $(dirname $0) ; pwd)
sudo rsync --progress --partial --recursive --exclude LICENSE --exclude README.md --exclude $(basename $0) $basedir/* /etc/nixos
