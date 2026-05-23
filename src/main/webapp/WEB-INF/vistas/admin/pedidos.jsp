<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Pedidos - GourmetFlow</title>
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
                    <div class="role">Administrador</div>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Dashboard</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/usuarios">👥 Usuarios</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/productos">🍕 Productos</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/categorias">📁 Categorías</a>
                </li>
                <li class="sidebar-menu-item active">
                    <a href="${pageContext.request.contextPath}/admin/pedidos">📝 Pedidos</a>
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
                    <h2>Seguimiento de Pedidos Globals</h2>
                </div>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'actualizado'}">
                    <div class="alert alert-success">
                        <span>✅ El estado del pedido se ha actualizado correctamente.</span>
                    </div>
                </c:if>

                <div class="section-card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Pedido ID</th>
                                    <th>Cliente</th>
                                    <th>Fecha / Hora</th>
                                    <th>Observaciones</th>
                                    <th>Monto Total</th>
                                    <th>Estado de Preparación</th>
                                    <th>Cambiar Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pedidos}">
                                    <tr>
                                        <td><strong>#${p.id}</strong></td>
                                        <td>
                                            <div style="font-weight: 600;">${p.cliente.nombre} ${p.cliente.apellido}</div>
                                        </td>
                                        <td style="font-size: 0.85rem; color: #718096;">
                                            ${p.fechaPedido.toString().replace('T', ' ')}
                                        </td>
                                        <td style="font-size: 0.85rem; color: #a0aec0; max-width: 250px;">
                                            ${not empty p.observaciones ? p.observaciones : 'Ninguna'}
                                        </td>
                                        <td style="font-weight: 700; color: hsl(var(--primary)); font-size: 1.1rem;">
                                            $${p.total}
                                        </td>
                                        <td>
                                            <span class="badge ${p.estado == 'PENDIENTE' ? 'badge-warning' : (p.estado == 'EN_PROCESO' ? 'badge-info' : (p.estado == 'ENTREGADO' ? 'badge-success' : 'badge-danger'))}">
                                                ${p.estado}
                                            </span>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/pedidos/estado" method="POST" style="margin: 0;">
                                                <input type="hidden" name="pedidoId" value="${p.id}">
                                                <select name="estado" class="form-control" onchange="this.form.submit()" 
                                                        style="padding: 0.3rem 0.6rem; font-size: 0.8rem; height: auto; min-width: 130px; border-radius: var(--radius-sm);">
                                                    <option value="PENDIENTE" ${p.estado == 'PENDIENTE' ? 'selected' : ''}>PENDIENTE</option>
                                                    <option value="EN_PROCESO" ${p.estado == 'EN_PROCESO' ? 'selected' : ''}>EN PROCESO</option>
                                                    <option value="ENTREGADO" ${p.estado == 'ENTREGADO' ? 'selected' : ''}>ENTREGADO</option>
                                                    <option value="CANCELADO" ${p.estado == 'CANCELADO' ? 'selected' : ''}>CANCELADO</option>
                                                </select>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pedidos}">
                                    <tr>
                                        <td colspan="7" style="text-align: center; color: #a0aec0; padding: 2rem 0;">No hay comandas registradas en el sistema.</td>
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
