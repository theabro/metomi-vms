# Amazon AWS

It is possible to run using Vagrant on an Amazon AWS EC2 virtual machine. To do this you will need to install the [`vagrant-aws`](https://github.com/mitchellh/vagrant-aws) plugin. You do not need VirtualBox. You should ensure that you are using a recent version of Vagrant to enable the AWS plugin to work, and you will first need to run the command
```
vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
```
in a different directory to your `metomi-vms` directory.

Some set-up is required within the AWS console. You will first need to:

1. Generate a key to allow you to connect to the VM
2. Create a security group and restrict incoming access to the IP address of your computer 
3. Create a user and make a note of the required information 

The information in points 1 & 2 will need to be saved to a file called **_aws-credentials_** - an example one is provided which looks like
```
export VAGRANT_VAGRANTFILE=Vagrantfile.aws_ubuntu-1804
export AWS_KEY='AAAAAAAAAAAAAAAAAAAA'
export AWS_SECRET='BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
export AWS_KEYNAME='CCCCCCCCC'
export AWS_KEYPATH='/full/path/to/CCCCCCCCC'
```
If you are using Windows you may want to replace the options in the Vagrantfile directly, but be careful not to commit this information back to a public repository.

**Note** that because the default username for EC2 Ubuntu VMs is **_ubuntu_** the `/home/ubuntu` directory has also been symbolically linked to `/home/vagrant`. You should continue to work under the `ubuntu` user as normal.

## VM size

There are many different sizes of VM to choose from (known as [instance types](https://aws.amazon.com/ec2/instance-types/)), some of which will be eligible for the free tier, e.g. `t2.micro` that has 1 CPU and 1GB of memory. To be able to run the UM you will need to select a larger type, such as `t2.medium`(2 CPUs and 4GB of memory) or `t2.large`(2 CPUs and 8GB of memory). This is changed in the `aws.instance_type` setting in the Vagrantfile. You can also select faster hardware, e.g. the `m5` hardware uses faster Intel Xeon processors with a greater network and storage bandwidth, and may give better performance. Larger and faster options are available, but these will all come with an associated cost.

The hard disk size of the VM is set to 30GB in the Vagrantfile in the `aws.block_device_mapping` setting. This can be changed as required. The default `t2.micro` size is 8GB if nothing is set.

It is possible to resize your VM by changing the instance type once it has been created. To do this you need to first stop it using
```
vagrant halt
```
and then [follow the instructions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-resize.html) for changing the instance using the AWS console. 

## Chose your region

On the [AWS console](https://aws.amazon.com/) you should change your region to the one where you want the VM to be provisioned by using the drop-down menu on the top right of the page. The default settings may put you in `us-east-2` (US East (Ohio)), but you may want to change this to, e.g., London (or `eu-west-2`). 

From here you should click the **All services** drop-down menu, and then click **EC2** to enter the EC2 Dashboard.

There are many different types of EC2 VMs (e.g. Ubuntu, Amazon Linux etc.), which are identified by their unique **ami-** identifier. This identifier is also unique to a particular region. The setting for Ubuntu 18.04 LTS in the London (eu-west-2) region has already been set in the `aws.ami` setting in the provided Vagrantfile. If you wish to use a different region you will need to search for the correct _ami-_ identifier from the **Launch instance** option within the EC2 Dashboard and then set this in the Vagrantfile accordingly.

## Create your key pair

In the EC2 Dashboard scroll down the left-hand menu until you find **Network & Security** and click **Key Pairs**, and then click **Create key pair** on the top right. 

Here you should give your key a name, e.g. "vagrant" or "metomi-vms" etc. You should keep the **pem** file format, and then click **Create key pair**. Save this file to your local machine, and ensure it has the correct permissions so that it is only readable by you.

You should add the name of and full path to your key to your **_aws-credentials_** file. Note that the name should not include any extension (e.g. `.pem`), but the full path should.

## Create a security group to limit IP access to your VM

In the EC2 Dashboard scroll down the left-hand menu until you find **Network & Security** and click **Security Groups**, and then click **Create security group** on the top right. 

You should give it a name, e.g. **MyIP** as is used in the Vagrantfile, and a description (e.g. "limit access to my IP"). Scroll down to the **Inbound rule** section and click **Add rule**.

Here, use the drop-down menus to change the _Type_ to **All traffic** and the _Source_ to **My IP** (your current IP address will be automatically added). Scroll down to the bottom of the page and click **Create security group**.

If you used a name other than "MyIP" for the name of the group you will need to update the `aws.security_groups` setting in the AWS Vagrantfile.

## Create a user

You will need to create a user with the correct permissions to access your EC2 VM, which again is done via the console. This is not done within the EC2 Dashboard, but is instead done within the **IAM Dashboard** (Identity and Access Management). To get to this from the EC2 Dashboard first click the AWS logo on the top left of the page to bring you back to the console front page, and then click the **All services** drop-down menu, and then click **IAM** under the "Security, Identity, & Compliance" section.

Under **Access Management** click **Users** and then click **Add user**. You should give them a name, e.g. _vagrant_ or _metomi-vms_ etc.. Tick the box for **Programmatic access** and then click the **Next: Permissions** button.

Here you should click the tab labelled **Attach existing policies directly** and search for **AmazonEC2FullAccess** and then tick the check-box next to this option. Now click the **Next: Tags** button. You can then click the **Next: Review** button. 

Now click **Create user**. This will bring you to a page listing the username, the _Access key ID_ and the _Secret access key_. **THE SECRET ACCESS KEY INFORMATION WILL BE DISPLAYED ONLY ONCE**. 

You should copy this information into your **_aws-credentials_** file and download and save the `.csv` file containing this information. Again, do not upload this information (either the aws-credentials file or the csv file) to a public repository.

## Provision your AWS VM

Once you have all the information for your aws-credentials file, you should first _source_ this file
```
source aws-credentials
```
Once you have created (& potentially added) the security group to your AWS Vagrantfile, you should then provision the VM by
```
vagrant up --provider=aws
```
If this hangs on the line
```
Waiting for SSH to become available...
```
then you should check the security group settings above. You may also recieve an email saying _"You recently requested an AWS Service that required additional validation"_, which may have also caused a delay. It will take several minutes to provision the VM for the first time.

Once the required packages have been installed you will need to run
```
vagrant up
```
again, before being able to connect via
```
vagrant ssh
```

If the VM becomes unresponsive you many need to force-stop it via the EC2 Dashboard and run
```
vagrant up
```
again. In the instance list it will be called **_metomi-vms_**.

## Connecting via X2Go

To be able to connect to a full desktop, you can use X2Go. You should install the [X2Go client](https://wiki.x2go.org/doku.php/download:start).

1. Fill out the settings details on the new session popup as in the table below, then press _OK_.

2. Click on your new session on the right hand side of the x2goclient window.

3. It should automatically login after asking you if you wish to allow the connection.

If you stop the instance and then later restart it, the IP address may change. You can find the IP address of your EC2 instance on the EC2 Dashboard. You will need to change this in your X2Go settings and allow the connection when prompted.

**X2Go settings for AWS EC2 instance**

| Option | Setting |
| :--- | :--- |
| Session name | *e.g.* AWS |
| Host | *IP address for the VM, e.g.* 3.8.24.92 |
| Login | ubuntu |
| Use RSA/DSA key for ssh connection | *The full path to the key file you created earlier (navigate via button)* |
| Session type | *Select* LXDE *from drop-down menu* |
