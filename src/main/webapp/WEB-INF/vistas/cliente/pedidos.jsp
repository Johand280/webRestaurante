<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Pedidos - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                🍔 GourmetFlow
            </div>
            <div class="sidebar-user">
                <div class="avatar">${sessionScope.usuario.nombre.substring(0,1)}</div>
                <div class="user-info">
                    <div class="name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</div>
                    <div class="role">Cliente</div>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/cliente/menu">🍕 Menú Digital</a>
                </li>
                <li class="sidebar-menu-item active">
                    <a href="${pageContext.request.contextPath}/cliente/pedidos">📝 Mis Pedidos</a>
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
                    <h2>Historial de Mis Pedidos</h2>
                </div>
                <a href="${pageContext.request.contextPath}/cliente/menu" class="btn btn-primary">
                    + Nueva Orden
                </a>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'creado'}">
                    <div class="alert alert-success">
                        <span>🎉 ¡Pedido registrado con éxito! Tu orden ya está en la cocina siendo preparada (Orden #${param.id}).</span>
                    </div>
                </c:if>

                <div class="section-card">
                    <div class="section-title">Lista de Órdenes Realizadas</div>
                    
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID Pedido</th>
                                    <th>Fecha / Hora</th>
                                    <th>Observaciones de Cocina</th>
                                    <th>Total Pagado</th>
                                    <th>Estado de Preparación</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pedidos}">
                                    <tr>
                                        <td><strong>#${p.id}</strong></td>
                                        <td style="font-size: 0.9rem; color: #718096;">
                                            ${p.fechaPedido.toString().replace('T', ' ')}
                                        </td>
                                        <td style="font-size: 0.85rem; color: #a0aec0; max-width: 300px;">
                                            ${not empty p.observaciones ? p.observaciones : '-'}
                                        </td>
                                        <td style="font-weight: 700; color: hsl(var(--primary)); font-size: 1.1rem;">
                                            $${p.total}
                                        </td>
                                        <td>
                                            <!-- Badge de Estado en Vivo -->
                                            <span class="badge ${p.estado == 'PENDIENTE' ? 'badge-warning' : (p.estado == 'EN_PROCESO' ? 'badge-info' : (p.estado == 'ENTREGADO' ? 'badge-success' : 'badge-danger'))}">
                                                ${p.estado}
                                            </span>
                                            
                                            <!-- Mensaje descriptivo para el cliente -->
                                            <c:if test="${p.estado == 'PENDIENTE'}">
                                                <div style="font-size: 0.75rem; color: hsl(var(--warning)); margin-top: 0.25rem;">Esperando aprobación de la cocina</div>
                                            </c:if>
                                            <c:if test="${p.estado == 'EN_PROCESO'}">
                                                <div style="font-size: 0.75rem; color: hsl(var(--info)); margin-top: 0.25rem;">👨‍🍳 El chef está preparando tu platillo</div>
                                            </c:if>
                                            <c:if test="${p.estado == 'ENTREGADO'}">
                                                <div style="font-size: 0.75rem; color: hsl(var(--success)); margin-top: 0.25rem;">🍔 ¡Buen provecho! Servido en mesa</div>
                                            </c:if>
                                            <c:if test="${p.estado == 'CANCELADO'}">
                                                <div style="font-size: 0.75rem; color: hsl(var(--danger)); margin-top: 0.25rem;">Orden cancelada</div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pedidos}">
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: #a0aec0; padding: 3rem 0;">Aún no has realizado ningún pedido. ¡Pide tu primer plato hoy!</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
