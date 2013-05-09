-module(rsstrackerd_util_controller, [Req]).
-compile(export_all).

create_feed_item('GET', []) ->
  ok;
create_feed_item('POST', []) ->
  SubscriptionName = Req:post_param("subscriptionname"),
  erlang:display("hey"),
  
  erlang:display(SubscriptionName),
  
  ItemName = Req:post_param("itemname"),
  ItemContent = Req:post_param("content"),
  Author = Req:post_param("author"),
  Link = Req:post_param("link"),
  PubDate = Req:post_param("date"),
  UserId = Req:post_param("userid"),
  
  erlang:display(PubDate),
  
  erlang:display("ho"),

  FeedItem = feed_item:new(id, SubscriptionName, ItemName, ItemContent, Author, Link, secondsToDate(PubDate), UserId, false),
  {ok, SavedItem} = FeedItem:save(),
  % {redirect, [{action, "create_feed_item"}]}.
  ok.


secondsToDate(SecondsIn) ->
  {SecAsInt, _} = string:to_integer(SecondsIn),

  Mega = SecAsInt div 1000000,
  Secs = SecAsInt - (Mega * 1000000),

  {Mega, Secs, 0}.


create_subscription('GET', []) ->
  ok;
create_subscription('POST', []) ->
  SubName = Req:post_param("name"),
  UserId = Req:post_param("userid"),

  Subscription = subscription:new(id, SubName, UserId),
  {ok, SavedItem} = Subscription:save(),

  erlang:display("Created a subscription"),
  ok.

create_favorite('GET', []) ->
  ok;
create_favorite('POST', []) ->
  ItemName = Req:post_param("itemname"),
  Favorite = favorite:new(id, ItemName),
  {ok, SavedItem} = Favorite:save(),
  % {redirect, [{action, "create_favorite"}]}.
  ok.
