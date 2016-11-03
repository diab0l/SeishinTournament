/// <reference path="components/login/x.ts" />

namespace Seishin {
  function onSuccessfulLogin() {
      
  }

  export function main() {
    const login = new Login();
    login.requireLogin(onSuccessfulLogin);
  }
}
