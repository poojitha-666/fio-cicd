pipeline {
    agent any

    environment {
        REMOTE_HOST = "poojitha@192.168.1.158"
        CRED_ID = "ubuntu-remote-key"   // Jenkins credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Copy Files to Remote') {
            steps {
                sshagent([env.CRED_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'mkdir -p /tmp/fio_jobs /tmp/fio_scripts'
                        scp jobs/storage_test.fio $REMOTE_HOST:/tmp/fio_jobs/storage_test.fio
                        scp scripts/run_fio.sh $REMOTE_HOST:/tmp/fio_scripts/run_fio.sh
                    """
                }
            }
        }

        stage('Run FIO on Remote') {
            steps {
                sshagent([env.CRED_ID]) {
                    sh """
                        ssh $REMOTE_HOST 'chmod +x /tmp/fio_scripts/run_fio.sh && /tmp/fio_scripts/run_fio.sh'
                    """
                }
            }
        }

        stage('Fetch Results') {
            steps {
                sshagent([env.CRED_ID]) {
                    sh """
                        mkdir -p results
                        scp -r $REMOTE_HOST:/tmp/fio_results/* results/
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ FIO workload executed successfully and results copied back."
        }
        failure {
            echo "❌ FIO workload failed! Check logs."
        }
    }
}
