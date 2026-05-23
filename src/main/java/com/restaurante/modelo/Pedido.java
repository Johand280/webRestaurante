package com.restaurante.modelo;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Pedido {
    private int id;
    private Usuario cliente;
    private String estado;
    private BigDecimal total;
    private String observaciones;
    private LocalDateTime fechaPedido;
    private LocalDateTime fechaActualizacion;
    private List<DetallePedido> detalles = new ArrayList<>();

    public Pedido() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Usuario getCliente() { return cliente; }
    public void setCliente(Usuario cliente) { this.cliente = cliente; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }

    public LocalDateTime getFechaPedido() { return fechaPedido; }
    public void setFechaPedido(LocalDateTime f) { this.fechaPedido = f; }

    public LocalDateTime getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(LocalDateTime f) { this.fechaActualizacion = f; }

    public List<DetallePedido> getDetalles() { return detalles; }
    public void setDetalles(List<DetallePedido> detalles) { this.detalles = detalles; }

    public void calcularTotal() {
        total = detalles.stream()
                .map(DetallePedido::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public String getTotalFormateado() {
        return total != null ? String.format("$%,.0f", total) : "$0";
    }

    // Estados posibles
    public static final String PENDIENTE   = "PENDIENTE";
    public static final String EN_PROCESO  = "EN_PROCESO";
    public static final String LISTO       = "LISTO";
    public static final String ENTREGADO   = "ENTREGADO";
    public static final String CANCELADO   = "CANCELADO";
}