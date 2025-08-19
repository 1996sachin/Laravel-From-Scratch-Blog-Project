pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        APP_CONTAINER = 'laravel_app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/1996sachin/Laravel-From-Scratch-Blog-Project.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh "docker compose -f ${COMPOSE_FILE} build"
            }
        }

        stage('Deploy Containers') {
            steps {
                sh "docker compose -f ${COMPOSE_FILE} down"
                sh "docker compose -f ${COMPOSE_FILE} up -d"
            }
        }

        stage('Run Laravel Migrations') {
            steps {
                sh "docker exec ${APP_CONTAINER} php artisan migrate --force"
            }
        }

        stage('Clear Laravel Cache') {
            steps {
                sh "docker exec ${APP_CONTAINER} php artisan config:clear"
                sh "docker exec ${APP_CONTAINER} php artisan cache:clear"
                sh "docker exec ${APP_CONTAINER} php artisan route:clear"
                sh "docker exec ${APP_CONTAINER} php artisan view:clear"
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
