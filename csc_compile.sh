#!/bin/bash
# https://stackoverflow.com/a/65283791/9512475

#dotnethome=`dirname "$0"`
#dotnethome=`dirname \`which dotnet\``
dotnethome=`dotnet --list-sdks | awk 'match($0,/\/.*\/[^ ]*/){sub("/sdk]","");print substr($0,RSTART,RLENGTH)}'`
sdkver=$(dotnet --version)
fwkver=$(dotnet --list-runtimes | grep Microsoft.NETCore.App | awk '{printf("%s", $2)}')
dotnetlib=$dotnethome/shared/Microsoft.NETCore.App/$fwkver

if [ "$#" -lt 1 ]; then
    dotnet $dotnethome/sdk/$sdkver/Roslyn/bincore/csc.dll -help
    echo dotnethome=$dotnethome
    echo sdkver=$sdkver
    echo fwkver=$fwkver
    echo dotnetlib=$dotnetlib
    exit 1
fi

progfile=$1
prog="${progfile%.*}"
echo -r:$dotnetlib/netstandard.dll > /tmp/$prog.rsp
echo -r:$dotnetlib/System.dll >> /tmp/$prog.rsp
echo -r:$dotnetlib/Microsoft.CSharp.dll >> /tmp/$prog.rsp
for f in  $dotnetlib/System.*.dll; do
    echo -r:$f >> /tmp/$prog.rsp
done

echo ">" dotnet $dotnethome/sdk/$sdkver/Roslyn/bincore/csc.dll -out:$prog.dll -nologo @/tmp/$prog.rsp $* 
dotnet $dotnethome/sdk/$sdkver/Roslyn/bincore/csc.dll -out:$prog.dll -nologo @/tmp/$prog.rsp $* 
if [ $? -eq 0 ]; then
   if test -f "$prog.dll"; then
    echo "Compilation Success"
    if  ! test -f "$prog.runtimeconfig.json" ; then
        echo "no config found. writing to ./$prog.runtimeconfig.json"
        echo "{
  \"runtimeOptions\": {
    \"framework\": {
      \"name\": \"Microsoft.NETCore.App\",
      \"version\": \"$fwkver\"
    }
  }
}"  > "$prog.runtimeconfig.json"
    fi
  fi
else
  echo "Compilation Failed"
  exitstatus=1
fi
#echo /tmp/$prog.rsp: 
#cat /tmp/$prog.rsp # uncomment this if you want to see dll chain
rm /tmp/$prog.rsp
exit $exitstatus