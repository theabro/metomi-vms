# Microsoft Azure

It is possible to run using Vagrant on a Microsoft Azure cloud virtual machine. To do this you will need to install the [`vagrant-azure`](https://github.com/Azure/vagrant-azure) plugin. You should also install the [Azure CLI command line tool](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest), which will allow you to manage your Azure resources. You do not need VirtualBox.

* To begin you should follow the instructions from https://github.com/Azure/vagrant-azure. First ensure you have the dummy box and have added the plugin:
```
vagrant box add azure https://github.com/azure/vagrant-azure/raw/v2.0/dummy.box --provider azure
vagrant plugin install vagrant-azure
```

* You should login using `az login`

* You will need to run the `az ad sp create-for-rbac` command to create the active directory. This will provide the following information with output similar to this:
```
{
  "appId": "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA",
  "displayName": "some-display-name",
  "name": "http://azure-cli-2017-04-03-15-30-52",
  "password": "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB",
  "tenant": "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC"
}
```

* You should then run the `az account list --query "[?isDefault].id" -o tsv` command to get your subscription information. This will have output similar to:
```
DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD
```

* You will then need to export these as the following environment variables, as these are used within the Azure Vagrantfile. You should also keep a note of them, as you will need to make sure that they are set each time you access the VM.
```
export AZURE_CLIENT_ID="AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAA"
export AZURE_CLIENT_SECRET="BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBB"
export AZURE_TENANT_ID="CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCC"
export AZURE_SUBSCRIPTION_ID="DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD"
```

* To run the VM you should then run `vagrant up --provider=azure` and once provisioned you can `vagrant ssh` etc. in the usual way.

There are many different [Linux VMs available on Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes) with different [price plans](https://azure.microsoft.com/en-gb/pricing/details/virtual-machines/linux/). Currently the VM is set to use the [`Standard_F4s_v2`](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes-compute) machine, which is compute optimised with 4 virtual CPUs and 8GB memory. Other options are available, depending on need and cost.
