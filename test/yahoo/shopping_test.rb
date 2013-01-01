# coding: utf-8

require 'pp'
require 'pry'
require 'rubygems'
require 'test/unit'

require File.expand_path(File.dirname(__FILE__) + '/../../lib/yahoo/shopping')

class Yahoo::ShoppingTest < Test::Unit::TestCase
  YAHOO_APPID = 'dummyDUMMYdummyDUMMYdummyDUMMYdummyDUMMYdummyDUMMYdummyDUMMYdummyDUMMYdummyDUMMYdummyDUMMYdd-'

  Yahoo::Shopping.configure do |options|
    options[:appid] = YAHOO_APPID
  end

  Yahoo::Shopping.debug = true

  def test_url_for_item_search
    url = Yahoo::Shopping.build_url(
      :appid           => YAHOO_APPID,
      :operation       => 'itemSearch',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :query           => 'ruby初心者',
      :type            => 'all',
      :jan             => 123456789,
      :isbn            => 123456789,
      :category_id     => 1,
      :product_id      => 1,
      :person_id       => 1,
      :brand_id        => 1,
      :store_id        => 'store000',
      :price_from      => 0,
      :price_to        => 1000,
      :hits            => 50,
      :offset          => 0,
      :sort            => '+price',
      :affiliate_from  => 0.0,
      :affiliate_to    => 100.0,
      :module          => 'priceranges',
      :availablity     => 1,
      :discount        => 1
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/itemSearch|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&query=ruby%E5%88%9D%E5%BF%83%E8%80%85&type=all&jan=123456789&isbn=123456789&category_id=1&product_id=1&person_id=1&brand_id=1&store_id=store000&price_from=0&price_to=1000&hits=50&offset=0&sort=%2Bprice&affiliate_from=0.0&affiliate_to=100.0&module=priceranges&availablity=1&discount=1\Z|, url)
  end

  def test_url_for_category_ranking
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'categoryRanking',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :category_id     => 1,
      :gender          => 'male',
      :generation      => 20,
      :period          => 'weekly',
      :offset          => 1,
      :type            => 'up'
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/categoryRanking|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&category_id=1&gender=male&generation=20&period=weekly&offset=1&type=up\Z|, url)
  end

  def test_url_for_category_search
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'categorySearch',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :category_id     => 1,
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/categorySearch|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&category_id=1\Z|, url)
  end

  def test_url_for_item_lookup
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'itemLookup',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :itemcode        => 'item000',
      :responsegroup   => 'small'
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/itemLookup|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&itemcode=item000&responsegroup=small\Z|, url)
  end

  def test_url_for_query_ranking
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'queryRanking',
      :affiliate_type => 'yid',
      :affiliate_id   => 'yid0123456789',
      :callback       => 'cb_hoge',
      :type           => 'ranking',
      :hits           => 20,
      :offset         => 0,
      :category_id    => 1,
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/queryRanking|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&type=ranking&hits=20&offset=0&category_id=1\Z|, url)
  end

  def test_url_for_contentMatchItem
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'contentMatchItem',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :url             => 'http://example.com/hoge',
      :type            => 'keyword',
      :hits            => 1,
      :store_id        => 'store000',
      :responsegroup   => 'small',
      :affiliate_from  => 0.0,
      :affiliate_to    => 100.0,
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/contentMatchItem|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&url=http://example.com/hoge&type=keyword&hits=1&store_id=store000&responsegroup=small&affiliate_from=0.0&affiliate_to=100.0\Z|, url)
  end

  def test_url_for_contentMatchRanking
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'contentMatchRanking',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :url             => 'http://example.com/hoge',
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/contentMatchRanking|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&url=http://example.com/hoge\Z|, url)
  end

  def test_url_for_get_module
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'getModule',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :category_id     => 1,
      :position        => 'eventrecommend'
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/getModule|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&category_id=1&position=eventrecommend\Z|, url)
  end

  def test_url_for_event_search
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'eventSearch',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :event_type      => 'all',
      :event_id        => 1,
      :sort            => 'score',
      :hits            => 5,
      :offset          => 0
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/eventSearch|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&event_type=all&event_id=1&sort=score&hits=5&offset=0\Z|, url)
  end

  def test_url_for_review_search
    url = Yahoo::Shopping.build_url(
      :appid     => YAHOO_APPID,
      :operation => 'reviewSearch',
      :affiliate_type  => 'yid',
      :affiliate_id    => 'yid0123456789',
      :callback        => 'cb_hoge',
      :jan             => 123456789,
      :category_id     => 1,
      :product_id      => 1,
      :person_id       => 1,
      :store_id        => 'store000',
      :result          => 10,
      :start           => 1,
      :sort            => 'updatetime'
    )

    assert_match(%r|\Ahttp://shopping\.yahooapis\.jp/ShoppingWebService/V1/reviewSearch|, url)
    assert_match(%r|\?appid=#{YAHOO_APPID}&affiliate_type=yid&affiliate_id=yid0123456789&callback=cb_hoge&jan=123456789&category_id=1&product_id=1&person_id=1&store_id=store000&result=10&start=1&sort=updatetime\Z|, url)
  end

  def test_hoge
    binding.pry
  end
end
