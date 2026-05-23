package com.restaurante.dao;

import com.restaurante.modelo.Rol;
import com.restaurante.modelo.Usuario;
import com.restaurante.util.ConexionDB;

import java.security.MessageDigest;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // ─── Autenticación ───────────────────────────────────────────────────────

    public Usuario autenticar(String email, String password) {
        String sql = "SELECT u.id, u.nombre, u.apellido, u.email, u.telefono, u.activo, " +
                     "       u.fecha_registro, r.id AS rol_id, r.nombre AS rol_nombre, r.descripcion AS rol_desc " +
                     "FROM usuarios u " +
                     "JOIN roles r ON u.rol_id = r.id " +
                     "WHERE u.email = ? AND u.password = SHA2(?, 256) AND u.activo = 1";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUsuario(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en autenticar: " + e.getMessage());
        }
        return null;
    }

    // ─── CRUD ────────────────────────────────────────────────────────────────

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.id, u.nombre, u.apellido, u.email, u.telefono, u.activo, " +
                     "       u.fecha_registro, r.id AS rol_id, r.nombre AS rol_nombre, r.descripcion AS rol_desc " +
                     "FROM usuarios u JOIN roles r ON u.rol_id = r.id " +
                     "ORDER BY u.nombre";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapUsuario(rs));

        } catch (SQLException e) {
            System.err.println("Error listarTodos usuarios: " + e.getMessage());
        }
        return lista;
    }

    public Usuario buscarPorId(int id) {
        String sql = "SELECT u.id, u.nombre, u.apellido, u.email, u.telefono, u.activo, " +
                     "       u.fecha_registro, r.id AS rol_id, r.nombre AS rol_nombre, r.descripcion AS rol_desc " +
                     "FROM usuarios u JOIN roles r ON u.rol_id = r.id WHERE u.id = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUsuario(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscarPorId usuario: " + e.getMessage());
        }
        return null;
    }

    public boolean emailExiste(String email) {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE email = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean insertar(Usuario u) {
        String sql = "INSERT INTO usuarios (nombre, apellido, email, password, telefono, rol_id, activo) " +
                     "VALUES (?, ?, ?, SHA2(?, 256), ?, ?, 1)";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getNombre());
            ps.setString(2, u.getApellido());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getTelefono());
            ps.setInt(6, u.getRol().getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error insertar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Usuario u) {
        String sql = "UPDATE usuarios SET nombre=?, apellido=?, email=?, telefono=?, rol_id=?, activo=? " +
                     "WHERE id=?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getNombre());
            ps.setString(2, u.getApellido());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getTelefono());
            ps.setInt(5, u.getRol().getId());
            ps.setBoolean(6, u.isActivo());
            ps.setInt(7, u.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error actualizar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean cambiarPassword(int usuarioId, String nuevaPassword) {
        String sql = "UPDATE usuarios SET password = SHA2(?, 256) WHERE id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nuevaPassword);
            ps.setInt(2, usuarioId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error cambiarPassword: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "UPDATE usuarios SET activo = 0 WHERE id = ?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar usuario: " + e.getMessage());
            return false;
        }
    }

    public List<Rol> listarRoles() {
        List<Rol> roles = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion FROM roles ORDER BY id";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(new Rol(rs.getInt("id"), rs.getString("nombre"), rs.getString("descripcion")));
            }
        } catch (SQLException e) {
            System.err.println("Error listarRoles: " + e.getMessage());
        }
        return roles;
    }

    // ─── Mapper ──────────────────────────────────────────────────────────────

    private Usuario mapUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setNombre(rs.getString("nombre"));
        u.setApellido(rs.getString("apellido"));
        u.setEmail(rs.getString("email"));
        u.setTelefono(rs.getString("telefono"));
        u.setActivo(rs.getBoolean("activo"));

        Timestamp ts = rs.getTimestamp("fecha_registro");
        if (ts != null) u.setFechaRegistro(ts.toLocalDateTime());

        Rol rol = new Rol(rs.getInt("rol_id"), rs.getString("rol_nombre"), rs.getString("rol_desc"));
        u.setRol(rol);
        return u;
    }
}