#!/bin/sh
rm export/android/oh-aligned.apk
rm export/android/oh-signed.apk
~/Android/Sdk/build-tools/27.0.3/zipalign -v -p 4 export/android/oh-unsigned.apk export/android/oh-aligned.apk
~/Android/Sdk/build-tools/27.0.3/apksigner sign --ks ~/.android/20180816-ld.keystore --out export/android/oh-signed.apk export/android/oh-aligned.apk
