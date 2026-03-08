/*
 * (c)2023 PATAPATA Corp. Corp. All Rights Reserved
 *
 * 機能名　　　　：DAOクラス
 * ファイル名　　：RoomDao.java
 * クラス名　　　：RoomDao
 * 概要　　　　　：room 部屋テーブルへのデータアクセスオブジェクト(DAO)を提供する。
 * バージョン　　：
 *
 * 改版履歴　　　：
 * 2018/09/21 <新規>    新規作成
 *
 */
package jp.swell.dao;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;

import jp.patasys.common.AtareSysException;
import jp.patasys.common.db.DaoPageInfo;
import jp.patasys.common.db.DbBase;
import jp.patasys.common.db.DbI;
import jp.patasys.common.db.DbO;
import jp.patasys.common.db.DbS;
import jp.patasys.common.db.GetNumber;

/**
 * room 部屋テーブルへのデータアクセス処理を提供するDAOクラス。
 * 単一テーブルの操作に加え、画面表示用のDTO（データ転送オブジェクト）としての役割も兼ねる。
 *
 * @author 2023 PATAPATA Corp. Corp.
 * @version 1.0
 */
public class RoomDao implements Serializable {
    /** Serializable No. */
    private static final long serialVersionUID = 1L;

    /** データアクセス権限のあるユーザリスト */
    private ArrayList<String> authorityUserList = null;

    /*
     * ==================================================
     * room テーブルの基本カラム
     * ==================================================
     */
    private String roomId = ""; // 部屋ID
    private String roomName = ""; // 部屋名
    private String insertDate = ""; // 登録日時
    private String insertUserId = ""; // 登録ユーザID
    private String updateDate = ""; // 更新日時
    private String updateUserId = ""; // 更新ユーザID

    /*
     * ==================================================
     * 予約・他テーブル結合情報（画面表示・DTO用）
     * ==================================================
     */
    private String reserveId = ""; // 予約ID
    private String userInfoId = ""; // 予約用ユーザーID
    private String reservationDate = ""; // 予約日
    private String checkinTime = ""; // チェックイン時間
    private String checkoutTime = ""; // チェックアウト時間
    private String inputText = ""; // 予約テキスト
    private String userId = ""; // ユーザーID
    private String color = ""; // 表示色
    private String inputRemark = ""; // 備考

    /**
     * ソートフィールドのチェック用マップ。SQLインジェクション対策として機能する。
     */
    private HashMap<String, String> fieldsArray = new HashMap<String, String>();

    /**
     * コンストラクタ。
     * ソート時に許可するフィールド名と、実際のテーブルのカラム名のマッピングを定義する。
     */
    public RoomDao() {
        fieldsArray.put("room_id", "room.room_id");
        fieldsArray.put("room_name", "room.room_name");
        fieldsArray.put("insert_date", "room.insert_date");
        fieldsArray.put("insert_user_id", "room.insert_user_id");
        fieldsArray.put("update_date", "room.update_date");
        fieldsArray.put("update_user_id", "room.update_user_id");
    }

    // =========================================================
    // Getter & Setter
    // =========================================================

