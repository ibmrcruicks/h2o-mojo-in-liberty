# Running MOJO pipeline in Liberty java runtime
This project assume you have an [H2O.AI Driverless AI](https://www.h2o.ai/products/h2o-driverless-ai/) trial or production installation, and have built and tested a model, with a view to deploying as a scoring service.

![Driverless AI deployment](https://www.h2o.ai/wp-content/uploads/2019/06/DAI-Architecture.png)

## Preparation
After exporting an H2O.ai Driverless AI pipeline as a _mojo_ package, you will have a set of files
+ README.txt
+ pipeline.mojo
+ mojo2-runtime.jar
+ run_example.sh
+ example.csv

(there may be others - not needed for this cloud foundry deployment)

You will need to create a _license.sig_ file in the same folder/directory with your H2O license key to allow the pipeline to be authorised.

Download/clone the files from this repository into the same directory as the mojo export.

Open a terminal window, and navigate to the directory where all the files have been placed.

## Deploy to IBM Cloud

Now you have the option to deploy the MOJO scoring service into a Cloud Foundry runtime service using the IBM Cloud.

This provides a quick and easy mechanism to test the scoring service, without having to invest time and effort to define and build an image and deploy into a Docker or Kubernetes runtime. (If you would like to try that option, see [cf docker](/docker/README.md) - note that an alternative http server will be needed as there is no native Ruby support if using the standard [websphere liberty docker image](https://hub.docker.com/_/websphere-liberty/))


Make sure you have the [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started) installed.

Logon to [IBM Cloud](https://cloud.ibm.com) and select the cloud foundry space where you want to deploy the mojo demo.
```
ibmcloud login

ibmcloud target --cf
```

Once logged in and targeted, you should be able to "push" the package to the cloud; pick a name for your application (not a fully-qualified hostname, just the name for app), and run the following command from within the project directory:
```
ibmcloud cf push << your-app-name-here >> -m 512m -p . -c "sh ./wlp/usr/servers/defaultServer/h2o_startup.sh"
```
*Note:* if you are using IBM Cloud with a Lite account, your maximum available runtime memory is 256MB; try changing the `-m 512m` for `-m 256m` if you get a memory size error when running the _push_ command. Also - by default, the _push_ command will also start your application - if you have other applications running (i.e.  using runtime memory), there needs to be sufficient free memory for the deployment to work (you may need to stop one or more running apps to liberate memory).

The output from this command will include the hostname where your application is running:

+ << your-app-name-here >>[.{region}].mybluemix.net

This deployment makes use of the default packaging and runtime instantiation for the IBM Liberty java runtime, so if you look in your IBM Cloud console, you will see a new Java Liberty application listed.

To run the scoring example, run the `/h2o_run_example.cgi`.

To run as a scoring service, POST `/h2o_mojo.cgi` form (or equivalent body) with all the feature/value pairs needed for your model.

Run a GET for `/h2o_mojo.cgi` to auto-generate a form, prepopulated with sample data - submitting this form will POST data into the scoring service.

Note that the scoring times can be wildly unpredictable, as the Cloud Foundry runtime services are prioritised for interactive- over CPU-intensive workloads.

*Note:* once you have run the scoring, or demo, remember to shutdown the application, or it will consume your runtime memory allocation unnecessarily.

[YMMV](https://en.wiktionary.org/wiki/your_mileage_may_vary)/[TANSTAAFL](https://en.wikipedia.org/wiki/There_ain%27t_no_such_thing_as_a_free_lunch)

# What's happening?

The cloud foundry buildpack process makes extensive use of Ruby, regardless of the actual runtime -- the libraries installed are sufficient to support a simple CGI server.

The _server.xml_ is used to trick the runtime setup into using the Liberty environment rather than a Ruby environment; the process doesn't actually create a Liberty server application, but does make the java environment available to the Mojo scoring application.

# Notes/caveats
The download mechanism prevents the security settings for the shell and CGI scripts being consistent - you will need to remember to ensure they are executable before pushiinig to IBM Cloud.

The `/h2o_mojo.cgi` does not check whether the list of features/values submitted are sufficient or correct for the scoring to work. 
The complete list of feature names is available through `/h2o_features.cgi` and a sample dataset from `/example.csv`.

The "push" command sets a runtime memory limit of 512MB; if this is unsufficient for your model to run, the application with trap and exit with a completion code of 137 -- you will need to increase the memory allocated to the application.

By increasing memory allocation, you may incur higher charges ...

# Handy links

https://jjasghar.github.io/blog/2019/03/07/using-docker-and-the-ibmcloud-together/
