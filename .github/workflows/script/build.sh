#!/bin/bash

# site_generator 直下でこのスクリプトを実行すること

set -ex

# サイトの生成
pip3 install -r docker/requirements.txt
python3 run.py settings.boostjp --concurrency=`nproc`

# 生成されたサイトの中身を push
pushd boostjp/boostjp.github.io
  # push するために ssh のリモートを追加する
  git remote add origin2 git@github.com:boostjp/boostjp.github.io.git

  git add ./ --all
  git config --global user.email "shigemasa7watanabe+boostjp@gmail.com"
  git config --global user.name "boostjp-autoupdate"
  git commit -a -m "update automatically"
  git push origin2 master
popd
