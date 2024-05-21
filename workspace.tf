locals {
    vpc = {
        cidr = "172.20.0.0/20"
    }
    subnet = {              
        availability_zones = {      //local for each az referenced in network.tf
            useasta = {
                az = "us-east-1a"
            }

            useastb = {
                az = "us-east-1b"
            }

            useastc = {
                az = "us-east-1c"
            }

        }
        cidr = {                            //local for each cidr referenced in each subnet in network.tf
            public-web = { 
                one   = {
                    block = "172.20.1.0/24"
                }

                two   = {
                    block = "172.20.2.0/24"
                }

                three   = {
                    block = "172.20.3.0/24"
                }
            }
            
            private-app = {
                one   = {
                    block = "172.20.4.0/24"
                }

                two   = {
                    block = "172.20.5.0/24"
                }

                three   = {
                    block = "172.20.6.0/24"
                }
            }

            private-db = {
                one   = {
                    block = "172.20.7.0/24"
                }

                two   = {
                    block = "172.20.8.0/24"
                }

                three   = {
                    block = "172.20.9.0/24"
                }
            } 
        }
    }
}
