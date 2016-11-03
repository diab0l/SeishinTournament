namespace Seishin.Services {
  export class AuthService {
    public static authenticate(username: string, password: string): JQueryPromise<string> {
      // TODO: hook up to the service

      const result = $.Deferred();
      result.resolve("ooga_booga");
      return result;
    }

    public static setAuthToken(token: string) {
      window.sessionStorage.setItem("authToken", token);
    }

    public static getAuthToken(): string {
      return window.sessionStorage.getItem("authToken");
    }
  }
}
