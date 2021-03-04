

# Add the Rookout Java Agent to your application using an environment variable
export JAVA_TOOL_OPTIONS="-javaagent:`pwd`/rook-0.1.159.jar -DROOKOUT_TOKEN=e1ec25f55757833d8c7c1a0483aff01184e635d53a1acd6be6f839fe97525d90"


# Optional, see Labels section below Projects
export ROOKOUT_LABELS=env:dev

java -cp src/rookout/examples/* rookout.examples.HelloWorld

