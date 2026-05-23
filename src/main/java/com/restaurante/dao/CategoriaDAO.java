package com.restaurante.dao;

import com.restaurante.modelo.Categoria;
import com.restaurante.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> listarTodas() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categorias WHERE activo=1 ORDER BY nombre";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categoria c = new Categoria();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setActivo(rs.getBoolean("activo"));
                lista.add(c);
            }

        } catch (SQLException e) {
            System.err.println("Error listarTodas categorias: " + e.getMessage());
        }
        return lista;
    }

    public Categoria buscarPorId(int id) {
        String sql = "SELECT * FROM categorias WHERE id=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Categoria c = new Categoria();
                    c.setId(rs.getInt("id"));
                    c.setNombre(rs.getString("nombre"));
                    c.setDescripcion(rs.getString("descripcion"));
                    return c;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error buscarPorId categoria: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Categoria c) {
        String sql = "INSERT INTO categorias (nombre, descripcion) VALUES (?,?)";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error insertar categoria: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Categoria c) {
        String sql = "UPDATE categorias SET nombre=?, descripcion=? WHERE id=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setInt(3, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizar categoria: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "UPDATE categorias SET activo=0 WHERE id=?";
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar categoria: " + e.getMessage());
            return false;
        }
    }
}