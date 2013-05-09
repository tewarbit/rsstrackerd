-module(rsstrackerd_main_controller, [Req]).
-export([before_/3, home/3, allitems/3, subscription/3, markread/3, logout/3]).

before_(_, _, _) ->
  user_lib:require_login(Req).

home('GET', [], TrackerdUser) ->
  Subscriptions = boss_db:find(subscription, [{user, 'equals', TrackerdUser:email()}]),
  SubCount = erlang:length(Subscriptions),
  UnreadCount = boss_db:count(feed_item, [{user, 'equals', TrackerdUser:email()}, {read, 'equals', false}]),
  {ok, [{user, TrackerdUser}, {subscr_count, SubCount}, {unread_count, UnreadCount}, {subscriptions, Subscriptions}]}.

allitems('GET', [], TrackerdUser) ->
  Subscriptions = boss_db:find(subscription, [{user, 'equals', TrackerdUser:email()}]),
  Favorites = boss_db:find(favorite, []),
  FeedItems = boss_db:find(feed_item, [{user, 'equals', TrackerdUser:email()}], [{order_by, item_time}, {descending, true}]),
  {ok, [{subscriptions, Subscriptions}, {favorites, Favorites}, {feed_items, FeedItems}]}.

subscription('GET', [SubscriptionName], TrackerdUser) ->
  Subscription = mochiweb_util:unquote(SubscriptionName),
  Subscriptions = boss_db:find(subscription, [{user, 'equals', TrackerdUser:email()}]),
  Favorites = boss_db:find(favorite, []),
  FeedItems = boss_db:find(feed_item, [{user, 'equals', TrackerdUser:email()}, {subscription_name, 'equals', Subscription}], [{order_by, item_time}, {descending, true}]),
  {ok, [{subscriptions, Subscriptions}, {favorites, Favorites}, {feed_items, FeedItems}, {selected, Subscription}]}.

markread('POST', [], TrackerdUser) ->
  FeedId = Req:query_param("feedid"),
  erlang:display(FeedId),
  FeedItem = boss_db:find_first(feed_item, [{id, 'equals', FeedId}]),
  NewItem = FeedItem:set(read, true),
  NewItem:save(),
  ok.  

logout('GET', [], TrackerdUser) ->
  {redirect, "/", TrackerdUser:invalidate_cookies()}.
  