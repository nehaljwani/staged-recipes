export GOPATH="${SRC_DIR}"
GO_BINDATA_SRC="${GOPATH}/src/github.com/jteeuwen/go-bindata"
mkdir -p "${GO_BINDATA_SRC}"
mv -v "${SRC_DIR}"/* "${GO_BINDATA_SRC}/" || true

pushd "${GO_BINDATA_SRC}"
go install ./...

mkdir -p "${PREFIX}/bin"
cp "${GOPATH}/bin/go-bindata" "${PREFIX}/bin/"
mv "${GO_BINDATA_SRC}/LICENSE" "${SRC_DIR}"
