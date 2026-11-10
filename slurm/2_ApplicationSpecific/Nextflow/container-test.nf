nextflow.enable.dsl=2

process CONTAINER_TEST {
    container 'docker://ubuntu:22.04'

    output:
    path 'container-output.txt'

    script:
    """
    echo "Hello from a Nextflow container on CCR" > container-output.txt
    cat /etc/os-release >> container-output.txt
    """
}

workflow {
    CONTAINER_TEST()
}
