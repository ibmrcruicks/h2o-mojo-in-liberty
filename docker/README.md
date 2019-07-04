# Deploying to Cloud Foundry native Docker runtime

https://cloud.ibm.com/docs/services/Registry?topic=registry-registry_access#registry_tokens_create


```
$> ibmcloud iam help api-key-create
NAME:
  api-key-create - Create a new platform API key

USAGE:
   ibmcloud iam api-key-create NAME [-d DESCRIPTION] [--file FILE] [--lock] [--output FORMAT]

OPTIONS:
   -d value        Description of the API key
   --file value    Save API key information to specified file
   --lock          Lock the API key when being created
   --output value  Specify output format, only JSON is supported now.
```

Login to your IBM Cloud account
```
ibmcloud login
```
Ensure you have an [IBM Cloud Container Registry service](https://cloud.ibm.com/kubernetes/catalog/registry) associated with your account,
and then login to the Container Registry Service:
```
ibmcloud cr login
```
```
ibmcloud cr namespaces
```
if you do not have a namespace, create one (**this needs to be unique for the Registry, not just for you**):
```
ibmcloud cr namespace-add ${registry-name}
```
Create your Dockerfile with the desired build instructions, test and validate; once you're happy that the image is what you want,
you can build and store an image in the Container Registry. Make sure to EXPOSE your application listener port so that Cloud Foundry
can route client traffic to your running instance:
```
ibmcloud cr build --tag ${region}.icr.io/${registry-name}/${image-name}:latest .
```
To be able to deploy from the Container Registry, the accessing task must have appropriate IAM credentials; if you do not already
have an IBM Cloud APIKEY you can use for this, request a new one, and store the result in the *CF_DOCKER_PASSWORD* environment
variable for the Cloud Foundry deployment task to use:
```
ibmcloud iam api-key-create ibmcloud-key-for-cr -d 'CR access automation' --file ibmcloud-key.json

CF_DOCKER_PASSWORD=`sed -ne '/apikey/s/.* "\([^"]*\)",/\1/p' ibmcloud-key.json` && export CF_DOCKER_PASSWORD
```
Now you should be able to "push" the image from the registry into a Cloud Foundry application container
```
ibmcloud cf push ${app-name} --docker-image ${region}.icr.io/${registry-name}/${image-name}:latest --docker-username iamapikey
```

By default, this command will automatically start the application; if you don't want that to happen immediately,
add the `--no-start` option


