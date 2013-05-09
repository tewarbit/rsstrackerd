-module(rsstrackerd_import_controller, [Req]).
-export([before_/3, import/3]).

before_(_, _, _) ->
  user_lib:require_login(Req).


import('GET', [], TrackerdUser) ->
  {ok, []};
import('POST', [], TrackerdUser) ->
    % {output, Req:dump()},

    [ {uploaded_file, _, FileUpload, _} ] = Req:post_files(),
    
    {ok, Files} = zip:unzip(FileUpload),

    {ok, Subscriptions} = file:read_file(lists:nth(8, Files)),
    AsUTF = unicode:characters_to_list(Subscriptions, utf8),

    UserId = TrackerdUser:email(),

    RequestResults = httpc:request(post, 
      {"http://localhost:8000", [], "application/x-www-form-urlencoded", string:join(["userid=", UserId, "&", "fileupload=", AsUTF], "")}, [], []),
    % RequestResults = ibrowse:send_req(
    %   "http://localhost:8000", [{"Content-Type","application/x-www-form-urlencoded"}], post, string:concat("fileupload=", AsUTF), 
    %   [{stream_to, self()}]),

    io:format("Results are: ~w", [RequestResults]),
    {redirect, "/", []}.


% ["btewari@gmail.com-takeout/Reader/followers.json",
%  "btewari@gmail.com-takeout/Reader/following.json",
%  "btewari@gmail.com-takeout/Reader/liked.json",
%  "btewari@gmail.com-takeout/Reader/starred.json",
%  "btewari@gmail.com-takeout/Reader/notes.json",
%  "btewari@gmail.com-takeout/Reader/shared.json",
%  "btewari@gmail.com-takeout/Reader/shared-by-followers.json",
%  "btewari@gmail.com-takeout/Reader/subscriptions.xml"]