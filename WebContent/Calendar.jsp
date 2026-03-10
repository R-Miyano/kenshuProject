<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.ArrayList" %>
        <%@ page import="java.util.Calendar" %>
            <%@ page import="java.text.SimpleDateFormat" %>
                <%@ page import="jp.swell.dao.ReserveDao" %>
                    <%@ page import="jp.swell.dao.RoomDao" %>
                        <%@ page import="jp.swell.dao.UserInfoDao" %>
                            <%@ page import="java.util.ArrayList" %>
                                <%@ page import="java.util.List" %>
                                    <%@ page import="jp.patasys.common.http.WebUtil" %>
                                        <%@ page import="jp.patasys.common.http.WebBean" %>
                                            <%@ page import="java.util.List" %>
                                                <%@ page import="jp.swell.dao.UserInfoDao" %>
                                                    <%@ page import="jp.patasys.common.http.WebUtil" %>
                                                        <%@ page import="java.util.ArrayList" %>
                                                            <%@ page import="java.util.Iterator" %>
                                                                <%@ page import="jp.swell.user.UserLoginInfo" %>

                                                                    <jsp:useBean id="webBean"
                                                                        class="jp.patasys.common.http.WebBean"
                                                                        scope="request" />
                                                                    <!DOCTYPE html
                                                                        PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
                                                                    <html xmlns="http://www.w3.org/1999/xhtml">
                                                                    <script type="text/javascript"
                                                                        src="js/jquery-3.6.4.min.js"></script>
                                                                    <script type="text/javascript"
                                                                        src="jquery-ui/jquery-ui.js"></script>
                                                                    <script type="text/javascript"
                                                                        src="js/jquery.timepicker.min.js"></script>
                                                                    <script type="text/javascript"
                                                                        src="js/colorchange.js"></script>
                                                                    <script type="text/javascript"
                                                                        src="js/replace2.js"></script>

                                                                    <head>
                                                                        <meta charset="UTF-8">

                                                                        <title>カレンダー</title>
                                                                        <style type="text/css">
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

                                                                            body {
                                                                                font-family: 'Arial', sans-serif;
                                                                                background-color: #f9f9f9;
                                                                                margin: 0;
                                                                                padding: 10px;
                                                                            }

                                                                            /* ボタンの共通スタイル */
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

                                                                            /* .new-btnのスタイル */
                                                                            .new-btn input {
                                                                                background: #fff;
                                                                                /* 背景色を白に */
                                                                                color: #000;
                                                                                /* 文字色を黒に */
                                                                            }

                                                                            /* ホバー時のスタイル */
                                                                            input[type="button"]:hover {
                                                                                background-color: #4baea8;
                                                                                /* ホバー時の背景色 */
                                                                            }

                                                                            #month_button {
                                                                                height: 50px;
                                                                                margin-left: 10px;
                                                                                display: flex;
                                                                                align-items: center;
                                                                            }

                                                                            button {
                                                                                height: 50px;
                                                                                border-radius: 10px;
                                                                                cursor: pointer;
                                                                            }

                                                                            #current_month {
                                                                                font-size: 50px;
                                                                            }

                                                                            #buttons {
                                                                                height: 100px;
                                                                                display: flex;
                                                                                align-items: end;
                                                                                justify-content: space-between;
                                                                            }

                                                                            #roomColor {
                                                                                display: flex;
                                                                                justify-content: center;
                                                                            }

                                                                            <% if (webBean.arrayList("roomList") !=null) {
                                                                                int colorIdx=0;

                                                                                String[] colors= {
                                                                                    "orangered",
                                                                                    "forestgreen",
                                                                                    "yellow",
                                                                                    "royalblue",
                                                                                    "chocolate",
                                                                                    "springgreen",
                                                                                    "mediumspringgreen",
                                                                                    "lawngreen",
                                                                                    "cyan",
                                                                                    "gold",
                                                                                    "pink",
                                                                                    "silver",
                                                                                    "plum",
                                                                                    "salmon",
                                                                                    "khaki"
                                                                                }

                                                                                ;

                                                                                for (Object item : webBean.arrayList("roomList")) {
                                                                                    RoomDao room=(RoomDao) item;
                                                                                    String color=colors[colorIdx % colors.length];
                                                                                    colorIdx++;

                                                                                    %>#room<%=WebUtil.htmlEscape(room.getRoomId())%>,
                                                                                    .room<%=WebUtil.htmlEscape(room.getRoomId())%> {
                                                                                        color: black;
                                                                                        background-color: <%=color%>;
                                                                                        margin: 5px;
                                                                                    }

                                                                                    <%
                                                                                }
                                                                            }

                                                                            %>table {
                                                                                width: 100%;
                                                                                border-collapse: collapse;
                                                                                margin-top: 20px;
                                                                                table-layout: fixed;
                                                                            }

                                                                            th {
                                                                                background-color: #f2f2f2;
                                                                                padding: 10px;
                                                                            }

                                                                            td {
                                                                                font-size: 95%;
                                                                                padding: 10px;
                                                                                border-bottom: 1px solid #ddd;
                                                                                vertical-align: top;
                                                                                border: 1px solid;
                                                                                border-color: black;
                                                                            }

                                                                            td:first-child {
                                                                                color: red;
                                                                            }

                                                                            td:last-child {
                                                                                color: blue;
                                                                            }

                                                                            .today {
                                                                                background-color: pink;
                                                                            }

                                                                            .sat {
                                                                                color: blue;
                                                                            }

                                                                            .sun {
                                                                                color: red;
                                                                            }

                                                                            td.mute {
                                                                                color: #ccc;
                                                                            }

                                                                            footer {
                                                                                width: 100%;
                                                                            }
                                                                        </style>
                                                                        <script type="text/javascript">

                                                                            function go_submit(action_cmd) {
                                                                                document.getElementById('main_form').action = 'Calendar.do';
                                                                                document.getElementById('action_cmd').value = action_cmd;
                                                                                document.getElementById('main_form').submit();
                                                                            }

                                                                            //カレンダーの作成
                                                                            const date = new Date();
                                                                            const today = date.getDate();
                                                                            const monthDays = ["日", "月", "火", "水", "木", "金", "土"];
                                                                            let currentMonth = date.getMonth();
                                                                            let currentYear = date.getFullYear();

                                                                            function createCalendar() {
                                                                                let calendarHTML = '<table class="calendar"><thead><tr>';

                                                                                for (let i = 0; i < 7; i++) {//曜日を作成
                                                                                    if (i === 0) {
                                                                                        calendarHTML += '<th class="sun">' + monthDays[i] + '</th>';
                                                                                    } else if (i === 6) {
                                                                                        calendarHTML += '<th class="sat">' + monthDays[i] + '</th>';
                                                                                    } else {
                                                                                        calendarHTML += '<th>' + monthDays[i] + '</th>';
                                                                                    }
                                                                                }

                                                                                calendarHTML += '</tr></thead><tbody>';

                                                                                const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();//今月の日数
                                                                                const firstDay = new Date(currentYear, currentMonth, 1).getDay();//今月の最初の曜日

                                                                                const daysInPrevMonth = new Date(currentYear, currentMonth, 0).getDate();//先月の日数

                                                                                let dayCount = 1;
                                                                                let prevDayCount = daysInPrevMonth - firstDay + 1;
                                                                                let nextMonthDayCount = 1;

                                                                                for (let i = 0; i < 6; i++) {
                                                                                    calendarHTML += '<tr>';

                                                                                    for (let j = 0; j < 7; j++) { //カレンダーを一列ずつ作成(一日ずつIDを付与)
                                                                                        if (i == 0 && j < firstDay) { //先月分の日付
                                                                                            if (currentMonth == 0) { //1月のカレンダーの場合
                                                                                                currentYear -= 1;
                                                                                                currentMonth += 12;
                                                                                                calendarHTML += '<td id = "date' + currentYear + ("0" + currentMonth).slice(-2) + ("0" + prevDayCount).slice(-2) + '" class = "mute">' + prevDayCount + '</td>';
                                                                                                prevDayCount++;
                                                                                                currentYear += 1;
                                                                                                currentMonth -= 12;
                                                                                            } else {
                                                                                                calendarHTML += '<td id = "date' + currentYear + ("0" + currentMonth).slice(-2) + ("0" + prevDayCount).slice(-2) + '" class = "mute">' + prevDayCount + '</td>';
                                                                                                prevDayCount++;
                                                                                            }
                                                                                        } else if (dayCount > daysInMonth) { //来月分の日付
                                                                                            if (currentMonth == 11) { //12月のカレンダーの場合
                                                                                                currentYear += 1;
                                                                                                currentMonth -= 12;
                                                                                                calendarHTML += '<td id = "date' + currentYear + ("0" + (currentMonth + 2)).slice(-2) + ("0" + nextMonthDayCount).slice(-2) + '" class = "mute">' + nextMonthDayCount + '</td>';
                                                                                                nextMonthDayCount++;
                                                                                                currentYear -= 1;
                                                                                                currentMonth += 12;
                                                                                            } else {
                                                                                                calendarHTML += '<td id = "date' + currentYear + ("0" + (currentMonth + 2)).slice(-2) + ("0" + nextMonthDayCount).slice(-2) + '" class = "mute">' + nextMonthDayCount + '</td>';
                                                                                                nextMonthDayCount++;
                                                                                            }
                                                                                        } else { //今月分の日付
                                                                                            if (dayCount == today && currentMonth == date.getMonth() && currentYear == date.getYear()) { // 今日の日付にclassを付ける
                                                                                                calendarHTML += '<td id = "date' + currentYear + ("0" + (currentMonth + 1)).slice(-2) + ("0" + dayCount).slice(-2) + '" class = "today">' + dayCount + '</td>';
                                                                                            } else {
                                                                                                calendarHTML += '<td id = "date' + currentYear + ("0" + (currentMonth + 1)).slice(-2) + ("0" + dayCount).slice(-2) + '">' + dayCount + '</td>';
                                                                                            }
                                                                                            dayCount++;
                                                                                        }
                                                                                    }
                                                                                    calendarHTML += '</tr>';

                                                                                    if (dayCount > daysInMonth) { //５週目で今月が終われば終了
                                                                                        break;
                                                                                    }
                                                                                }
                                                                                calendarHTML += '</tbody></table>';

                                                                                return calendarHTML;
                                                                            }

                                                                            //カレンダーに予約を挿入する関数
                                                                            function insertReserve() {
                                                                                let dateCell = null;
            
            <%
            // データベースの予約情報が空でないかの確認
            if (webBean.arrayList("reserves") != null && !webBean.arrayList("reserves").isEmpty()) {
                                                                                    // 予約情報を取るためのループ処理
                                                                                    for (Object reserveItem : webBean.arrayList("reserves")) {
                    ReserveDao reserve = (ReserveDao) reserveItem;
                    
                    String checkinTime = reserve.getCheckinTime() == null ? "" : WebUtil.htmlEscape(reserve.getCheckinTime());
                    String checkoutTime = reserve.getCheckoutTime() == null ? "" : WebUtil.htmlEscape(reserve.getCheckoutTime());
                    String formatCheckinTime = checkinTime.length() >= 4 ? checkinTime.substring(0, 2) + ":" + checkinTime.substring(2, 4) : checkinTime;
                    String formatCheckoutTime = checkoutTime.length() >= 4 ? checkoutTime.substring(0, 2) + ":" + checkoutTime.substring(2, 4) : checkoutTime;
                    %>
                                                                                            dateCell = document.getElementById("date<%=WebUtil.htmlEscape(reserve.getReservationDate())%>");
                                                                                        if (dateCell) {
                                                                                            dateCell.innerHTML += '<div class="reserved room<%=WebUtil.htmlEscape(reserve.getRoomId())%>"><%=WebUtil.htmlEscape(formatCheckinTime)%>-<%=WebUtil.htmlEscape(formatCheckoutTime)%> <%=WebUtil.htmlEscape(reserve.getUserName())%></div>';
                                                                                        }
                <%}
                                                                                }%>
        }

                                                                            //チェックボックスで予約の表示・非表示を操作する関数
                                                                            function reserveDisplay(checkboxId, roomClass) {
                                                                                const roomElements = document.getElementsByClassName(roomClass);
                                                                                for (let i = 0; i < roomElements.length; i++) {
                                                                                    if (document.getElementById(checkboxId).checked) {
                                                                                        roomElements[i].style.display = "block";
                                                                                    } else {
                                                                                        roomElements[i].style.display = "none";
                                                                                    }
                                                                                }
                                                                            }

                                                                            //チェックボックスを押したときにイベントが起きるように設定する関数
                                                                            function changeReserveDisplay(checkboxId, roomClass) {
                                                                                document.getElementById(checkboxId).addEventListener('change', () => {
                                                                                    reserveDisplay(checkboxId, roomClass);
                                                                                });
                                                                            }

                                                                            //チェック全外し用関数
                                                                            window.addEventListener('DOMContentLoaded', function () {
                                                                                const checkboxes = document.querySelectorAll('.os-checkbox');
                                                                                const removeBtn = document.getElementById('remove-btn');

                                                                                removeBtn.addEventListener('click', function () {
                                                                                    checkboxes.forEach(cb => {
                                                                                        cb.checked = false;
                                                                                        reserveDisplay(cb.id, cb.id.replace('check', '')); // "room1check" -> "room1"
                                                                                    });
                                                                                });
                                                                            });

                                                                            //チェック全付け関数
                                                                            window.addEventListener('DOMContentLoaded', function () {
                                                                                const checkboxes = document.querySelectorAll('.os-checkbox');
                                                                                const checksBtn = document.getElementById('checks-btn');

                                                                                checksBtn.addEventListener('click', function () {
                                                                                    checkboxes.forEach(cb => {
                                                                                        cb.checked = true;
                                                                                        reserveDisplay(cb.id, cb.id.replace('check', '')); // "room1check" -> "room1"
                                                                                    });
                                                                                });
                                                                            });

                                                                            function showCalendar() {
                                                                                document.getElementById('current_month').innerHTML = currentYear + '年' + (currentMonth + 1) + '月'; //年月の表示
                                                                                document.getElementById('calendar').innerHTML = createCalendar(); //カレンダーの表示
                                                                                insertReserve();
<%
                                                                                if (webBean.arrayList("roomList") != null) {
                                                                                    for (Object item : webBean.arrayList("roomList")) {
                                                                                        RoomDao room = (RoomDao) item;
                                                                                %>
                                                                                            reserveDisplay('room<%=WebUtil.htmlEscape(room.getRoomId())%>check', 'room<%=WebUtil.htmlEscape(room.getRoomId())%>');
                                                                                <%  }
                                                                                } %>
                                                                            }

                                                                            //月を動かす関数
                                                                            function moveCalendar(e) {
                                                                                if (e.target.id === 'prev') {//前の月に戻る処理
                                                                                    currentMonth--;
                                                                                    if (currentMonth < 0) {
                                                                                        currentMonth += 12;
                                                                                        currentYear -= 1;
                                                                                    }
                                                                                }
                                                                                else if (e.target.id === 'next') {//次の月に進む処理
                                                                                    currentMonth++;
                                                                                    if (currentMonth > 11) {
                                                                                        currentMonth -= 12;
                                                                                        currentYear += 1;
                                                                                    }
                                                                                }
                                                                                showCalendar();
                                                                            }

                                                                            $(function () {
                                                                                showCalendar();
                                                                                document.querySelector('#prev').addEventListener('click', moveCalendar);
                                                                                document.querySelector('#next').addEventListener('click', moveCalendar);
<%
                                                                                if (webBean.arrayList("roomList") != null) {
                                                                                    for (Object item : webBean.arrayList("roomList")) {
                                                                                        RoomDao room = (RoomDao) item;
                                                                                %>
                                                                                    changeReserveDisplay('room<%=WebUtil.htmlEscape(room.getRoomId())%>check', 'room<%=WebUtil.htmlEscape(room.getRoomId())%>');
                                                                                <%  }
                                                                                } %>
                                                                            });

                                                                        </script>
                                                                    </head>

                                                                    <body>

                                                                        <div class="calendar-container">
                                                                            <div class="new-btn">
                                                                                <% UserLoginInfo
                                                                                    loginInfo=(UserLoginInfo)
                                                                                    session.getAttribute("LoginInfo");
                                                                                    if (loginInfo !=null &&
                                                                                    loginInfo.isSystemManager()) { %>
                                                                                    <input type="button" value="戻る"
                                                                                        onclick="history.back();" />
                                                                                    <% } %>

                                                                            </div>
                                                                            <header>
                                                                                <h1>
                                                                                    <a>カレンダー</a>
                                                                                </h1>
                                                                            </header>
                                                                            <div>
                                                                                <button id="remove-btn"
                                                                                    type="button">全てのチェックを外す</button>
                                                                                <button id="checks-btn"
                                                                                    type="button">全てのチェックを入れる</button>
                                                                            </div>
                                                                            <form id="main_form" method="post"
                                                                                action="">

                                                                                <input type="hidden" name="form_name"
                                                                                    id="form_name" value="Calendar" />
                                                                                <input type="hidden" name="action_cmd"
                                                                                    id="action_cmd" value="" />
                                                                                <input type="hidden" name="request_cmd"
                                                                                    id="request_cmd" value="" />
                                                                                <input type="hidden" name="main_key"
                                                                                    id="main_key" value="" />
                                                                                <input type="hidden" name="sort_key_old"
                                                                                    id="sort_key_old"
                                                                                    value='<%=webBean.txt("sort_key_old")%>' />
                                                                                <input type="hidden" name="sort_key"
                                                                                    id="sort_key" value="" />
                                                                                <input type="hidden" name="sort_order"
                                                                                    id="sort_order"
                                                                                    value='<%=webBean.txt("sort_order")%>' />
                                                                                <input type="hidden" name="search_info"
                                                                                    id="search_info"
                                                                                    value='<%=webBean.txt("search_info")%>' />
                                                                                <input type="hidden" name="user_info_id"
                                                                                    id="user_info_id"
                                                                                    value='<%=webBean.txt("user_info_id")%>' />

                                                                                <div id=buttons>
                                                                                    <div id=month_button>
                                                                                        <button id="prev"
                                                                                            type="button">&lt;</button>
                                                                                        <div id="current_month"></div>
                                                                                        <button id="next"
                                                                                            type="button">&gt;</button>
                                                                                    </div>

                                                                                    <div id="roomColor">
                                                                                        <% if
                                                                                            (webBean.arrayList("roomList")
                                                                                            !=null) { for (Object item :
                                                                                            webBean.arrayList("roomList"))
                                                                                            { RoomDao room=(RoomDao)
                                                                                            item; %>
                                                                                            <div
                                                                                                id="room<%=WebUtil.htmlEscape(room.getRoomId())%>">
                                                                                                <label><input
                                                                                                        type="checkbox"
                                                                                                        id="room<%=WebUtil.htmlEscape(room.getRoomId())%>check"
                                                                                                        name="room<%=WebUtil.htmlEscape(room.getRoomId())%>check"
                                                                                                        value=""
                                                                                                        class="os-checkbox"
                                                                                                        checked />
                                                                                                    <%=WebUtil.htmlEscape(room.getRoomName())%>
                                                                                                </label>
                                                                                            </div>
                                                                                            <% } } %>
                                                                                    </div>
                                                                                </div>
                                                                                <div id="calendar" class="calendar">
                                                                                </div>

                                                                            </form>
                                                                        </div>

                                                                    </body>

                                                                    </html>