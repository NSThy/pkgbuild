#!/bin/sh

# PLEASE EDIT
#FILENAME: APPNAME-[VERSION]

#STR_LICENSE
#STR_MD5
#STR_FILENAME
#STR_APPNAME
#STR_MAINTAINER
#STR_DESCRIPTION_SHORT
#STR_DESCRIPTION
#STR_DEPEND_DEB
#STR_DEPEND_RPM
#STR_DEPEND_ARCHPKG
#URL_HOMEPAGE
#URL_DOWNLOAD
#STR_ENV_DEPEND_FREEBSD
#STR_ENV_DEPEND_DEBIAN
#STR_ENV_DEPEND_GENTOO
#STR_ENV_DEPEND_FEDORA
#STR_ENV_DEPEND_ARCHLINUX

# TIP
#use STR_OSID to set each system config compile...


# Define ANSI color codes and different echo style
ANSI_RED='\033[1;31m'
ANSI_GREEN='\033[1;32m'
ANSI_YELLOW='\033[1;33m'
ANSI_BLUE='\033[1;34m'
ANSI_RESET_COLOR='\033[0m'
echo_error() {
  echo -e "${ANSI_RED}Warning: $1${ANSI_RESET_COLOR}"
}
echo_success() {
  echo -e "${ANSI_GREEN}Success: $1${ANSI_RESET_COLOR}"
}
echo_running() {
  echo -e "${ANSI_BLUE}Running: $1${ANSI_RESET_COLOR}"
}
echo_information() {
  echo -e "${ANSI_YELLOW}Information: $1${ANSI_RESET_COLOR}"
}
api_mkdir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}
	echo_information "------------------------[initialize]-------------------------"
# variable define

DIR_HOME=$(pwd)
DIR_WORKING="./Working"
DIR_PACKING_DEB="./Packing_DEB"
DIR_PACKING_RPM="./Packing_RPM"
DIR_PACKING_ARCHPKG="./Packing_ARCHPKG"
DIR_SOURCE="./Source"
DIR_RELEASE="./Release"
api_mkdir $DIR_WORKING
api_mkdir $DIR_PACKING_DEB
api_mkdir $DIR_PACKING_RPM
api_mkdir $DIR_PACKING_ARCHPKG
api_mkdir $DIR_SOURCE
api_mkdir $DIR_RELEASE

STR_OSID=$(grep '^ID=' /etc/os-release | awk -F= '{print $2}')
STR_VERSION=$(echo "$0" | grep -o '\[.*\]' | tr -d '[]')
STR_NPROC=$(nproc)
#vvvvvvvvvv EDIT vvvvvvvvvv
STR_LICENSE="MIT"
STR_MD5="307164ed6fecf942fb85d4534755cb97"
STR_FILENAME="3.0.tar.gz"
STR_APPNAME="pyahoo"
STR_MAINTAINER="nsthy@hotmail.com"
STR_DESCRIPTION_SHORT="A small tool to display stocks and cryptos from yahoo"
STR_DESCRIPTION="A small tool to display stocks and cryptos from yahoo [FULLY CREATED BY CHATGPT]"
#^^^^^^^^^^ EDIT ^^^^^^^^^^
STR_ARCH2=$(uname -m)



if [ "$(uname)" = "FreeBSD" ]; then
    	STR_ARCH="freebsd-amd64"
    	STR_PREFIX="usr/local"
    	#vvvvvvvvvv EDIT vvvvvvvvvv
	STR_DEPEND_DEB="python3, py39-tkinter, py39-sqlite3, py39-yfinance"
	#^^^^^^^^^^ EDIT ^^^^^^^^^^
	echo_information "You are building in FreeBSD"
	echo -e "${ANSI_YELLOW}"
	uname -a
	echo -e "${ANSI_RESET_COLOR}"
elif [ "$(uname)" = "Linux" ]; then
	STR_ARCH="amd64"
	STR_PREFIX="usr"
	#vvvvvvvvvv EDIT vvvvvvvvvv
	STR_DEPEND_DEB="python3, tk, python3-appdirs, python3-frozendict, python3-html5lib, python3-lxml, python3-pandas, python3-numpy, python3-peewee, python3-pytzdata"
	STR_DEPEND_RPM="python3 python3-tkinter python3-yfinance"
	STR_DEPEND_ARCHPKG="python tk python-yfinance"
	#^^^^^^^^^^ EDIT ^^^^^^^^^^
	echo_information "You are building in Linux"
	echo -e "${ANSI_YELLOW}"
	uname -a
	echo -e "${ANSI_RESET_COLOR}"
else
  	echo_error "Unsupported operating system,stopping..."
  	exit 1
fi

#vvvvvvvvvv EDIT vvvvvvvvvv
URL_HOMEPAGE="https://github.com/NSThy/pyahoo"
URL_DOWNLOAD="https://github.com/NSThy/pyahoo.git"

