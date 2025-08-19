
pipeline {
    agent any

    environment {
        APP_SERVICE = "app"
        DB_SERVICE  = "db"
        NGINX_SERVICE = "nginx"
        PROJECT_NAME = "blog_project"
    }
        stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
                        }
                             }
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/1996sachin/Laravel-From-Scratch-Blog-Project.git', branch: 'main'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh "docker compose -p ${PROJECT_NAM
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/1996sachin/Laravel-From-Scratch-Blog-Project.git', branch: 'main'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh "docker compose -p ${PROJECT_NAME} -f docker-compose.yml build"
                }
            }
        }

        stage('Deploy Containers') {
            steps {
                script {
                    echo "Stopping and removing old containers..."
                    sh "docker compose -p ${PROJECT_NAME} -f docker-compose.yml down --remove-orphans || true"
                    
                    echo "Starting fresh containers..."
                    sh "docker compose -p ${PROJECT_NAME} -f docker-compose.yml up -d"
                }
            }
        }

        stage('Set Permissions') {
            steps {
                script {
                    echo "Setting permissions for Laravel storage and cache..."
                    sh "docker compose -p ${PROJECT_NAME} exec -T ${APP_SERVICE} chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    echo "Installing Composer dependencies..."
                    sh "docker compose -p ${PROJECT_NAME} exec -T ${APP_SERVICE} composer install --no-interaction --prefer-dist"
                }
            }
        }

        stage('Run Laravel Migrations') {
            steps {
                script {
                    echo "Running Laravel migrations..."
                    sh "docker compose -p ${PROJECT_NAME} exec -T ${APP_SERVICE} php artisan migrate --force"
                }
            }
        }

        stage('Clear Laravel Cache') {
            steps {
                script {
                    echo "Clearing Laravel cache..."
                    sh "docker compose -p ${PROJECT_NAME} exec -T ${APP_SERVICE} php artisan config:cache"
                    sh "docker compose -p ${PROJECT_NAME} exec -T ${APP_SERVICE} php artisan cache:clear"
                    sh "docker compose -p ${PROJECT_NAME} exec -T ${APP_SERVICE} php artisan route:clear"
                }
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
