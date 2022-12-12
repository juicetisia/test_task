resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "docdb-cluster"
  engine                  = "docdb"
  master_username         = "asokova"
  master_password         = "admin123"
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 3
  identifier         = "docdb-cluster-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "db.r5.large"
}