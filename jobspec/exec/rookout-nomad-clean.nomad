job "rookout-java" {
  name = "rookout-java"
  datacenters = ["dc1"]
  type = "service"

  group "java" {
    task "java-run" {
      driver = "rookout-java"
      
      artifact {
        source      = "https://github.com/sayarg/nomad-rookout/raw/main/hello-world.jar"
        destination = "local/hello-world.jar"

        // mode and empty options... can go? what is the default for mode.
        mode        = "file"
        options {}
      }
      
      config {
        //
        // can we omit completely and have defaults
        //
        version     = "${env.rookout-version}"
        token       = "${var.rookout-token}"
        lables      = "${var.rookout-lables}"

        // from the java driver
        class       = "rookout.examples.HelloWorld"
        class_path  = "local/hello-world.jar"
      }
    }
  }
}