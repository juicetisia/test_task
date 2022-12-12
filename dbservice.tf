resource "aws_ecs_task_definition" "service" {
  family = "service"
   container_definitions = <<TASK_DEFINITION
[
  {
    "environment": [
      {"name": "DBL_DEMO_SMILE", "value": "nodedb"},
      {"name": "HOST_OF_YOUR_DOCUMENTDB", "value": "docdb-cluster.cluster-corppl2sk9x6.eu-central-1.docdb.amazonaws.com"},
      {"name": "PASSWORD_OF_YOUR_DOCUMENTDB", "value": "admin123"},
      {"name": "USERNAME_OF_YOUR_DOCUMENTDB", "value": "asokova"}
    ],
    "essential": true,
    "image": "staging_smile",
    "name": "nodedb",
    "memory": 128,
    "cpu": 10,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 8080
      }
    ]

  }
]
TASK_DEFINITION

}

resource "aws_ecs_cluster" "test-cluster" {
  name = "test-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "dbservice" {
  name            = "dbservice"
  task_definition = aws_ecs_task_definition.service.arn
  cluster         = aws_ecs_cluster.test-cluster.id


  load_balancer {
    target_group_arn = aws_lb_target_group.lb_tg.arn
    container_name   = "nodedb"
    container_port   = 80
  }

}