echo "OS name: ${NAME}"
echo "OS Version: ${OS_VER}"
echo "CPU cores: ${CPU_CORES}"
echo "Physical Memory: ${MEM_GIG}G"
echo "Disk install: ${DISK_INSTALL}"
echo "Disk space total: ${DISK_TOTAL}G"
echo "Disk space available: ${DISK_AVAIL}G"

[[ "${OS_MIN}" -lt 12 ]] && echo "You must be running Mac OS 10.12.x or higher to install EOSIO." && exit 1

[[ $MEM_GIG -lt 7 ]] && echo "Your system must have 7 or more Gigabytes of physical memory installed." && exit 1
[[ "${DISK_AVAIL}" -lt "${DISK_MIN}" ]] && echo " - You must have at least ${DISK_MIN}GB of available storage to install EOSIO." && exit 1

echo ""

echo "${COLOR_CYAN}[Ensuring xcode-select installation]${COLOR_NC}"
if ! XCODESELECT=$( command -v xcode-select ); then echo " - xcode-select must be installed in order to proceed!" && exit 1;
else echo " - xcode-select installation found @ ${XCODESELECT}"; fi

echo "${COLOR_CYAN}[Ensuring Ruby installation]${COLOR_NC}"
if ! RUBY=$( command -v ruby ); then echo " - Ruby must be installed in order to proceed!" && exit 1;
else echo " - Ruby installation found @ ${RUBY}"; fi

ensure-homebrew

if [ ! -d /usr/local/Frameworks ]; then
	echo "${COLOR_YELLOW}/usr/local/Frameworks is necessary to brew install python@3. Run the following commands as sudo and try again:${COLOR_NC}"
	echo "sudo mkdir /usr/local/Frameworks && sudo chown $(whoami):admin /usr/local/Frameworks"
	exit 1;
fi

<<<<<<< HEAD
# Handle clang/compiler
ensure-compiler
# Ensure packages exist
ensure-brew-packages "${REPO_ROOT}/scripts/eosio_build_darwin_deps"
[[ -z "${CMAKE}" ]] && export CMAKE="/usr/local/bin/cmake"
# CLANG Installation
build-clang
# LLVM Installation
ensure-llvm
# BOOST Installation
ensure-boost
# MONGO Installation
if $INSTALL_MONGO; then
	echo "${COLOR_CYAN}[Ensuring MongoDB installation]${COLOR_NC}"
	if [[ ! -d $MONGODB_ROOT ]]; then
		execute bash -c "cd $SRC_DIR && \
		curl -OL https://fastdl.mongodb.org/osx/mongodb-osx-ssl-x86_64-$MONGODB_VERSION.tgz \
		&& tar -xzf mongodb-osx-ssl-x86_64-$MONGODB_VERSION.tgz \
		&& mv $SRC_DIR/mongodb-osx-x86_64-$MONGODB_VERSION $MONGODB_ROOT \
		&& touch $MONGODB_LOG_DIR/mongod.log \
		&& rm -f mongodb-osx-ssl-x86_64-$MONGODB_VERSION.tgz \
		&& cp -f $REPO_ROOT/scripts/mongod.conf $MONGODB_CONF \
		&& mkdir -p $MONGODB_DATA_DIR \
		&& rm -rf $MONGODB_LINK_DIR \
		&& rm -rf $BIN_DIR/mongod \
		&& ln -s $MONGODB_ROOT $MONGODB_LINK_DIR \
		&& ln -s $MONGODB_LINK_DIR/bin/mongod $BIN_DIR/mongod"
		echo " - MongoDB successfully installed @ ${MONGODB_ROOT}"
	else
		echo " - MongoDB found with correct version @ ${MONGODB_ROOT}."
	fi
	echo "${COLOR_CYAN}[Ensuring MongoDB C driver installation]${COLOR_NC}"
	if [[ ! -d $MONGO_C_DRIVER_ROOT ]]; then
		execute bash -c "cd $SRC_DIR && \
		curl -LO https://github.com/mongodb/mongo-c-driver/releases/download/$MONGO_C_DRIVER_VERSION/mongo-c-driver-$MONGO_C_DRIVER_VERSION.tar.gz \
		&& tar -xzf mongo-c-driver-$MONGO_C_DRIVER_VERSION.tar.gz \
		&& cd mongo-c-driver-$MONGO_C_DRIVER_VERSION \
		&& mkdir -p cmake-build \
		&& cd cmake-build \
		&& $CMAKE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$EOSIO_INSTALL_DIR -DENABLE_BSON=ON -DENABLE_SSL=DARWIN -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DENABLE_STATIC=ON -DENABLE_ICU=OFF -DENABLE_SASL=OFF -DENABLE_SNAPPY=OFF .. \
		&& make -j${JOBS} \
		&& make install \
		&& cd ../.. \
		&& rm mongo-c-driver-$MONGO_C_DRIVER_VERSION.tar.gz"
		echo " - MongoDB C driver successfully installed @ ${MONGO_C_DRIVER_ROOT}."
	else
		echo " - MongoDB C driver found with correct version @ ${MONGO_C_DRIVER_ROOT}."
	fi
	echo "${COLOR_CYAN}[Ensuring MongoDB C++ driver installation]${COLOR_NC}"
	if [[ "$(grep "Version:" $EOSIO_INSTALL_DIR/lib/pkgconfig/libmongocxx-static.pc 2>/dev/null | tr -s ' ' | awk '{print $2}' || true)" != $MONGO_CXX_DRIVER_VERSION ]]; then
		execute bash -c "cd $SRC_DIR && \
		curl -L https://github.com/mongodb/mongo-cxx-driver/archive/r${MONGO_CXX_DRIVER_VERSION}.tar.gz -o mongo-cxx-driver-r${MONGO_CXX_DRIVER_VERSION}.tar.gz \
		&& tar -xzf mongo-cxx-driver-r${MONGO_CXX_DRIVER_VERSION}.tar.gz \
		&& cd mongo-cxx-driver-r${MONGO_CXX_DRIVER_VERSION}/build \
		&& $CMAKE -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$EOSIO_INSTALL_DIR -DCMAKE_PREFIX_PATH=$EOSIO_INSTALL_DIR .. \
		&& make -j${JOBS} VERBOSE=1 \
		&& make install \
		&& cd ../.. \
		&& rm -f mongo-cxx-driver-r$MONGO_CXX_DRIVER_VERSION.tar.gz"
		echo " - MongoDB C++ driver successfully installed @ ${MONGO_CXX_DRIVER_ROOT}."
	else
		echo " - MongoDB C++ driver found with correct version @ ${MONGO_CXX_DRIVER_ROOT}."
	fi
