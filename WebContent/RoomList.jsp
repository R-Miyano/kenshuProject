<?xml version="1.0" encoding="UTF8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%-- 必要なクラスのインポート --%>
    <%@ page import="jp.swell.dao.RoomDao" %>
      <%@ page import="jp.patasys.common.http.WebUtil" %>
        <%@ page import="jp.patasys.common.http.HtmlParts" %>
          <%@ page import="jp.swell.constant.UserInfoState" %>
            <%@ page import="java.util.ArrayList" %>
              <%-- コントローラから渡されたWebBeanをリクエストスコープから取得 --%>
                <jsp:useBean id="webBean" class="jp.patasys.common.http.WebBean" scope="request" />

                <!DOCTYPE html
                  PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">

                <head>
                  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
                  <meta http-equiv="Content-Script-Type" content="text/javascript" />
                  <meta http-equiv="Content-Style-Type" content="text/css" />

                  <%-- CSS・ライブラリの読み込み --%>
                    <link type="text/css" href="jquery-ui/jquery-ui.css" rel="stylesheet" />
                    <link rel="shortcut icon" href="images/favicon.ico" type="image/vnd.microsoft.icon" />
                    <link rel="icon" href="images/favicon.ico" type="image/vnd.microsoft.icon" />
                    <script type="text/javascript" src="js/jquery-3.6.4.min.js"></script>
                    <script type="text/javascript" src="jquery-ui/jquery-ui.js"></script>
                    <script type="text/javascript" src="jquery.watermark/jquery.watermark.js"></script>
                    <script type="text/javascript" src="js/common.js"></script>

                    <title>部屋情報一覧</title>

                    <style type="text/css">
                      /* =========================================
   基本スタイル・レイアウト
   ========================================= */
                      body {
                        font-family: 'Arial', sans-serif;
                        background-color: #f9f9f9;
                        margin: 0;
                        padding: 10px;
                      }

                      header {
                        position: relative;
                        background: #00bcd4;
                        /* ヘッダーの背景色 */
                        width: 100%;
                        /* 幅を画面いっぱいに */
                        margin-bottom: 5px;
                        /* 不要な余白を排除 */
                        text-align: center;
                        /* テキスト中央寄せ */
                      }

                      h1 a {
                        font-size: 1.5em;
                        color: white;
                        /* リンクの文字色を白に */
                        text-decoration: none;
                        /* 下線を削除 */
                        font-weight: normal;
                      }

                      h1 a:hover {
                        color: #4baea8;
                        /* ホバー時に下線を表示する場合 */
                      }

                      .container {
                        position: relative;
                        /* ボタンを基準に配置するため */
                        background-color: #f0f0f0;
                        border: 1px solid #ddd;
                        border-radius: 5px;
                        padding: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        width: 90%;
                        /* コンテナの幅を画面幅に揃える */
                        margin: 20px auto;
                        /* 中央寄せ */
                      }

                      .left {
                        margin-bottom: 20px;
                        text-align: center;
                      }

                      /* =========================================
   ボタンのスタイル
   ========================================= */
                      input[type="button"] {
                        border-radius: 10px;
                        /* 角を丸くする */
                        color: #fff;
                        /* 文字色 */
                        cursor: pointer;
                        /* カーソルをポインタにする */
                        background: #90a0b0;
                        /* デフォルトの背景色 */
                      }

                      .new-btn {
                        position: absolute;
                        right: 10px;
                        /* 右端に10pxの余白を取る */
                        top: 5px;
                      }

                      .new-btn input {
                        background: #fff;
                        /* 背景色を白に */
                        color: #000;
                        /* 文字色を黒に */
                      }

                      input[type="button"]:hover {
                        background-color: #4baea8;
                        /* ホバー時の背景色 */
                      }

                      /* =========================================
   テーブル・フォーム要素のスタイル
   ========================================= */
                      table {
                        width: 100%;
                        margin: 0px;
                        padding: 0px;
                        border-collapse: collapse;
                        border-spacing: 0px;
                        border: 0px #808080 solid;
                      }

                      td {
                        height: 1.8em;
                        border-color: #404040;
                        border-collapse: collapse;
                      }

                      .search_label {
                        /* 検索エリアのラベル */
                        background: #00bcd4;
                        color: #fff;
                        text-align: center;
                      }

                      .search_text,
                      .search_line,
                      .list_btn {
                        text-align: center;
                      }

                      .search_text input {
                        text-align: left;
                        border-radius: 5px;
                      }

                      .search_line input {
                        text-align: right;
                        border-radius: 5px;
                      }

                      .pagenation,
                      .select_table {
                        margin-bottom: 10px;
                      }

                      .select_table td {
                        border-collapse: collapse;
                        border: 1px #a0a0a0 solid;
                        padding: 2px;
                      }

                      .list_label {
                        /* 一覧テーブルの見出し */
                        background: #00bcd4;
                        color: #fff;
                        text-align: center;
                      }

                      .list_label a {
                        color: #fff;
                        text-decoration: none;
                      }

                      .list_table td {
                        border-collapse: collapse;
                        border: 1px #a0a0a0 solid;
                        padding: 2px;
                      }

                      #pageNo {
                        text-align: center;
                        border-radius: 5px;
                      }

                      .list_tr:nth-child(odd) {
                        /* ストライプテーブル用の設定（CSS版） */
                        background: #efefef;
                      }

                      footer {
                        width: 100%;
                      }
                    </style>

                    <script type="text/javascript">
