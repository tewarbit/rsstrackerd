-module(user_lib).
-export([require_login/1]).

require_login(Req) ->
  erlang:display("Checking request for session cookies..."),
  
  case Req:cookie("trackerd_user_id") of
    undefined -> {redirect, [{action, "../user/login"}]};
    Id ->
      case boss_db:find(Id) of
        undefined -> {redirect, [{action, "../user/login"}]};
        TrackerdUser ->
          case TrackerdUser:session_identifier() =:= Req:cookie("session_id") of
            false -> {redirect, [{action, "../user/login"}]};
            true -> {ok, TrackerdUser}
          end
      end
  end.
