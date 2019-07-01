# Running MOJO pipeline in Liberty java runtime

After exporting an H2O.ai Driverless AI pipeline as a _mojo_ package, you will have a set of files
+ README.txt
+ pipeline.mojo
+ mojo2-runtime.jar
+ run_example.sh
+ example.csv

(there may be others - not needed for the cloud foundry deployment)

You will need to create a _license.sig_ file with your key to allow the pipeline to be authorised.

Downloads/clone the files from this repository into the same directory as the mojo export.

Make sure you have the [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started) installed.

Open a terminal window, and navigate to the directory where all the files have been placed.

Logon to [IBM Cloud](https://cloud.ibm.com) and select the cloud foundry space where you want to deploy the mojo demo.
```
ibmcloud login

ibmcloud target --cf
```

Once logged in and targetted, you should be able to "push" the package to the cloud :
```
ibmcloud cf push << your-app-name-here >> -m 512m -p . -c "wlp/usr/servers/defaultServer/h2o_startup.sh"
```

The output from this command will include the hostname where your application is running:

+ << your-app-name-here >>[.{region}].mybluemix.net
This makes use of the default packaging and runtime instantiation for the IBM Liberty java runtime.

To run the scoring example, run the `/h2o_run_example.cgi`.

To run as a scoring service, POST `/h2o_mojo.cgi` form (or equivalent body) with all the feature/value pairs needed for your model.
