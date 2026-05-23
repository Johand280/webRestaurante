<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Cocina y Operaciones - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                🍳 CocinaFlow
            </div>
            <div class="sidebar-user">
                <div class="avatar">${sessionScope.usuario.nombre.substring(0,1)}</div>
                <div class="user-info">
                    <div class="name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</div>
                    <div class="role">Personal Operativo</div>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item active">
                    <a href="${pageContext.request.contextPath}/trabajador/dashboard">📋 Resumen Actividad</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/trabajador/productos">🍕 Inventario Menú</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/trabajador/pedidos">🍳 Comandas Activas</a>
                </li>
            </ul>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-block">Cerrar Sesión</a>
            </div>
        </div>

        <!-- Contenido Principal -->
        <div class="main-content">
            <div class="main-header">
                <div class="page-title">
                    <h2>Panel Operativo Diarío</h2>
                </div>
                <div style="font-weight: 500; font-size: 0.95rem; color: #718096;">
                    Rol: Cocina / Servicio
                </div>
            </div>

            <div class="page-body">
                <!-- Estadísticas de Cocina -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div>
                            <div style="color: #718096; font-weight: 600;">Comandas por Preparar</div>
                            <div class="stat-number" style="color: hsl(var(--warning));">${pedidosActivos.size()}</div>
                        </div>
                        <div class="stat-icon" style="background-color: hsl(var(--warning-light)); color: hsl(var(--warning));">🍳</div>
                    </div>
                    <div class="stat-card">
                        <div>
                            <div style="color: #718096; font-weight: 600;">Alertas de Stock</div>
                            <div class="stat-number" style="color: hsl(var(--danger));">${stockBajo.size()}</div>
                        </div>
                        <div class="stat-icon" style="background-color: hsl(var(--danger-light)); color: hsl(var(--danger));">⚠️</div>
                    </div>
                </div>

                <div class="dashboard-sections">
                    <!-- Comandas Activas -->
                    <div class="section-card">
                        <div class="section-title">
                            <span>Comandas en Curso</span>
                            <a href="${pageContext.request.contextPath}/trabajador/pedidos" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">Atender</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Mesa / Orden</th>
                                        <th>Fecha / Hora</th>
                                        <th>Detalles de Notas</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${pedidosActivos}">
                                        <tr>
                                            <td><strong>#${p.id}</strong></td>
                                            <td>${p.fechaPedido.toString().replace('T', ' ')}</td>
                                            <td style="color: #718096; font-size: 0.85rem;">${not empty p.observaciones ? p.observaciones : 'Sin observaciones adicionales'}</td>
                                            <td>
                                                <span class="badge ${p.estado == 'PENDIENTE' ? 'badge-warning' : 'badge-info'}">
                                                    ${p.estado}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pedidosActivos}">
                                        <tr>
                                            <td colspan="4" style="text-align: center; color: hsl(var(--success)); padding: 2rem 0; font-weight: 500;">
                                                🎉 ¡Excelente! No hay comandas pendientes de despacho.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Insumos en Alerta -->
                    <div class="section-card">
                        <div class="section-title">Insumos Críticos</div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Plato</th>
                                        <th>Stock</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sb" items="${stockBajo}">
                                        <tr style="background-color: hsla(var(--danger), 0.02);">
                                            <td><strong>${sb.nombre}</strong></td>
                                            <td style="font-weight: 700; color: hsl(var(--danger));">${sb.stock} unidades</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty stockBajo}">
                                        <tr>
                                            <td colspan="2" style="text-align: center; color: hsl(var(--success)); padding: 1.5rem 0;">No hay insumos críticos.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
