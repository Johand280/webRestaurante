package com.restaurante.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utilidad de conexión a la base de datos MySQL.
 * Patrón Singleton para gestión de conexiones.
 */
public class ConexionDB {

    private static final String URL      = "jdbc:mysql://localhost:3306/restaurante_db?useSSL=false&serverTimezone=America/Bogota&characterEncoding=UTF-8";
    private static final String USUARIO  = "root";
    private static final String PASSWORD = ""; // Cambiar en producción

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("No se encontró el driver MySQL: " + e.getMessage());
        }
    }

    private ConexionDB() {}

    public static Connection obtenerConexion() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, PASSWORD);
    }

    public static void cerrarConexion(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar conexión: " + e.getMessage());
            }
        }
    }
}
