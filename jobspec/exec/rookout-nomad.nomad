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
    task "exec" {
      driver = "exec"
      config {
        command = "java"
        args    = ["-cp", "local/examples/*", "rookout.examples.HelloWorld"]
      }
      artifact {
        source      = "https://repository.sonatype.org/service/local/repositories/central-proxy/content/com/rookout/rook/${var.rookout-version}/rook-${var.rookout-version}.jar"
        destination = "local/rook.jar"
        mode        = "file"
        options {}
      }
      artifact {
        source      = "https://raw.githubusercontent.com/sayarg/nomad-rookout/main/src/rookout/examples/HelloWorld.java"
        destination = "local/examples"
        options {}
      }
      env {
        JAVA_TOOL_OPTIONS="-javaagent:local/rook.jar -DROOKOUT_TOKEN=${var.rookout-token}"
        ROOKOUT_LABELS="env:dev"
      }
    }
  }
}