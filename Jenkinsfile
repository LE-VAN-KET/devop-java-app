pipeline{
    agent{
        label "master"
    }

    tools {
        maven "Maven 3.6.3"
    }

    environment {
         // This can be nexus3 or nexus2
        NEXUS_VERSION = "nexus3"
        // This can be http or https
        NEXUS_PROTOCOL = "http"
        // Where your Nexus is running. 'nexus-3' is defined in the docker-compose file
        NEXUS_URL = "172.20.0.2:8081"
        // Repository where we will upload the artifact
        NEXUS_REPOSITORY = "repository-jenkins-demo"
        // Jenkins credential id to authenticate to Nexus OSS
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }

    stages{
        stage("clone code"){
            steps{
                script {
                    // Let's clone the source
                    git 'https://github.com/LE-VAN-KET/devop-java-app.git';
                }
            }
            post{
                success{
                    echo "========Clone code executed successfully========"
                }
                failure{
                    echo "========Clone code execution failed========"
                }
            }
        }

        stage("mvn build") {
            steps{
                script {
                    // If you are using Windows then you should use "bat" step
                    sh "mvn package -DskipTests=false"
                }
            }
        }

        stage("push to nexus"){
            steps{
                script {
                    // Read POM xml file
                    pom = readMavenPom file: "pom.xml";
                    // Find built artifact under target folder
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");

                    // Print some info from the artifact found
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}";

                    // Extract the path from the File found
                    artifactPath = filesByGlob[0].path;

                    echo "OKE artifactPath"

                    // Assign to a boolean response verifying If the artifact name exists
                    artifactExists = fileExists artifactPath;
                    if (artifactExists) {
                        echo "=>File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";

                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: "${pom.groupId}",
                            version: "${pom.version}",
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                // Artifact generated such as .jar, .ear and .war files.
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],

                                // Lets upload the pom.xml file for additional information for Transitive dependencies
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        )
                    } else {
                        error "-> File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
    }

    post{
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}