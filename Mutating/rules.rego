package policy["com.styra.kubernetes.mutating"].rules.rules


# Goal:
# We want to write the following custom Mutating rule for a Kubernetes cluster and enforce it using OPA:

# No deployment should have replicas more than 2.
# If the replica count of a deployment is more than 2, then mutate the incoming request by updating the replica to 2. This is not a best practise but just a precautionary setting as my cluster is test cluster and I do not want my nodes to run low on CPU / Memory due to any accidental scaling of any application.




ignore[decision] {
  #title: restrict-deployment-replica
  input.request.object.kind == "Deployment"

  #   Check if the replica count is more than 2
  input.request.object.spec.replicas > 2

  # As all of the above conditions are true, the request will be updated with
  # the following JSON patch and respective decision will be returned.
  decision := {
    "allowed": true,
    "message": "replacing replicas",
    "patch": [
      {
        "op": "replace",
        "path": "/spec/replicas",
        "value": 2
      }
    ]
  }
}
