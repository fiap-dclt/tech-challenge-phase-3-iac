resource "helm_release" "argocd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "10.18.0"

  wait    = true
  atomic  = true
  timeout = 1200

  values = [
    yamlencode({
      global = {
        networkPolicy = {
          create = false
        }
      }
    })
  ]
}
