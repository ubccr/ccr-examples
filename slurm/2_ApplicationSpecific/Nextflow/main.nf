nextflow.enable.dsl=2

process CREATE_MESSAGE {
    input:
    val name

    output:
    path 'message.txt'

    script:
    """
    echo "Hello ${name} from CCR" > message.txt
    """
}

process PROCESS_MESSAGE {
    input:
    path message_file

    output:
    path 'final.txt'

    script:
    """
    cat ${message_file} > final.txt
    echo "Processed by a second Nextflow process" >> final.txt
    """
}

workflow {
    names = Channel.of('CCR')

    message_ch = CREATE_MESSAGE(names)
    PROCESS_MESSAGE(message_ch)
}
