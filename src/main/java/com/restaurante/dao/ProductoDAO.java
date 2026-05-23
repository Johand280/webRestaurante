package com.restaurante.dao;

import com.restaurante.modelo.Categoria;
import com.restaurante.modelo.Producto;
import com.restaurante.util.ConexionDB;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> listarTodos() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.id AS cat_id, c.nombre AS cat_nombre " +
                     "FROM productos p JOIN categorias c ON p.categoria_id = c.id " +
                     "ORDER BY c.nombre, p.nombre";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapProducto(rs));

        } catch (SQLException e) {
            System.err.println("Error listarTodos productos: " + e.getMessage());
        }
        return lista;
    }

    public List<Producto> listarDisponibles() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.id AS cat_id, c.nombre AS cat_nombre " +
                     "FROM productos p JOIN categorias c ON p.categoria_id = c.id " +
                     "WHERE p.disponible = 1 AND p.stock > 0 " +
                     "ORDER BY c.nombre, p.nombre";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapProducto(rs));

        } catch (SQLException e) {
            System.err.println("Error listarDisponibles: " + e.getMessage());
        }
        return lista;
    }

    public List<Producto> listarPorCategoria(int categoriaId) {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.id AS cat_id, c.nombre AS cat_nombre " +
                     "FROM productos p JOIN categorias c ON p.categoria_id = c.id " +
                     "WHERE p.categoria_id = ? AND p.disponible = 1 " +
                     "ORDER BY p.nombre";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoriaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapProducto(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listarPorCategoria: " + e.getMessage());
        }
        return lista;
    }

    public Producto buscarPorId(int id) {
        String sql = "SELECT p.*, c.id AS cat_id, c.nombre AS cat_nombre " +
                     "FROM productos p JOIN categorias c ON p.categoria_id = c.id " +
                     "WHERE p.id = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapProducto(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscarPorId producto: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Producto p) {
        String sql = "INSERT INTO productos (nombre, descripcion, precio, stock, stock_minimo, categoria_id, imagen_url, disponible) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setBigDecimal(3, p.getPrecio());
            ps.setInt(4, p.getStock());
            ps.setInt(5, p.getStockMinimo());
            ps.setInt(6, p.getCategoria().getId());
            ps.setString(7, p.getImagenUrl());
            ps.setBoolean(8, p.isDisponible());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error insertar producto: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Producto p) {
        String sql = "UPDATE productos SET nombre=?, descripcion=?, precio=?, stock=?, stock_minimo=?, " +
                     "categoria_id=?, imagen_url=?, disponible=? WHERE id=?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setBigDecimal(3, p.getPrecio());
            ps.setInt(4, p.getStock());
            ps.setInt(5, p.getStockMinimo());
            ps.setInt(6, p.getCategoria().getId());
            ps.setString(7, p.getImagenUrl());
            ps.setBoolean(8, p.isDisponible());
            ps.setInt(9, p.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error actualizar producto: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarPrecio(int productoId, BigDecimal nuevoPrecio, int usuarioId, String motivo) {
        Connection conn = null;
        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false);

            // Guardar precio anterior
            BigDecimal precioAnterior = null;
            try (PreparedStatement ps = conn.prepareStatement("SELECT precio FROM productos WHERE id=?")) {
                ps.setInt(1, productoId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) precioAnterior = rs.getBigDecimal("precio");
                }
            }

            // Actualizar precio en producto
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE productos SET precio=?, precio_anterior=? WHERE id=?")) {
                ps.setBigDecimal(1, nuevoPrecio);
                ps.setBigDecimal(2, precioAnterior);
                ps.setInt(3, productoId);
                ps.executeUpdate();
            }

            // Guardar historial
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo, usuario_id, motivo) VALUES (?,?,?,?,?)")) {
                ps.setInt(1, productoId);
                ps.setBigDecimal(2, precioAnterior);
                ps.setBigDecimal(3, nuevoPrecio);
                ps.setInt(4, usuarioId);
                ps.setString(5, motivo);
                ps.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Error actualizarPrecio: " + e.getMessage());
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            return false;
        } finally {
            ConexionDB.cerrarConexion(conn);
        }
    }

    public boolean actualizarStock(int productoId, int nuevoStock) {
        String sql = "UPDATE productos SET stock=? WHERE id=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nuevoStock);
            ps.setInt(2, productoId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizarStock: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "UPDATE productos SET disponible = 0 WHERE id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar producto: " + e.getMessage());
            return false;
        }
    }

    public List<Producto> listarStockBajo() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.id AS cat_id, c.nombre AS cat_nombre " +
                     "FROM productos p JOIN categorias c ON p.categoria_id = c.id " +
                     "WHERE p.stock <= p.stock_minimo AND p.disponible = 1 " +
                     "ORDER BY p.stock ASC";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapProducto(rs));
        } catch (SQLException e) {
            System.err.println("Error listarStockBajo: " + e.getMessage());
        }
        return lista;
    }

    // ─── Mapper ──────────────────────────────────────────────────────────────

    private Producto mapProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setId(rs.getInt("id"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setPrecioAnterior(rs.getBigDecimal("precio_anterior"));
        p.setStock(rs.getInt("stock"));
        p.setStockMinimo(rs.getInt("stock_minimo"));
        p.setImagenUrl(rs.getString("imagen_url"));
        p.setDisponible(rs.getBoolean("disponible"));

        Categoria cat = new Categoria(rs.getInt("cat_id"), rs.getString("cat_nombre"));
        p.setCategoria(cat);

        Timestamp ts = rs.getTimestamp("fecha_creacion");
        if (ts != null) p.setFechaCreacion(ts.toLocalDateTime());
        Timestamp ts2 = rs.getTimestamp("fecha_actualizacion");
        if (ts2 != null) p.setFechaActualizacion(ts2.toLocalDateTime());

        return p;
    }
}