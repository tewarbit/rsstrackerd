-module(subscription, [Id, Name, User]).
-compile(export_all).

encode_name() ->
  mochiweb_util:quote_plus(Name). 