    public ArrayList<String> getAuthorityUserList() {
        return authorityUserList;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getInsertDate() {
        return insertDate;
    }

    public void setInsertDate(String insertDate) {
        this.insertDate = insertDate;
    }

    public String getInsertUserId() {
        return insertUserId;
    }

    public void setInsertUserId(String insertUserId) {
        this.insertUserId = insertUserId;
    }

    public String getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(String updateDate) {
        this.updateDate = updateDate;
    }

    public String getUpdateUserId() {
        return updateUserId;
    }

    public void setUpdateUserId(String updateUserId) {
        this.updateUserId = updateUserId;
    }

    // 予約関連情報のGetter/Setter
    public String getReserveId() {
        return reserveId;
    }

    public void setReserveId(String reserveId) {
        this.reserveId = reserveId;
    }

    public String getUserInfoId() {
        return userInfoId;
    }

    public void setUserInfoId(String userInfoId) {
        this.userInfoId = userInfoId;
    }

    public String getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(String reservationDate) {
        this.reservationDate = reservationDate;
    }

    public String getCheckinTime() {
        return checkinTime;
    }

    public void setCheckinTime(String checkinTime) {
        this.checkinTime = checkinTime;
    }

    public String getCheckoutTime() {
        return checkoutTime;
    }

    public void setCheckoutTime(String checkoutTime) {
        this.checkoutTime = checkoutTime;
    }

    public String getInputText() {
        return inputText;
    }

    public void setInputText(String inputText) {
        this.inputText = inputText;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getInputRemark() {
        return inputRemark;
    }

    public void setInputRemark(String inputRemark) {
        this.inputRemark = inputRemark;
    }

    // =========================================================
    // データアクセス処理（CRUD）
    // =========================================================

    /**
     * 部屋IDをキーにして、roomテーブルから1件のデータを取得する。
     * PreparedStatementを使用してSQLインジェクションを防ぐ。
     *
     * @param pRoomId 取得対象の部屋ID
     * @return true:取得成功, false:データが存在しない
     * @throws AtareSysException
     */
    public boolean dbSelect(String pRoomId) throws AtareSysException {
        String sql = "SELECT * FROM room WHERE room_id = ?";

        try (PreparedStatement pstmt = (PreparedStatement) DbBase.getDbConnection().prepareStatement(sql)) {
            pstmt.setString(1, pRoomId);

            try (ResultSet rs = (ResultSet) pstmt.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                // DB取得値がnullの場合、DbI.charaがエラーになるため空文字列に変換
                HashMap<String, String> map = new HashMap<>();
                map.put("room_id", rs.getString("room_id") != null ? rs.getString("room_id") : "");
                map.put("room_name", rs.getString("room_name") != null ? rs.getString("room_name") : "");
                map.put("insert_date", rs.getString("insert_date") != null ? rs.getString("insert_date") : "");
                map.put("insert_user_id", rs.getString("insert_user_id") != null ? rs.getString("insert_user_id") : "");
                map.put("update_date", rs.getString("update_date") != null ? rs.getString("update_date") : "");
                map.put("update_user_id", rs.getString("update_user_id") != null ? rs.getString("update_user_id") : "");

                setRoomDao(map, this);
                return true;
            } catch (SQLException e) {
                throw new AtareSysException("データベースクエリの実行中にエラーが発生しました: " + e.getMessage(), e);
            }
        } catch (SQLException e) {
            throw new AtareSysException("データベース接続中にエラーが発生しました: " + e.getMessage(), e);
        }
    }

    /**
     * 部屋IDと部屋名を指定して、roomテーブルから1件のデータを取得する。
     *
     * @param pRoomId  部屋ID
     * @param roomName 部屋名
     * @return true:取得成功, false:データが存在しない
     * @throws AtareSysException
     */
    public boolean dbSelect(String pRoomId, String roomName) throws AtareSysException {
        String sql = "select * from room "
                + " where room_id = " + DbS.chara(pRoomId)
                + " and room_name = " + DbS.chara(roomName);

        List<HashMap<String, String>> rs = DbBase.dbSelect(sql);
        if (0 == rs.size())
            return false;

        HashMap<String, String> map = rs.get(0);
        setRoomDao(map, this);
        return true;
    }

    /**
     * HashMapから取り出したレコードデータを、RoomDaoインスタンスにセットする。
     *
     * @param map データベースから取得した1レコード分のHashMap
     * @param dao 値をセットするRoomDaoインスタンス
     */
    public void setRoomDao(HashMap<String, String> map, RoomDao dao) throws AtareSysException {
        dao.setRoomId(DbI.chara(map.get("room_id")));
        dao.setRoomName(DbI.chara(map.get("room_name")));
        dao.setInsertDate(DbI.chara(map.get("insert_date")));
        dao.setInsertUserId(DbI.chara(map.get("insert_user_id")));
        dao.setUpdateDate(DbI.chara(map.get("update_date")));
        dao.setUpdateUserId(DbI.chara(map.get("update_user_id")));
    }

    /**
     * JOINを使用して取得したレコードデータを、RoomDaoインスタンスにセットする。
     * カラム名のプレフィックス（room___）を考慮したマッピング。
     */
    public void setRoomDaoForJoin(HashMap<String, String> map, RoomDao dao) throws AtareSysException {
        dao.setRoomId(DbI.chara(map.get("room___room_id") != null ? map.get("room___room_id") : ""));
        dao.setRoomName(DbI.chara(map.get("room___room_name") != null ? map.get("room___room_name") : ""));
        dao.setInsertDate(DbI.chara(map.get("room___insert_date") != null ? map.get("room___insert_date") : ""));
        dao.setInsertUserId(
                DbI.chara(map.get("room___insert_user_id") != null ? map.get("room___insert_user_id") : ""));
        dao.setUpdateDate(DbI.chara(map.get("room___update_date") != null ? map.get("room___update_date") : ""));
        dao.setUpdateUserId(
                DbI.chara(map.get("room___update_user_id") != null ? map.get("room___update_user_id") : ""));
    }

    /**
     * インスタンスの保持するデータを、roomテーブルに新規登録（INSERT）する。
     *
     * @return true:成功, false:失敗
     * @throws AtareSysException
     */
    public boolean dbInsert() throws AtareSysException {
        // 新規採番処理
        setRoomId(GetNumber.getNumberChar("room"));

        System.out.println("DEBUG_ROOM_INSERT: " + this.roomName);

        String sql = "insert into room ("
                + " room_id"
                + ",room_name"
                + ",insert_date"
                + ",insert_user_id"
                + ",update_date"
                + ",update_user_id"
                + " ) values ( "
                + DbO.chara(this.roomId)
                + "," + DbO.chara(this.roomName)
                + "," + (this.insertDate.isEmpty() ? "null" : DbO.chara(this.insertDate))
                + "," + (this.insertUserId.isEmpty() ? "null" : DbO.chara(this.insertUserId))
                + "," + (this.updateDate.isEmpty() ? "null" : DbO.chara(this.updateDate))
                + "," + (this.updateUserId.isEmpty() ? "null" : DbO.chara(this.updateUserId))
                + " )";

        int ret = DbBase.dbExec(sql);
        if (ret != 1)
            throw new AtareSysException("dbInsert number or record exception.");

        return true;
    }

    /**
     * 指定された部屋IDのレコードを、現在のインスタンスの値で更新（UPDATE）する。
     *
     * @param pRoomId 更新対象の部屋ID
     * @return true:成功, false:失敗
     * @throws AtareSysException
     */
    public boolean dbUpdate(String pRoomId) throws AtareSysException {
        String sql = "update room set "
                + " room_name = " + DbO.chara(this.roomName)
                + " where room_id = " + DbS.chara(pRoomId);

        int ret = DbBase.dbExec(sql);
        if (ret != 1)
            throw new AtareSysException("dbupdate number or record exception");

        return true;
    }

    /**
     * 部屋情報を論理削除（is_deletedフラグをtrueに更新）する。
     * ※以前は物理削除(DELETE)だったが、論理削除に変更されている。
     *
     * @param pRoomId 削除対象の部屋ID
     * @return true:成功, false:失敗
     * @throws AtareSysException
     */
    public boolean dbDelete(String pRoomId) throws AtareSysException {
        String sql = "UPDATE room set is_deleted = true WHERE room_id = " + DbS.chara(pRoomId);

        int ret = DbBase.dbExec(sql);
        if (ret != 1)
            throw new AtareSysException("dbDelete number or record exception");

        return true;
    }

    /**
     * データベースから全てのルーム情報を取得する。
     *
     * @return 取得したRoomDaoのリスト
     * @throws AtareSysException
     */
    public ArrayList<RoomDao> getAllRooms() throws AtareSysException {
        String sql = "SELECT * FROM room WHERE is_deleted = false;";
        List<HashMap<String, String>> rs = DbBase.dbSelect(sql);
        ArrayList<RoomDao> rooms = new ArrayList<>();

        for (HashMap<String, String> map : rs) {
            RoomDao room = new RoomDao();
            room.setRoomId(map.get("room_id"));
            room.setRoomName(map.get("room_name"));
            // ↓ ここで取得していないカラムを参照しているため修正推奨
            room.setInsertDate(map.get("insert_date"));
            room.setInsertUserId(map.get("insert_user_id"));
            room.setUpdateDate(map.get("update_date"));
            room.setUpdateUserId(map.get("update_user_id"));

            rooms.add(room);
        }

        return rooms;
    }

    /**
     * 検索条件やソート順、ページング情報を適用して、roomテーブルから一覧表示用のデータを取得する。
     *
     * @param myclass     検索条件がセットされたRoomDaoインスタンス
     * @param sortKey     ソート条件（カラム名と昇順/降順）
     * @param daoPageInfo ページング制御情報
     * @return 検索結果のRoomDaoリスト
     * @throws AtareSysException
     */
    static public ArrayList<RoomDao> dbSelectList(RoomDao myclass, LinkedHashMap<String, String> sortKey,
            DaoPageInfo daoPageInfo) throws AtareSysException {
        ArrayList<RoomDao> array = new ArrayList<RoomDao>();

        // 1. 検索条件に合致するレコードの総件数を求める
        String sql = "select count(*) as count from room " + myclass.dbWhere();
        List<HashMap<String, String>> rs = DbBase.dbSelect(sql);
        if (0 == rs.size())
            return array;

        HashMap<String, String> map = rs.get(0);
        int len = Integer.parseInt(map.get("count"));
        daoPageInfo.setRecordCount(len);

        if (len == 0)
            return array; // 0件なら終了

        // ページング計算
        if (-1 == daoPageInfo.getLineCount())
            daoPageInfo.setLineCount(len);
        daoPageInfo.setMaxPageNo((int) Math.ceil((double) len / (double) (daoPageInfo.getLineCount())));
        if (daoPageInfo.getPageNo() < 1)
            daoPageInfo.setPageNo(1);
        if (daoPageInfo.getPageNo() > daoPageInfo.getMaxPageNo())
            daoPageInfo.setPageNo(daoPageInfo.getMaxPageNo());
        int start = (daoPageInfo.getPageNo() - 1) * daoPageInfo.getLineCount();

        // 2. 実際のデータを取得するクエリの組み立て
        sql = "select * from room ";
        String where = myclass.dbWhere();
        String order = myclass.dbOrder(sortKey);

        sql += where + order + " limit " + daoPageInfo.getLineCount() + " offset " + start + ";";
        System.out.println("DAO_SELECT_SQL: " + sql);

        // 3. データの取得とリスト化
        rs = DbBase.dbSelect(sql);
        int cnt = rs.size();
        if (cnt < 1)
            return array;

        for (int i = 0; i < cnt; i++) {
            RoomDao dao = new RoomDao();
            map = rs.get(i);
            dao.setRoomDao(map, dao);
            array.add(dao);
        }
        return array;
    }

    /**
     * インスタンスにセットされている値をもとに、WHERE句の文字列を動的に生成する。
     *
     * @return 生成されたWHERE句（例: "where room.is_deleted = false AND ..."）
     * @throws AtareSysException
     */
    private String dbWhere() throws AtareSysException {
        StringBuffer where = new StringBuffer(1024);

        // 論理削除されていないデータ（有効なデータ）のみを対象とする
        where.append("room.is_deleted = false");

        if (getRoomId().length() > 0) {
            where.append(" AND room.room_id LIKE " + DbS.chara("%" + getRoomId() + "%"));
        }
        if (getRoomName().length() > 0) {
            where.append(" AND room.room_name LIKE " + DbS.chara("%" + getRoomName() + "%"));
        }
        if (getInsertDate().length() > 0) {
            where.append(" AND room.insert_date LIKE " + DbS.chara("%" + getInsertDate() + "%"));
        }
        if (getInsertUserId().length() > 0) {
            where.append(" AND room.insert_user_id LIKE " + DbS.chara("%" + getInsertUserId() + "%"));
        }
        if (getUpdateDate().length() > 0) {
            where.append(" AND room.update_date LIKE " + DbS.chara("%" + getUpdateDate() + "%"));
        }
        if (getUpdateUserId().length() > 0) {
            where.append(" AND room.update_user_id LIKE " + DbS.chara("%" + getUpdateUserId() + "%"));
        }

        if (where.length() > 0) {
            return "where " + where.toString();
        }
        return "";
    }

    /**
     * 画面から渡されたソート情報をもとに、ORDER BY句の文字列を生成する。
     * fieldsArrayによるホワイトリストチェックを行い、SQLインジェクションを防ぐ。
     *
     * @param sortKey カラム名と昇順/降順の指定マップ
     * @return ORDER BY句の文字列
     */
    private String dbOrder(LinkedHashMap<String, String> sortKey) {
        String str = "";
        if (sortKey == null)
            return "";

        Set<String> keySet = sortKey.keySet();
        for (Iterator<String> i = keySet.iterator(); i.hasNext();) {
            String key = i.next();
            // fieldsArrayに定義されていない不正なカラム名は無視する
            if (null == fieldsArray.get(key))
                continue;

            str += !"".equals(str) ? " , " : "";
            String ss[] = fieldsArray.get(key).split(",");
            for (int j = 0; j < ss.length; j++) {
                if (j != 0)
                    str += ",";
                str += ss[j] + ' ' + sortKey.get(key); // カラム名 + asc/desc
            }
        }

        str = "".equals(str) ? "" : (" order by " + str);
        return str;
    }
}