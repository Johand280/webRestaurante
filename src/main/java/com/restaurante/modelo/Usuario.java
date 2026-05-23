package com.restaurante.modelo;

import java.time.LocalDateTime;

public class Usuario {
    private int id;
    private String nombre;
    private String apellido;
    private String email;
    private String password;
    private String telefono;
    private Rol rol;
    private boolean activo;
    private LocalDateTime fechaRegistro;

    public Usuario() {}

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getNombreCompleto() { return nombre + " " + apellido; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public Rol getRol() { return rol; }
    public void setRol(Rol rol) { this.rol = rol; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public boolean esAdministrador() { return rol != null && rol.esAdministrador(); }
    public boolean esTrabajador()    { return rol != null && rol.esTrabajador(); }
    public boolean esCliente()       { return rol != null && rol.esCliente(); }
}
