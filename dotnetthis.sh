if [ "$1" == "" ];then
echo "$0 compile Filename.cs"
echo "  $0 run Filename.dll"
echo "or"
echo "$0 Filename.cs /out:Filename.exe"
echo "  $0 run Filename.exe"
echo "or"
echo "$0 Filename # both compile a dll and run"
echo ""
echo "and to clean"
echo "$0 Filename # clean dll, exe, and runtimeconfig.json files"
exit
fi

# run only
if [ "$1" == "clean" ];then
  if test -f "$2.dll" ; then  rm $2.dll 2> /dev/null ;fi
  if test -f "$2.exe" ; then  rm $2.exe 2> /dev/null ;fi
  if test -f "$2.runtimeconfig.json" ; then  rm $2.runtimeconfig.json 2> /dev/null ;fi
  exit
fi


# run only
if [ "$1" == "run" ];then
  ./csc_run.sh ${@:2}
  exit
fi

# compile only
if [ "$1" == "compile" ];then
    echo "Compiling"
    ./csc_compile.sh ${@:2}
    if [ $? -eq 0 ]; then
        echo "Success"
    else
        echo "Failed"
    fi
    exit
fi

# compile and run
echo "...Compiling..."
./csc_compile.sh $1.cs
if [ $? -eq 0 ]; then
  echo "...Success..."
else
 echo "...Failed..."
 exit
fi

echo
echo "...Running..."
./csc_run.sh $1.dll
echo
echo "...Finished..."