fi
=======
if [ $COUNT -gt 1 ]; then
	printf "\\nThe following dependencies are required to install EOSIO:\\n"
	printf "${DISPLAY}\\n\\n"
	if [ $ANSWER != 1 ]; then read -p "Do you wish to install these packages? (y/n) " ANSWER; fi
	case $ANSWER in
		1 | [Yy]* )
			"${XCODESELECT}" --install 2>/dev/null;
			if [ $1 == 0 ]; then read -p "Do you wish to update homebrew packages first? (y/n) " ANSWER; fi
			case $ANSWER in
				1 | [Yy]* )
					if ! brew update; then
						printf " - Brew update failed.\\n"
						exit 1;
					else
						printf " - Brew update complete.\\n"
					fi
				;;
				[Nn]* ) echo "Proceeding without update!";;
				* ) echo "Please type 'y' for yes or 'n' for no."; exit;;
			esac
			brew tap eosio/eosio # Required to install mongo-cxx-driver with static library
			printf "\\nInstalling Dependencies...\\n"
			# Ignore cmake so we don't install a newer version.
			# Build from source to use local cmake; see homebrew-eosio repo for examples
			# DON'T INSTALL llvm@4 WITH --force!
			OIFS="$IFS"
			IFS=$','
			for DEP in $DEPS; do
				# Eval to support string/arguments with $DEP
				if ! eval $BREW install $DEP; then
					printf " - Homebrew exited with the above errors!\\n"
					exit 1;
				fi
			done
			IFS="$OIFS"
		;;
		[Nn]* ) echo "User aborting installation of required dependencies, Exiting now."; exit;;
		* ) echo "Please type 'y' for yes or 'n' for no."; exit;;
	esac
else
	printf "\\n - No required Home Brew dependencies to install.\\n"
fi


printf "\\n"


export CPATH="$(python-config --includes | awk '{print $1}' | cut -dI -f2):$CPATH" # Boost has trouble finding pyconfig.h
printf "Checking Boost library (${BOOST_VERSION}) installation...\\n"
BOOSTVERSION=$( grep "#define BOOST_VERSION" "$HOME/opt/boost/include/boost/version.hpp" 2>/dev/null | tail -1 | tr -s ' ' | cut -d\  -f3 )
if [ "${BOOSTVERSION}" != "${BOOST_VERSION_MAJOR}0${BOOST_VERSION_MINOR}0${BOOST_VERSION_PATCH}" ]; then
	printf "Installing Boost library...\\n"
	curl -LO https://dl.bintray.com/boostorg/release/$BOOST_VERSION_MAJOR.$BOOST_VERSION_MINOR.$BOOST_VERSION_PATCH/source/boost_$BOOST_VERSION.tar.bz2 \
	&& tar -xjf boost_$BOOST_VERSION.tar.bz2 \
	&& cd $BOOST_ROOT \
	&& ./bootstrap.sh --prefix=$BOOST_ROOT \
	&& ./b2 -q -j$(sysctl -in machdep.cpu.core_count) --with-iostreams --with-date_time --with-filesystem \
	                                                  --with-system --with-program_options --with-chrono --with-test install \
	&& cd .. \
	&& rm -f boost_$BOOST_VERSION.tar.bz2 \
	&& rm -rf $BOOST_LINK_LOCATION \
	&& ln -s $BOOST_ROOT $BOOST_LINK_LOCATION \
	|| exit 1
	printf " - Boost library successfully installed @ ${BOOST_ROOT}.\\n"
