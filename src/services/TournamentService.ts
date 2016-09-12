/// <reference path="../model/Tournament.ts"/>

module Services {
  export module Tournament {
    import Tournament = Model.Tournament;

    var tournaments : Tournament[] = [];

    export function getTournaments() : Tournament[] {
      return tournaments;
    }
  }
}
