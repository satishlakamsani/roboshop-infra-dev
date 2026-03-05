variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "sg_names"{
    type = list 
    default = [
        #database
        "mongodb","redis","mysql","rabbitmq",
        #backend
        "catalogue","user","cart","shippong","payment",
        #backendALD 
        "backend_alb",
        #frontend
        "frontend",
        #frontendALB
        "frontend_alb",
        #bastion
        "bastion"    
            ]
}