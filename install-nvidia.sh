#### Install necessary additions for running with the NVIDIA HPC SDK - only do for Ubuntu 18.04

if [[ $dist == ubuntu ]]; then
  if [[ $release == 1804 ]]; then

    # 1. Install additional required packages
    #     - environment-modules as the NVHPC will be provided as a module
    #     - libnuma-dev as `-lnuma` is needed to compile the UM with NVIDIA
    #     - nvidia-driver-495 to provide the NVIDIA graphics drivers (will 
    #       only work if the VM can access the GPU)to the VM and provide nvidia-smi 
    apt-get install -q -y environment-modules libnuma-dev nvidia-driver-495 || error

    # 2. Install pre-made-up NetCDF4 libraries, made using NVHPC v22.1
    TMPDEB="$(mktemp)" || error
    wget -O "$TMPDEB" https://gws-access.jasmin.ac.uk/public/ukca/nvidia-netcdf_4.5.4-1_amd64.deb || error
    dpkg -i "$TMPDEB" || error
    rm -f "$TMPDEB" || error


    apt-get install -q -y software-properties-common || error
    add-apt-repository -y ppa:x2go/stable || error
    apt-get -q -y update || error
    apt-get install -q -y x2goserver x2goserver-xsession x2golxdebindings || error
  fi
fi