else
	printf " - Boost library found with correct version @ ${BOOST_ROOT}.\\n"
fi
if [ $? -ne 0 ]; then exit -1; fi


printf "\\n"


printf "Checking MongoDB installation...\\n"
if [ ! -d $MONGODB_ROOT ]; then
	printf "Installing MongoDB into ${MONGODB_ROOT}...\\n"
	curl -OL https://fastdl.mongodb.org/osx/mongodb-osx-ssl-x86_64-$MONGODB_VERSION.tgz \
	&& tar -xzf mongodb-osx-ssl-x86_64-$MONGODB_VERSION.tgz \
	&& mv $SRC_LOCATION/mongodb-osx-x86_64-$MONGODB_VERSION $MONGODB_ROOT \
	&& touch $MONGODB_LOG_LOCATION/mongod.log \
	&& rm -f mongodb-osx-ssl-x86_64-$MONGODB_VERSION.tgz \
	&& cp -f $REPO_ROOT/scripts/mongod.conf $MONGODB_CONF \
	&& mkdir -p $MONGODB_DATA_LOCATION \
	&& rm -rf $MONGODB_LINK_LOCATION \
	&& rm -rf $BIN_LOCATION/mongod \
	&& ln -s $MONGODB_ROOT $MONGODB_LINK_LOCATION \
	&& ln -s $MONGODB_LINK_LOCATION/bin/mongod $BIN_LOCATION/mongod \
	|| exit 1
	printf " - MongoDB successfully installed @ ${MONGODB_ROOT}\\n"
else
	printf " - MongoDB found with correct version @ ${MONGODB_ROOT}.\\n"
fi
if [ $? -ne 0 ]; then exit -1; fi
printf "Checking MongoDB C driver installation...\\n"
if [ ! -d $MONGO_C_DRIVER_ROOT ]; then
	printf "Installing MongoDB C driver...\\n"
	curl -LO https://github.com/mongodb/mongo-c-driver/releases/download/$MONGO_C_DRIVER_VERSION/mongo-c-driver-$MONGO_C_DRIVER_VERSION.tar.gz \
	&& tar -xzf mongo-c-driver-$MONGO_C_DRIVER_VERSION.tar.gz \
	&& cd mongo-c-driver-$MONGO_C_DRIVER_VERSION \
	&& mkdir -p cmake-build \
	&& cd cmake-build \
	&& $CMAKE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME -DENABLE_BSON=ON -DENABLE_SSL=DARWIN -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DENABLE_STATIC=ON .. \
	&& make -j"${JOBS}" \
	&& make install \
	&& cd ../.. \
	&& rm mongo-c-driver-$MONGO_C_DRIVER_VERSION.tar.gz \
	|| exit 1
	printf " - MongoDB C driver successfully installed @ ${MONGO_C_DRIVER_ROOT}.\\n"
else
	printf " - MongoDB C driver found with correct version @ ${MONGO_C_DRIVER_ROOT}.\\n"
fi
if [ $? -ne 0 ]; then exit -1; fi
printf "Checking MongoDB C++ driver installation...\\n"
if [ "$(grep "Version:" $HOME/lib/pkgconfig/libmongocxx-static.pc 2>/dev/null | tr -s ' ' | awk '{print $2}')" != $MONGO_CXX_DRIVER_VERSION ]; then
	printf "Installing MongoDB C++ driver...\\n"
	curl -L https://github.com/mongodb/mongo-cxx-driver/archive/r$MONGO_CXX_DRIVER_VERSION.tar.gz -o mongo-cxx-driver-r$MONGO_CXX_DRIVER_VERSION.tar.gz \
	&& tar -xzf mongo-cxx-driver-r${MONGO_CXX_DRIVER_VERSION}.tar.gz \
	&& cd mongo-cxx-driver-r$MONGO_CXX_DRIVER_VERSION/build \
	&& $CMAKE -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME .. \
	&& make -j"${JOBS}" VERBOSE=1 \
	&& make install \
	&& cd ../.. \
	&& rm -f mongo-cxx-driver-r$MONGO_CXX_DRIVER_VERSION.tar.gz \
	|| exit 1
	printf " - MongoDB C++ driver successfully installed @ ${MONGO_CXX_DRIVER_ROOT}.\\n"
else
	printf " - MongoDB C++ driver found with correct version @ ${MONGO_CXX_DRIVER_ROOT}.\\n"
fi
if [ $? -ne 0 ]; then exit -1; fi

printf "\\n"


# We install llvm into /usr/local/opt using brew install llvm@4
printf "Checking LLVM 4 support...\\n"
if [ ! -d $LLVM_ROOT ]; then
	ln -s /usr/local/opt/llvm@4 $LLVM_ROOT \
	|| exit 1
	printf " - LLVM successfully linked from /usr/local/opt/llvm@4 to ${LLVM_ROOT}\\n"
else
	printf " - LLVM found @ ${LLVM_ROOT}.\\n"
fi


cd ..
printf "\\n"

function print_instructions() {
	return 0
}
>>>>>>> ad3b43c22940c8573c9a8fd9ec02afcfd125770e
