pipeline {
    agent any

    environment {
        REMOTE_HOST = "poojitha@192.168.1.158"
        CRED_ID = "ubuntu_remote_key"   // Jenkins SSH key credential ID
        REMOTE_DIR = "/home/poojitha/fio-tests"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📥 Checking out repository..."
                checkout scm
            }
        }

        stage('Prepare Remote Directory') {
            steps {
                sshagent(credentials: [env.CRED_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'mkdir -p $REMOTE_DIR/results'
                    """
                }
            }
        }

        stage('Copy FIO Job & Script') {
            steps {
                sshagent(credentials: [env.CRED_ID]) {
                    sh """
                        scp -o StrictHostKeyChecking=no jobs/storage_test.fio $REMOTE_HOST:$REMOTE_DIR/
                        scp -o StrictHostKeyChecking=no scripts/run_fio.sh $REMOTE_HOST:$REMOTE_DIR/
                        ssh $REMOTE_HOST 'chmod +x $REMOTE_DIR/run_fio.sh'
                    """
                }
            }
        }

        stage('Run FIO Workload') {
            steps {
                sshagent(credentials: [env.CRED_ID]) {
                    sh """
                        echo "▶️ Running FIO on remote Ubuntu..."
                        ssh $REMOTE_HOST '$REMOTE_DIR/run_fio.sh'
                    """
                }
            }
        }

        stage('Fetch Results') {
            steps {
                sshagent(credentials: [env.CRED_ID]) {
                    sh """
                        echo "📂 Copying results back to Jenkins workspace..."
                        mkdir -p results
                        scp -o StrictHostKeyChecking=no -r $REMOTE_HOST:$REMOTE_DIR/results/* results/
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ FIO workload executed successfully and results copied."
        }
        failure {
            echo "❌ FIO workload failed! Check console logs."
        }
    }
}
