locals {
    vpc = {
        cidr = "172.20.0.0/20"
    }
    subnet = {
        availability_zones = {
            default = ["us-east-1a", "us-east-1b", "us-east-1c"]
        }
        cidr = {
            public-web = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
            private-app = ["172.20.4.0/24", "172.20.5.0/24", "172.20.6.0/24"]
            private-db = ["172.20.7.0/24", "172.20.8.0/24", "172.20.9.0/24"]
        }
    }
}
