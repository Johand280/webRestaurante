<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar Principal -->
        <div class="sidebar">
            <div class="sidebar-header">
                🍔 GourmetFlow
            </div>
            <div class="sidebar-user">
                <div class="avatar">
                    ${sessionScope.usuario.nombre.substring(0,1)}
                </div>
                <div class="user-info">
                    <div class="name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</div>
                    <div class="role">Administrador</div>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item active">
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
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/pedidos">📝 Pedidos</a>
                </li>
            </ul>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-block">
                    Cerrar Sesión
                </a>
            </div>
        </div>

        <!-- Contenido Principal -->
        <div class="main-content">
            <div class="main-header">
                <div class="page-title">
                    <h2>Panel de Control</h2>
                </div>
                <div style="font-weight: 500; font-size: 0.95rem; color: #718096;">
                    Fecha: <%= java.time.LocalDate.now() %>
                </div>
            </div>

            <div class="page-body">
                <!-- Tarjetas de Estadísticas -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div>
                            <div style="color: #718096; font-weight: 600;">Productos</div>
                            <div class="stat-number">${totalProductos}</div>
                        </div>
                        <div class="stat-icon">🍕</div>
                    </div>
                    <div class="stat-card">
                        <div>
                            <div style="color: #718096; font-weight: 600;">Usuarios</div>
                            <div class="stat-number">${totalUsuarios}</div>
                        </div>
                        <div class="stat-icon">👥</div>
                    </div>
                    <div class="stat-card">
                        <div>
                            <div style="color: #718096; font-weight: 600;">Pedidos Recibidos</div>
                            <div class="stat-number">${totalPedidos}</div>
                        </div>
                        <div class="stat-icon">📝</div>
                    </div>
                </div>

                <!-- Secciones de Datos Recientes -->
                <div class="dashboard-sections">
                    <!-- Tabla de Últimos Pedidos -->
                    <div class="section-card">
                        <div class="section-title">
                            <span>Últimos Pedidos</span>
                            <a href="${pageContext.request.contextPath}/admin/pedidos" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">Ver Todos</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Cliente</th>
                                        <th>Fecha</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="pedido" items="${pedidosRecientes}">
                                        <tr>
                                            <td><strong>#${pedido.id}</strong></td>
                                            <td>${pedido.cliente.nombre} ${pedido.cliente.apellido}</td>
                                            <td>${pedido.fechaPedido.toString().replace('T', ' ')}</td>
                                            <td style="font-weight: 600; color: hsl(var(--primary));">$${pedido.total}</td>
                                            <td>
                                                <span class="badge ${pedido.estado == 'PENDIENTE' ? 'badge-warning' : (pedido.estado == 'EN_PROCESO' ? 'badge-info' : (pedido.estado == 'ENTREGADO' ? 'badge-success' : 'badge-danger'))}">
                                                    ${pedido.estado}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pedidosRecientes}">
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: #a0aec0;">No hay pedidos registrados.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Alertas de Stock Bajo -->
                    <div class="section-card">
                        <div class="section-title">
                            <span>⚠️ Stock Bajo</span>
                        </div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Producto</th>
                                        <th>Stock</th>
                                        <th>Mínimo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="prod" items="${stockBajo}">
                                        <tr style="background-color: hsla(var(--danger), 0.03);">
                                            <td>
                                                <div style="font-weight: 600;">${prod.nombre}</div>
                                                <div style="font-size: 0.75rem; color: #a0aec0;">${prod.categoria.nombre}</div>
                                            </td>
                                            <td style="font-weight: 700; color: hsl(var(--danger));">${prod.stock}</td>
                                            <td>${prod.stockMinimo}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty stockBajo}">
                                        <tr>
                                            <td colspan="3" style="text-align: center; color: hsl(var(--success)); font-weight: 500;">
                                                ✅ Todos los productos tienen buen stock.
                                            </td>
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
