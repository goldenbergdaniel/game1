PKG="src"
if [[ $1 != "" ]]; then PKG=$1; fi

FLAGS="-o:speed -use-separate-modules -collection:src=src -collection:ext=ext"

mkdir -p out

if [[ $PKG == "src" ]]; then
  odin build src/client -out:out/client $FLAGS
  odin build src/server -out:out/server $FLAGS
else 
  odin build src/$PKG -out:out/$PKG $FLAGS
fi
