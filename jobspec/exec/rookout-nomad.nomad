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
    task "build-package" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "exec"
      config {
        command = "javac"
        args    = ["-g", "local/examples/HelloWorld.java"]
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
    }
    task "java-run" {
      driver = "java"
      config {
        jar_path    = "local/HelloWorld.jar"
        class_path  = "rookout.examples.HelloWorld"
        jvm_options = ["-Xmx2048m", "-Xms256m", "-javaagent:local/rook.jar","-DROOKOUT_TOKEN=${var.rookout-token}"]
      }
      env {
        ROOKOUT_LABELS="env:dev"
      }
    }
  }
}