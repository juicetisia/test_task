resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "docdb-cluster"
  engine                  = "docdb"
  master_username         = "asokova"
  master_password         = "admin123"
  skip_final_snapshot     = true
  db_subnet_group_name    = "main"
  vpc_security_group_ids  = [
      aws_security_group.service_security_group.id,
    ]
}

resource "aws_docdb_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.public.*.id

}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 3
  identifier         = "docdb-cluster-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "db.t3.medium"
}