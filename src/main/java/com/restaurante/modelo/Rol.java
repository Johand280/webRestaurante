package com.restaurante.modelo;

public class Rol {
    private int id;
    private String nombre;
    private String descripcion;

    public Rol() {}

    public Rol(int id, String nombre, String descripcion) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public boolean esAdministrador() { return "ADMINISTRADOR".equals(nombre); }
    public boolean esTrabajador()    { return "TRABAJADOR".equals(nombre); }
    public boolean esCliente()       { return "CLIENTE".equals(nombre); }

    @Override
    public String toString() {
        return "Rol{id=" + id + ", nombre='" + nombre + "'}";
    }
}