<%-- jQuery初期化処理 --%>
                        jQuery(function ($) {
  <%-- 検索条件入力フィールドでEnterキーが押された場合の処理 --%>
                            $(".select_table input").keydown(function (e) {
                              if (e.which == 13) {
                                go_submit('search');
                              }
                            });
  
  <%-- [注意] HTML内に "page_table" クラスが存在しません（"pagenation"のみ）。ページング入力時のEnter処理が動かない可能性があります --%>
                            $(".page_table input").keydown(function (e) {
                              if (e.which == 13) {
                                go_submit('jump');
                              }
                            });
                        });

<%-- テーブルの行を交互に色分けする処理（CSSのnth - childでも設定されていますが念のため） --%>
                        $(document).ready(function () {
                          $('table.list_table tr:even').addClass('even');
                          $('table.list_table tr:odd').addClass('odd');
                        });

<%-- 汎用的なフォーム送信処理 --%>
                        function go_submit(action_cmd) {
                          document.getElementById('main_form').action = 'RoomList.do';
                          document.getElementById('action_cmd').value = action_cmd;
                          document.getElementById('main_form').submit();
                        }

                        <%-- ソート（見出しクリック）処理 --%>
                          function go_sort_request(key) {
                            document.getElementById('sort_key').value = key;
                            document.getElementById('action_cmd').value = 'sort';
                            document.getElementById('main_form').submit();
                          }

                          <%-- メニューへ戻る処理 --%>
                            function go_menu(action_cmd) {
                              document.getElementById('main_form').action = 'UserMenu.do';
                              document.getElementById('action_cmd').value = action_cmd;
                              document.getElementById('main_form').submit();
                            }

                            <%-- 編集ボタン押下時の詳細画面遷移（before_nameを保持） --%>
                              function go_detail_1(action_cmd, request_cmd, main_key, before_name) {
                                document.getElementById('main_form').action = 'RoomDetail.do';
                                document.getElementById('action_cmd').value = action_cmd;
                                document.getElementById('request_cmd').value = request_cmd;
                                document.getElementById('main_key').value = main_key;
                                document.getElementById('before_name').value = before_name;
                                document.getElementById('main_form').submit();
                              }

                              <%-- 削除ボタン押下時の詳細画面遷移（room_nameを保持） --%>
                                function go_detail_2(action_cmd, request_cmd, main_key, room_name) {
                                  document.getElementById('main_form').action = 'RoomDetail.do';
                                  document.getElementById('action_cmd').value = action_cmd;
                                  document.getElementById('request_cmd').value = request_cmd;
                                  document.getElementById('main_key').value = main_key;
                                  document.getElementById('room_name').value = room_name;
                                  document.getElementById('main_form').submit();
                                }

                                <%-- 新規登録ボタン押下時の詳細画面遷移 --%>
                                  function go_detail(action_cmd, request_cmd) {
                                    document.getElementById('main_form').action = 'RoomDetail.do';
                                    document.getElementById('action_cmd').value = action_cmd;
                                    document.getElementById('request_cmd').value = request_cmd;
                                    document.getElementById('main_form').submit();
                                  }
                    </script>
                </head>

                <body>
                  <div class="container">
                    <%-- ヘッダー右上ボタン群 --%>
                      <div class="new-btn">
                        <input type="button" value="新規登録" onclick="go_detail('go_next','ins')" />
                        <input type="button" value="　戻る　" onclick="window.parent.location.href='MenuAdmin.do'" />
                      </div>

                      <header>
                        <h1>
                          <a href="javascript:void(0)" onclick="go_menu('top')">部屋情報一覧</a>
                        </h1>
                      </header>

                      <%-- 部屋情報の更新・削除完了メッセージ表示エリア（赤太字・下1行空け） --%>
                        <div
                          style="color: red; font-weight: bold; text-align: center; margin-top: 10px; margin-bottom: 20px;">
                          <%= webBean.dispMessages() %>
                        </div>

                        <%-- メインフォーム --%>
                          <form id="main_form" method="post" action="">

                            <%-- 状態維持・コントローラへのパラメータ渡し用の隠しフィールド（Hidden） --%>
                              <input type="hidden" name="form_name" id="form_name" value="RoomList" />
                              <input type="hidden" name="action_cmd" id="action_cmd" value="" />
                              <input type="hidden" name="request_cmd" id="request_cmd" value="" />
                              <input type="hidden" name="main_key" id="main_key" value="" />
                              <input type="hidden" name="room_name" id="room_name" value="<%=webBean.txt("room_name")%>" />
                              <input type="hidden" name="before_name" id="before_name" value="<%=webBean.txt("before_name")%>" />
                              <input type="hidden" name="sort_key_old" id="sort_key_old" value="<%=webBean.txt("sort_key_old")%>"/>
                              <input type="hidden" name="sort_key" id="sort_key" value="" />
                              <input type="hidden" name="sort_order" id="sort_order" value="<%=webBean.txt("sort_order")%>"/>
                              <input type="hidden" name="search_info" id="search_info" value="<%=webBean.txt("search_info")%>"/>
                              <input type="hidden" name="room_id" id="room_id" value="<%=webBean.txt("room_id")%>"/>

                              <div class="left">
                                <%-- 検索条件エリア --%>
                                  <table class="select_table">
                                    <tr>
                                      <td class="search_label center" style="width: 50%">部屋名</td>
                                      <td class="search_label center" style="width: 25%">表示件数</td>
                                      <td class="search_label center" style="width: 25%"></td>
                                    </tr>
                                    <tr>
                                      <td class="search_text center">
                                        <input type="text" name="list_search_room_name" id="list_search_room_name"
                                          size="30" maxlength="100" value="<%=webBean.txt("list_search_room_name") %>"
                                        class="ime_active <%=webBean.dispErrorCSS("list_search_room_name")%>"
                                          placeholder="検索"/>
                                          <%=webBean.dispError("list_search_room_name")%>
                                      </td>
                                      <td class="search_line center">
                                        <input type="text" name="lineCount" id="lineCount" size="2" maxlength="5"
                                          value="<%=webBean.txt("lineCount") %>" class="right ime_disabled" />件
                                      </td>
                                      <td style="text-align: center; vertical-align: middle;">
                                        <input type="button" value="検索" onclick="go_submit('search')" />
                                        <input type="button" value="クリア" onclick="go_submit('clear')" />
                                      </td>
                                    </tr>
                                  </table>

                                  <%-- 検索結果がある場合のみ以下のエリアを表示 --%>
                                    <%if(webBean.arrayList("list").size()> 0){%>

                                      <%-- ページネーションエリア --%>
                                        <div class="pagenation">
                                          <input type="text" name="pageNo" id="pageNo" maxlength="3" size='1'
                                            value="<%=webBean.txt("pageNo")%>" class="right ime_disabled" /> /
                                          <%=webBean.html("maxPageNo")%> ページ〚全 <%=webBean.html("recordCount")%>件〛<br />

                                              <%-- 前のページへボタン --%>
                                                <%if(!"1".equals(webBean.value("pageNo"))){%>
                                                  <input type="button" value="<--前の<%=webBean.html("lineCount")%>件"
                                                  onclick="go_submit('prior')" />
                                                  <%}else{%>
                                                    <%-- （必要に応じて非アクティブなボタン等を配置） --%>
                                                      <%}%>

                                                        <input type="button" value="ページ表示"
                                                          onclick="go_submit('jump')" />

                                                        <%-- 次のページへボタン --%>
                                                          <%if(!webBean.value("pageNo").equals(webBean.value("maxPageNo"))){%>
                                                            <input type="button" value="次の<%=webBean.html("lineCount")%>件-->" onclick="go_submit('next')" />
                                                            <%}else{%>
                                                              <%}%>
                                        </div>

                                        <%-- 検索結果一覧テーブル --%>
                                          <table class="list_table">
                                            <tr class="list_title">
                                              <td class="list_label" style="width: 70%"><a
                                                  href="javaScript:go_sort_request('room_name')">部屋名</a></td>
                                              <td class="list_label" style="width: 30%"></td>
                                            </tr>

                                            <%-- リストデータのループ展開 --%>
                                              <% for(Object item : webBean.arrayList("list")) { RoomDao
                                                dao=(RoomDao)item; %>
                                                <tr class="list_tr">
                                                  <td class="list_text">
                                                    <%=WebUtil.htmlEscape(dao.getRoomName())%>
                                                  </td>
                                                  <td class="list_btn">
                                                    <%-- 編集・削除のアクション発火。XSS対策としてWebUtil.txtEscapeを使用 --%>
                                                      <input type="button" value="編集"
                                                        onclick="go_detail_1('go_next','update','<%=WebUtil.txtEscape(dao.getRoomId())%>','<%=WebUtil.txtEscape(dao.getRoomName())%>');" />
                                                      <input type="button" value="削除"
                                                        onclick="go_detail_2('go_next','deletef','<%=WebUtil.txtEscape(dao.getRoomId())%>','<%=WebUtil.txtEscape(dao.getRoomName())%>');" />
                                                  </td>
                                                </tr>
                                                <%}%>
                                          </table>
                                          <%}%> <%-- リスト表示if文の終了 --%>

                              </div>
                          </form>
                  </div>
                </body>

                </html>