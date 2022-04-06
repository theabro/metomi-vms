#### Install necessary additions for running with the NVIDIA HPC SDK - only do for Ubuntu 18.04

# NOTE: to install the NVIDIA HPC SDK, follow the instructions here:
#       https://developer.nvidia.com/nvidia-hpc-sdk-downloads
#       It is recommended to install version 22.1.

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

    # add-in required text to make the NVHPC modulefile available
    cat >> /home/$(logname)/.bashrc <<EOF
# load nvhpc modules if available
if [[ -d /opt/nvidia/hpc_sdk/modulefiles ]]; then
        export MODULEPATH=$MODULEPATH:/opt/nvidia/hpc_sdk/modulefiles
fi
EOF || error

  fi
fi