STR_ENV_DEPEND_FREEBSD=""
STR_ENV_DEPEND_DEBIAN="python3 tk python3-appdirs python3-frozendict python3-html5lib python3-lxml python3-pandas python3-numpy python3-peewee python3-pytzdata"
STR_ENV_DEPEND_GENTOO=""
STR_ENV_DEPEND_FEDORA=""
STR_ENV_DEPEND_ARCHLINUX=""

#^^^^^^^^^^ EDIT ^^^^^^^^^^
CONTROL_GIT=false
if echo "$URL_DOWNLOAD" | grep -q "\.git" || [[ $(basename "$0") == *-git* ]]; then
	STR_VERSION=999
	STR_APPNAME=$STR_APPNAME"-git"
	CONTROL_GIT=true
fi

CONTROL_VERBOSE=true
STR_VERBOSE_ENABLE_NORMAL=""
if [ "$1" = "-v" ]; then
	CONTROL_VERBOSE=false
	STR_VERBOSE_ENABLE_NORMAL="-v"
	echo_running "Asking for root permission,enter password"
	sudo uname > /dev/null 2>&1
	shift
fi

CONTROL_AUTOANSWER_GENERAL=""
CONTROL_AUTOANSWER_EMERGE=""
CONTROL_AUTOANSWER_YAY=""
CONTROL_AUTOANSWER_PACMAN=""
if [ "$1" = "-y" ]; then
    	CONTROL_AUTOANSWER_GENERAL="-y"
	CONTROL_AUTOANSWER_EMERGE="-a"
	CONTROL_AUTOANSWER_YAY="--noconfirm --answerclean N --answerdiff N"
	CONTROL_AUTOANSWER_PACMAN="--noconfirm"
	shift
fi

# base depend for tools that the script use
STR_ENV_DEPEND_FREEBSD_BASE="dpkg wget git gtar unzip unrar 7-zip binutils py39-pip "
STR_ENV_DEPEND_DEBIAN_BASE="dpkg rpm rsync wget git tar unzip unrar p7zip-full xz-utils binutils python3-pip libarchive-tools pacman-package-manager fakeroot "
STR_ENV_DEPEND_GENTOO_BASE="app-arch/dpkg app-arch/rpm net-misc/rsync net-misc/wget dev-vcs/git app-arch/tar app-arch/unzip app-arch/unrar app-arch/p7zip app-arch/xz-utils sys-devel/binutils dev-python/pip app-arch/libarchive sys-apps/pacman sys-apps/fakeroot "
STR_ENV_DEPEND_FEDORA_BASE="dpkg rpm rsync wget git tar unzip unrar p7zip xz binutils python3-pip bsdtar pacman fakeroot "
STR_ENV_DEPEND_ARCHLINUX_BASE="dpkg rpm-tools rsync wget git tar unzip unrar p7zip xz binutils python-pip "

STR_ENV_DEPEND_FREEBSD=$STR_ENV_DEPEND_FREEBSD_BASE$STR_ENV_DEPEND_FREEBSD
STR_ENV_DEPEND_DEBIAN=$STR_ENV_DEPEND_DEBIAN_BASE$STR_ENV_DEPEND_DEBIAN
STR_ENV_DEPEND_GENTOO=$STR_ENV_DEPEND_GENTOO_BASE$STR_ENV_DEPEND_GENTOO
STR_ENV_DEPEND_FEDORA=$STR_ENV_DEPEND_FEDORA_BASE$STR_ENV_DEPEND_FEDORA
STR_ENV_DEPEND_ARCHLINUX=$STR_ENV_DEPEND_ARCHLINUX_BASE$STR_ENV_DEPEND_ARCHLINUX

echo_success "Initialize successfully"
# api define
api_verbose_run() {
	if [ "$CONTROL_VERBOSE" = true ]; then
		bash -c "$1"
		if [ $? -eq 0 ]; then
    			return 0
		else
	    		return 1
		fi
	else
		bash -c "$1" > /dev/null 2>&1
		if [ $? -eq 0 ]; then
    			return 0
		else
	    		return 1
		fi
	fi
}

api_md5_check() {
    local tmp_actual_md5=$(md5sum "$DIR_SOURCE/$STR_FILENAME" | awk '{print $1}')

    if [ "$tmp_actual_md5" = "$STR_MD5" ]; then
        echo_success "MD5 hash matches."
        return 0
    else
        echo_error "MD5 hash does not match.stopping..."
        return 1
    fi
}

