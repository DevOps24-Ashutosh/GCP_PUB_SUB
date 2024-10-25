pipeline {
    agent any

    environment {
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('GCP_CRED') // Replace with your Jenkins credentials ID
        GOOGLE_PROJECT = 'terraform-pub-sub' // Replace with your GCP project ID
    }

    stages {
        stage('Checkout') {
            steps {
                // Check out code from version control
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Plan Terraform changes
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform changes
                    sh 'terraform apply tfplan'
                }
            }
        }
    }

    post {
        // always {
        //     cleanWs() // Clean workspace
        // }
        success {
            echo 'Terraform script executed successfully!'
        }
        failure {
            echo 'Terraform script failed.'
        }
    }
}
