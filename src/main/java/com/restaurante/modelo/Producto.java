package com.restaurante.modelo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Producto {
    private int id;
    private String nombre;
    private String descripcion;
    private BigDecimal precio;
    private BigDecimal precioAnterior;
    private int stock;
    private int stockMinimo;
    private Categoria categoria;
    private String imagenUrl;
    private boolean disponible;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;

    public Producto() {}

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }

    public BigDecimal getPrecioAnterior() { return precioAnterior; }
    public void setPrecioAnterior(BigDecimal precioAnterior) { this.precioAnterior = precioAnterior; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public int getStockMinimo() { return stockMinimo; }
    public void setStockMinimo(int stockMinimo) { this.stockMinimo = stockMinimo; }

    public Categoria getCategoria() { return categoria; }
    public void setCategoria(Categoria categoria) { this.categoria = categoria; }

    public String getImagenUrl() { return imagenUrl; }
    public void setImagenUrl(String imagenUrl) { this.imagenUrl = imagenUrl; }

    public boolean isDisponible() { return disponible; }
    public void setDisponible(boolean disponible) { this.disponible = disponible; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime f) { this.fechaCreacion = f; }

    public LocalDateTime getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(LocalDateTime f) { this.fechaActualizacion = f; }

    public boolean tieneStockBajo() {
        return stock <= stockMinimo;
    }

    public String getPrecioFormateado() {
        return String.format("$%,.0f", precio);
    }
}