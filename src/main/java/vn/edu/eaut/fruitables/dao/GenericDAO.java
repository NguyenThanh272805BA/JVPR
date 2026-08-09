package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.mapper.IRowMapper;
import java.util.List;

public interface GenericDAO<T> {
    // Truy vấn trả về danh sách
    List<T> query(String sql, IRowMapper<T> rowMapper, Object... parameters);

    // Dùng cho UPDATE, DELETE
    void update(String sql, Object... parameters);

    // Dùng cho INSERT, trả về ID vừa được tự động tăng
    Long insert(String sql, Object... parameters);

    // Dùng cho đếm số lượng (COUNT)
    int count(String sql, Object... parameters);
}