api_file_download() {
if [ "$CONTROL_GIT" = true ]; then
	if [ -d "${DIR_SOURCE}/${STR_APPNAME}" ]; then
		cd ${DIR_SOURCE}/${STR_APPNAME}
		api_verbose_run "git pull"
		api_last_cmd_status_check
		cd ${DIR_HOME}
		echo_success "Git pull successfully"
	else
		api_verbose_run "git clone --recursive $URL_DOWNLOAD ${DIR_SOURCE}/${STR_APPNAME}"
		if [ $? -eq 0 ]; then
    			echo_success "Git clone successfully"
		else
	    		echo_error "Git clone failed.stopping..."
	    		exit 1
		fi
	fi
else
	if [ -f "$DIR_SOURCE/$STR_FILENAME" ] && api_md5_check; then
	 	echo_success "Downloaded files are ready"
	 else
	 	api_verbose_run "wget -P $DIR_SOURCE $URL_DOWNLOAD"
	 	api_last_cmd_status_check
	 	if api_md5_check; then
	 		echo_success "Download successfully"
	 	else
	 		echo_error "Download failure.stopping..."
	 		exit 1
	 	fi
	 fi
fi

}
api_file_extract_status_check() {	
	if [ $? -eq 0 ]; then
    		echo_success "File: $1 Extraction successful"
	else
	    	echo_error "File: $1 Extraction failed.stopping..."
	    	echo_information "Tips: some rpm packages require root permission,try run with sudo"
	    	exit 1
	fi
}

api_rm_status_check() {
	if [ $? -eq 1 ]; then
	    	echo_error "$1 are failed to clean.try to run with sudo ,stopping..."
	    	exit 1
	fi
}

api_last_cmd_status_check() {
	if [ $? -eq 1 ]; then
	    	echo_error "Last command finished with error,please check above .stopping..."
	    	exit 1
	fi
}

api_python_check_install(){
	pip show $1 > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo_success "a python dependency $1 is installed"
	else
		echo_error "a python dependency $1 is missing ,try install"
		api_verbose_run "sudo pip install $1 --break-system-packages"
		pip show $1 > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo_success "a python dependency $1 is installed"
		else
			echo_error "a python dependency $1 failed to install,stopping..."
			exit 1
		fi
	fi
}

