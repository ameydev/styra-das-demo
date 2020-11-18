package policy["com.styra.kubernetes.validating"].rules.rules

# Goal:
# We want to write the following best practise rules along with some custom rules for a Kubernetes cluster and enforce or monitor them:
# 
# The containers must be pulled from an approved registry `gcr.io`.:
# Organisations can have their own container registries where they can perform security scans and test the images in order to avoid any security negligence while using the images in the cluster. In my case I am using a GKE cluster so I would prefer the docker images to be pulled in the cluster MUST only be from gcr.io.
# 
# The Containers must not use “latest” tag.:
# Avoid using the latest tag when deploying containers because it is harder to determine which version of the image is running and it is harder to roll back properly.


# Write your Policy Rules here 


monitor[decision] {
  data.library.v1.kubernetes.admission.workload.v1.block_latest_image_tag[message]

  decision := {
    "allowed": false,
    "message": message
  }
}


# Write your Policy Rules here 
enforce[reason] {
  #title: deny-pod-with-non-gcr-image
  input.request.kind.kind = "Pod"
  container = input.request.object.spec.containers[_]
  image = container.image
  parts := split(image, "/")
  not parts[0] = "gcr.io"
  reason := sprintf("Resource Pod/%v uses an image from of an unauthorised registry.", [input.request.object.metadata.name])
}

enforce[reason] {
  #title: deny-deployment-with-non-gcr-image

  #   Note the change in JSONPath of `containers`
  #   basically any Kubernetes object which has containers at the below JSONPath this rule should apply
  container = input.request.object.spec.template.spec.containers[_]
  image = container.image
  parts := split(image, "/")
  not parts[0] = "gcr.io"
  reason := sprintf("Resource %v/%v uses an image from of an unauthorised registry.", [input.request.kind.kind, input.request.object.metadata.name])
}
