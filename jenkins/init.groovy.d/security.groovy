// Admin user from a random password generated on the server (~/lab-secrets), never stored in Git.
import jenkins.model.Jenkins
import hudson.model.User
import hudson.security.HudsonPrivateSecurityRealm
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy

def j = Jenkins.get()
def realm = new HudsonPrivateSecurityRealm(false)
if (User.getById('admin', false) == null) {
  realm.createAccount('admin', new File('/run/secrets/jenkins-admin-pass').text.trim())
}
j.setSecurityRealm(realm)
def auth = new FullControlOnceLoggedInAuthorizationStrategy()
auth.setAllowAnonymousRead(false)
j.setAuthorizationStrategy(auth)
j.save()
