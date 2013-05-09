-module(trackerd_user, [Id, Email, Password::string()]).
-export([session_identifier/0, check_password/1, login_cookies/0, invalidate_cookies/0]).

-define(SALTY_DOG, "Too many secrets").

session_identifier() ->
    mochihex:to_hex(erlang:md5(?SALTY_DOG)).

check_password(PasswordAttempt) ->
  erlang:display(Password),
  erlang:display(bcrypt:hashpw(PasswordAttempt, Password)),
  {ok, Hash} = bcrypt:hashpw(PasswordAttempt, Password),
  erlang:display(Hash),
  Password =:= Hash.

login_cookies() ->
  erlang:display(Id),
  [ mochiweb_cookies:cookie("trackerd_user_id", Id, [{path, "/"}]),
    mochiweb_cookies:cookie("session_id", session_identifier(), [{path, "/"}]) ]. 

invalidate_cookies() ->
  erlang:display("Invalidating cookies"),
  [ mochiweb_cookies:cookie("trackerd_user_id", "expired", [{path, "/"}, {max_age, 0}]),
    mochiweb_cookies:cookie("session_id", "expired", [{path, "/"}, {max_age, 0}]) ].
