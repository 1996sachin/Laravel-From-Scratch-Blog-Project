pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        APP_SERVICE = 'laravel_app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/1996sachin/Laravel-From-Scratch-Blog-Project.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    def projectName = env.JOB_NAME.toLowerCase().replaceAll('[^a-z0-9]', '_')
                    sh "docker compose -p ${projectName} -f ${COMPOSE_FILE} build"
                }
            }
        }

        stage('Deploy Containers') {
            steps {
                script {
                    def projectName = env.JOB_NAME.toLowerCase().replaceAll('[^a-z0-9]', '_')

                    echo "Stopping and removing old containers..."
                    sh "docker compose -p ${projectName} -f ${COMPOSE_FILE} down --remove-orphans || true"

                    // Safe removal for all services
                    ['laravel_app', 'laravel_db', 'laravel_nginx'].each { svc ->
                        def containers = sh(script: "docker ps -aq --filter name=${svc}", returnStdout: true).trim()
                        if (containers) {
                            sh "docker rm -f ${containers}"
                        }
                    }

                    echo "Starting fresh containers..."
                    sh "docker compose -p ${projectName} -f ${COMPOSE_FILE} up -d"
                }
            }
        }

        stage('Run Laravel Migrations') {
            steps {
                script {
                    def projectName = env.JOB_NAME.toLowerCase().replaceAll('[^a-z0-9]', '_')
                    sh "docker exec ${projectName}_${APP_SERVICE}_1 php artisan migrate --force"
                }
            }
        }

        stage('Clear Laravel Cache') {
            steps {
                script {
                    def projectName = env.JOB_NAME.toLowerCase().replaceAll('[^a-z0-9]', '_')
                    sh "docker exec ${projectName}_${APP_SERVICE}_1 php artisan config:clear"
                    sh "docker exec ${projectName}_${APP_SERVICE}_1 php artisan cache:clear"
                    sh "docker exec ${projectName}_${APP_SERVICE}_1 php artisan route:clear"
                    sh "docker exec ${projectName}_${APP_SERVICE}_1 php artisan view:clear"
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
