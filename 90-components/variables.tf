variable "components"{
    default = {
        #backend components are attaching to backend ALB

        catalogue = {
            rule_priority = 10
        }
        user = { 
            rule_priority = 20
        }

        cart  = {
            rule_priority = 30
        }
        shipping = {
            rule_priority = 40
        }

        payment = {
            rule_priority = 50
        }
  #This is attaching to frontend alb, there is only one component here

    frontend = {
        rule_priority = 10
    }
    }
}