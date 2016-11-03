/// <reference path="../../../typings/index.d.ts" />

/// <reference path="../../services/AuthService.ts" />
namespace Seishin {
  type Action = () => void;

  export class Login {
    public requireLogin(onLogin: Action): void {
      $.get("components/login/x.html", (result: string) => Login.onTemplateLoaded(result, onLogin));
    }

    private static onTemplateLoaded(tpl: string, onLogin: Action) {
      const body = $("body");
      // TODO: add some sort of modal container
      body.children().remove();

      body.html(tpl);

      const component = $("div[data-id=login]");
      const $username = $("input[data-id=username]", component);
      const $password = $("input[data-id=password]", component);
      const login_button = $("button[data-cmd=login]", component);

      login_button.click(() => Login.onLoginButtonClicked($username, $password, onLogin));
    }

    private static onLoginButtonClicked($username, $password, onLogin: Action) {
      const username = $username.val();
      const password = $password.val();

      const promise = Seishin.Services.AuthService.authenticate(username, password);

      promise.fail(() => {
        alert("login failed");
      });

      promise.then((token: string) => {
        Seishin.Services.AuthService.setAuthToken(token);

        if(onLogin) {
          onLogin();
        }
      });
    }
  }
}
