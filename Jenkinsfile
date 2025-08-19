pipeline {
    agent any

    environment {
        PROJECT_NAME = "blog_project"
        COMPOSE_FILE = "docker-compose.yml"
        COMPOSER_PATH = "/usr/local/bin/composer"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/1996sachin/Laravel-From-Scratch-Blog-Project.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                echo "Building Docker images..."
                sh "docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} build --no-cache"
            }
        }

        stage('Deploy Containers') {
            steps {
                echo "Stopping and removing old containers..."
                sh "docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} down --remove-orphans"

                echo "Starting fresh containers..."
                sh "docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} up -d"
            }
        }

        stage('Set Permissions') {
            steps {
                echo "Setting permissions for Laravel storage and cache..."
                sh "docker compose -p ${PROJECT_NAME} exec -T app chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache"
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing Composer dependencies..."
                sh "docker compose -p ${PROJECT_NAME} exec -T app ${COMPOSER_PATH} install --no-interaction --prefer-dist"
            }
        }

        stage('Run Laravel Migrations') {
            steps {
                echo "Running Laravel migrations..."
                sh "docker compose -p ${PROJECT_NAME} exec -T app php artisan migrate --force"
            }
        }

        stage('Clear Laravel Cache') {
            steps {
                echo "Clearing Laravel cache..."
                sh "docker compose -p ${PROJECT_NAME} exec -T app php artisan config:cache"
                sh "docker compose -p ${PROJECT_NAME} exec -T app php artisan route:cache"
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

