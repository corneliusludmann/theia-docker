#!/bin/sh

set -euxo

# Install dependencies for the Go plugin
# see https://github.com/Microsoft/vscode-go/wiki/Go-tools-that-the-Go-extension-depends-on

go get github.com/acroca/go-symbols
go get github.com/cweill/gotests/...
go get github.com/davidrjenni/reftools/cmd/fillstruct
go get github.com/fatih/gomodifytags
go get github.com/go-delve/delve/cmd/dlv
go get github.com/godoctor/godoctor
go get github.com/haya14busa/goplay/cmd/goplay
go get github.com/josharian/impl
go get github.com/mdempsky/gocode
go get github.com/ramya-rao-a/go-outline
go get github.com/rogpeppe/godef
go get github.com/sqs/goreturns
go get github.com/stamblerre/gocode
go get github.com/uudashr/gopkgs/cmd/gopkgs
go get golang.org/x/lint/golint
go get golang.org/x/tools/cmd/gorename
go get golang.org/x/tools/cmd/guru
go get golang.org/x/tools/gopls
