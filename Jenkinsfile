pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        // k3s runs on the host Docker engine (--docker), so this image is instantly
        // available to the cluster - no registry push or image import needed.
        sh 'docker build -t myapp:v2 .'
      }
    }
    stage('Deploy Green') {
      steps {
        sh 'kubectl apply -f deployment-green.yaml'
        sh 'kubectl rollout status deployment/myapp-green --timeout=120s'
        // Smoke-test a green pod directly (it receives no Service traffic yet)
        sh 'curl -s http://$(kubectl get pod -l color=green -o jsonpath="{.items[0].status.podIP}")/ | grep -o "VERSION 2 - GREEN"'
      }
    }
    stage('Switch Traffic') {
      steps {
        input "Switch to Green?"
        sh '''
        kubectl patch service myapp-service \
        -p '{"spec":{"selector":{"app":"myapp","color":"green"}}}'
        '''
        sh 'kubectl get svc myapp-service -o jsonpath="{.spec.selector}"; echo'
      }
    }
  }
}
