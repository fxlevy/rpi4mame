#!/usr/bin/env bash

[[ ! -d $HOME/.attract/layouts ]] && bt_script_error "$ln_script_attract_required"

mySourceDir="${myRootPath}/sources/${mySoftware}/$myZipName"
myTargetName="$(echo $myZipName | sed 's/\.//g')"      # Supress '.'
myTargetName="$(echo $myTargetName | sed 's/-/_/g')"   # Replace '-' by '_'
myTargetName="$(echo ${myTargetName,,})"               # Transform to Lowercase
myTargetDir="$HOME/.attract/layouts/$myTargetName"
myLinkDir="$HOME/.attract/layouts/arcadeflow"
myTemplatetDir="${myRootPath}/templates/arcadeflow"

[[ -d $myTargetDir ]] && rm -rf $myTargetDir
cp -r $mySourceDir $myTargetDir

[[ -L $myLinkDir ]] && rm $myLinkDir
ln -s $myTargetDir $myLinkDir

cat $myLinkDir/data_systems.txt | grep "," | awk -F, '{print $1}' | sed 's/$/,/g' > $myTemplatetDir/systems_template.txt
tail -n +2 "$myTemplatetDir/systems_template.txt" > "$myTemplatetDir/systems_template.tmp"
mv "$myTemplatetDir/systems_template.tmp" "$myTemplatetDir/systems_template.txt"

git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion $myGitVersion
