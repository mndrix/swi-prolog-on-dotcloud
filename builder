#!/bin/bash

VERSION=6.5.2
SWIPL_URL="https://commondatastorage.googleapis.com/ndrix/swi-prolog-on-dotcloud/$VERSION.tar.gz"
START_DIR=`pwd`
BUILDER_DIR="$(dirname "$0")"


# functions
msg() {
    echo -e "\033[1;32m-->\033[0m " $*
}


# use custom SWI-Prolog build, if wanted
if [ -n "$SERVICE_SWIPLURL" ]; then
    msg "Using custom SWI-Prolog build"
    SWIPL_URL="$SERVICE_SWIPLURL"
fi

# download SWI-Prolog binaries if needed
if [ ! -d "$HOME/swipl/lib/swipl-$VERSION" ]; then
    msg "Downloading SWI-Prolog $VERSION binaries"
    curl --silent "$SWIPL_URL" > swipl.tar.gz
    rm -rf ~/swipl
    tar -xz -C ~ -f swipl.tar.gz
    rm -f swipl.tar.gz
fi

# copy all project code into $HOME
msg "Installing your code"
if [ -n "$SERVICE_APPROOT" ]; then
    cd $SERVICE_APPROOT
fi
cp -a . ~

# build ~/profile with $HOME/swipl/bin in $PATH
cd
cat > profile <<'EOF'
export PATH="~/swipl/bin:$PATH"
EOF
source profile

# build pl convenience wrapper for running SWI-Prolog scripts
cat > pl <<'EOF'
#!/bin/bash
exec ~/swipl/bin/swipl -q -f none -t main -s $@
EOF
chmod +x pl

# install pack dependencies based on Packfile or pack.pl
msg "Installing dependencies"
swipl -q -f "$START_DIR/$BUILDER_DIR/install-deps.pl" -g main
