# styra-das-demo
Best practise Rego rules (Validating and Mutating) for OPA in Kubernetes

# Goal:

We want to write the following best practise rules along with some custom rules for a Kubernetes cluster and enforce or monitor them using Styra DAS:

* The containers must be pulled from an approved registry `gcr.io`.:

    Organisations can have their own container registries where they can perform security scans and test the images in order to avoid any security negligence while using the images in the cluster. In my case I am using a GKE cluster so I would prefer the docker images to be pulled in the cluster MUST only be from gcr.io.

* The Containers must not use “latest” tag.:

    Avoid using the latest tag when deploying containers because it is harder to determine which version of the image is running and it is harder to roll back properly.

* No deployment should have replicas more than 2.

    If the replica count of a deployment is more than 2, then mutate the incoming request by updating the replica count to 2. This is not a best practise but just a precautionary setting for my cluster as I do not want my nodes to run low on CPU / Memory due to any accidental scaling of any application.

# Use the AdmissionReview request JSONs for reference while playing around the Rego rules:

When we create a pod using below command then its respective AdmissionReview request JSON can be found at `input-requests/nginx-pod-admissionreview.json`

    $ kubectl run nginx --image=nginx


When we create a deployment using below command then its respective AdmissionReview request JSON can be found at `input-requests/nginx-deploy-admissionreview.json`.

    $ kubectl create deployment nginx-deployment --image=nginx:1.15


# Use the Rego Rules directly in Styra DAS's Kubernetes System rules.
    
We can follow this post to get started OPA and Styra DAS. We can use the Validating and Mutating rules from this repo as the first written rules in the DAS System.
