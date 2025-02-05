def VERSION = '377' // Version information not provided by tool on CLI

process UCSC_BED12TOBIGBED {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::ucsc-bedtobigbed=377" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ucsc-bedtobigbed:377--h446ed27_1' :
        'quay.io/biocontainers/ucsc-bedtobigbed:377--h446ed27_1' }"

    input:
    tuple val(meta), path(bed)
    path  sizes

    output:
    tuple val(meta), path("*.bigBed"), emit: bigbed
    path "versions.yml"              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    bedToBigBed \\
        $bed \\
        $sizes \\
        ${prefix}.bigBed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ucsc: $VERSION
    END_VERSIONS
    """
}
