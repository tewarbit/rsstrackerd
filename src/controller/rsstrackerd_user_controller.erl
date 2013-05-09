-module(rsstrackerd_user_controller, [Req]).
-export([login/2, signup/2]).


login('GET', []) ->
    {ok, [{redirect, Req:header(referer)}]};
login('POST', []) ->
    Username = Req:post_param("username"),
    erlang:display(Username),
    erlang:display(boss_db:find(trackerd_user, [{email, 'equals', Username}])),
    case boss_db:find(trackerd_user, [{email, 'equals', Username}]) of
        [TrackerdUser] ->
            case TrackerdUser:check_password(Req:post_param("password")) of
                true ->
                   {redirect, "/", TrackerdUser:login_cookies()};
                false ->
                    {ok, [{error, "Authentication error"}]}
            end;
        [] ->
            {ok, [{error, "Authentication error"}]}
    end.

signup('GET', []) ->
    {ok, []};
signup('POST', []) ->
    Email = Req:post_param("email"),
    {ok, Salt} = bcrypt:gen_salt(),
    {ok, Hash} = bcrypt:hashpw(Req:post_param("password"), Salt),
    TrackerdUser = trackerd_user:new(id, Email, Hash),
    {ok, NewUser} = TrackerdUser:save(),

    erlang:display(TrackerdUser),
    erlang:display(NewUser),
    erlang:display(TrackerdUser:login_cookies()),
    
    {redirect, "/", NewUser:login_cookies()}.

