pipeline{
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        region = "ap-south-1"
        cluster_name = "my-cluster"
    }
    stages{
        stage("checkout SCM"){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/AnshRoshan/DevOps']])
                }
            }
        }
        stage("Initialiaze the terrraform"){
            steps{
                script{
                    dir("EKS"){
                        sh "terraform init"
                    }
                }
            }
        }
        stage("Formatting the terrraform"){
            steps{
                script{
                    dir("EKS"){
                        sh "terraform fmt"
                    }
                }
            }
        }
        stage("Validate the terrraform"){
            steps{
                script{
                    dir("EKS"){
                        sh "terraform validate"
                    }
                }
            }
        }
        stage("Preview the terrraform"){
            steps{
                script{
                    dir("EKS"){
                        sh "terraform plan"
                    }
                    input(message:"Would you proceed Furthur...")
                }
            }
        }
        stage("Apply the terrraform"){
            steps{
                script{
                    dir("EKS"){
                        sh "terraform $action --auto-approve "
                    }
                }
            }
        }
        stage("Deploy Ngix"){
            steps{
                script{
                    dir("EKS/config"){
                        sh "aws eks update-kubeconfig --name $cluster_name --region $region"
                        sh "kubectl apply -f deployment.yaml"
                        sh "kubectl apply -f service.yaml"
                    }
                }
            }
        }
        
    }
}