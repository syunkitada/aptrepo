# devrepo


## repo 設定
```
$ cat <<EOF | sudo dd of=/etc/apt/sources.list.d/syunkitada-aptrepo.list
deb [trusted=yes] http://syunkitada.github.io/aptrepo/ubuntu/16/amd64/ ./
EOF
$ sudo apt-get update
$ sudo apt-get install hoge
```


## GitHubPagesでDEBを公開する
```
$ git clone https://github.com/syunkitada/aptrepo.git
$ cd aptrepo
$ git checkout --orphan gh-pages
$ mkdir -p ubuntu/16/amd64/pool

$ cp hoge.deb ubuntu/16/amd64/pool/
$ cd ubuntu/16/amd64/
$ apt-ftparchive packages pool | gzip | sudo dd of=Packages.gz bs=1M
$ git add .
$ git commit -a -m "hoge"
$ git push origin gh-pages
```


## 参考
* [社内利用のための deb パッケージング入門](http://blog.cybozu.io/entry/2016/05/16/111500)
