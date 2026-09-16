module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "~> 21.0"
  name               = "eks-${var.env}"
  kubernetes_version = var.kubernetes_version
  subnet_ids         = var.private_subnet_ids
  vpc_id             = var.vpc_id

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.small"]

      iam_role_additional_policies = {
        amazon_eks_worker_node_policy    = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        amazon_eks_cni_policy            = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        amazon_ecr_read_only             = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        amazon_ssm_managed_instance_core = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  tags = {
    Name = "eks-${var.env}-toggle-master"
  }
}
