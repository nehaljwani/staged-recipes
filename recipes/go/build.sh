# First, build go1.4 using gcc, then use that go to build go>1.4
# Should I make this a separate package called go-bootstrap?
# Should I check the checksum of this tarball? What about windows?
mkdir go-bootstrap && pushd $_
curl -L https://storage.googleapis.com/golang/go1.4-bootstrap-20170531.tar.gz | tar -xzf -
export GOROOT_BOOTSTRAP=$PWD/go
cd $GOROOT_BOOTSTRAP/src
./make.bash

# Should I run all.bash instead? That will run tests too, but some tests
# like unshare() require higher capabilities which might not be available
# on the CI systems
pushd $SRC_DIR/src
./all.bash

rm -fr $GOROOT_BOOTSTRAP
mkdir $PREFIX/go
cp -rv $SRC_DIR/* $PREFIX/go/

# Right now, it's just go and gofmt, but might be more in the future?
mkdir $PREFIX/bin && pushd $_
for binary in ../go/bin/* ; do ln -s $binary ; done

# Install [de]activate scripts.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
