package com.restaurante.dao;

import com.restaurante.modelo.*;
import com.restaurante.util.ConexionDB;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {

    public boolean crearPedido(Pedido pedido) {
        Connection conn = null;
        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false);

            // Insertar pedido
            String sqlPedido = "INSERT INTO pedidos (cliente_id, estado, total, observaciones) VALUES (?,?,?,?)";
            int pedidoId;
            try (PreparedStatement ps = conn.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, pedido.getCliente().getId());
                ps.setString(2, Pedido.PENDIENTE);
                ps.setBigDecimal(3, pedido.getTotal());
                ps.setString(4, pedido.getObservaciones());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) throw new SQLException("No se generó ID de pedido");
                    pedidoId = rs.getInt(1);
                }
            }

            // Insertar detalles y reducir stock
            String sqlDetalle = "INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario, subtotal) VALUES (?,?,?,?,?)";
            String sqlStock   = "UPDATE productos SET stock = stock - ? WHERE id = ? AND stock >= ?";

            for (DetallePedido d : pedido.getDetalles()) {
                try (PreparedStatement ps = conn.prepareStatement(sqlDetalle)) {
                    ps.setInt(1, pedidoId);
                    ps.setInt(2, d.getProducto().getId());
                    ps.setInt(3, d.getCantidad());
                    ps.setBigDecimal(4, d.getPrecioUnitario());
                    ps.setBigDecimal(5, d.getSubtotal());
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(sqlStock)) {
                    ps.setInt(1, d.getCantidad());
                    ps.setInt(2, d.getProducto().getId());
                    ps.setInt(3, d.getCantidad());
                    int filas = ps.executeUpdate();
                    if (filas == 0) throw new SQLException("Stock insuficiente para: " + d.getProducto().getNombre());
                }
            }

            conn.commit();
            pedido.setId(pedidoId);
            return true;

        } catch (SQLException e) {
            System.err.println("Error crearPedido: " + e.getMessage());
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            return false;
        } finally {
            ConexionDB.cerrarConexion(conn);
        }
    }

    public List<Pedido> listarPorCliente(int clienteId) {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.id, p.estado, p.total, p.observaciones, p.fecha_pedido FROM pedidos p WHERE p.cliente_id=? ORDER BY p.fecha_pedido DESC";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapPedidoSimple(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listarPorCliente: " + e.getMessage());
        }
        return lista;
    }

    public List<Pedido> listarTodos() {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.id, p.estado, p.total, p.observaciones, p.fecha_pedido, " +
                     "       u.id AS uid, u.nombre AS unombre, u.apellido AS uapellido " +
                     "FROM pedidos p JOIN usuarios u ON p.cliente_id = u.id " +
                     "ORDER BY p.fecha_pedido DESC";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Pedido p = mapPedidoSimple(rs);
                Usuario u = new Usuario();
                u.setId(rs.getInt("uid"));
                u.setNombre(rs.getString("unombre"));
                u.setApellido(rs.getString("uapellido"));
                p.setCliente(u);
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error listarTodos pedidos: " + e.getMessage());
        }
        return lista;
    }

    public boolean actualizarEstado(int pedidoId, String nuevoEstado) {
        String sql = "UPDATE pedidos SET estado=? WHERE id=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, pedidoId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizarEstado pedido: " + e.getMessage());
            return false;
        }
    }

    private Pedido mapPedidoSimple(ResultSet rs) throws SQLException {
        Pedido p = new Pedido();
        p.setId(rs.getInt("id"));
        p.setEstado(rs.getString("estado"));
        p.setTotal(rs.getBigDecimal("total"));
        p.setObservaciones(rs.getString("observaciones"));
        Timestamp ts = rs.getTimestamp("fecha_pedido");
        if (ts != null) p.setFechaPedido(ts.toLocalDateTime());
        return p;
    }
}