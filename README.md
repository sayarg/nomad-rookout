# Nomad-Rookout Examples

## Introduction to HashiCorp Nomad

If you are new to Nomad you can go to this site <https://learn.hashicorp.com/nomad> to learn about this great scheduling tool.

The main project page can be found here <https://www.nomadproject.io/>

The documentation can be found here <https://www.nomadproject.io/docs>

## Main Rookout Debug Page

<https://app.rookout.com/org/Hashicorp/debugger>

## Rookout Examples Repository

<https://github.com/Rookout/deployment-examples/tree/master/java-jetty>

## Local Environment Setup

This environment uses vagrant / virtualbox to deploy an **All In One** Nomad cluster locally.

* Install the Nomad cli <https://www.nomadproject.io/docs/install>
* Install virtualbox for your system. <https://www.virtualbox.org/wiki/Downloads>
* Install vagrant for your system. <https://www.vagrantup.com/docs/installation>
* Install git for your system. <https://github.com/git-guides/install-git>

Open a terminal and follow below to spin up the vagrant server.

```bash
cd [DIRECTORY_YOU_WANT_WORK_IN]
git clone https://github.com/sayarg/nomad-rookout.git
cd nomad-rookout
vagrant up
```

This will download an ubuntu system and install Nomad in the VM.

## prepare the exec job for deployment

### Edit the variables file

Open the variables **rookout-nomad.nvars** file in your favorite editor.
For this example you only need to add your rookout token to the file.
Once you have saved the file we need to deploy the job to our Nomad Cluster

## Deploying the jobfile

### CLI

We will use the cli to deploy our example to the nomad server we created earlier
While in the `nomad-rookout` directory

```bash
# Tell the nomad cli where our server is
export NOMAD_ADDR="http://127.0.0.1:4646"
cd jobspec/exec
nomad job run -var-file="rookout-nomad.nvars" rookout-nomad.nomad
```

## Accessing Nomad

You can see the status of the deployment by going to the UI <http://localhost:4646> and clicking on the rookout-job job.

### Local Nomad cluster

Demo I: Hello world java app running on nomad, with the job spec adding all the required flags
Demo II: Implicit support for rookout, no input required from app (maybe a flag).