api_file_extract() {
if [ "$CONTROL_GIT" = true ]; then
	cp -rf ${DIR_SOURCE}/${STR_APPNAME} $DIR_WORKING/
	cd $DIR_WORKING/${STR_APPNAME}
	DIR_HOME_WORKING=$(pwd)
	cd $DIR_HOME
else	
	local TMP_FILE_EXTENSION="${STR_FILENAME##*.}"

	case "$TMP_FILE_EXTENSION" in
	    "tar") 
		tar -xf "$DIR_SOURCE/$STR_FILENAME" -C "$DIR_WORKING" > /dev/null 2>&1 ;;
	    "gz" | "tgz")
		tar -xzf "$DIR_SOURCE/$STR_FILENAME" -C "$DIR_WORKING" > /dev/null 2>&1 ;;
	    "zip")
		unzip -q "$DIR_SOURCE/$STR_FILENAME" -d "$DIR_WORKING" > /dev/null 2>&1 ;;
	    "rar")
		unrar x -y "$DIR_SOURCE/$STR_FILENAME" "$DIR_WORKING" > /dev/null 2>&1 ;;
	    "7z")
		7z x -y "$DIR_SOURCE/$STR_FILENAME" -o"$DIR_WORKING" > /dev/null 2>&1 ;;
	    "xz")
		xz -d "$DIR_SOURCE/$STR_FILENAME" -c | tar -x -C "$DIR_WORKING" > /dev/null 2>&1 ;;
	    "deb")
		dpkg-deb -R "$DIR_SOURCE/$STR_FILENAME" "$DIR_WORKING" > /dev/null 2>&1 ;;
	    "rpm")
	    	cd $DIR_SOURCE
		rpm2cpio $STR_FILENAME | cpio -idmv -D $DIR_HOME/$DIR_WORKING > /dev/null 2>&1 ;;
	    "AppImage")
	    	cd $DIR_SOURCE
	    	chmod +x $STR_FILENAME
		./$STR_FILENAME --appimage-extract > /dev/null 2>&1
		mv squashfs-root $DIR_HOME/$DIR_WORKING
		cd $DIR_HOME ;;
	    *)
		echo_error "Unsupported file format: $TMP_FILE_EXTENSION. stopping..."
		exit 1 ;;
	esac
	api_file_extract_status_check "$DIR_SOURCE/$STR_FILENAME"
	if [ -d $DIR_WORKING/* ]; then
        	cd $DIR_WORKING/*
		DIR_HOME_WORKING=$(pwd)
	else
		DIR_HOME_WORKING=$DIR_WORKING
	fi
	cd $DIR_HOME
fi

}


api_deb_install_icon() {
	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/icons/hicolor/scalable/apps
	cp "$1" $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/icons/hicolor/scalable/apps/
}

api_deb_install_desktop() {
	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/applications
	cp "$1" $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/applications/
}

api_deb_install_bin() {
	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/bin
	cp "$1" $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/bin/
}

api_deb_install_opt() {
    	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/opt/$2
    	cp -rf "$1" "$DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/opt/$2"
}

api_deb_install_opt_sub() {
    	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/opt/$2
    	cp -rf "$1"/* "$DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/opt/$2"
}

api_deb_install_share() {
    	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/$2
    	cp -rf "$1" "$DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/$2"
}

api_deb_install_share_sub() {
    	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/$2
    	cp -rf "$1"/* "$DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/$2"
}

api_deb_install_metainfo() {
	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/metainfo
	cp "$1" $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/$STR_PREFIX/share/metainfo/
}

api_deb_install_linux_c7_root() {
    	api_mkdir $DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/compat/linux
    	cp -rf "$1"/* "$DIR_HOME/$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/compat/linux"
}


api_deb_write_control() {
	api_mkdir $DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/DEBIAN
	local tmp_folder_size=$(du -s "$DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION" | awk '{print $1}')
	echo "Package: $STR_APPNAME
Version: $STR_VERSION
Architecture: $STR_ARCH
Maintainer: $STR_MAINTAINER
Installed-Size: $tmp_folder_size
Depends: $STR_DEPEND_DEB
Priority: optional
Homepage: $URL_HOMEPAGE
Description: $STR_DESCRIPTION" > $DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/DEBIAN/control
}

api_deb_build() {
	cd $DIR_HOME
	echo_running "Building DEB..."
	api_deb_write_control
	api_verbose_run "dpkg-deb --build $DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION $DIR_RELEASE"
	if [ $? -eq 0 ]; then
    		echo_success "DEB build successfully"
	else
	    	echo_error "DEB build failed.stopping..."
	    	exit 1
	fi
}


api_rpm_copy_files_from_deb() {
	echo_running "Transfering file from Packing_DEB to Packing_RPM"
	api_mkdir $DIR_PACKING_RPM/$STR_APPNAME-$STR_VERSION
	api_mkdir $DIR_PACKING_RPM/SPECS
	api_verbose_run "rsync -av --exclude='DEBIAN' $DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/ $DIR_PACKING_RPM/$STR_APPNAME-$STR_VERSION/"
	api_last_cmd_status_check
	echo_success "Transfer done"
}

api_rpm_write_spec() {
	local tmp_date=$(date +"%a %b%e %Y")
	cd $DIR_PACKING_RPM/$STR_APPNAME-$STR_VERSION
	local tmp_dir_tree_unformat=$(find . -type f | sed 's|^\.||')
	while IFS= read -r line; do
    	if [[ $line == *" "* ]]; then
        	line="\"$line\""
    	fi
    		tmp_dir_tree="$tmp_dir_tree$line"$'\n'
	done <<< "$tmp_dir_tree_unformat"
	cd $DIR_HOME
	
	echo "%global __os_install_post %{nil}
Name: $STR_APPNAME
Version: $STR_VERSION
Release: 1%{?dist}
Summary: $STR_DESCRIPTION_SHORT
License: $STR_LICENSE
URL: $URL_HOMEPAGE
Requires: $STR_DEPEND_RPM

%description
$STR_DESCRIPTION

%install
cp -rf $DIR_HOME/$DIR_PACKING_RPM/$STR_APPNAME-$STR_VERSION/* %{buildroot}

%files
$tmp_dir_tree

%changelog
* $tmp_date <$STR_MAINTAINER> - $STR_VERSION-1
- Initial package release
" > $DIR_PACKING_RPM/SPECS/$STR_APPNAME-$STR_VERSION.spec

}

api_rpm_build() {
echo_running "Building RPM..."
if [ "$(uname)" = "Linux" ]; then
	cd $DIR_HOME
	api_rpm_copy_files_from_deb
	api_rpm_write_spec
	api_verbose_run "rpmbuild --define \"_topdir $DIR_HOME/$DIR_PACKING_RPM\" -bb $DIR_PACKING_RPM/SPECS/$STR_APPNAME-$STR_VERSION.spec"
	if [ $? -eq 0 ]; then
    		echo_success "RPM build successful"
	else
	    	echo_error "RPM build failed.stopping..."
	    	exit 1
	fi
	mv $DIR_PACKING_RPM/RPMS/$STR_ARCH2/$STR_APPNAME-$STR_VERSION-1*$STR_ARCH2.rpm $DIR_RELEASE
	api_last_cmd_status_check
else
	echo_information "Unsupport system,Skipping build rpm"
fi
}

api_archpkg_copy_files_from_deb() {
	echo_running "Transfering file from Packing_DEB to Packing_ARCHPKG"
	api_mkdir $DIR_PACKING_ARCHPKG/src
	api_verbose_run "rsync -av --exclude='DEBIAN' $DIR_PACKING_DEB/$STR_APPNAME-$STR_VERSION/ $DIR_PACKING_ARCHPKG/src/"
	api_last_cmd_status_check
	echo_success "Transfer done"
}

api_archpkg_write_pkgbuild() {
	echo "# Maintainer: $STR_MAINTAINER

pkgname=$STR_APPNAME
pkgver=$STR_VERSION
pkgrel=1
pkgdesc=\"$STR_DESCRIPTION\"
arch=(\"$STR_ARCH2\")
url=\"$URL_HOMEPAGE\"
license=(\"$STR_LICENSE\")
depends=($STR_DEPEND_ARCHPKG)
options=(!strip)
package() {
    mv \$srcdir/* \$pkgdir
}" > $DIR_PACKING_ARCHPKG/PKGBUILD

}

api_archpkg_build() {
echo_running "Building ARCHPKG..."
if [ "$(uname)" = "Linux" ]; then
	cd $DIR_HOME
	api_archpkg_copy_files_from_deb
	api_archpkg_write_pkgbuild
	if ! [ -f "/var/lib/pacman/local/ALPM_DB_VERSION" ]; then
	    	echo_error "Pacman is not initialized,try to fix..."
	    	if [ ! -d "/var/chroot/archlinux" ]; then
			sudo mkdir -p "/var/chroot/archlinux"
		fi
	    	sudo pacman
	    	if [ -f "/var/lib/pacman/local/ALPM_DB_VERSION" ]; then
    			echo_success "Pacman initialized successful"
		else
		    	echo_error "Pacman has a problem please check.stopping..."
		    	exit 1
		fi
	fi
	cd $DIR_PACKING_ARCHPKG
	api_verbose_run "makepkg --nodeps"
	if [ $? -eq 0 ]; then
    		echo_success "ARCHPKG build successful"
	else
	    	echo_error "ARCHPKG build failed.stopping..."
	    	exit 1
	fi
	mv $STR_APPNAME-$STR_VERSION-1-$STR_ARCH2.pkg* $DIR_HOME/$DIR_RELEASE
	api_last_cmd_status_check
else
	echo_information "Unsupport system,Skipping build archpkg"
fi
	cd $DIR_HOME
}


api_replace() {
	local pattern="$1"
  	local replacement="$2"
   	local file="$3"
	
	if [ "$(uname)" = "FreeBSD" ]; then
    		sed -i '' "s+${pattern}+${replacement}+g" "${file}"
	elif [ "$(uname)" = "Linux" ]; then
		sed -i "s+${pattern}+${replacement}+g" "${file}"
	else
  	  	echo_error "api_replace failed,Unsupported operating system,stopping..."
  	  	exit 1
	fi
}

api_clean_working() {
	rm -rf $DIR_WORKING/*
	api_rm_status_check "$DIR_WORKING"
}

api_clean_packing_deb() {
	rm -rf $DIR_PACKING_DEB/*
	api_rm_status_check "$DIR_PACKING_DEB"
}

api_clean_packing_rpm() {
	rm -rf $DIR_PACKING_RPM/*
	api_rm_status_check "$DIR_PACKING_RPM"
}

api_clean_packing_archpkg() {
	rm -rf $DIR_PACKING_ARCHPKG/*
	api_rm_status_check "$DIR_PACKING_ARCHPKG"
}

api_clean_source() {
	rm -rf $DIR_SOURCE/*
	api_rm_status_check "$DIR_SOURCE"
}

api_clean_release() {
	rm -rf $DIR_RELEASE/*
	api_rm_status_check "$DIR_RELEASE"
}

api_clean_all() {
	echo_running "Cleaning all"
	api_clean_working
	api_clean_packing_deb
	api_clean_packing_rpm
	api_clean_packing_archpkg
	api_clean_source
	api_clean_release
	echo_success "Clean successfully"
}

api_update_script() {
	cd $DIR_HOME
	echo_running "Updating md5 and filename with ${1}"
    	local tmp_update_filename=$(basename "$1")
    	local tmp_update_md5=$(md5sum "$1" | awk '{print $1}')
    	if [ "$(uname)" = "Linux" ]; then
    		sed -i "s/^STR_FILENAME=\".*\"$/STR_FILENAME=\"$tmp_update_filename\"/" "$0"
    		sed -i "s/^STR_MD5=\".*\"$/STR_MD5=\"$tmp_update_md5\"/" "$0"
    	elif [ "$(uname)" = "FreeBSD" ]; then
    		sed -e "s/^STR_FILENAME=\".*\"$/STR_FILENAME=\"$tmp_update_filename\"/" "$0" > "$0.tmp" && \
		sed -e "s/^STR_MD5=\".*\"$/STR_MD5=\"$tmp_update_md5\"/" "$0.tmp" > "$0" && \
		rm "$0.tmp"
    	fi
    	api_last_cmd_status_check
    	echo_success "Finished,please rerun the script"
}


# main funtion define
env_prepare() {
	echo_information "-----------------------[env_prepare]-----------------------"
	
	if [ "$STR_OSID" = "freebsd" ]; then
    		echo_information "os: freebsd" 
    		if [ -n "$STR_ENV_DEPEND_FREEBSD" ]; then
    			echo_running "Checking env dependencies"
    			pkg info $STR_ENV_DEPEND_FREEBSD > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				echo_success "FreeBSD env dependencies are ready"
			else
				echo_error "FreeBSD env is missing dependencies,try install"
				api_verbose_run "sudo pkg install $CONTROL_AUTOANSWER_GENERAL $STR_ENV_DEPEND_FREEBSD"
				if [ $? -eq 0 ]; then
					echo_success "FreeBSD env dependencies are ready"
				else
					echo_error "Missing dependencies are failed to install,stopping..."
					exit 1
				fi
			fi
    		fi
    	# vvvvvvvvvv [DIY CODE START freebsd] vvvvvvvvvv
    	
    	
	
	# ^^^^^^^^^^^ [DIY CODE END freebsd] ^^^^^^^^^^^
	elif [ "$STR_OSID" = "gentoo" ]; then
		echo_information "os: gentoo"
		if [ -n "$STR_ENV_DEPEND_GENTOO" ]; then
    			echo_running "Checking env dependencies"
    			equery list sys-apps/pacman > /dev/null 2>&1
    			if ! [ $? -eq 0 ]; then
    				echo_error "pacman is not installed,now fixing"
    				api_verbose_run "sudo eselect repository enable gentoo-zh"
    				sudo bash -c 'echo "sys-apps/pacman ~amd64" > /etc/portage/package.accept_keywords/pacman'
				sudo bash -c 'echo "app-crypt/archlinux-keyring ~amd64" > /etc/portage/package.accept_keywords/archlinux-keyring'
				api_verbose_run "sudo emerge --sync"
				api_verbose_run "sudo emerge $CONTROL_AUTOANSWER_EMERGE sys-apps/pacman"
				api_last_cmd_status_check
				echo_success "pacman installed successfully"
    			fi
    			equery list $STR_ENV_DEPEND_GENTOO > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				echo_success "Gentoo env dependencies are ready"
			else
				echo_error "Gentoo env is missing dependencies,try install"
				api_verbose_run "sudo emerge $CONTROL_AUTOANSWER_EMERGE -n $STR_ENV_DEPEND_GENTOO app-portage/gentoolkit"
				if [ $? -eq 0 ]; then
					echo_success "Gentoo env dependencies are ready"
				else
					echo_error "Missing dependencies are failed to install,stopping..."
					exit 1
				fi
			fi
    		fi
	# vvvvvvvvvv [DIY CODE START gentoo] vvvvvvvvvv
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END gentoo] ^^^^^^^^^^^
	elif [ "$STR_OSID" = "debian" ] || [ "$STR_OSID" = "ubuntu" ]; then
		echo_information "os: debian"
		if [ -n "$STR_ENV_DEPEND_DEBIAN" ]; then
    			echo_running "Checking env dependencies"
    			dpkg -s $STR_ENV_DEPEND_DEBIAN > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				echo_success "debian env dependencies are ready"
			else
				echo_error "debian env is missing dependencies,try install"
				api_verbose_run "sudo apt-get install $CONTROL_AUTOANSWER_GENERAL $STR_ENV_DEPEND_DEBIAN"
				if [ $? -eq 0 ]; then
					echo_success "debian env dependencies are ready"
				else
					echo_error "Missing dependencies are failed to install,stopping..."
					exit 1
				fi
			fi
    		fi
	# vvvvvvvvvv [DIY CODE START debian] vvvvvvvvvv
	api_python_check_install "yfinance"
	
	
	# ^^^^^^^^^^^ [DIY CODE END debian] ^^^^^^^^^^^
	elif [ "$STR_OSID" = "arch" ]; then
		echo_information "os: archlinux"
		if [ -n "$STR_ENV_DEPEND_ARCHLINUX" ]; then
    			echo_running "Checking env dependencies"
    			if ! [ -f "/usr/bin/yay" ]; then
    				echo_error "yay not found,installing..."
    				api_verbose_run "sudo pacman -S $CONTROL_AUTOANSWER_PACMAN --needed go git base-devel"
    				git clone https://aur.archlinux.org/yay.git /tmp/yay
    				cd /tmp/yay
    				api_verbose_run "makepkg -si $CONTROL_AUTOANSWER_PACMAN"
    				if [ -f "/usr/bin/yay" ]; then
					echo_success "yay install successfully"
				else
					echo_error "yay failed to install,stopping..."
					exit 1
				fi
				cd $DIR_HOME
    			fi
    			yay -Q $STR_ENV_DEPEND_ARCHLINUX > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				echo_success "archlinux env dependencies are ready"
			else
				echo_error "archlinux env is missing dependencies,try install"
				api_verbose_run "yay -S --needed $CONTROL_AUTOANSWER_YAY $STR_ENV_DEPEND_ARCHLINUX"
				if [ $? -eq 0 ]; then
					echo_success "archlinux env dependencies are ready"
				else
					echo_error "Missing dependencies are failed to install,stopping..."
					exit 1
				fi
			fi
    		fi
	# vvvvvvvvvv [DIY CODE START archlinux] vvvvvvvvvv
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END archlinux] ^^^^^^^^^^^
	elif [ "$STR_OSID" = "fedora" ]; then
		echo_information "os: fedora"
		if [ -n "$STR_ENV_DEPEND_FEDORA" ]; then
    			echo_running "Checking env dependencies"
    			rpm -q $STR_ENV_DEPEND_FEDORA > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				echo_success "fedora env dependencies are ready"
			else
				echo_error "fedora env is missing dependencies,try install"
				api_verbose_run "sudo dnf install $CONTROL_AUTOANSWER_GENERAL $STR_ENV_DEPEND_FEDORA"
				if [ $? -eq 0 ]; then
					echo_success "fedora env dependencies are ready"
				else
					echo_error "Missing dependencies are failed to install,stopping..."
					exit 1
				fi
			fi
    		fi
	# vvvvvvvvvv [DIY CODE START fedora] vvvvvvvvvv
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END fedora] ^^^^^^^^^^^
	else
  	  	echo_error "Unsupported operating system,stopping..."
  	  	exit 1
	fi
	cd $DIR_HOME
}

src_download() {
	 echo_information "-----------------------[src_download]-----------------------"
	 echo_running "Downloading files..."
	 api_file_download
	# vvvvvvvvvv [DIY CODE] vvvvvvvvvv
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END] ^^^^^^^^^^^
	cd $DIR_HOME
}

src_extract() {
	 echo_information "-----------------------[src_extract]------------------------"
	 echo_running "Extracting files..."
	 api_file_extract
	# vvvvvvvvvv [DIY CODE] vvvvvvvvvv
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END] ^^^^^^^^^^^
	cd $DIR_HOME
}

src_configure() {
	echo_information "-----------------------[src_configure]-----------------------"
	echo_running "Configuring files..."
	# vvvvvvvvvv [DIY CODE] vvvvvvvvvv
	
	
	
	
	
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END] ^^^^^^^^^^^
	api_last_cmd_status_check
	echo_success "Configure successfully"
	cd $DIR_HOME
}

src_compile() {
	echo_information "------------------------[src_compile]------------------------"
	echo_running "Compiling..."
	# vvvvvvvvvv [DIY CODE] vvvvvvvvvv
	
	
	# ^^^^^^^^^^^ [DIY CODE END] ^^^^^^^^^^^
	api_last_cmd_status_check
	echo_success "Compile successfully"
	cd $DIR_HOME
}

src_pack() {
	echo_information "-------------------------[src_pack]--------------------------"
	# vvvvvvvvvv [DIY CODE] vvvvvvvvvv
	api_deb_install_bin ${DIR_HOME_WORKING}/pyahoo.py
	api_replace "/usr/bin/" "/${STR_PREFIX}/bin/" "${DIR_HOME_WORKING}/pyahoo.desktop"
	api_deb_install_desktop ${DIR_HOME_WORKING}/pyahoo.desktop
	api_deb_install_icon ${DIR_HOME_WORKING}/pyahoo.png
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END] ^^^^^^^^^^^
	api_deb_build
	api_rpm_build
	api_archpkg_build
	cd $DIR_HOME
}


src_install() {
	echo_information "------------------------[src_install]------------------------"
	echo_running "Installing binary packages..."
	
	if [ "$STR_OSID" = "freebsd" ]; then
		echo_running "Installing DEB ${STR_APPNAME}-${STR_VERSION}..."
		if ! [ -f "/usr/local/bin/dpkgfreebsd" ]; then
			echo_error "dpkgfreebsd not found,installing..."
			api_verbose_run "sudo wget https://github.com/NSThy/dpkgfreebsd/raw/main/dpkgfreebsd.sh -O /usr/local/bin/dpkgfreebsd && sudo chmod +x /usr/local/bin/dpkgfreebsd"
			if [ $? -eq 0 ]; then
		    		echo_success "dpkgfreebsd install successfully"
		    	else
		    		echo_error "dpkgfreebsd failed to install,stopping..."
		    		exit 1
			fi
		fi
    		sudo dpkgfreebsd $STR_VERBOSE_ENABLE_NORMAL $CONTROL_AUTOANSWER_GENERAL ${DIR_RELEASE}/${STR_APPNAME}_${STR_VERSION}_${STR_ARCH}.deb
    		api_last_cmd_status_check
	elif [ "$STR_OSID" = "debian" ] || [ "$STR_OSID" = "ubuntu" ]; then
		echo_running "Installing DEB ${STR_APPNAME}-${STR_VERSION}..."
		api_verbose_run "sudo dpkg -i ${DIR_RELEASE}/${STR_APPNAME}_${STR_VERSION}_${STR_ARCH}.deb"
		if [ $? -eq 1 ]; then
		    	echo_error "Missing dependencies,try auto fix install"
		    	api_verbose_run "sudo apt install -f $CONTROL_AUTOANSWER_GENERAL"
		fi
		api_last_cmd_status_check
	elif [ "$STR_OSID" = "fedora" ]; then	
		echo_running "Installing RPM ${STR_APPNAME}-${STR_VERSION}..."
		rpm -q $STR_APPNAME > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			api_verbose_run "sudo yum reinstall $CONTROL_AUTOANSWER_GENERAL ${DIR_RELEASE}/$STR_APPNAME-$STR_VERSION-1*$STR_ARCH2.rpm"
		else
			api_verbose_run "sudo yum install $CONTROL_AUTOANSWER_GENERAL ${DIR_RELEASE}/$STR_APPNAME-$STR_VERSION-1*$STR_ARCH2.rpm"
		fi
		api_last_cmd_status_check
	elif [ "$STR_OSID" = "arch" ]; then
		echo_running "Checking and install dependencies"
		api_verbose_run "yay -S --needed $CONTROL_AUTOANSWER_YAY $STR_DEPEND_ARCHPKG"
		if [ $? -eq 0 ]; then
			echo_success "Depends are ready"
		else
			echo_error "Depends are failed to install"
			exit 1
		fi
		echo_running "Installing ARCHPKG ${STR_APPNAME}-${STR_VERSION}..."
		api_verbose_run "sudo pacman -U $CONTROL_AUTOANSWER_PACMAN ${DIR_RELEASE}/$STR_APPNAME-$STR_VERSION-1-$STR_ARCH2.pkg*"
		api_last_cmd_status_check
	else
  	  	echo_error "system not support.binary package is not installed,stopping..."
  	  	exit 1
	fi
	echo_success "Binary package installed successfully"
	# vvvvvvvvvv [DIY CODE] vvvvvvvvvv
	
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END] ^^^^^^^^^^^
	cd $DIR_HOME
}

src_clean() {
	echo_information "-------------------------[src_clean]-------------------------"
	api_clean_working
	api_clean_packing_deb
	api_clean_packing_rpm
	api_clean_packing_archpkg
	echo_success "Clean successfully"
	# vvvvvvvvvv [DIY CODE] vvvvvvvvvv
	
	
	
	# ^^^^^^^^^^^ [DIY CODE END] ^^^^^^^^^^^
	cd $DIR_HOME 
}

# Main
if [ "$1" = "help" ]; then
    echo -e "${ANSI_YELLOW}"
    echo "use -v -y otheroption in sequence"
    echo "Option:                  run to build the package"
    echo "Option: -v               toggle show log"
    echo "Option: -y               answer yes to all"
    echo "Option: update yourfile  update a md5 and filename depend on your inputed file eg. update yourfile.tar.gz"
    echo "Option: cleanall         clean all four folders contents"
    echo "Option: install/ins      build the package and install"
    echo "Option: installdeb       only install built deb package"
    echo "Option: installrpm       only install built rpm package"
    echo "Option: installarchpkg   only install built arch package"
    echo "Option: keep             keep the compiled file,so you can install it manully"
    echo "Option: help             give you a help"
    exit 0
fi
if [ "$1" = "update" ]; then
    if [ -f "$2" ] ; then
    	api_update_script "$2"
    	exit 0
    else
    	echo_error "File not found,stopping..."
    	exit 1
    fi
    
fi
if [ "$1" = "cleanall" ]; then
    api_clean_all
    exit 0
fi
if [ "$1" = "installdeb" ]; then
    if [ -f ${DIR_RELEASE}/${STR_APPNAME}_${STR_VERSION}_${STR_ARCH}.deb ]; then
    	src_install
    	exit 0
    else
    	echo_error "Target binary package not found.stopping..."
    	exit 1
    fi
fi
if [ "$1" = "installrpm" ]; then
    if [ -f ${DIR_RELEASE}/$STR_APPNAME-$STR_VERSION-1*$STR_ARCH2.rpm ]; then
    	src_install
    	exit 0
    else
    	echo_error "Target binary package not found.stopping..."
    	exit 1
    fi
fi
if [ "$1" = "installarchpkg" ]; then
    if [ -f ${DIR_RELEASE}/$STR_APPNAME-$STR_VERSION-1-$STR_ARCH2.pkg* ]; then
    	src_install
    	exit 0
    else
    	echo_error "Target binary package not found.stopping..."
    	exit 1
    fi
fi
src_clean
env_prepare
src_download
src_extract
src_configure
src_compile
src_pack
if [ "$1" = "keep" ]; then
	api_clean_packing_deb
	api_clean_packing_rpm
	api_clean_packing_archpkg
    	echo_success "Finished!!! Binary packages will be in folder Release"
    	echo_success "Compiled project is in folder Working,you can install manully,eg: sudo make install..."
    	exit 0
fi
src_clean
if [ "$1" = "install" ] || [ "$1" = "ins" ]; then
    src_install
fi
echo_success "Finished!!! Binary packages will be in folder Release"
exit 0
