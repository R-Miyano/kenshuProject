</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <%@ page import="jp.swell.dao.UserInfoDao" %>
    <%@ page import="jp.swell.dao.RoomDao" %>
      <%@ page import="jp.swell.dao.ReserveDao" %>
        <%@ page import="jp.patasys.common.http.WebUtil" %>
          <%@ page import="jp.patasys.common.http.HtmlParts" %>
            <%@ page import="jp.patasys.common.http.WebBean" %>
              <%@ page import="jp.swell.constant.UserInfoState" %>
                <%@ page import="java.util.ArrayList" %>
                  <%@ page import="java.util.List" %>
                    <jsp:useBean id="webBean" class="jp.patasys.common.http.WebBean" scope="request" />
                    <% /* 埋め込み用変数の準備（フォーマッタによる改行破綻対策） */ String sortKeyOld=webBean.txt("sort_key_old"); String
                      sortOrder=webBean.txt("sort_order"); String searchInfo=webBean.txt("search_info"); String
                      reserveId=webBean.txt("reserve_id"); String inputInfo=webBean.txt("input_info"); String
                      listSearch=webBean.txt("list_search"); String listSearchCss=webBean.dispErrorCSS("list_search");
                      String listSearchErr=webBean.dispError("list_search"); String lineCount=webBean.txt("lineCount");
                      String pageNo=webBean.txt("pageNo"); String maxPageNo=webBean.html("maxPageNo"); String
                      recordCount=webBean.html("recordCount"); String lineCountHtml=webBean.html("lineCount"); %>
                      <html xmlns="http://www.w3.org/1999/xhtml" lang="ja">

                      <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <link rel="stylesheet" href="css/jquery.timepicker.min.css">
                        <link rel="stylesheet" href="jquery-ui/jquery-ui.css">
                        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
                        <script type="text/javascript" src="js/jquery-3.6.4.min.js"></script>
                        <script type="text/javascript" src="jquery-ui/jquery-ui.js"></script>
                        <script type="text/javascript" src="js/jquery.timepicker.min.js"></script>
                        <script type="text/javascript" src="js/colorchange.js"></script>
                        <script type="text/javascript" src="js/replace2.js"></script>
                        <script type="text/javascript" src="js/datePicker.js"></script>
                        <title>予約一覧</title>
                        <style>
                          body {
                            font-family: 'Arial', sans-serif;
                            background-color: #f9f9f9;
                            margin: 0;
                            padding: 10px;
                          }

                          header {
                            position: relative;
                            background: #00bcd4;
                            width: 100%;
                            margin-bottom: 5px;
                            text-align: center;
                          }

                          h1 a {
                            font-size: 1.5em;
                            color: white;
                            text-decoration: none;
                            font-weight: normal;
                          }

                          h1 a:hover {
                            color: #4baea8;
                          }

                          .container {
                            position: relative;
                            background-color: #f0f0f0;
                            border: 1px solid #ddd;
                            border-radius: 5px;
                            padding: 20px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                            width: 90%;
                            margin: 20px auto;
                          }

                          .left {
                            margin-bottom: 20px;
                            text-align: center;
                          }

                          table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-top: 20px;
                            background: #fff;
                          }

                          th,
                          td {
                            padding: 10px;
                            border-bottom: 1px solid #ddd;
                            text-align: center;
                            border: 1px #a0a0a0 solid;
                          }

                          th {
                            background-color: #00bcd4;
                            width: 150px;
                            color: #fff;
                            border: 1px #a0a0a0 solid;
                          }

                          select {
                            width: 23%;
                            padding: 5px;
                            border: 1px solid #000;
                            border-radius: 5px;
                          }

                          input.reserve_id {
                            width: 100px;
                          }

                          input.error {
                            color: #FF0000;
                            background-color: #FFCCCC;
                          }

                          span.error {
                            color: #FF0000;
                          }

                          .timestamp {
                            font-size: 0.8em;
                            color: #666;
                          }

                          input[type="button"] {
                            border-radius: 10px;
                            color: #fff;
                            cursor: pointer;
                            background: #90a0b0;
                          }

                          .new-btn {
                            position: absolute;
                            right: 10px;
                            top: 5px;
                          }

                          .new-btn input {
                            background: #fff;
                            color: #000;
                          }

                          input[type="button"]:hover {
                            background-color: #4baea8;
                          }

                          .color-palette {
                            display: flex;
                            border: 1px solid #a9a9a9;
                            width: fit-content;
                          }

                          .color-box {
                            width: 20px;
                            height: 20px;
                            cursor: pointer;
                          }

                          .color-option {
                            width: 20px;
                            height: 20px;
                            border: 1px solid #ddd;
                            cursor: pointer;
                          }

                          .vertical {
                            padding: 10px;
                            -ms-writing-mode: tb-rl;
                            writing-mode: vertical-rl;
                          }

                          select:disabled {
                            opacity: 1;
                            color: #000;
                            background-color: #fff;
                          }

                          .material-icons {
                            margin-right: 5px;
                            vertical-align: middle;
                          }

                          #dateHeader {
                            position: relative;
                          }

                          #timeHeader {
                            position: relative;
                          }

                          #memberHeader {
                            position: relative;
                          }

                          #roomHeader {
                            position: relative;
                          }

                          .list_label a {
                            color: #fff;
                            text-decoration: none;
                            cursor: pointer;
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

                          .search_label {
                            background: #00bcd4;
                            color: #fff;
                            text-align: center;
                            font-weight: bold;
                          }

                          .search_text,
                          .search_line {
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

                          a {
                            color: white;
                            text-decoration: none;
                          }

                          a:hover {
                            color: white;
                            text-decoration: none;
                          }

                          .select_table {
                            margin-bottom: 10px;
                            table-layout: fixed;
                          }

                          #pageNo {
                            text-align: center;
                            border-radius: 5px;
                          }

                          .search_text,
                          .search_line,
                          .list_btn {
                            text-align: center;
                            white-space: nowrap;
                          }

                          .search_line input {
                            display: inline-block;
                            width: auto;
                          }

                          .pagenation {
                            text-align: center;
                            margin: 0 auto;
                            margin-bottom: 10px;
                          }
                        </style>
                        <script type="text/javascript">
                          /* 検索条件入力でenterキーが押された場合の処理 */
                          jQuery(function ($) {
                            $(".select_table input").keydown(function (e) { if (e.which == 13) { go_submit('search'); } });
                            $(".page_table input").keydown(function (e) { if (e.which == 13) { go_submit('jump'); } });
                          });

                          /* テーブルを一行ごとにいろを変える */
                          $(document).ready(function () {
                            $('table.list_table tr:even').addClass('even');
                            $('table.list_table tr:odd').addClass('odd');
                          });

                          function displayData(startTime, endTime, roomName) {
                            document.getElementById('startTimeInput').value = startTime;
                            document.getElementById('endTimeInput').value = endTime;
                            document.getElementById('roomNameInput').value = roomName;
                          }

                          function go_submit(action_cmd) {
                            document.getElementById('main_form').action = 'ReserveList.do';
                            document.getElementById('action_cmd').value = action_cmd;
                            document.getElementById('main_form').submit();
                          }

                          function go_sort_request(key) {
                            document.getElementById('sort_key').value = key;
                            document.getElementById('action_cmd').value = 'sort';
                            document.getElementById('main_form').submit();
                          }

                          function go_menu(action_cmd) {
                            document.getElementById('main_form').action = 'UserMenu.do';
                            document.getElementById('action_cmd').value = action_cmd;
                            document.getElementById('main_form').submit();
                          }

                          function go_detail(action_cmd, main_key) {
                            document.getElementById('main_form').action = 'ReserveList.do';
                            document.getElementById('action_cmd').value = action_cmd;
                            document.getElementById('main_key').value = main_key;
                            document.getElementById('main_form').submit();
                          }

                          $(function () {
                            $("#reservation_date_input").datepicker();
                            $("#reservation_date_input").on("change", function () {
                              var value = $(this).val();
                              var value1 = value.replaceAll("-", "");
                              $("#reservation_date").val(value1);
                            });
                          });

                          $(document).ready(function () {
                            var $select = $('#user_info_id_input');
                            var $input = $('#user_info_name_input');
                            var $option = $select.find('option:selected');
                            $input.val($option.data('user-name'));
                          });

                          function delete1(reserveId) {
                            if (confirm("本当に削除してもよろしいですか？")) {
                              alert("削除が完了しました");
                              go_detail('delete', reserveId);
                            } else {
                              alert("削除がキャンセルされました");
                            }
                          }
                        </script>
                      </head>

                      <body>
                        <div class="container">
                          <div class="new-btn"><input type="button" value="　戻る　" onclick="go_submit('top')" /></div>
                          <header>
                            <h1><a href="javascript:void(0)" value="" onclick="go_menu('top')">予約一覧</a></h1>
                          </header>
                          <form id="main_form" method="post" action="">
                            <div class="edit-reservation">
                              <input type="hidden" name="form_name" id="form_name" value="ReserveList" />
                              <input type="hidden" name="action_cmd" id="action_cmd" value="" />
                              <input type="hidden" name="main_key" id="main_key" value="" />
                              <input type="hidden" name="sort_key_old" id="sort_key_old" value="<%=sortKeyOld%>" />
                              <input type="hidden" name="sort_key" id="sort_key" value="" />
                              <input type="hidden" name="sort_order" id="sort_order" value="<%=sortOrder%>" />
                              <input type="hidden" name="search_info" id="search_info" value="<%=searchInfo%>" />
                              <input type="hidden" name="reserveId" id="reserveId" value="<%=reserveId%>" />
                              <input type="hidden" name="user_info_id" id="user_info_id" value="">
                              <input type="hidden" name="user_info_name" id="user_info_name" value="">
                              <input type="hidden" name="input_info" id="input_info" value="<%=inputInfo%>" />

                              <div class="left">
                                <table class="select_table">
                                  <tr>
                                    <td class="search_label center" style="width: 50%">検索</td>
                                    <td class="search_label center" style="width: 25%">表示件数</td>
                                    <td class="search_label center" style="width: 25%"></td>
                                  </tr>
                                  <tr>
                                    <td class="search_text center"><input type="text" name="list_search"
                                        id="list_search" size="30" maxlength="100" value="<%=listSearch%>"
                                        class="ime_active <%=listSearchCss%>" placeholder="検索" />
                                      <%=listSearchErr%>
                                    </td>
                                    <td class="search_line center"><input type="text" name="lineCount" id="lineCount"
                                        size="2" maxlength="5" value="<%=lineCount%>" class="right ime_disabled" />件
                                    </td>
                                    <td class="search_text center"><input type="button" value="検索"
                                        onclick="go_submit('search')" /> <input type="button" value="クリア"
                                        onclick="go_submit('clear')" /></td>
                                  </tr>
                                </table>

                                <% if (webBean.arrayList("list").size()> 0) { %>
                                  <div class="pagenation">
                                    <input type="text" name="pageNo" id="pageNo" maxlength="3" size='1'
                                      value="<%=pageNo%>" class="right ime_disabled" /> / <%=maxPageNo%> ページ〚全
                                      <%=recordCount%>件〛<br />
                                        <% if (!"1".equals(webBean.value("pageNo"))) { %>
                                          <input type="button" value="<--前の<%=lineCountHtml%>件"
                                            onclick="go_submit('prior')" />
                                          <% } %>
                                            <input type="button" value="ページ表示" onclick="go_submit('jump')" />
                                            <% if (!webBean.value("pageNo").equals(webBean.value("maxPageNo"))) { %>
                                              <input type="button" value="次の<%=lineCountHtml%>件-->"
                                                onclick="go_submit('next')" />
                                              <% } %>
                                  </div>
                                  <% } %>

                                    <table id="reservationTable">
                                      <thead>
                                        <tr>
                                          <th id="dateHeader" class="list_label"><a
                                              href="javaScript:go_sort_request('reservation_date')">日付</a></th>
                                          <th id="timeHeader" class="list_label"><a
                                              href="javaScript:go_sort_request('checkin_time')">時間</a></th>
                                          <th id="memberHeader" class="list_label"><a
                                              href="javaScript:go_sort_request('last_name')">利用者名</a></th>
                                          <th id="roomHeader" class="list_label"><a
                                              href="javaScript:go_sort_request('room_name')">部屋名</a></th>
                                          <th>操作</th>
                                        </tr>
                                      </thead>
                                      <tbody>
                                        <% /* データベースの予約情報が空でないかの確認 */ if (webBean.arrayList("reserve") !=null &&
                                          !webBean.arrayList("reserve").isEmpty()) { /* 予約情報を取るためのループ処理 */ for (Object
                                          reserveItem : webBean.arrayList("reserve")) { ReserveDao reserve=(ReserveDao)
                                          reserveItem; RoomDao room=null; UserInfoDao user=null; /* データベースのroomが空でないかの確認
                                          */ if (webBean.arrayList("rooms") !=null &&
                                          !webBean.arrayList("rooms").isEmpty()) { /* 部屋情報を取るためのループ処理 */ for (Object
                                          roomItem : webBean.arrayList("rooms")) { RoomDao testRoom=(RoomDao) roomItem;
                                          if (testRoom.getRoomId().equals(reserve.getRoomId())) { room=testRoom; break;
                                          } } } /* データベースのuserが空でないかの確認 */ if (webBean.arrayList("users") !=null &&
                                          !webBean.arrayList("users").isEmpty()) { /* ユーザー情報を取るためのループ処理 */ for (Object
                                          userItem : webBean.arrayList("users")) { UserInfoDao testUser=(UserInfoDao)
                                          userItem; if (testUser.getUserInfoId().equals(reserve.getUserInfoId())) {
                                          user=testUser; break; } } } String
                                          reserveDate=WebUtil.htmlEscape(reserve.getReservationDate()); String
                                          formatDate=reserveDate.substring(0, 4) + "/" + reserveDate.substring(4, 6)
                                          + "/" + reserveDate.substring(6, 8); String
                                          checkinTime=WebUtil.htmlEscape(reserve.getCheckinTime()); String
                                          checkoutTime=WebUtil.htmlEscape(reserve.getCheckoutTime()); String
                                          formatCheckinTime=checkinTime.substring(0, 2) + ":" + checkinTime.substring(2,
                                          4); String formatCheckoutTime=checkoutTime.substring(0, 2) + ":" +
                                          checkoutTime.substring(2, 4); %>
                                          <tr>
                                            <td>
                                              <%=WebUtil.htmlEscape(formatDate)%>
                                            </td>
                                            <td>
                                              <%=WebUtil.htmlEscape(formatCheckinTime)%> -
                                                <%=WebUtil.htmlEscape(formatCheckoutTime)%>
                                            </td>
                                            <% if (user !=null) { %>
                                              <td>
                                                <%=WebUtil.htmlEscape(user.getLastName())%>
                                                  <%=WebUtil.htmlEscape(user.getMiddleName())%>
                                                    <%=WebUtil.htmlEscape(user.getFirstName())%>
                                              </td>
                                              <% } else { %>
                                                <td class="text-muted">(退会済ユーザー)</td>
                                                <% } %>
                                                  <% if (room !=null) { %>
                                                    <td>
                                                      <%=WebUtil.htmlEscape(room.getRoomName())%>
                                                    </td>
                                                    <% } else { %>
                                                      <td class="text-muted">(部屋不明)</td>
                                                      <% } %>
                                                        <td><button type="button" class="button delete_button"
                                                            onclick="delete1('<%=WebUtil.htmlEscape(reserve.getReserveId())%>');"><i
                                                              class="material-icons">delete</i>削除</button></td>
                                          </tr>
                                          <% } } %>
                                      </tbody>
                                    </table>
                              </div>
                            </div>
                          </form>
                        </div>
                      </body>

                      </html>