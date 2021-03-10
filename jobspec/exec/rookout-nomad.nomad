variable "rookout-version" {
  type = string
  // default = "0.1.159"
}
variable "rookout-token" {
  type = string
  // default = "ADDTOKENHERE"
  description = "Rookout API Token"
}
job "rookout-java" {
  name = "rookout-java"
  datacenters = ["dc1"]
  type = "service"
  group "java" {
    task "java-run" {
      driver = "java"
      artifact {
        source      = "https://repository.sonatype.org/service/local/repositories/central-proxy/content/com/rookout/rook/${var.rookout-version}/rook-${var.rookout-version}.jar"
        destination = "local/rook.jar"
        mode        = "file"
        options {}
      }
      artifact {
        source      = "https://github.com/sayarg/nomad-rookout/raw/main/hello-world.jar"
        destination = "local/hello-world.jar"
        mode        = "file"
        options {}
      }
      config {
        class       = "rookout.examples.HelloWorld"
        class_path  = "local/hello-world.jar"
        jvm_options = ["-Xmx2048m", "-Xms256m", "-javaagent:local/rook.jar", "-DROOKOUT_TOKEN=${var.rookout-token}"]
      }
      env {
        ROOKOUT_LABELS="env:dev"
      }
    }
  }
}