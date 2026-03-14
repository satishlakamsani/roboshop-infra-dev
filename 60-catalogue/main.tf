resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_id
  vpc_security_group_ids = [local.catalogue_sg_id]

  tags = merge({

    Name = "${var.project}-${var.environment}-catalogue"
    
  },
  local.common_tags
  )
}


resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
    
  ]

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.catalogue.private_ip
    
      }

  provisioner "file" {
    source = "bootstrap.sh" #local file path
    destination = "/tmp/bootstrap.sh" #Destination path on the remote machine
    }

    provisioner "remote-exec"{
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh catalogue dev"

        ]
    }
}

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  # Set the state to "stopped" to stop the instance
  state       = "stopped" 

  # Optional: set force to true to request a forced stop if needed
  # force = true 
  depends_on = [terraform_data.catalogue]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue"
  source_instance_id =  aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]

  tags = merge(
    {
        Name = "${var.project}-${var.environment}-catalogue"
    },
    local.common_tags
  )

}
/*
resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60

  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 3
  }

}

resource "aws_launch_template" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue"

  
  image_id = aws_ami_from_instance.catalogue.id

# once autoscaling sees less traffic, it will terminate the instance
  instance_initiated_shutdown_behavior = "terminate"

  
  instance_type = "t3.micro"

  
  vpc_security_group_ids = [local.catalogue_sg_id]

  # each time we apply terraform this version will be updated as default

  update_default_version  = true

  # tags for instances created by launch template through autoscaling

   tag_specifications {
    resource_type = "instance"

    tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
  }
  # tags for volumes created by instances
  tag_specifications {
    resource_type = "volume"

    tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
  }
  # tags for launch template
  tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
}

*/

/*
resource "aws_autoscaling_group" "catalogue" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }

  tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}


*/
