#!/usr/bin/env sh
#https://stackoverflow.com/a/56133028/9512475

# IMPORTANT: make sure dotnet is present in PATH before the next lines

# prepare csc alias

dotnethome=`dotnet --list-sdks | awk 'match($0,/\/.*\/[^ ]*/){sub("/sdk]","");print substr($0,RSTART,RLENGTH)}'`
sdkver=$(dotnet --version)
fwkver=$(dotnet --list-runtimes | grep Microsoft.NETCore.App | awk '{printf("%s", $2)}')
dotnetlib=$dotnethome/shared/Microsoft.NETCore.App/$fwkver

DOTNETDIR=$dotnethome/sdk/$sdkver/
CSCPATH=$(find $DOTNETDIR -name csc.dll -print | sort | tail -n1)
NETSTANDARDPATH=$(find $DOTNETDIR -path *sdk/*/ref/netstandard.dll ! -path *NuGetFallback* -print | sort | tail -n1)

# prepare csc_run alias

if [ ! -w "$DOTNETDIR" ]; then
  mkdir -p $HOME/.dotnet
  DOTNETDIR=$HOME/.dotnet
fi

if test -f "${1%.*}.runtimeconfig.json"; then
  DOTNETCSCRUNTIMECONFIG=${1%.*}.runtimeconfig.json
else
  echo "${1%.*}.runtimeconfig.json not found. using config for more recent runtime"
  DOTNETCSCRUNTIMECONFIG=$DOTNETDIR/csc-console-apps.runtimeconfig.json
fi
#echo DOTNETCSCRUNTIMECONFIG: $DOTNETCSCRUNTIMECONFIG


if [ ! -f $DOTNETCSCRUNTIMECONFIG ]; then
  echo "recent runtime config not found. creating one at $DOTNETDIR"
  DOTNETRUNTIMEVERSION=$(dotnet --list-runtimes |
    grep Microsoft\.NETCore\.App | tail -1 | cut -d' ' -f2)

  cat << EOF > $DOTNETCSCRUNTIMECONFIG
{
  "runtimeOptions": {
    "framework": {
      "name": "Microsoft.NETCore.App",
      "version": "$DOTNETRUNTIMEVERSION"
    }
  }
}
EOF
fi

csc_run="dotnet exec --runtimeconfig $DOTNETCSCRUNTIMECONFIG"
echo ">" $csc_run
echo
$csc_run $*