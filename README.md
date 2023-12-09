# pkgbuild
one script to create package for debian fedora freebsd and archlinux  
with the script you can build other platform package in one os,for me i build in gentoo  
ubuntu is compatible,i have tested all scripts on these system,just simple run the script ,you will get a package from source code compile  
futher update is easy,just change the version number  
you can edit whatever you want,like add for system support  

# Usage  
use -v -y otheroption in sequence  
Option:                  run to build the package  
Option: -v               toggle show log  
Option: -y               answer yes to all  
Option: update yourfile  update a md5 and filename depend on your inputed file eg. update yourfile.tar.gz  
Option: cleanall         clean all four folders contents  
Option: install/ins      build the package and install  
Option: installdeb       only install built deb package  
Option: installrpm       only install built rpm package  
Option: installarchpkg   only install built arch package  
Option: keep             keep the compiled file,so you can install it manully  
Option: help             give you a help  

# Example
bash goldendict-ng-\[23.12.07\].sh -v -y ins   
this will hide verbose,answer yes to all,and install the built package depend on your current running system  

bash goldendict-ng-\[23.12.07\].sh update newerversion.tar.gz  
this will update the scripts md5 and filename with new sourcefile  

bash goldendict-ng-\[23.12.07\].sh installdeb  
this will install compiled deb file  

bash goldendict-ng-\[23.12.07\].sh keep  
this will keep the compiled file,let you decide what to do  
