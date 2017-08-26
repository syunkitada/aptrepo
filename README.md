# devrepo

## GitHubPagesでDEBを公開する
```
$ git clone https://github.com/syunkitada/aptrepo.git
$ cd aptrepo
$ git checkout --orphan gh-pages
$ mkdir -p ubuntu/16/amd64/pool

$ cp hoge.deb ubuntu/16/amd64/pool/
$ apt-ftparchive packages ubuntu/16/amd64/pool | gzip | sudo dd of=ubuntu/16/amd64/Packages.gz bs=1M
$ git add .
$ git commit -a -m "hoge"
$ git push origin gh-pages
```


## 参考
* [社内利用のための deb パッケージング入門](http://blog.cybozu.io/entry/2016/05/16/111500)


